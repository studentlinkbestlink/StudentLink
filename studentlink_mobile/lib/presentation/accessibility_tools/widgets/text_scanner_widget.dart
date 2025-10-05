import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../services/ml_kit_service.dart';
import '../../../utils/responsive_design.dart';

class TextScannerWidget extends StatefulWidget {
  final VoidCallback onPermissionRequest;

  const TextScannerWidget({
    Key? key,
    required this.onPermissionRequest,
  }) : super(key: key);

  @override
  State<TextScannerWidget> createState() => _TextScannerWidgetState();
}

class _TextScannerWidgetState extends State<TextScannerWidget> {
  final MLKitService _mlKitService = MLKitService();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isProcessing = false;
  String _extractedText = '';
  File? _selectedImage;

  Future<void> _pickImageFromCamera() async {
    try {
      widget.onPermissionRequest();
      
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _extractTextFromImage(image.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to capture image: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _extractTextFromImage(image.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  Future<void> _extractTextFromImage(String imagePath) async {
    setState(() {
      _isProcessing = true;
      _extractedText = '';
    });

    try {
      final result = await _mlKitService.extractTextFromImage(imagePath);
      
      setState(() {
        _extractedText = result;
        _isProcessing = false;
      });

      if (result.isEmpty) {
        _showInfoDialog('No text found in the image. Please try with a clearer image.');
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Failed to extract text: $e');
    }
  }

  void _copyToClipboard() {
    if (_extractedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _extractedText));
      HapticFeedback.lightImpact();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 2.w),
              const Text('Text copied to clipboard'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearText() {
    setState(() {
      _extractedText = '';
      _selectedImage = null;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Information'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveDesign.getPadding(all: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Card(
            elevation: 2,
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.text_fields,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Text Scanner',
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveDesign.getFontSize(18).sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Extract text from images using your camera or gallery. Perfect for reading documents, signs, or any printed text.',
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(14).sp,
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Image Selection Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: ResponsiveDesign.getPadding(vertical: 3.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: ResponsiveDesign.getPadding(vertical: 3.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Selected Image Preview
          if (_selectedImage != null) ...[
            Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: ResponsiveDesign.getPadding(all: 4.w),
                    child: Text(
                      'Selected Image',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(16).sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    margin: ResponsiveDesign.getPadding(horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      border: Border.all(
                        color: const Color(0xFF300300300).withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Processing Indicator
          if (_isProcessing) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: ResponsiveDesign.getPadding(all: 6.w),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Extracting text from image...',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Extracted Text
          if (_extractedText.isNotEmpty) ...[
            Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: ResponsiveDesign.getPadding(all: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Extracted Text',
                          style: GoogleFonts.inter(
                            fontSize: ResponsiveDesign.getFontSize(16).sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _copyToClipboard,
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copy to clipboard',
                            ),
                            IconButton(
                              onPressed: _clearText,
                              icon: const Icon(Icons.clear),
                              tooltip: 'Clear text',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: ResponsiveDesign.getPadding(horizontal: 4.w),
                    padding: ResponsiveDesign.getPadding(all: 4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      border: Border.all(
                        color: const Color(0xFF300300300).withValues(alpha: 0.3),
                      ),
                    ),
                    child: SelectableText(
                      _extractedText,
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],

          // Tips
          Card(
            elevation: 1,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Tips for Better Results',
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveDesign.getFontSize(14).sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '• Ensure good lighting\n• Keep the text straight and clear\n• Avoid shadows and reflections\n• Hold the camera steady',
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(12).sp,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
