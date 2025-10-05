import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernAttachmentWidget extends StatelessWidget {
  final List<Map<String, dynamic>> attachments;
  final Function(Map<String, dynamic>) onAttachmentAdded;
  final Function(int) onAttachmentRemoved;

  const ModernAttachmentWidget({
    Key? key,
    required this.attachments,
    required this.onAttachmentAdded,
    required this.onAttachmentRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: ResponsiveDesign.getPadding(all: 16),
            child: Row(
              children: [
                Container(
                  padding: ResponsiveDesign.getPadding(all: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                  ),
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                ),
                ResponsiveSpacing(height: 0, width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attachments',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleSmall?.color,
                        ),
                      ),
                      Text(
                        'Add files to support your concern',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (attachments.isNotEmpty)
                  Container(
                    padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                    child: Text(
                      '${attachments.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveDesign.getFontSize(12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Attachments list
          if (attachments.isNotEmpty) ...[
            Divider(height: 1, color: Theme.of(context).colorScheme.outline),
            Padding(
              padding: ResponsiveDesign.getPadding(horizontal: 16),
              child: Column(
                children: attachments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final attachment = entry.value;
                  return _buildAttachmentItem(attachment, index, context);
                }).toList(),
              ),
            ),
          ],
          
          // Add attachment button
          Padding(
            padding: ResponsiveDesign.getPadding(all: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showAttachmentOptions(context);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                  ),
                  padding: ResponsiveDesign.getPadding(vertical: 12),
                ),
                icon: Icon(
                  Icons.add_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: ResponsiveDesign.getIconSize(18),
                ),
                label: Text(
                  'Add Attachment',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(Map<String, dynamic> attachment, int index, BuildContext context) {
    final fileName = attachment['name'] ?? 'Unknown File';
    final fileSize = attachment['size'] ?? 0;
    final fileType = _getFileType(fileName);
    
    return Container(
      margin: ResponsiveDesign.getPadding(bottom: 8),
      padding: ResponsiveDesign.getPadding(all: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: ResponsiveDesign.getPadding(all: 8),
            decoration: BoxDecoration(
              color: _getFileTypeColor(fileType).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
            child: Icon(
              _getFileTypeIcon(fileType),
              color: _getFileTypeColor(fileType),
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatFileSize(fileSize),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onAttachmentRemoved(index);
            },
            icon: Icon(
              Icons.close_rounded,
              color: Theme.of(context).colorScheme.error,
              size: ResponsiveDesign.getIconSize(20),
            ),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            
            // Title
            Padding(
              padding: ResponsiveDesign.getPadding(all: 20),
              child: Text(
                'Add Attachment',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
            
            // Options
            Padding(
              padding: ResponsiveDesign.getPadding(horizontal: 20),
              child: Column(
                children: [
                  _buildAttachmentOption(
                    context,
                    icon: Icons.camera_alt_rounded,
                    title: 'Take Photo',
                    subtitle: 'Capture a new photo',
                    onTap: () {
                      Navigator.pop(context);
                      _addMockAttachment('Photo', 'image/jpeg', 1024000);
                    },
                  ),
                  _buildAttachmentOption(
                    context,
                    icon: Icons.photo_library_rounded,
                    title: 'Choose from Gallery',
                    subtitle: 'Select from your photos',
                    onTap: () {
                      Navigator.pop(context);
                      _addMockAttachment('Gallery Image', 'image/jpeg', 2048000);
                    },
                  ),
                  _buildAttachmentOption(
                    context,
                    icon: Icons.insert_drive_file_rounded,
                    title: 'Choose File',
                    subtitle: 'Select any file type',
                    onTap: () {
                      Navigator.pop(context);
                      _addMockAttachment('Document.pdf', 'application/pdf', 512000);
                    },
                  ),
                ],
              ),
            ),
            
            ResponsiveSpacing(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        child: Container(
          padding: ResponsiveDesign.getPadding(all: 16),
          child: Row(
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: ResponsiveDesign.getIconSize(24),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).textTheme.bodySmall?.color,
                size: ResponsiveDesign.getIconSize(20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMockAttachment(String name, String type, int size) {
    onAttachmentAdded({
      'name': name,
      'type': type,
      'size': size,
      'url': 'mock_url_$name',
    });
  }

  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'document';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'video';
      case 'mp3':
      case 'wav':
        return 'audio';
      default:
        return 'file';
    }
  }

  IconData _getFileTypeIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'document':
        return Icons.description_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'video':
        return Icons.videocam_rounded;
      case 'audio':
        return Icons.audiotrack_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType) {
      case 'pdf':
        return const Color(0xFFE22824);
      case 'document':
        return const Color(0xFF1E2A78);
      case 'image':
        return const Color(0xFF28A745);
      case 'video':
        return const Color(0xFF2480EA);
      case 'audio':
        return const Color(0xFFFFC107);
      default:
        return Color(0xFF757575);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
