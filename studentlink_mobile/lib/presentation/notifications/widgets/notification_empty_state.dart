import 'package:flutter/material.dart';

import '../../../utils/responsive_design.dart';
import '../../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class NotificationEmptyState extends StatelessWidget {
  final String filter;
  final bool hasSearchQuery;
  final VoidCallback onRefresh;

  const NotificationEmptyState({
    Key? key,
    required this.filter,
    required this.hasSearchQuery,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveDesign.getPadding(all: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: ResponsiveDesign.getPadding(all: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getEmptyStateIcon(),
                size: ResponsiveDesign.getIconSize(48),
                color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
              ),
            ),
            
            ResponsiveSpacing(height: 24),
            
            // Title
            Text(
              _getEmptyStateTitle(),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF300300300),
              ),
              textAlign: TextAlign.center,
            ),
            
            ResponsiveSpacing(height: 8),
            
            // Description
            Text(
              _getEmptyStateDescription(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            ResponsiveSpacing(height: 32),
            
            // Action Button
            if (!hasSearchQuery)
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh_rounded,
                  size: ResponsiveDesign.getIconSize(20),
                ),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A78),
                  foregroundColor: Colors.white,
                  padding: ResponsiveDesign.getPadding(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                  ),
                  elevation: 0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    if (hasSearchQuery) {
      return Icons.search_off_rounded;
    }
    
    switch (filter) {
      case 'Unread':
        return Icons.mark_email_read_rounded;
      case 'Read':
        return Icons.mark_email_unread_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _getEmptyStateTitle() {
    if (hasSearchQuery) {
      return 'No Results Found';
    }
    
    switch (filter) {
      case 'Unread':
        return 'No Unread Notifications';
      case 'Read':
        return 'No Read Notifications';
      default:
        return 'No Notifications Yet';
    }
  }

  String _getEmptyStateDescription() {
    if (hasSearchQuery) {
      return 'Try adjusting your search terms or check back later for new notifications.';
    }
    
    switch (filter) {
      case 'Unread':
        return 'You\'re all caught up! New notifications will appear here when they arrive.';
      case 'Read':
        return 'You haven\'t read any notifications yet. New notifications will appear in the "Unread" tab.';
      default:
        return 'You\'ll receive notifications about announcements, concern updates, and other important information here.';
    }
  }
}
