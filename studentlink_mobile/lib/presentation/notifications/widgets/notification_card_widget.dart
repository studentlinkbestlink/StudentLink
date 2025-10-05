import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/responsive_design.dart';
import '../../../../widgets/responsive_widgets.dart';

class NotificationCardWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;

  const NotificationCardWidget({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUnread = notification['read_at'] == null;
    final type = notification['type']?.toString() ?? 'general';
    final title = notification['title']?.toString() ?? 'Notification';
    final body = notification['message']?.toString() ?? '';
    final createdAt = notification['created_at']?.toString();
    final priority = notification['priority']?.toString() ?? 'normal';

    return Container(
      margin: ResponsiveDesign.getPadding(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: isUnread 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline,
          width: isUnread ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          child: Padding(
            padding: ResponsiveDesign.getPadding(all: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                _buildNotificationIcon(type, priority, isUnread, context),
                
                ResponsiveSpacing(height: 0, width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ResponsiveSpacing(height: 0, width: 8),
                          Text(
                            _formatTime(createdAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
                          ),
                        ],
                      ),
                      
                      if (body.isNotEmpty) ...[
                        ResponsiveSpacing(height: 4),
                        Text(
                          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            height: 1.4,
          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      
                      ResponsiveSpacing(height: 8),
                      
                      // Type and Actions
                      Row(
                        children: [
                          _buildTypeChip(type, context),
                          const Spacer(),
                          if (isUnread)
                            GestureDetector(
                              onTap: onMarkAsRead,
                              child: Container(
                                padding: ResponsiveDesign.getPadding(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
                                ),
                                child: Text(
                                  'Mark as read',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Unread indicator
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type, String priority, bool isUnread, BuildContext context) {
    IconData iconData;
    Color iconColor;
    
    // Check if this is a concern notification and determine priority from the message
    final message = notification['message']?.toString() ?? '';
    final isEmergency = message.contains('EMRG-') || message.contains('emergency');
    final isCrossDepartment = message.contains('CROSS-');
    
    switch (type) {
      case 'announcement':
        iconData = Icons.campaign_rounded;
        // Use priority-based colors for announcements
        if (priority == 'urgent') {
          iconColor = Theme.of(context).colorScheme.error; // Red for urgent announcements
        } else if (priority == 'high') {
          iconColor = Theme.of(context).colorScheme.error; // Orange for high priority
        } else if (priority == 'medium') {
          iconColor = Theme.of(context).colorScheme.tertiary; // Yellow for medium priority
        } else {
          iconColor = Theme.of(context).colorScheme.secondary; // Blue for low/normal priority
        }
        break;
      case 'concern_update':
        iconData = Icons.assignment_rounded;
        if (isEmergency) {
          iconColor = Theme.of(context).colorScheme.error; // Red for emergency
        } else if (isCrossDepartment) {
          iconColor = Theme.of(context).colorScheme.secondary; // Purple for cross-department
        } else {
          iconColor = Theme.of(context).colorScheme.tertiary; // Yellow for normal concerns
        }
        break;
      case 'concern_assignment':
        iconData = Icons.person_add_rounded;
        if (isEmergency) {
          iconColor = Theme.of(context).colorScheme.error;
        } else if (isCrossDepartment) {
          iconColor = Theme.of(context).colorScheme.secondary;
        } else {
          iconColor = Theme.of(context).colorScheme.primary;
        }
        break;
      case 'chat_message':
        iconData = Icons.chat_rounded;
        iconColor = Theme.of(context).colorScheme.tertiary;
        break;
      case 'emergency':
        iconData = Icons.warning_rounded;
        iconColor = Theme.of(context).colorScheme.error;
        break;
      default:
        iconData = Icons.notifications_rounded;
        iconColor = Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    }

    // Adjust color based on priority (only if not already determined by concern type)
    if ((priority == 'high' || priority == 'urgent') && !isEmergency && !isCrossDepartment) {
      iconColor = Theme.of(context).colorScheme.error;
    }

    return Container(
      padding: ResponsiveDesign.getPadding(all: 8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: ResponsiveDesign.getIconSize(20),
      ),
    );
  }

  Widget _buildTypeChip(String type, BuildContext context) {
    String label;
    Color color;
    
    // Get priority from notification data
    final priority = notification['priority']?.toString() ?? 'normal';
    
    // Check if this is a concern notification and determine priority from the message
    final message = notification['message']?.toString() ?? '';
    final isEmergency = message.contains('EMRG-') || message.contains('emergency');
    final isCrossDepartment = message.contains('CROSS-');
    
    switch (type) {
      case 'announcement':
        label = 'Announcement';
        // Use priority-based colors for announcement chips
        if (priority == 'urgent') {
          color = Theme.of(context).colorScheme.error; // Red for urgent announcements
        } else if (priority == 'high') {
          color = Theme.of(context).colorScheme.error; // Red for high priority
        } else if (priority == 'medium') {
          color = Theme.of(context).colorScheme.tertiary; // Yellow for medium priority
        } else {
          color = Theme.of(context).colorScheme.secondary; // Blue for low/normal priority
        }
        break;
      case 'concern_update':
        if (isEmergency) {
          label = 'Emergency';
          color = Theme.of(context).colorScheme.error; // Red for emergency
        } else if (isCrossDepartment) {
          label = 'Cross-Department';
          color = Theme.of(context).colorScheme.secondary; // Purple for cross-department
        } else if (message.contains('CNR-')) {
          label = 'Concern Update';
          color = Theme.of(context).colorScheme.tertiary; // Yellow for normal concerns
        } else {
          label = 'Concern Update';
          color = Theme.of(context).colorScheme.tertiary;
        }
        break;
      case 'concern_assignment':
        if (isEmergency) {
          label = 'Emergency Assignment';
          color = Theme.of(context).colorScheme.error;
        } else if (isCrossDepartment) {
          label = 'Cross-Department Assignment';
          color = Theme.of(context).colorScheme.secondary;
        } else {
          label = 'Assignment';
          color = Theme.of(context).colorScheme.primary;
        }
        break;
      case 'chat_message':
        label = 'Message';
        color = Theme.of(context).colorScheme.tertiary;
        break;
      case 'emergency':
        label = 'Emergency';
        color = Theme.of(context).colorScheme.error;
        break;
      default:
        label = 'General';
        color = Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: ResponsiveDesign.getPadding(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM d').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }
}
