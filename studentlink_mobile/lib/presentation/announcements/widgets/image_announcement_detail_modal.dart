import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ImageAnnouncementDetailModal extends StatefulWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const ImageAnnouncementDetailModal({
    Key? key,
    required this.announcement,
    required this.onBookmark,
    required this.onShare,
  }) : super(key: key);

  @override
  State<ImageAnnouncementDetailModal> createState() => _ImageAnnouncementDetailModalState();
}

class _ImageAnnouncementDetailModalState extends State<ImageAnnouncementDetailModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isDownloading = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  _buildHandleBar(),
                  
                  // Image content
                  Expanded(
                    child: _buildImageContent(),
                  ),
                  
                  // Action buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandleBar() {
    return Container(
      padding: ResponsiveDesign.getPadding(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveSpacing(height: 0, width: 40), // Spacer
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF300300300),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
              ),
              child: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    final imageUrl = widget.announcement['image_url'] ?? widget.announcement['image_path'];
    final createdAt = widget.announcement['created_at'] ?? widget.announcement['published_at'] ?? '';
    final isBookmarked = widget.announcement['is_bookmarked'] ?? false;

    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 16),
      child: Column(
        children: [
          // Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                child: _buildImage(imageUrl),
              ),
            ),
          ),
          
          ResponsiveSpacing(height: 16),
          
          // Timestamp and bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timestamp
              Container(
                padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: ResponsiveDesign.getIconSize(16),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    ResponsiveSpacing(height: 0, width: 6),
                    Text(
                      _formatTimestamp(createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bookmark button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onBookmark();
                },
                child: Container(
                  padding: ResponsiveDesign.getPadding(all: 12),
                  decoration: BoxDecoration(
                    color: isBookmarked 
                        ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1)
                        : Theme.of(context).textTheme.bodySmall?.color ?? Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    border: Border.all(
                      color: isBookmarked 
                          ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3)
                          : Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF300300300),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isBookmarked ? Theme.of(context).colorScheme.tertiary : Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackImage();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => _buildImagePlaceholder(),
      errorWidget: (context, url, error) => _buildFallbackImage(),
      memCacheWidth: 1200, // Higher quality for detail view
      memCacheHeight: 1200,
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              strokeWidth: 3,
            ),
            ResponsiveSpacing(height: 16),
            Text(
              'Loading announcement...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: ResponsiveDesign.getPadding(all: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
              ),
              child: Icon(
                Icons.image_not_supported_rounded,
                size: ResponsiveDesign.getIconSize(64),
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            ResponsiveSpacing(height: 16),
            Text(
              'Image not available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'This announcement image could not be loaded',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      child: Row(
        children: [
          // Download button
          Expanded(
            child: _buildActionButton(
              icon: _isDownloading ? Icons.downloading_rounded : Icons.download_rounded,
              label: _isDownloading ? 'Downloading...' : 'Download',
              color: Theme.of(context).colorScheme.primary,
              onTap: _isDownloading ? null : _downloadImage,
              isLoading: _isDownloading,
            ),
          ),
          
          ResponsiveSpacing(height: 0, width: 12),
          
          // Share button
          Expanded(
            child: _buildActionButton(
              icon: _isSharing ? Icons.share_rounded : Icons.share_rounded,
              label: _isSharing ? 'Sharing...' : 'Share',
              color: Theme.of(context).colorScheme.secondary,
              onTap: _isSharing ? null : _shareImage,
              isLoading: _isSharing,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ResponsiveDesign.getPadding(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 2,
                ),
              )
            else
              Icon(
                icon,
                color: color,
                size: ResponsiveDesign.getIconSize(20),
              ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      // Request storage permission
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        _showErrorSnackBar('Storage permission required to download images');
        return;
      }

      final imageUrl = widget.announcement['image_url'] ?? widget.announcement['image_path'];
      if (imageUrl == null || imageUrl.isEmpty) {
        _showErrorSnackBar('Image URL not available');
        return;
      }

      // Download image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        _showErrorSnackBar('Failed to download image');
        return;
      }

      // Save to gallery
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'announcement_${widget.announcement['id']}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(response.bodyBytes);

      // Show success message
      _showSuccessSnackBar('Image saved to gallery');
      
      // Haptic feedback
      HapticFeedback.heavyImpact();

    } catch (e) {
      _showErrorSnackBar('Failed to download image: $e');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _shareImage() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final imageUrl = widget.announcement['image_url'] ?? widget.announcement['image_path'];
      if (imageUrl == null || imageUrl.isEmpty) {
        _showErrorSnackBar('Image URL not available');
        return;
      }

      // Download image for sharing
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        _showErrorSnackBar('Failed to prepare image for sharing');
        return;
      }

      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final fileName = 'share_announcement_${widget.announcement['id']}.jpg';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(response.bodyBytes);

      // Share the image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out this announcement from StudentLink!',
      );

      // Haptic feedback
      HapticFeedback.lightImpact();

    } catch (e) {
      _showErrorSnackBar('Failed to share image: $e');
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
              ResponsiveSpacing(height: 0, width: 8),
              Text(message),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
          margin: ResponsiveDesign.getPadding(all: 16),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                    Icons.error_rounded,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
              ResponsiveSpacing(height: 0, width: 8),
              Text(message),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
          margin: ResponsiveDesign.getPadding(all: 16),
        ),
      );
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}
