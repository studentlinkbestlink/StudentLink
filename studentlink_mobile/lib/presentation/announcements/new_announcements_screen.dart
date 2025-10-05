import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/api_service.dart';

import './widgets/new_announcement_card_widget.dart';
import './widgets/new_announcement_detail_modal.dart';
import './widgets/modern_announcement_filter_chips_widget.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../theme/app_theme.dart';

class NewAnnouncementsScreen extends StatefulWidget {
  const NewAnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<NewAnnouncementsScreen> createState() => _NewAnnouncementsScreenState();
}

class _NewAnnouncementsScreenState extends State<NewAnnouncementsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';

  // Filter states
  String _categoryFilter = 'All';
  List<String> _availableCategories = [
    'All',
    'Academic Modules',
    'Class Schedules & Exams',
    'Enrollment & Clearance',
    'Scholarships & Financial Aid',
    'Student Activities & Events',
    'Emergency Notices',
    'Administrative Updates',
    'OJT & Career Services',
    'Campus Ministry',
    'Faculty Announcements',
    'System Maintenance',
    'Student Services',
  ];

  // Announcements will be loaded from API
  List<Map<String, dynamic>> _allAnnouncements = [];
  List<Map<String, dynamic>> _filteredAnnouncements = [];
  Set<Map<String, dynamic>> _bookmarkedAnnouncements = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.text = _searchQuery;
    _filteredAnnouncements = List.from(_allAnnouncements);
    _loadAnnouncements();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔄 Loading announcements...');
      // Load announcements from API service
      final announcements = await apiService.getAnnouncements(
        status: 'published',
        perPage: 50,
      );
      
      print('📢 Loaded ${announcements.length} announcements');
      for (var announcement in announcements) {
        print('  - ${announcement['title'] ?? 'Announcement #${announcement['id']}'} (ID: ${announcement['id']})');
      }
      
      // Note: Using predefined categories instead of extracting from API
      // This ensures consistent filtering across all announcements
      
      setState(() {
        _allAnnouncements = announcements;
        _filteredAnnouncements = List.from(_allAnnouncements);
      });
      _loadBookmarked();
      _applyFilters();
    } catch (e) {
      print('❌ Error loading announcements: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load announcements: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      
      setState(() {
        _allAnnouncements = [];
        _filteredAnnouncements = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadBookmarked() {
    _bookmarkedAnnouncements = _allAnnouncements
        .where((announcement) => announcement['isBookmarked'] == true)
        .toSet();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreAnnouncements();
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredAnnouncements = _allAnnouncements.where((announcement) {
        // Category filter
        bool categoryMatch = _categoryFilter == 'All' || 
                           announcement['category'] == _categoryFilter;
        
        // Search filter
        bool searchMatch = _searchQuery.isEmpty ||
                          (announcement['title']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
                          (announcement['category']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
        
        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Theme-aware background
      appBar: _buildModernAppBar(),
      body: Column(
        children: [
          // Modern Search Bar
          _buildModernSearchBar(),

          // Modern Filter Chips
          if (_categoryFilter != 'All')
            ModernAnnouncementFilterChipsWidget(
              categoryFilter: _categoryFilter,
              onClearAll: _clearAllFilters,
            ),

          // Modern Tab Bar
          _buildModernTabBar(),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildModernAllAnnouncementsTab(),
                _buildModernBookmarkedAnnouncementsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: Text(
        'General Announcements',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            // Global search functionality
            HapticFeedback.lightImpact();
          },
          icon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: ResponsiveDesign.getIconSize(24),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSearchBar() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _applyFilters();
                },
                decoration: InputDecoration(
                  hintText: 'Search announcements...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                  border: InputBorder.none,
                  contentPadding: ResponsiveDesign.getPadding(horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: _showCategoryFilter,
              icon: Icon(
                Icons.filter_list_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(20),
              ),
              tooltip: 'Filter announcements',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveDesign.getFontSize(16),
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: ResponsiveDesign.getFontSize(16),
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Icon(
                    Icons.campaign_rounded,
                    size: ResponsiveDesign.getIconSize(18),
                  ),
                ResponsiveSpacing(height: 0, width: 8),
                Text('School Updates'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_rounded,
                  size: ResponsiveDesign.getIconSize(18),
                ),
                ResponsiveSpacing(height: 0, width: 8),
                Text('Saved'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAllAnnouncementsTab() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      );
    }
    
    if (_filteredAnnouncements.isEmpty && !_isRefreshing) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
        itemCount: _filteredAnnouncements.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredAnnouncements.length) {
            return _buildLoadingIndicator();
          }

          final announcement = _filteredAnnouncements[index];
          return NewAnnouncementCardWidget(
            announcement: announcement,
            onTap: () => _showAnnouncementDetail(announcement),
            onBookmark: () => _toggleBookmark(announcement),
            onShare: () => _shareAnnouncement(announcement),
          );
        },
      ),
    );
  }

  Widget _buildModernBookmarkedAnnouncementsTab() {
    final bookmarkedAnnouncements = _filteredAnnouncements
        .where((announcement) => announcement['is_bookmarked'] == true)
        .toList();

    if (bookmarkedAnnouncements.isEmpty) {
      return _buildEmptyBookmarksState();
    }

    return ListView.builder(
      padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
      itemCount: bookmarkedAnnouncements.length,
      itemBuilder: (context, index) {
        final announcement = bookmarkedAnnouncements[index];
        return NewAnnouncementCardWidget(
          announcement: announcement,
          onTap: () => _showAnnouncementDetail(announcement),
          onBookmark: () => _toggleBookmark(announcement),
          onShare: () => _shareAnnouncement(announcement),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: ResponsiveDesign.getPadding(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // More subtle icon with better proportions
            Container(
              padding: ResponsiveDesign.getPadding(all: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.announcement_outlined,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                size: ResponsiveDesign.getIconSize(48),
              ),
            ),
            ResponsiveSpacing(height: 20),
            
            // Better typography hierarchy
            Text(
              'No announcements found',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF300300300),
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveDesign.getFontSize(20),
              ),
              textAlign: TextAlign.center,
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'Check back later for new updates',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                fontSize: ResponsiveDesign.getFontSize(14),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBookmarksState() {
    return Center(
      child: Padding(
        padding: ResponsiveDesign.getPadding(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // More subtle icon with better proportions
            Container(
              padding: ResponsiveDesign.getPadding(all: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_outline_rounded,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                size: ResponsiveDesign.getIconSize(48),
              ),
            ),
            ResponsiveSpacing(height: 20),
            
            // Better typography hierarchy
            Text(
              'No saved announcements',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF300300300),
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveDesign.getFontSize(20),
              ),
              textAlign: TextAlign.center,
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'Tap the bookmark icon to save announcements',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                fontSize: ResponsiveDesign.getFontSize(14),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    
    await _loadAnnouncements();
    
    setState(() {
      _isRefreshing = false;
    });
  }

  void _loadMoreAnnouncements() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more announcements
    Future.delayed(Duration(seconds: 1)).then((_) {
      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  void _showAnnouncementDetail(Map<String, dynamic> announcement) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NewAnnouncementDetailModal(
        announcement: announcement,
        onBookmark: () => _toggleBookmark(announcement),
        onShare: () => _shareAnnouncement(announcement),
      ),
    );
  }

  void _toggleBookmark(Map<String, dynamic> announcement) {
    setState(() {
      announcement['is_bookmarked'] = !announcement['is_bookmarked'];

      if (announcement['is_bookmarked']) {
        _bookmarkedAnnouncements.add(announcement);
      } else {
        _bookmarkedAnnouncements.remove(announcement);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          announcement['is_bookmarked']
              ? 'Announcement bookmarked'
              : 'Bookmark removed',
        ),
        backgroundColor: announcement['is_bookmarked']
            ? Theme.of(context).colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _shareAnnouncement(Map<String, dynamic> announcement) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Announcement shared successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: ResponsiveDesign.getPadding(all: 16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter by Category',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            ResponsiveSpacing(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _availableCategories.length,
                itemBuilder: (context, index) {
                  final category = _availableCategories[index];
                  return ListTile(
                    title: Text(category),
                    leading: Radio<String>(
                      value: category,
                      groupValue: _categoryFilter,
                      onChanged: (value) {
                        setState(() {
                          _categoryFilter = value!;
                        });
                        _applyFilters();
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _categoryFilter = 'All';
      _searchQuery = '';
      _searchController.clear();
    });
    _applyFilters();
  }
}
