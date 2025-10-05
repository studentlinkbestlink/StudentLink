import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernAnnouncementCardWidget extends StatelessWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final String searchQuery;

  const ModernAnnouncementCardWidget({
    Key? key,
    required this.announcement,
    required this.onTap,
    required this.onBookmark,
    required this.onShare,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = announcement['title'] ?? 'Untitled Announcement';
    final content = announcement['content'] ?? '';
    final createdAt = announcement['created_at'] ?? '';
    final isImportant = announcement['is_important'] ?? false;
    final isBookmarked = announcement['isBookmarked'] ?? false;
    final category = announcement['category'] ?? 'General';

    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
          child: Container(
            padding: ResponsiveDesign.getPadding(all: 24),
            decoration: BoxDecoration(
              color: isImportant 
                  ? Theme.of(context).colorScheme.error.withValues(alpha: 0.03)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
              border: Border.all(
                color: isImportant
                    ? Theme.of(context).colorScheme.error.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced header with category and actions
                Row(
                  children: [
                    _buildEnhancedCategoryChip(category, context),
                    const Spacer(),
                    if (isImportant) _buildImportantBadge(context),
                    ResponsiveSpacing(height: 0, width: 8),
                    _buildActionButtons(isBookmarked, context),
                  ],
                ),
                
                ResponsiveSpacing(height: 16),
                
                // Enhanced title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    height: 1.3,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                ResponsiveSpacing(height: 12),
                
                // Enhanced content preview
                if (content.isNotEmpty) ...[
                  Text(
                    content,
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
                
                // Enhanced footer with date and read more
                Row(
                  children: [
                    Container(
                      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
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
                            color: theme.textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                            size: ResponsiveDesign.getIconSize(14),
                          ),
                          ResponsiveSpacing(height: 0, width: 6),
                          Text(
                            _formatDate(createdAt),
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: ResponsiveDesign.getFontSize(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Read More',
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveDesign.getFontSize(12),
                            ),
                          ),
                          ResponsiveSpacing(height: 0, width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: ResponsiveDesign.getIconSize(14),
                          ),
                        ],
                      ),
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

  Widget _buildEnhancedCategoryChip(String category, BuildContext context) {
    final color = _getCategoryColor(category, context);
    final icon = _getCategoryIcon(category);
    
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: ResponsiveDesign.getIconSize(14),
          ),
          ResponsiveSpacing(height: 0, width: 6),
          Text(
            category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: ResponsiveDesign.getFontSize(12),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantBadge(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.error, Theme.of(context).colorScheme.error.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.priority_high_rounded,
            color: Colors.white,
            size: ResponsiveDesign.getIconSize(12),
          ),
          ResponsiveSpacing(height: 0, width: 4),
          Text(
            'IMPORTANT',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: ResponsiveDesign.getFontSize(9),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isBookmarked, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bookmark button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onBookmark();
            },
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
            child: Container(
              padding: ResponsiveDesign.getPadding(all: 8),
              decoration: BoxDecoration(
                color: isBookmarked 
                    ? const Color(0xFFFFC107).withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
                border: Border.all(
                  color: isBookmarked 
                      ? const Color(0xFFFFC107).withValues(alpha: 0.3)
                      : Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Icon(
                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isBookmarked ? const Color(0xFFFFC107) : Theme.of(context).colorScheme.onSurfaceVariant,
                size: ResponsiveDesign.getIconSize(18),
              ),
            ),
          ),
        ),
        ResponsiveSpacing(height: 0, width: 8),
        // Share button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onShare();
            },
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
            child: Container(
              padding: ResponsiveDesign.getPadding(all: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.share_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: ResponsiveDesign.getIconSize(18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category, BuildContext context) {
    switch (category.toLowerCase()) {
      case 'academic':
      case 'academic modules':
        return Theme.of(context).colorScheme.primary;
      case 'events':
        return const Color(0xFF2480EA);
      case 'administrative':
        return const Color(0xFFFFC107);
      case 'emergency':
        return const Color(0xFFE22824);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school_rounded;
      case 'events':
        return Icons.event_rounded;
      case 'administrative':
        return Icons.admin_panel_settings_rounded;
      case 'emergency':
        return Icons.warning_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}
