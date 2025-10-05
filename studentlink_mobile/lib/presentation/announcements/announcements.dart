import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/api_service.dart';

import './widgets/image_announcement_card_widget.dart';
import './widgets/image_announcement_detail_modal.dart';
import './widgets/modern_announcement_filter_chips_widget.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';

  // Filter states
  String _categoryFilter = 'All';

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
    _loadAnnouncements(); // Load from API
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔄 Loading announcements...');
      // Load announcements from API service (all are now image-only)
      final announcements = await apiService.getAnnouncements(
        status: 'published',
        perPage: 50,
      );
      
      debugPrint('📢 Loaded ${announcements.length} announcements');
      for (var announcement in announcements) {
        debugPrint('  - ${announcement['internal_title'] ?? 'Image Announcement #${announcement['id']}'} (ID: ${announcement['id']})');
      }
      
      setState(() {
        _allAnnouncements = announcements;
        _filteredAnnouncements = List.from(_allAnnouncements);
      });
      _loadBookmarked();
    } catch (e) {
      debugPrint('❌ Error loading announcements: $e');
      // Show error message to user
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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
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
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: _handleRefresh,
          icon: Icon(
            Icons.refresh_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: ResponsiveDesign.getIconSize(24),
          ),
          tooltip: 'Refresh Announcements',
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
                onChanged: _onSearchChanged,
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
                  color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 3,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
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
                  _tabController.index == 0 ? Icons.campaign_rounded : Icons.campaign_outlined,
                  size: ResponsiveDesign.getIconSize(20),
                ),
                ResponsiveSpacing(height: 0, width: 8),
                const Text('All'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _tabController.index == 1 ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  size: ResponsiveDesign.getIconSize(20),
                ),
                ResponsiveSpacing(height: 0, width: 8),
                const Text('Saved'),
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
      return _buildModernEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: ResponsiveDesign.getPadding(vertical: 8),
        itemCount: _filteredAnnouncements.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredAnnouncements.length) {
            return _buildModernLoadingIndicator();
          }

          final announcement = _filteredAnnouncements[index];
          return ImageAnnouncementCardWidget(
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
    final bookmarkedList = _bookmarkedAnnouncements.toList();

    if (bookmarkedList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: ResponsiveDesign.getPadding(all: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_outline_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(64),
              ),
            ),
            ResponsiveSpacing(height: 24),
            Text(
              'No Saved Announcements',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontWeight: FontWeight.w700,
              ),
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'Bookmark important announcements to save them here',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: ResponsiveDesign.getPadding(vertical: 8),
      itemCount: bookmarkedList.length,
      itemBuilder: (context, index) {
        final announcement = bookmarkedList[index];
        return ImageAnnouncementCardWidget(
          announcement: announcement,
          onTap: () => _showAnnouncementDetail(announcement),
          onBookmark: () => _toggleBookmark(announcement),
          onShare: () => _shareAnnouncement(announcement),
        );
      },
    );
  }

  Widget _buildModernEmptyState() {
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
                Icons.image_outlined,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                size: ResponsiveDesign.getIconSize(48),
              ),
            ),
            ResponsiveSpacing(height: 20),
            
            // Better typography hierarchy
            Text(
              'No Image Announcements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF300300300),
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveDesign.getFontSize(20),
              ),
              textAlign: TextAlign.center,
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'Check back later for visual announcements and updates',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: ResponsiveDesign.getFontSize(14),
              ),
              textAlign: TextAlign.center,
            ),
            ResponsiveSpacing(height: 32),
            
            // Smaller, more subtle button
            SizedBox(
              width: 160,
              height: 40,
              child: OutlinedButton(
                onPressed: _clearAllFilters,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                  ),
                  padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'Clear Filters',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveDesign.getFontSize(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernLoadingIndicator() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredAnnouncements = _allAnnouncements.where((announcement) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          final titleMatch = announcement['title']
              .toString()
              .toLowerCase()
              .contains(searchLower);
          final contentMatch = announcement['content']
              .toString()
              .toLowerCase()
              .contains(searchLower);
          if (!titleMatch && !contentMatch) return false;
        }

        // Category filter
        if (_categoryFilter != 'All' &&
            announcement['category'] != _categoryFilter) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _showCategoryFilter() {
    final categories = [
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            ResponsiveSpacing(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
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

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Actually refresh announcements from API
    await _loadAnnouncements();

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Announcements refreshed'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: Duration(seconds: 2),
      ),
    );
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
      builder: (context) => ImageAnnouncementDetailModal(
        announcement: announcement,
        onBookmark: () => _toggleBookmark(announcement),
        onShare: () => _shareAnnouncement(announcement),
      ),
    );
  }

  void _toggleBookmark(Map<String, dynamic> announcement) {
    setState(() {
      announcement['isBookmarked'] = !announcement['isBookmarked'];

      if (announcement['isBookmarked']) {
        _bookmarkedAnnouncements.add(announcement);
      } else {
        _bookmarkedAnnouncements.remove(announcement);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          announcement['isBookmarked']
              ? 'Announcement bookmarked'
              : 'Bookmark removed',
        ),
        backgroundColor: announcement['isBookmarked']
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).textTheme.titleMedium?.color,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _shareAnnouncement(Map<String, dynamic> announcement) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Announcement shared successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
