import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class AnnouncementDetailModal extends StatefulWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const AnnouncementDetailModal({
    Key? key,
    required this.announcement,
    required this.onBookmark,
    required this.onShare,
  }) : super(key: key);

  @override
  State<AnnouncementDetailModal> createState() => _AnnouncementDetailModalState();
}

class _AnnouncementDetailModalState extends State<AnnouncementDetailModal> {
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
        backgroundColor: isError ? const Color(0xFFE22824) : const Color(0xFF28A745),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      final bool isHighPriority = widget.announcement['priority'] == 'high';
      final bool isBookmarked = widget.announcement['isBookmarked'] ?? false;
      final bool isImageAnnouncement = widget.announcement['announcement_type'] == 'image';
      
      // Safely parse the published date
      DateTime publishedAt;
      if (widget.announcement['publishedAt'] != null) {
        if (widget.announcement['publishedAt'] is DateTime) {
          publishedAt = widget.announcement['publishedAt'];
        } else if (widget.announcement['publishedAt'] is String) {
          publishedAt = DateTime.parse(widget.announcement['publishedAt']);
        } else {
          publishedAt = DateTime.now();
        }
      } else {
        publishedAt = DateTime.now();
      }

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: ResponsiveDesign.getPadding(vertical: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.black
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
            ),
          ),

          // Header
          Container(
            padding: ResponsiveDesign.getPadding(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Announcement Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: ResponsiveDesign.getIconSize(24),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveDesign.getPadding(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Priority and bookmark row
                  Row(
                    children: [
                      if (isHighPriority) ...[
                        Container(
                          padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFE22824).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                            border: Border.all(
                              color: const Color(0xFFE22824)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.priority_high,
                                color: const Color(0xFFE22824),
                                size: ResponsiveDesign.getIconSize(16),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'HIGH PRIORITY',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                  color: const Color(0xFFE22824),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Spacer(),
                      GestureDetector(
                        onTap: widget.onBookmark,
                        child: Container(
                          padding: ResponsiveDesign.getPadding(all: 2.w),
                          decoration: BoxDecoration(
                            color: isBookmarked
                                ? const Color(0xFF28A745).withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                            border: Border.all(
                              color: isBookmarked
                                  ? const Color(0xFF28A745).withValues(alpha: 0.3)
                                  : AppTheme.lightTheme.dividerColor,
                            ),
                          ),
                          child: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: isBookmarked
                                ? const Color(0xFF28A745)
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: ResponsiveDesign.getIconSize(24),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Title
                  Text(
                    widget.announcement['title'] ?? 'Untitled Announcement',
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isHighPriority
                          ? const Color(0xFFE22824)
                          : Colors.black,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Metadata row
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      border:
                          Border.all(color: AppTheme.lightTheme.dividerColor),
                    ),
                    child: Column(
                      children: [
                        _buildMetadataRow(
                            'Department',
                            widget.announcement['department'] ?? 'Unknown',
                            'business'),
                        _buildDivider(),
                        _buildMetadataRow('Category',
                            widget.announcement['category'] ?? 'General', 'category'),
                        _buildDivider(),
                        _buildMetadataRow('Author',
                            widget.announcement['author'] ?? 'System', 'person'),
                        _buildDivider(),
                        _buildMetadataRow('Target Course',
                            widget.announcement['targetCourse'] ?? 'All', 'school'),
                        _buildDivider(),
                        _buildMetadataRow('Published',
                            _formatFullDate(publishedAt), 'schedule'),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Content
                  Container(
                    width: double.infinity,
                    padding: ResponsiveDesign.getPadding(all: 4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      border:
                          Border.all(color: AppTheme.lightTheme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.article,
                              color: const Color(0xFF1E2A78),
                              size: ResponsiveDesign.getIconSize(20),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Content',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E2A78),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        if (isImageAnnouncement) ...[
                          _buildImageContent(),
                        ] else ...[
                          Text(
                            widget.announcement['content'] ?? 'No content available.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              height: 1.6,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: ResponsiveDesign.getPadding(all: 4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onShare,
                    icon: Icon(
                      Icons.share,
                      color: const Color(0xFF1E2A78),
                      size: ResponsiveDesign.getIconSize(20),
                    ),
                    label: Text('Share'),
                    style: OutlinedButton.styleFrom(
                      padding: ResponsiveDesign.getPadding(vertical: 1.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onBookmark,
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                      size: ResponsiveDesign.getIconSize(20),
                    ),
                    label: Text(isBookmarked ? 'Saved' : 'Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBookmarked
                          ? const Color(0xFF28A745)
                          : const Color(0xFF1E2A78),
                      foregroundColor: Colors.white,
                      padding: ResponsiveDesign.getPadding(vertical: 1.5.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    } catch (e) {
      debugPrint('❌ Error in AnnouncementDetailModal: $e');
      return Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: const Color(0xFFE22824),
                size: ResponsiveDesign.getIconSize(48),
              ),
              SizedBox(height: 2.h),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFE22824),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Unable to load announcement details',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildMetadataRow(String label, String value, String iconName) {
    return Padding(
      padding: ResponsiveDesign.getPadding(vertical: 1.h),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.black,
            size: ResponsiveDesign.getIconSize(18),
          ),
          SizedBox(width: 3.w),
          SizedBox(
            width: 20.w,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: ResponsiveDesign.getPadding(vertical: 0.5.h),
      color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
    );
  }

  String _formatFullDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildImageContent() {
    final String? imageUrl = widget.announcement['image_url'];
    
    if (imageUrl == null) {
      return Container(
        height: 30.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                color: Colors.black,
                size: ResponsiveDesign.getIconSize(48),
              ),
              SizedBox(height: 2.h),
              Text(
                'Image not available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
        height: 40.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 40.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF1E2A78),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.black,
                            size: ResponsiveDesign.getIconSize(48),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Failed to load image',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
              bottom: 12,
              right: 12,
              child: Container(
                padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.download,
                      color: Colors.white,
                      size: ResponsiveDesign.getIconSize(18),
                    ),
                    ResponsiveSpacing(height: 0, width: 6),
                    Text(
                      'Long press to download',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveDesign.getFontSize(12),
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
