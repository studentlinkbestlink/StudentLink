import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class AnnouncementCardWidget extends StatefulWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final String searchQuery;

  const AnnouncementCardWidget({
    Key? key,
    required this.announcement,
    required this.onTap,
    required this.onBookmark,
    required this.onShare,
    this.searchQuery = '',
  }) : super(key: key);

  @override
  State<AnnouncementCardWidget> createState() => _AnnouncementCardWidgetState();
}

class _AnnouncementCardWidgetState extends State<AnnouncementCardWidget> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    if (_isDownloading) return;
    
    setState(() {
      _isDownloading = true;
    });

    try {
      final imageUrl = widget.announcement['image_url'];
      if (imageUrl == null) {
        _showSnackBar('No image available for download', isError: true);
        return;
      }

      // Get the downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'announcement_${widget.announcement['id']}.jpg';
      final filePath = '${directory.path}/$fileName';

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        _showSnackBar('Image saved to Downloads');
        
        // Provide haptic feedback
        HapticFeedback.lightImpact();
      } else {
        _showSnackBar('Failed to download image', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error downloading image: $e', isError: true);
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.tertiary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isHighPriority = widget.announcement['priority'] == 'high';
    final bool isBookmarked = widget.announcement['isBookmarked'] ?? false;
    final DateTime publishedAt = widget.announcement['publishedAt'] ?? DateTime.now();
    final bool isImageAnnouncement = widget.announcement['announcement_type'] == 'image';

    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: isHighPriority
            ? Border.all(color: Theme.of(context).colorScheme.error, width: 2)
            : Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          onTap: widget.onTap,
          child: Column(
            children: [
              // Header Section
              Container(
                padding: ResponsiveDesign.getPadding(all: 4.w),
                decoration: BoxDecoration(
                  color: isHighPriority
                      ? Theme.of(context).colorScheme.error.withValues(alpha: 0.05)
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row with Priority and Bookmark
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isHighPriority) ...[
                          Container(
                            padding: ResponsiveDesign.getPadding(all: 1.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(4)),
                            ),
                            child: Icon(
                              Icons.priority_high,
                              color: Colors.white,
                              size: ResponsiveDesign.getIconSize(16),
                            ),
                          ),
                          SizedBox(width: 2.w),
                        ],

                        Expanded(
                          child: _buildHighlightedText(
                            widget.announcement['title'] ?? '',
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isHighPriority
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).textTheme.titleMedium?.color,
                            ),
                          ),
                        ),

                        // Bookmark Button
                        GestureDetector(
                          onTap: widget.onBookmark,
                          child: Container(
                            padding: ResponsiveDesign.getPadding(all: 1.w),
                            child: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: isBookmarked
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                              size: ResponsiveDesign.getIconSize(24),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Department and Date Row
                    Row(
                      children: [
                        Container(
                          padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getDepartmentColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                          ),
                          child: Text(
                            widget.announcement['department'] ?? '',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                              color: _getDepartmentColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getCategoryColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                          ),
                          child: Text(
                            widget.announcement['category'] ?? '',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                              color: _getCategoryColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _formatDate(publishedAt),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content Section
              Container(
                padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content Preview or Image
                    if (isImageAnnouncement) ...[
                      _buildImageContent(),
                    ] else ...[
                      _buildHighlightedText(
                        _getContentPreview(),
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                    ],

                    SizedBox(height: 2.h),

                    // Footer with Author and Actions
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color:
                              Colors.black,
                          size: ResponsiveDesign.getIconSize(16),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          widget.announcement['department'] ?? 'General',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Spacer(),

                        // Share Button
                        GestureDetector(
                          onTap: widget.onShare,
                          child: Container(
                            padding: ResponsiveDesign.getPadding(all: 1.w),
                            child: Icon(
                              Icons.share,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: ResponsiveDesign.getIconSize(20),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),

                        // Read More Indicator
                        Container(
                          padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Read More',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: ResponsiveDesign.getIconSize(12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, TextStyle? style) {
    if (widget.searchQuery.isEmpty) {
      return Text(text, style: style);
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = widget.searchQuery.toLowerCase();
    int start = 0;

    while (true) {
      final int index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + widget.searchQuery.length),
        style: style?.copyWith(
          backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
          fontWeight: FontWeight.w700,
        ),
      ));

      start = index + widget.searchQuery.length;
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }

  String _getContentPreview() {
    final String content = widget.announcement['content'] ?? '';
    if (content.length <= 120) return content;
    return '${content.substring(0, 120)}...';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getDepartmentColor() {
    final String department = widget.announcement['department']?.toLowerCase() ?? '';

    if (department.contains('academic')) return Theme.of(context).colorScheme.primary;
    if (department.contains('mis') || department.contains('it')) {
      return Theme.of(context).colorScheme.primary;
    }
    if (department.contains('student')) return Theme.of(context).colorScheme.tertiary;
    if (department.contains('library')) return Theme.of(context).colorScheme.secondary;
    if (department.contains('admin')) return Theme.of(context).colorScheme.tertiary;
    if (department.contains('criminology')) return Theme.of(context).colorScheme.error;

    return Theme.of(context).colorScheme.primary;
  }

  Color _getCategoryColor() {
    final String category = widget.announcement['category']?.toLowerCase() ?? '';

    switch (category) {
      case 'academic':
        return Theme.of(context).colorScheme.primary;
      case 'events':
        return Theme.of(context).colorScheme.tertiary;
      case 'administrative':
        return Theme.of(context).colorScheme.tertiary;
      case 'emergency':
        return Theme.of(context).colorScheme.error;
      default:
        return Colors.black;
    }
  }

  Widget _buildImageContent() {
    final String? imageUrl = widget.announcement['image_url'];
    
    if (imageUrl == null) {
      return Container(
        height: 20.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                color: Colors.black,
                size: ResponsiveDesign.getIconSize(32),
              ),
              SizedBox(height: 1.h),
              Text(
                'Image not available',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPress: _downloadImage,
      child: Container(
        height: 25.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 25.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.black,
                            size: ResponsiveDesign.getIconSize(32),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Failed to load image',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Download indicator
            if (_isDownloading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            // Long press hint
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.download,
                      color: Colors.white,
                      size: ResponsiveDesign.getIconSize(16),
                    ),
                    ResponsiveSpacing(height: 0, width: 4),
                    Text(
                      'Long press to download',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveDesign.getFontSize(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
