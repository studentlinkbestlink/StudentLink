import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../announcements/widgets/new_announcement_detail_modal.dart';
import '../../announcements/widgets/new_announcement_card_widget.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import 'announcement_category_filter_bar.dart';

class ModernAnnouncementsFeed extends StatefulWidget {
  final List<Map<String, dynamic>> announcements;

  const ModernAnnouncementsFeed({
    super.key,
    required this.announcements,
  });

  @override
  State<ModernAnnouncementsFeed> createState() =>
      _ModernAnnouncementsFeedState();
}

class _ModernAnnouncementsFeedState extends State<ModernAnnouncementsFeed> {
  String _selectedCategory = 'All';
  late List<Map<String, dynamic>> _filteredAnnouncements;
  final ScrollController _filterScrollController = ScrollController();

  // Available categories (same as in announcements screen)
  final List<String> _availableCategories = [
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

  @override
  void initState() {
    super.initState();
    _filteredAnnouncements = List.from(widget.announcements);
    _applyFilters();
  }

  @override
  void didUpdateWidget(ModernAnnouncementsFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.announcements != widget.announcements) {
      _filteredAnnouncements = List.from(widget.announcements);
      _applyFilters();
    }
  }

  @override
  void dispose() {
    _filterScrollController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredAnnouncements = widget.announcements.where((announcement) {
        // Category filter
        bool categoryMatch = _selectedCategory == 'All' ||
            announcement['category'] == _selectedCategory;

        return categoryMatch;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  void _handleBookmark(Map<String, dynamic> announcement) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmark functionality coming soon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleShare(Map<String, dynamic> announcement) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality coming soon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 24, vertical: 12),
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Icon(
                Icons.campaign_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(24),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              // Title - flexible to take available space
              Expanded(
                child: Text(
                  'Latest Announcements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: ResponsiveDesign.getFontSize(18),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // View All button - fixed width to prevent truncation
              if (widget.announcements.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                    minWidth: ResponsiveDesign.getFontSize(60),
                  ),
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, '/announcements');
                    },
                    style: TextButton.styleFrom(
                      padding: ResponsiveDesign.getPadding(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View All',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveDesign.getFontSize(14),
                          ),
                    ),
                  ),
                ),
            ],
          ),

          ResponsiveSpacing(height: 16),

          // Category Filter Bar
          AnnouncementCategoryFilterBar(
            selectedCategory: _selectedCategory,
            categories: _availableCategories,
            onCategorySelected: _onCategorySelected,
            scrollController: _filterScrollController,
          ),

          ResponsiveSpacing(height: 16),

          if (widget.announcements.isEmpty)
            _buildEmptyState()
          else if (_filteredAnnouncements.isEmpty)
            _buildEmptyFilteredState()
          else
            Column(
              children: _filteredAnnouncements.take(3).map((announcement) {
                return NewAnnouncementCardWidget(
                  announcement: announcement,
                  onTap: () => _showAnnouncementDetails(context, announcement),
                  onBookmark: () => _handleBookmark(announcement),
                  onShare: () => _handleShare(announcement),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: const Color(0xFF300300300),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Compact icon
          Container(
            padding: ResponsiveDesign.getPadding(all: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF300300300),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
            child: Icon(
              Icons.campaign_outlined,
              color: Theme.of(context).textTheme.bodySmall?.color,
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),

          // Compact text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No announcements',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: ResponsiveDesign.getFontSize(14),
                      ),
                ),
                ResponsiveSpacing(height: 2),
                Text(
                  'Check back later for updates',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        fontSize: ResponsiveDesign.getFontSize(12),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Compact icon
          Container(
            padding: ResponsiveDesign.getPadding(all: 8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
            child: Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),

          // Compact text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No announcements found in this category',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: ResponsiveDesign.getFontSize(14),
                      ),
                ),
                ResponsiveSpacing(height: 2),
                Text(
                  'Try selecting a different category',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        fontSize: ResponsiveDesign.getFontSize(12),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDetails(
      BuildContext context, Map<String, dynamic> announcement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewAnnouncementDetailModal(
        announcement: announcement,
        onBookmark: () {
          // Handle bookmark functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bookmark functionality coming soon'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
        onShare: () {
          // Handle share functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Share functionality coming soon'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
