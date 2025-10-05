import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernAnnouncementDetailModal extends StatelessWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const ModernAnnouncementDetailModal({
    Key? key,
    required this.announcement,
    required this.onBookmark,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = announcement['title'] ?? 'Untitled Announcement';
    final content = announcement['content'] ?? '';
    final createdAt = announcement['created_at'] ?? '';
    final isImportant = announcement['is_important'] ?? false;
    final isBookmarked = announcement['isBookmarked'] ?? false;
    final category = announcement['category'] ?? 'General';

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: ResponsiveDesign.getPadding(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
            ),
          ),
          
          // Header
          Container(
            padding: ResponsiveDesign.getPadding(all: 20),
            decoration: BoxDecoration(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(category, context).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                            ),
                            child: Text(
                              category,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getCategoryColor(category, context),
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveDesign.getFontSize(11),
                              ),
                            ),
                          ),
                          if (isImportant) ...[
                            ResponsiveSpacing(height: 0, width: 8),
                            Container(
                              padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
                              ),
                              child: Text(
                                'IMPORTANT',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ResponsiveDesign.getFontSize(8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      ResponsiveSpacing(height: 8),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                          height: 1.3,
                        ),
                      ),
                      ResponsiveSpacing(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                            size: ResponsiveDesign.getIconSize(16),
                          ),
                          ResponsiveSpacing(height: 0, width: 4),
                          Text(
                            _formatDate(createdAt),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(24),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveDesign.getPadding(all: 20),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF300300300),
                  height: 1.6,
                ),
              ),
            ),
          ),
          
          // Actions
          Container(
            padding: ResponsiveDesign.getPadding(all: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onBookmark();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isBookmarked ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      ),
                      padding: ResponsiveDesign.getPadding(vertical: 12),
                    ),
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                      color: isBookmarked ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                      size: ResponsiveDesign.getIconSize(18),
                    ),
                    label: Text(
                      isBookmarked ? 'Bookmarked' : 'Bookmark',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isBookmarked ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ResponsiveSpacing(height: 0, width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onShare();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      ),
                      padding: ResponsiveDesign.getPadding(vertical: 12),
                    ),
                    icon: Icon(
                      Icons.share_rounded,
                      color: Colors.white,
                      size: ResponsiveDesign.getIconSize(18),
                    ),
                    label: Text(
                      'Share',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category, BuildContext context) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Theme.of(context).colorScheme.primary;
      case 'events':
        return Theme.of(context).colorScheme.secondary;
      case 'administrative':
        return Theme.of(context).colorScheme.tertiary;
      case 'emergency':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
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
