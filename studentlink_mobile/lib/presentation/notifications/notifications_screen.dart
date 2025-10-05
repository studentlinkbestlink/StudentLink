import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/api_service.dart';

import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notification_filter_chips.dart';
import './widgets/notification_empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  
  // Data
  List<Map<String, dynamic>> _allNotifications = [];
  List<Map<String, dynamic>> _unreadNotifications = [];
  List<Map<String, dynamic>> _readNotifications = [];
  
  // Filtering
  String _selectedFilter = 'All';
  String _searchQuery = '';
  
  // State
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreNotifications();
    }
  }

  Future<void> _loadNotifications({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMoreData = true;
        _allNotifications.clear();
        _unreadNotifications.clear();
        _readNotifications.clear();
      });
    }

    setState(() {
      _isLoading = refresh;
    });

    try {
      print('📱 Loading notifications...');
      
      // Load notifications from API
      final notifications = await apiService.getNotifications(
        page: _currentPage,
        perPage: 20,
      );

      print('📱 Received ${notifications.length} notifications');

      // Separate read and unread notifications
      final unread = notifications.where((n) => n['read_at'] == null).toList();
      final read = notifications.where((n) => n['read_at'] != null).toList();

      setState(() {
        if (refresh) {
          _allNotifications = notifications;
          _unreadNotifications = unread;
          _readNotifications = read;
        } else {
          _allNotifications.addAll(notifications);
          _unreadNotifications.addAll(unread);
          _readNotifications.addAll(read);
        }
        
        _hasMoreData = notifications.length >= 20;
        _currentPage++;
      });

      print('✅ Notifications loaded: ${_allNotifications.length} total, ${_unreadNotifications.length} unread');
      
    } catch (e) {
      print('❌ Error loading notifications: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load notifications: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _loadNotifications();
  }

  Future<void> _refreshNotifications() async {
    HapticFeedback.lightImpact();
    await _loadNotifications(refresh: true);
  }

  Future<void> _markAsRead(List<int> notificationIds) async {
    try {
      await apiService.markNotificationsAsRead(notificationIds);
      
      // Update local state
      setState(() {
        for (final notification in _allNotifications) {
          if (notificationIds.contains(notification['id'])) {
            notification['read_at'] = DateTime.now().toIso8601String();
          }
        }
        
        // Re-categorize notifications
        _unreadNotifications = _allNotifications.where((n) => n['read_at'] == null).toList();
        _readNotifications = _allNotifications.where((n) => n['read_at'] != null).toList();
      });

      HapticFeedback.lightImpact();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${notificationIds.length} notification${notificationIds.length > 1 ? 's' : ''} marked as read'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('❌ Error marking notifications as read: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as read: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final unreadIds = _unreadNotifications.map((n) => n['id'] as int).toList();
    if (unreadIds.isEmpty) return;

    await _markAsRead(unreadIds);
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    HapticFeedback.lightImpact();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    List<Map<String, dynamic>> notifications;
    
    switch (_selectedFilter) {
      case 'Unread':
        notifications = _unreadNotifications;
        break;
      case 'Read':
        notifications = _readNotifications;
        break;
      default:
        notifications = _allNotifications;
    }

    if (_searchQuery.isNotEmpty) {
      notifications = notifications.where((notification) {
        final title = notification['title']?.toString().toLowerCase() ?? '';
        final body = notification['message']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || body.contains(query);
      }).toList();
    }

    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          
          // Filter Chips
          NotificationFilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
            unreadCount: _unreadNotifications.length,
            totalCount: _allNotifications.length,
          ),
          
          // Tab Bar
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_rounded,
                        size: ResponsiveDesign.getIconSize(18),
                      ),
                      ResponsiveSpacing(height: 0, width: 8),
                      Text('All'),
                      if (_allNotifications.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_allNotifications.length}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mark_email_unread_rounded,
                        size: ResponsiveDesign.getIconSize(18),
                      ),
                      ResponsiveSpacing(height: 0, width: 8),
                      Text('Unread'),
                      if (_unreadNotifications.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_unreadNotifications.length}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(_getFilteredNotifications()),
                _buildNotificationsList(_unreadNotifications),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Notifications',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
      elevation: 0,
      centerTitle: false,
      actions: [
        if (_unreadNotifications.isNotEmpty)
          IconButton(
            onPressed: _markAllAsRead,
            icon: Icon(
              Icons.done_all_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Mark all as read',
          ),
        IconButton(
          onPressed: _refreshNotifications,
          icon: Icon(
            Icons.refresh_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: 'Refresh',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      color: Theme.of(context).colorScheme.surface,
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search notifications...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).textTheme.bodySmall?.color,
            size: ResponsiveDesign.getIconSize(20),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () => _onSearchChanged(''),
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          contentPadding: ResponsiveDesign.getPadding(all: 16),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      );
    }

    if (notifications.isEmpty) {
      return NotificationEmptyState(
        filter: _selectedFilter,
        hasSearchQuery: _searchQuery.isNotEmpty,
        onRefresh: _refreshNotifications,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: ResponsiveDesign.getPadding(all: 16),
        itemCount: notifications.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            );
          }

          final notification = notifications[index];
          return NotificationCardWidget(
            notification: notification,
            onTap: () => _handleNotificationTap(notification),
            onMarkAsRead: () => _markAsRead([notification['id']]),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    HapticFeedback.lightImpact();
    
    // Mark as read if unread
    if (notification['read_at'] == null) {
      _markAsRead([notification['id']]);
    }
    
    // Navigate based on notification type
    final type = notification['type']?.toString();
    final concernId = notification['concern_id']?.toString();
    final announcementId = notification['announcement_id']?.toString();
    
    switch (type) {
      case 'concern_update':
        if (concernId != null) {
          Navigator.pushNamed(context, '/my-concerns');
        }
        break;
      case 'announcement':
        if (announcementId != null) {
          Navigator.pushNamed(context, '/announcements');
        }
        break;
      case 'concern_assignment':
        if (concernId != null) {
          Navigator.pushNamed(context, '/my-concerns');
        }
        break;
      default:
        // Default navigation
        Navigator.pushNamed(context, '/dashboard-home');
    }
  }
}
