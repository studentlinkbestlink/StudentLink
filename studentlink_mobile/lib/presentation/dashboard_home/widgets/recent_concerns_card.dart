import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

class RecentConcernsCard extends StatelessWidget {
  final List<Map<String, dynamic>> recentConcerns;
  final Function(Map<String, dynamic>) onConcernTap;
  final Function(Map<String, dynamic>) onConcernLongPress;

  const RecentConcernsCard({
    Key? key,
    required this.recentConcerns,
    required this.onConcernTap,
    required this.onConcernLongPress,
  }) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Concerns',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/my-concerns');
                  },
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            recentConcerns.isEmpty
                ? _buildEmptyState(context)
                : Column(
                    children: recentConcerns
                        .take(3)
                        .map((concern) => _buildConcernItem(context, concern))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(vertical: 4.h),
      child: Column(
        children: [
          Icon(
            Icons.inbox,
            color: Colors.black,
            size: ResponsiveDesign.getIconSize(48),
          ),
          SizedBox(height: 2.h),
          Text(
            'No concerns submitted yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Submit your first concern to get started',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConcernItem(BuildContext context, Map<String, dynamic> concern) {
    return GestureDetector(
      onTap: () => onConcernTap(concern),
      onLongPress: () => onConcernLongPress(concern),
      child: Container(
        margin: ResponsiveDesign.getPadding(bottom: 1.h),
        padding: ResponsiveDesign.getPadding(all: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
          border: Border.all(
            color:
                const Color(0xFF300300300).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concern['title'] as String? ?? 'Untitled Concern',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    concern['department'] as String? ?? 'Unknown Department',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatDate(concern['submittedAt']),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            _buildStatusBadge(concern['status'] as String? ?? 'Received', context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'received':
        backgroundColor =
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);
        textColor = Theme.of(context).colorScheme.primary;
        break;
      case 'in process':
        backgroundColor = Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = Theme.of(context).colorScheme.tertiary;
        break;
      case 'resolved':
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
            Icons.circle,
            color: textColor,
            size: ResponsiveDesign.getIconSize(12),
          ),
          SizedBox(width: 1.w),
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
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
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }
}
