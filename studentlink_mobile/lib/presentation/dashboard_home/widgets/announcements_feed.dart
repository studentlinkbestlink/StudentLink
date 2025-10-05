import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

class AnnouncementsFeed extends StatefulWidget {
  final List<Map<String, dynamic>> announcements;

  const AnnouncementsFeed({
    Key? key,
    required this.announcements,
  }) : super(key: key);

  @override
  State<AnnouncementsFeed> createState() => _AnnouncementsFeedState();
}

class _AnnouncementsFeedState extends State<AnnouncementsFeed> {
  String selectedFilter = 'All';
  final List<String> filterOptions = [
    'All',
    'BS Information Technology',
    'BS Hospitality Management',
    'BS Office Administration',
    'BS Business Administration',
    'BS Criminology',
    'Bachelor of Elementary Education',
    'Bachelor of Secondary Education',
    'BS Computer Engineering',
    'BS Tourism Management',
    'BS Entrepreneurship',
    'BS Accounting Information System',
    'BS Psychology',
  ];

  List<Map<String, dynamic>> get filteredAnnouncements {
    if (selectedFilter == 'All') {
      return widget.announcements;
    }
    return widget.announcements
        .where((announcement) =>
            (announcement['targetCourse'] as String?) == selectedFilter ||
            (announcement['department'] as String?) == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
      ),
      child: Container(
        width: double.infinity,
        padding: ResponsiveDesign.getPadding(all: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Announcements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 2.h),
            _buildFilterChips(),
            SizedBox(height: 2.h),
            filteredAnnouncements.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: filteredAnnouncements
                        .map((announcement) =>
                            _buildAnnouncementItem(announcement))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 5.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final option = filterOptions[index];
          final isSelected = selectedFilter == option;

          return Container(
            margin: ResponsiveDesign.getPadding(right: 2.w),
            child: FilterChip(
              label: Text(
                option,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = option;
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!
                        .withValues(alpha: 0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(vertical: 4.h),
      child: Column(
        children: [
          Icon(
            Icons.campaign,
            color: Colors.black,
            size: ResponsiveDesign.getIconSize(48),
          ),
          SizedBox(height: 2.h),
          Text(
            'No announcements available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            selectedFilter == 'All'
                ? 'Check back later for updates'
                : 'No announcements for $selectedFilter',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(Map<String, dynamic> announcement) {
    return GestureDetector(
      onTap: () => _navigateToAnnouncementDetail(announcement),
      child: Container(
        margin: ResponsiveDesign.getPadding(bottom: 2.h),
        padding: ResponsiveDesign.getPadding(all: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
          border: Border.all(
            color: Colors.grey[300]!.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  announcement['title'] as String? ?? 'Untitled Announcement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2.w),
              _buildPriorityBadge(
                  announcement['priority'] as String? ?? 'normal'),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(
                Icons.business,
                color: Colors.black,
                size: ResponsiveDesign.getIconSize(16),
              ),
              SizedBox(width: 1.w),
              Text(
                announcement['department'] as String? ?? 'Unknown Department',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 3.w),
              Icon(
                Icons.schedule,
                color: Colors.black,
                size: ResponsiveDesign.getIconSize(16),
              ),
              SizedBox(width: 1.w),
              Text(
                _formatDate(announcement['publishedAt']),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            announcement['content'] as String? ?? 'No content available',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if ((announcement['targetCourse'] as String?)?.isNotEmpty ==
              true) ...[
            SizedBox(height: 1.h),
            Container(
              padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.primary,
                    size: ResponsiveDesign.getIconSize(14),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    announcement['targetCourse'] as String,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
    );
  }

  void _navigateToAnnouncementDetail(Map<String, dynamic> announcement) {
    // Navigate to announcements screen with the specific announcement
    Navigator.pushNamed(
      context,
      '/announcements',
      arguments: {'highlightId': announcement['id']},
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color backgroundColor;
    Color textColor;

    switch (priority.toLowerCase()) {
      case 'high':
        backgroundColor = Theme.of(context).colorScheme.error.withValues(alpha: 0.1);
        textColor = Theme.of(context).colorScheme.error;
        break;
      case 'medium':
        backgroundColor = Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = Theme.of(context).colorScheme.tertiary;
        break;
      case 'low':
        backgroundColor = Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = Theme.of(context).colorScheme.tertiary;
        break;
      default:
        backgroundColor = Colors.white.withValues(alpha: 0.8);
        textColor = Colors.black;
    }

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.refresh,
            color: textColor,
            size: ResponsiveDesign.getIconSize(12),
          ),
          SizedBox(width: 1.w),
          Text(
            priority.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';

    try {
      DateTime dateTime;
      if (date is DateTime) {
        dateTime = date;
      } else if (date is String) {
        dateTime = DateTime.parse(date);
      } else {
        return 'Invalid date';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }
}
