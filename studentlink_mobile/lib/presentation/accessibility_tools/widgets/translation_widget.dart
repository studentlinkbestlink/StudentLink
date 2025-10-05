import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/ml_kit_service.dart';
import '../../../utils/responsive_design.dart';

class TranslationWidget extends StatefulWidget {
  const TranslationWidget({Key? key}) : super(key: key);

  @override
  State<TranslationWidget> createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  final MLKitService _mlKitService = MLKitService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  
  bool _isProcessing = false;
  String _translatedText = '';
  String _sourceLanguage = '';
  String _targetLanguage = 'en';

  final List<Map<String, String>> _popularLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'zh', 'name': 'Chinese'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'th', 'name': 'Thai'},
    {'code': 'vi', 'name': 'Vietnamese'},
    {'code': 'tl', 'name': 'Filipino'},
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        await _processImageWithTranslation(image.path);
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
        await _processImageWithTranslation(image.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  Future<void> _processImageWithTranslation(String imagePath) async {
    setState(() {
      _isProcessing = true;
      _translatedText = '';
      _sourceLanguage = '';
    });

    try {
      final result = await _mlKitService.processImageWithTranslation(
        imagePath, 
        _targetLanguage
      );
      
      setState(() {
        _isProcessing = false;
        if (result['success']) {
          _textController.text = result['extractedText'];
          _translatedText = result['translatedText'];
          _sourceLanguage = result['sourceLanguage'];
        } else {
          _showErrorDialog(result['message'] ?? 'Failed to process image');
        }
      });

      if (result['success'] && result['extractedText'].isNotEmpty) {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Failed to process image: $e');
    }
  }

  Future<void> _translateText() async {
    if (_textController.text.trim().isEmpty) {
      _showErrorDialog('Please enter text to translate');
      return;
    }

    setState(() {
      _isProcessing = true;
      _translatedText = '';
    });

    try {
      final translatedText = await _mlKitService.translateText(
        _textController.text.trim(),
        _targetLanguage
      );
      
      setState(() {
        _translatedText = translatedText;
        _isProcessing = false;
      });

      HapticFeedback.lightImpact();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Failed to translate text: $e');
    }
  }

  void _copyTranslatedText() {
    if (_translatedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _translatedText));
      HapticFeedback.lightImpact();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 2.w),
              const Text('Translated text copied to clipboard'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _swapLanguages() {
    if (_sourceLanguage.isNotEmpty && _targetLanguage.isNotEmpty) {
      setState(() {
        final temp = _targetLanguage;
        _targetLanguage = _sourceLanguage;
        _sourceLanguage = temp;
        
        // Swap the text content
        final tempText = _textController.text;
        _textController.text = _translatedText;
        _translatedText = tempText;
      });
    }
  }

  void _clearAll() {
    setState(() {
      _textController.clear();
      _translatedText = '';
      _sourceLanguage = '';
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
                        Icons.translate,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Text Translation',
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
                    'Translate text between different languages. You can type text manually or scan it from images.',
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
                  label: const Text('Scan & Translate'),
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
                  label: const Text('From Gallery'),
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

          // Target Language Selection
          Card(
            elevation: 2,
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Translate to:',
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(14).sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  DropdownButtonFormField<String>(
                    value: _targetLanguage,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      ),
                      contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                    items: _popularLanguages.map((language) {
                      return DropdownMenuItem<String>(
                        value: _targetLanguage,
                        child: Text(language['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _targetLanguage = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Source Text Input
          Card(
            elevation: 2,
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Source Text',
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveDesign.getFontSize(14).sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      if (_sourceLanguage.isNotEmpty)
                        Container(
                          padding: ResponsiveDesign.getPadding(horizontal: 2.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                          ),
                          child: Text(
                            _mlKitService.getLanguageName(_sourceLanguage),
                            style: GoogleFonts.inter(
                              fontSize: ResponsiveDesign.getFontSize(12).sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter text to translate or scan from image...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      ),
                      contentPadding: ResponsiveDesign.getPadding(all: 4.w),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Translate Button
          ElevatedButton.icon(
            onPressed: _isProcessing ? null : _translateText,
            icon: _isProcessing 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : const Icon(Icons.translate),
            label: Text(_isProcessing ? 'Translating...' : 'Translate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              foregroundColor: Colors.white,
              padding: ResponsiveDesign.getPadding(vertical: 3.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Swap Languages Button
          if (_sourceLanguage.isNotEmpty && _targetLanguage.isNotEmpty)
            Center(
              child: IconButton(
                onPressed: _swapLanguages,
                icon: Icon(
                  Icons.swap_horiz,
                  size: 32.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                tooltip: 'Swap languages',
              ),
            ),

          SizedBox(height: 2.h),

          // Translated Text
          if (_translatedText.isNotEmpty) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: ResponsiveDesign.getPadding(all: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Translated Text',
                          style: GoogleFonts.inter(
                            fontSize: ResponsiveDesign.getFontSize(14).sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _copyTranslatedText,
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copy translated text',
                            ),
                            IconButton(
                              onPressed: _clearAll,
                              icon: const Icon(Icons.clear),
                              tooltip: 'Clear all',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: ResponsiveDesign.getPadding(all: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                        border: Border.all(
                          color: const Color(0xFF300300300).withValues(alpha: 0.3),
                        ),
                      ),
                      child: SelectableText(
                        _translatedText,
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveDesign.getFontSize(14).sp,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
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
                        'Translation Tips',
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
                    '• Works offline for supported languages\n• Better results with clear, well-lit images\n• Type manually for more accurate translations\n• Tap the swap button to reverse translation',
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
