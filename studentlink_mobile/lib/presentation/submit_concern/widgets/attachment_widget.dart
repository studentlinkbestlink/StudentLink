import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../services/api_service.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class AttachmentWidget extends StatefulWidget {
  final List<Map<String, dynamic>> attachments;
  final Function(Map<String, dynamic>) onAttachmentAdded;
  final Function(int) onAttachmentRemoved;

  const AttachmentWidget({
    Key? key,
    required this.attachments,
    required this.onAttachmentAdded,
    required this.onAttachmentRemoved,
  }) : super(key: key);

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final camera = kIsWeb
            ? _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras.first)
            : _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
                orElse: () => _cameras.first);

        _cameraController = CameraController(
            camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

        await _cameraController!.initialize();
        await _applySettings();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (!_isCameraInitialized || _cameraController == null) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      await _uploadAndAddAttachment(
        File(photo.path),
        'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'image',
        'photo_camera',
      );
    } catch (e) {
      _showError('Failed to capture photo: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _uploadAndAddAttachment(
          File(image.path),
          image.name,
          'image',
          'image',
        );
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          await _uploadAndAddAttachment(
            File(file.path!),
            file.name,
            _getFileType(file.extension ?? ''),
            _getFileIcon(file.extension ?? ''),
          );
        }
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  String _getFileType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'document';
      case 'doc':
      case 'docx':
        return 'document';
      case 'txt':
        return 'text';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'file';
    }
  }

  String _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'doc':
      case 'docx':
        return 'description';
      case 'txt':
        return 'text_snippet';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'attach_file';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  Future<void> _uploadAndAddAttachment(
    File file,
    String name,
    String type,
    String icon,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              ResponsiveSpacing(height: 0, width: 16),
              Text('Uploading file...'),
            ],
          ),
        ),
      );

      // Upload file to backend
      final url = await apiService.uploadFile(file, 'concern');
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Add attachment to list
      final attachment = {
        'name': name,
        'type': type,
        'url': url,
        'size': await file.length(),
        'icon': icon,
      };
      widget.onAttachmentAdded(attachment);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File uploaded successfully'),
          backgroundColor: const Color(0xFF28A745),
        ),
      );
    } catch (e) {
      // Close loading dialog if still open
      Navigator.pop(context);
      _showError('Failed to upload file: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE22824),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    color: const Color(0xFF1E2A78),
                    size: ResponsiveDesign.getIconSize(24),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Add Attachment',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.photo_camera,
                color: const Color(0xFF1E2A78),
                size: ResponsiveDesign.getIconSize(24),
              ),
              title: Text('Take Photo'),
              subtitle: Text('Capture using camera'),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: const Color(0xFF1E2A78),
                size: ResponsiveDesign.getIconSize(24),
              ),
              title: Text('Choose from Gallery'),
              subtitle: Text('Select existing photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'folder',
                color: const Color(0xFF1E2A78),
                size: ResponsiveDesign.getIconSize(24),
              ),
              title: Text('Browse Files'),
              subtitle: Text('PDF, DOC, TXT files'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attachments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            TextButton.icon(
              onPressed: _showAttachmentOptions,
              icon: Icon(
                Icons.add,
                color: const Color(0xFF1E2A78),
                size: ResponsiveDesign.getIconSize(18),
              ),
              label: Text(
                'Add File',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF1E2A78),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        widget.attachments.isEmpty
            ? Container(
                width: double.infinity,
                padding: ResponsiveDesign.getPadding(all: 4.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF300300300)
                        .withAlpha(128),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      color: Colors.black,
                      size: ResponsiveDesign.getIconSize(32),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'No attachments added',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Tap "Add File" to attach documents or images',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                children: widget.attachments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final attachment = entry.value;
                  return Container(
                    margin: ResponsiveDesign.getPadding(bottom: 1.h),
                    padding: ResponsiveDesign.getPadding(all: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF300300300)
                            .withAlpha(77),
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: ResponsiveDesign.getPadding(all: 2.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2A78)
                                .withAlpha(26),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8.0)),
                          ),
                          child: CustomIconWidget(
                            iconName: attachment['icon'],
                            color: const Color(0xFF1E2A78),
                            size: ResponsiveDesign.getIconSize(20),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attachment['name'],
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${attachment['type'].toString().toUpperCase()} • ${_formatFileSize(attachment['size'])}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => widget.onAttachmentRemoved(index),
                          icon: Icon(
                            Icons.delete,
                            color: const Color(0xFFE22824),
                            size: ResponsiveDesign.getIconSize(20),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}
