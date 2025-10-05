import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class NewAnnouncementDetailModal extends StatefulWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const NewAnnouncementDetailModal({
    Key? key,
    required this.announcement,
    required this.onBookmark,
    required this.onShare,
  }) : super(key: key);

  @override
  State<NewAnnouncementDetailModal> createState() => _NewAnnouncementDetailModalState();
}

class _NewAnnouncementDetailModalState extends State<NewAnnouncementDetailModal> {
  @override
  Widget build(BuildContext context) {
    final category = widget.announcement['category'] ?? 'General';
    final title = widget.announcement['title'] ?? 'Announcement';
    final description = widget.announcement['description'] ?? '';
    final timestamp = widget.announcement['announcement_timestamp'] ?? 
                     widget.announcement['created_at'] ?? 
                     widget.announcement['published_at'] ?? '';
    final imageUrl = widget.announcement['image_url'] ?? widget.announcement['image_path'];
    final actionButtonText = widget.announcement['action_button_text'];
    final actionButtonUrl = widget.announcement['action_button_url'];
    final isBookmarked = widget.announcement['is_bookmarked'] ?? false;
    
    // Debug logging for action button data
    debugPrint('🔍 Detail Modal Action Button Debug:');
    debugPrint('  - actionButtonText: "$actionButtonText" (${actionButtonText.runtimeType})');
    debugPrint('  - actionButtonUrl: "$actionButtonUrl" (${actionButtonUrl.runtimeType})');
    debugPrint('  - Will show button: ${actionButtonText != null && actionButtonUrl != null}');

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
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
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
            ),
          ),
          
          // Header
          Padding(
            padding: ResponsiveDesign.getPadding(all: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category tag
                Container(
                  padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                    border: Border.all(
                      color: const Color(0xFF1E2A78).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF1E2A78),
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveDesign.getFontSize(11),
                    ),
                  ),
                ),
                
                // Action buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        widget.onBookmark();
                      },
                      icon: Icon(
                        isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isBookmarked ? const Color(0xFF28A745) : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: ResponsiveDesign.getIconSize(24),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        widget.onShare();
                      },
                      icon: Icon(
                        Icons.share_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: ResponsiveDesign.getIconSize(24),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: ResponsiveDesign.getIconSize(24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveDesign.getPadding(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                      fontWeight: FontWeight.w800,
                      fontSize: ResponsiveDesign.getFontSize(24),
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 8),
                  
                  // Timestamp
                  Text(
                    _formatTimestamp(timestamp),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 20),
                  
                  // Image
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final imageHeight = _calculateOptimalHeight(constraints.maxWidth);
                        return Container(
                          width: double.infinity,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.contain, // Changed from cover to contain to show full image
                              width: double.infinity,
                              height: imageHeight,
                              placeholder: (context, url) => _buildImagePlaceholder(imageHeight),
                              errorWidget: (context, url, error) => _buildImagePlaceholder(imageHeight),
                              memCacheWidth: 1200, // Increased for better quality
                              memCacheHeight: 1200,
                            ),
                          ),
                        );
                      },
                    ),
                  
                  ResponsiveSpacing(height: 20),
                  
                  // Description
                  if (description.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ResponsiveSpacing(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.6,
                      ),
                    ),
                    ResponsiveSpacing(height: 20),
                  ],
                  
                  // Action button and bookmark (if present)
                  if (actionButtonText != null && actionButtonUrl != null) ...[
                    Row(
                      children: [
                        // Open SMS button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _handleActionButtonTap(actionButtonUrl),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2A78),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: ResponsiveDesign.getPadding(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  actionButtonText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: ResponsiveDesign.getFontSize(16),
                                  ),
                                ),
                                ResponsiveSpacing(height: 0, width: 8),
                                Icon(
                                  Icons.open_in_new_rounded,
                                  size: ResponsiveDesign.getIconSize(18),
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        ResponsiveSpacing(height: 0, width: 12),
                        
                        // Separate bookmark button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            widget.onBookmark();
                          },
                          child: Container(
                            padding: ResponsiveDesign.getPadding(all: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                              border: Border.all(
                                color: const Color(0xFF1E2A78).withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isBookmarked ? const Color(0xFF28A745) : const Color(0xFF1E2A78),
                              size: ResponsiveDesign.getIconSize(24),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ResponsiveSpacing(height: 20),
                  ],
                  
                  // Additional info
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2A78).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      border: Border.all(
                        color: const Color(0xFF1E2A78).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Announcement Details',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF1E2A78),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ResponsiveSpacing(height: 8),
                        _buildDetailRow('Category', category),
                        _buildDetailRow('Published', _formatTimestamp(timestamp)),
                        if (widget.announcement['author'] != null)
                          _buildDetailRow('Author', widget.announcement['author']['name'] ?? 'Unknown'),
                      ],
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateOptimalHeight(double availableWidth) {
    // Calculate height based on available width to maintain good proportions
    // This creates a flexible aspect ratio that works well for most images
    final baseHeight = availableWidth * 0.6; // 5:3 aspect ratio as base
    final minHeight = 200.0;
    final maxHeight = 350.0;
    
    return baseHeight.clamp(minHeight, maxHeight);
  }

  Widget _buildImagePlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A78).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: const Color(0xFF1E2A78).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: ResponsiveDesign.getPadding(all: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              ),
              child: Icon(
                Icons.image_not_supported_rounded,
                size: ResponsiveDesign.getIconSize(48),
                color: const Color(0xFF1E2A78).withValues(alpha: 0.6),
              ),
            ),
            ResponsiveSpacing(height: 12),
            Text(
              'Image not available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: ResponsiveDesign.getPadding(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleActionButtonTap(String url) async {
    try {
      debugPrint('🔗 Attempting to open URL: $url');
      
      // Validate URL format
      if (url.isEmpty || url.trim().isEmpty) {
        _showErrorSnackBar('No URL provided');
        return;
      }
      
      // Clean and format URL
      String cleanUrl = url.trim();
      String formattedUrl = cleanUrl;
      
      // Ensure URL has proper scheme
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        // Check if it looks like a domain
        if (cleanUrl.contains('.') && !cleanUrl.contains(' ')) {
          formattedUrl = 'https://$cleanUrl';
        } else {
          _showErrorSnackBar('Invalid URL format. Please check the URL.');
          return;
        }
      }
      
      final uri = Uri.parse(formattedUrl);
      debugPrint('🔗 Parsed URI: $uri');
      
      // Validate URI components
      if (uri.scheme.isEmpty || uri.host.isEmpty) {
        _showErrorSnackBar('Invalid URL format. Please check the URL.');
        return;
      }
      
      // Try to launch the URL directly without canLaunchUrl check
      // as it can be unreliable on some devices
      debugPrint('✅ Attempting to launch URL directly...');
      final launched = await launchUrl(
        uri, 
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      
      if (launched) {
        debugPrint('✅ URL launched successfully');
        HapticFeedback.lightImpact();
      } else {
        debugPrint('❌ URL launch returned false');
        _showErrorSnackBar('Could not open the link. Please check if the URL is valid.');
      }
    } catch (e) {
      debugPrint('❌ Error opening link: $e');
      _showErrorSnackBar('Could not open the link. Please check if the URL is valid.');
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
          backgroundColor: const Color(0xFFE22824),
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
        return '${difference.inMinutes} min ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}

