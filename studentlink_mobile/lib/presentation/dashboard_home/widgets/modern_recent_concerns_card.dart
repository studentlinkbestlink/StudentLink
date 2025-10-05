import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernRecentConcernsCard extends StatelessWidget {
  final List<Map<String, dynamic>> recentConcerns;
  final Function(Map<String, dynamic>) onConcernTap;
  final Function(Map<String, dynamic>) onConcernLongPress;

  const ModernRecentConcernsCard({
    Key? key,
    required this.recentConcerns,
    required this.onConcernTap,
    required this.onConcernLongPress,
  }) : super(key: key);

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
                Icons.assignment_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(24),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              // Title - flexible to take available space
              Expanded(
                child: Text(
                  'Recent Concerns',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleMedium?.color ??
                        Colors.black,
                    fontSize: ResponsiveDesign.getFontSize(18),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // View All button - fixed width to prevent truncation
              if (recentConcerns.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                    minWidth: ResponsiveDesign.getFontSize(60),
                  ),
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, '/my-concerns');
                    },
                    style: TextButton.styleFrom(
                      padding: ResponsiveDesign.getPadding(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View All',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
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
          if (recentConcerns.isEmpty)
            _buildEmptyState()
          else
            Column(
              children: recentConcerns.take(3).map((concern) {
                return Padding(
                  padding: ResponsiveDesign.getPadding(bottom: 12),
                  child: _buildConcernItem(concern, context),
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
          color: Color(0xFF300300300),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Compact icon
          Container(
            padding: ResponsiveDesign.getPadding(all: 8),
            decoration: BoxDecoration(
              color: Color(0xFF300300300),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
            child: Icon(
              Icons.inbox_outlined,
              color: const Color(0xFF757575),
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
                  'No concerns yet',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: ResponsiveDesign.getFontSize(14),
                  ),
                ),
                ResponsiveSpacing(height: 2),
                Text(
                  'Submit your first concern to get started',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF757575),
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

  Widget _buildConcernItem(Map<String, dynamic> concern, BuildContext context) {
    final status = concern['status'] ?? 'pending';
    final title = concern['subject'] ?? concern['title'] ?? 'Untitled Concern';
    final createdAt = concern['created_at'] ?? '';
    final priority = concern['priority'] ?? 'medium';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onConcernTap(concern);
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          onConcernLongPress(concern);
        },
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        child: Container(
          padding: ResponsiveDesign.getPadding(all: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(status, context),
                  shape: BoxShape.circle,
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),

              // Concern details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color ??
                            Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ResponsiveSpacing(height: 4),
                    Row(
                      children: [
                        _buildStatusChip(status, context),
                        ResponsiveSpacing(height: 0, width: 8),
                        _buildPriorityChip(priority, context),
                        const Spacer(),
                        Text(
                          _formatDate(createdAt),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color ??
                                Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    Theme.of(context).textTheme.bodySmall?.color,
                size: ResponsiveDesign.getIconSize(20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, BuildContext context) {
    final color = _getStatusColor(status, context);
    final label = _getStatusLabel(status);

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveDesign.getFontSize(10),
            ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority, BuildContext context) {
    final color = _getPriorityColor(priority, context);
    final label = _getPriorityLabel(priority);

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveDesign.getFontSize(10),
            ),
      ),
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
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
      case 'disputed':
        return const Color(0xFFEF4444); // Red for disputed
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
      case 'disputed':
        return 'Disputed';
      default:
        return 'Unknown';
    }
  }

  Color _getPriorityColor(String priority, BuildContext context) {
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
}
