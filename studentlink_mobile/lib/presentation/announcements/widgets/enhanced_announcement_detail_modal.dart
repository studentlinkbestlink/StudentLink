import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class EnhancedAnnouncementDetailModal extends StatefulWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const EnhancedAnnouncementDetailModal({
    Key? key,
    required this.announcement,
    required this.onBookmark,
    required this.onShare,
  }) : super(key: key);

  @override
  State<EnhancedAnnouncementDetailModal> createState() => _EnhancedAnnouncementDetailModalState();
}

class _EnhancedAnnouncementDetailModalState extends State<EnhancedAnnouncementDetailModal> {

  @override
  Widget build(BuildContext context) {
    final title = widget.announcement['title'] ?? 'Untitled Announcement';
    final content = widget.announcement['content'] ?? '';
    final createdAt = widget.announcement['created_at'] ?? '';
    final isImportant = widget.announcement['is_important'] ?? false;
    final isBookmarked = widget.announcement['isBookmarked'] ?? false;
    final category = widget.announcement['category'] ?? 'General';

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Enhanced handle bar
          Container(
            margin: ResponsiveDesign.getPadding(top: 16),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(3)),
            ),
          ),
          
          // Enhanced header with gradient
          Container(
            padding: ResponsiveDesign.getPadding(all: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Category and importance row
                Row(
                  children: [
                    _buildEnhancedCategoryChip(category),
                    ResponsiveSpacing(height: 0, width: 12),
                    if (isImportant) _buildImportantBadge(),
                    const Spacer(),
                    _buildActionButtons(isBookmarked),
                  ],
                ),
                
                ResponsiveSpacing(height: 20),
                
                // Enhanced title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                    height: 1.3,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                ResponsiveSpacing(height: 16),
                
                // Date and metadata
                Container(
                  padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                        size: ResponsiveDesign.getIconSize(16),
                      ),
                      ResponsiveSpacing(height: 0, width: 8),
                      Text(
                        _formatDate(createdAt),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Enhanced content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveDesign.getPadding(all: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content section with enhanced styling
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: ResponsiveDesign.getPadding(all: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
                              ),
                              child: Icon(
                                Icons.article_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: ResponsiveDesign.getIconSize(18),
                              ),
                            ),
                            ResponsiveSpacing(height: 0, width: 12),
                            Text(
                              'Content',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                              ),
                            ),
                          ],
                        ),
                        ResponsiveSpacing(height: 16),
                        Text(
                          content,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            height: 1.7,
                            fontSize: ResponsiveDesign.getFontSize(16),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 24),
                  
                  // Additional information section
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: ResponsiveDesign.getIconSize(20),
                            ),
                            ResponsiveSpacing(height: 0, width: 8),
                            Text(
                              'Announcement Details',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                              ),
                            ),
                          ],
                        ),
                        ResponsiveSpacing(height: 16),
                        
                        _buildMetadataRow(
                          icon: Icons.category_rounded,
                          label: 'Category',
                          value: category,
                        ),
                        
                        ResponsiveSpacing(height: 12),
                        
                        _buildMetadataRow(
                          icon: Icons.access_time_rounded,
                          label: 'Published',
                          value: createdAt,
                        ),
                        
                        if (isImportant) ...[
                          ResponsiveSpacing(height: 12),
                          _buildMetadataRow(
                            icon: Icons.priority_high_rounded,
                            label: 'Priority',
                            value: 'High',
                            valueColor: Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedCategoryChip(String category) {
    final color = _getCategoryColor(category);
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

  Widget _buildImportantBadge() {
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

  Widget _buildActionButtons(bool isBookmarked) {
    return Builder(
      builder: (context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bookmark button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onBookmark();
              },
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              child: Container(
                padding: ResponsiveDesign.getPadding(all: 10),
                decoration: BoxDecoration(
                  color: isBookmarked 
                      ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                  border: Border.all(
                    color: isBookmarked 
                        ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3)
                        : Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isBookmarked ? Theme.of(context).colorScheme.tertiary : Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                  size: ResponsiveDesign.getIconSize(20),
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
                widget.onShare();
              },
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              child: Container(
                padding: ResponsiveDesign.getPadding(all: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.share_rounded,
                  color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                  size: ResponsiveDesign.getIconSize(20),
                ),
              ),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 8),
          // Close button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              child: Container(
                padding: ResponsiveDesign.getPadding(all: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
          size: ResponsiveDesign.getIconSize(16),
        ),
        ResponsiveSpacing(height: 0, width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveDesign.getFontSize(12),
                ),
              ),
              ResponsiveSpacing(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor ?? Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
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
