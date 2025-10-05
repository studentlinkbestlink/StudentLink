import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernConcernCardWidget extends StatelessWidget {
  final Map<String, dynamic> concern;
  final VoidCallback onViewDetails;
  final VoidCallback onAddReply;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const ModernConcernCardWidget({
    Key? key,
    required this.concern,
    required this.onViewDetails,
    required this.onAddReply,
    required this.onDelete,
    required this.onLongPress,
  }) : super(key: key);

  bool get _isApproved => concern['status'] == 'approved';

  @override
  Widget build(BuildContext context) {
    final status = concern['status'] ?? 'pending';
    final priority = concern['priority'] ?? 'medium';
    final title = concern['subject'] ?? concern['title'] ?? 'Untitled Concern';
    final description = concern['description'] ?? '';
    final createdAt = concern['created_at'] ?? '';
    final replyCount = concern['replies_count'] ?? 0;

    return Container(
      margin: ResponsiveDesign.getPadding(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onViewDetails,
          onLongPress: () {
            HapticFeedback.mediumImpact();
            onLongPress();
          },
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
          child: Container(
            padding: ResponsiveDesign.getPadding(all: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status and priority
                Row(
                  children: [
                    _buildEnhancedStatusChip(status, context),
                    ResponsiveSpacing(height: 0, width: 12),
                    _buildEnhancedPriorityChip(priority, context),
                    const Spacer(),
                    Container(
                      padding: ResponsiveDesign.getPadding(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                            ResponsiveDesign.getBorderRadius(12)),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            size: ResponsiveDesign.getIconSize(14),
                          ),
                          ResponsiveSpacing(height: 0, width: 6),
                          Text(
                            _formatDate(createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: ResponsiveDesign.getFontSize(12),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                ResponsiveSpacing(height: 16),

                // Title with enhanced typography
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        height: 1.3,
                        letterSpacing: -0.2,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                ResponsiveSpacing(height: 12),

                // Description with better spacing
                if (description.isNotEmpty) ...[
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          height: 1.5,
                          fontSize: ResponsiveDesign.getFontSize(15),
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveSpacing(height: 16),
                ],

                // Enhanced footer with actions
                Row(
                  children: [
                    // Reply count with better styling
                    if (replyCount > 0) ...[
                      Container(
                        padding: ResponsiveDesign.getPadding(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                              ResponsiveDesign.getBorderRadius(10)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: ResponsiveDesign.getIconSize(16),
                            ),
                            ResponsiveSpacing(height: 0, width: 6),
                            Text(
                              '$replyCount ${replyCount == 1 ? 'reply' : 'replies'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: ResponsiveDesign.getFontSize(12),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ResponsiveSpacing(height: 0, width: 12),
                    ],

                    const Spacer(),

                    // Enhanced action buttons
                    if (_isApproved) ...[
                      _buildEnhancedActionButton(
                        icon: Icons.reply_rounded,
                        label: 'Reply',
                        onTap: onAddReply,
                        color: Theme.of(context).colorScheme.primary,
                        isPrimary: true,
                        context: context,
                      ),
                      ResponsiveSpacing(height: 0, width: 12),
                    ] else ...[
                      _buildEnhancedActionButton(
                        icon: Icons.visibility_rounded,
                        label: 'View',
                        onTap: onViewDetails,
                        color: Theme.of(context).colorScheme.primary,
                        isPrimary: true,
                        context: context,
                      ),
                      ResponsiveSpacing(height: 0, width: 12),
                    ],
                    _buildEnhancedActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      onTap: onDelete,
                      color: Theme.of(context).colorScheme.error,
                      isPrimary: false,
                      context: context,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStatusChip(String status, BuildContext context) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);
    final icon = _getStatusIcon(status);

    // Determine text color based on background brightness for better contrast
    final isLightBackground = Theme.of(context).brightness == Brightness.light;
    final textColor =
        isLightBackground ? color : _getContrastingTextColor(color);

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isLightBackground ? 0.12 : 0.2),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: color.withValues(alpha: isLightBackground ? 0.25 : 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: ResponsiveDesign.getIconSize(14),
          ),
          ResponsiveSpacing(height: 0, width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveDesign.getFontSize(12),
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPriorityChip(String priority, BuildContext context) {
    final color = _getPriorityColor(priority);
    final label = _getPriorityLabel(priority);
    final icon = _getPriorityIcon(priority);

    // Determine text color based on background brightness for better contrast
    final isLightBackground = Theme.of(context).brightness == Brightness.light;
    final textColor =
        isLightBackground ? color : _getContrastingTextColor(color);

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isLightBackground ? 0.12 : 0.2),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: color.withValues(alpha: isLightBackground ? 0.25 : 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: ResponsiveDesign.getIconSize(14),
          ),
          ResponsiveSpacing(height: 0, width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveDesign.getFontSize(12),
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required bool isPrimary,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        child: Container(
          padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isPrimary ? color : color.withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            border: isPrimary
                ? null
                : Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : color,
                size: ResponsiveDesign.getIconSize(16),
              ),
              ResponsiveSpacing(height: 0, width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isPrimary ? Colors.white : color,
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveDesign.getFontSize(13),
                      letterSpacing: 0.2,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF3B82F6); // Blue for pending
      case 'approved':
        return const Color(0xFF10B981); // Green for approved
      case 'in_progress':
        return const Color(
            0xFFFFA726); // Brighter amber for in progress - better contrast
      case 'resolved':
        return const Color(0xFF8B5CF6); // Purple for resolved
      case 'student_confirmed':
        return const Color(0xFF10B981); // Green for confirmed
      case 'closed':
        return const Color(0xFF6B7280); // Gray for closed
      case 'cancelled':
        return const Color(0xFF6B7280); // Gray for cancelled
      case 'rejected':
        return const Color(0xFFEF4444); // Red for rejected
      case 'escalated':
        return const Color(0xFFEC4899); // Pink for escalated
      default:
        return const Color(0xFF6B7280); // Gray for unknown
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'student_confirmed':
        return 'Confirmed';
      case 'closed':
        return 'Closed';
      case 'cancelled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      case 'escalated':
        return 'Escalated';
      default:
        return 'Unknown';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'approved':
        return Icons.verified_rounded;
      case 'in_progress':
        return Icons.hourglass_empty_rounded;
      case 'resolved':
        return Icons.check_circle_rounded;
      case 'student_confirmed':
        return Icons.verified_user_rounded;
      case 'closed':
        return Icons.lock_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'rejected':
        return Icons.close_rounded;
      case 'escalated':
        return Icons.trending_up_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFDC2626); // Red for urgent
      case 'high':
        return const Color(0xFFEF4444); // Red for high
      case 'medium':
        return const Color(
            0xFFFFA726); // Brighter amber for medium - better contrast
      case 'low':
        return const Color(0xFF10B981); // Green for low
      default:
        return const Color(0xFF6B7280); // Gray for normal
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 'Urgent';
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      default:
        return 'Normal';
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Icons.warning_rounded;
      case 'high':
        return Icons.priority_high_rounded;
      case 'medium':
        return Icons.remove_rounded;
      case 'low':
        return Icons.keyboard_arrow_down_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

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
      return '';
    }
  }

  /// Helper method to get contrasting text color for better visibility in dark mode
  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance to determine if we need light or dark text
    final luminance = backgroundColor.computeLuminance();

    // For dark backgrounds, use light text; for light backgrounds, use dark text
    if (luminance < 0.5) {
      // Dark background - use light text
      return Colors.white;
    } else {
      // Light background - use dark text
      return const Color(
          0xFF1F2937); // Dark gray instead of black for better readability
    }
  }
}
