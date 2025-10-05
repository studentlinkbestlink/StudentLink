import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ConcernCardWidget extends StatelessWidget {
  final Map<String, dynamic> concern;
  final VoidCallback? onViewDetails;
  final VoidCallback? onAddReply;
  final VoidCallback? onArchive;
  final VoidCallback? onLongPress;

  const ConcernCardWidget({
    Key? key,
    required this.concern,
    this.onViewDetails,
    this.onAddReply,
    this.onArchive,
    this.onLongPress,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF28A745);
      case 'approved':
        return const Color(0xFF28A745);
      case 'rejected':
        return const Color(0xFFE22824);
      case 'in_progress':
        return const Color(0xFF2480EA);
      case 'resolved':
        return const Color(0xFF28A745);
      case 'closed':
        return const Color(0xFF757575);
      case 'cancelled':
        return const Color(0xFF757575);
      default:
        return const Color(0xFF757575);
    }
  }

  String _getDepartmentName(Map<String, dynamic> concern) {
    // Try to get department name from assigned_to object
    if (concern['assigned_to'] != null && concern['assigned_to'] is Map) {
      final assignedTo = concern['assigned_to'] as Map<String, dynamic>;
      if (assignedTo['name'] != null) {
        return assignedTo['name'] as String;
      }
    }
    
    // Try to get department name from department object
    if (concern['department'] != null) {
      if (concern['department'] is String) {
        return concern['department'] as String;
      } else if (concern['department'] is Map) {
        final dept = concern['department'] as Map<String, dynamic>;
        return dept['name'] ?? dept['code'] ?? 'Unknown Department';
      }
    }
    
    return 'Unknown Department';
  }

  DateTime _getSubmissionDate(Map<String, dynamic> concern) {
    try {
      if (concern['created_at'] != null) {
        return DateTime.parse(concern['created_at'] as String);
      }
      if (concern['submissionDate'] != null) {
        if (concern['submissionDate'] is DateTime) {
          return concern['submissionDate'] as DateTime;
        } else if (concern['submissionDate'] is String) {
          return DateTime.parse(concern['submissionDate'] as String);
        }
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final String title = concern['subject'] ?? concern['title'] ?? 'No Title';
    final String department = _getDepartmentName(concern);
    final String status = concern['status'] ?? 'Unknown';
    final DateTime submissionDate = _getSubmissionDate(concern);
    final String latestReply = concern['latestReply'] ?? '';

    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(concern['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onViewDetails?.call(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View Details',
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            SlidableAction(
              onPressed: (context) => onAddReply?.call(),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.reply,
              label: 'Add Reply',
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
          ],
        ),
        endActionPane: status.toLowerCase() == 'resolved'
            ? ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => onArchive?.call(),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                  ),
                ],
              )
            : null,
        child: GestureDetector(
          onLongPress: onLongPress,
          onLongPressStart: (details) {
            // Provide haptic feedback for better UX
            HapticFeedback.mediumImpact();
          },
          onLongPressCancel: () {
            // Reset any visual feedback if long press is cancelled
          },
          behavior: HitTestBehavior.opaque,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            child: Container(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                          border: Border.all(
                            color: _getStatusColor(status),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          status,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                        ),
                        child: Text(
                          department,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${submissionDate.day}/${submissionDate.month}/${submissionDate.year}',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (latestReply.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: ResponsiveDesign.getPadding(all: 2.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                        border: Border.all(
                          color: Color(0xFF300300300)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'chat_bubble_outline',
                            size: ResponsiveDesign.getIconSize(16),
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              latestReply,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Show rejection reason if concern is rejected
                  if (status.toLowerCase() == 'rejected' && concern['rejection_reason'] != null) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: ResponsiveDesign.getPadding(all: 2.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            size: ResponsiveDesign.getIconSize(16),
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rejection Reason:',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  concern['rejection_reason'],
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
