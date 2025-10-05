import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/responsive_design.dart';

class AccessibilityMenuWidget extends StatefulWidget {
  const AccessibilityMenuWidget({Key? key}) : super(key: key);

  @override
  State<AccessibilityMenuWidget> createState() => _AccessibilityMenuWidgetState();
}

class _AccessibilityMenuWidgetState extends State<AccessibilityMenuWidget> {
  bool _highContrastMode = false;
  bool _largeTextMode = false;
  bool _screenReaderMode = false;
  bool _hapticFeedbackEnabled = true;
  double _textScaleFactor = 1.0;

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
                        Icons.accessibility,
                        color: const Color(0xFF1E2A78),
                        size: 24.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Accessibility Settings',
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
                    'Customize the app to make it more accessible and easier to use.',
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

          // Visual Accessibility
          Card(
            elevation: 2,
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visual Accessibility',
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(16).sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // High Contrast Mode
                  SwitchListTile(
                    title: Text(
                      'High Contrast Mode',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Increase contrast for better visibility',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(12).sp,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    value: _highContrastMode,
                    onChanged: (value) {
                      setState(() {
                        _highContrastMode = value;
                      });
                      if (value) {
                        HapticFeedback.lightImpact();
                      }
                    },
                  ),

                  Divider(),

                  // Large Text Mode
                  SwitchListTile(
                    title: Text(
                      'Large Text Mode',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Increase text size throughout the app',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(12).sp,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    value: _largeTextMode,
                    onChanged: (value) {
                      setState(() {
                        _largeTextMode = value;
                        _textScaleFactor = value ? 1.3 : 1.0;
                      });
                      if (value) {
                        HapticFeedback.lightImpact();
                      }
                    },
                  ),

                  // Text Scale Slider
                  if (_largeTextMode) ...[
                    Padding(
                      padding: ResponsiveDesign.getPadding(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Text Scale: ${(_textScaleFactor * 100).round()}%',
                            style: GoogleFonts.inter(
                              fontSize: ResponsiveDesign.getFontSize(12).sp,
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                          ),
                          Slider(
                            value: _highContrastMode ? 1.0 : 0.0,
                            min: 1.0,
                            max: 2.0,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                _textScaleFactor = value;
                              });
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Interaction Accessibility
          Card(
            elevation: 2,
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interaction Accessibility',
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(16).sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Haptic Feedback
                  SwitchListTile(
                    title: Text(
                      'Haptic Feedback',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Vibrate on touch interactions',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(12).sp,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    value: _hapticFeedbackEnabled,
                    onChanged: (value) {
                      setState(() {
                        _hapticFeedbackEnabled = value;
                      });
                      if (value) {
                        HapticFeedback.lightImpact();
                      }
                    },
                  ),

                  Divider(),

                  // Screen Reader Mode
                  SwitchListTile(
                    title: Text(
                      'Screen Reader Mode',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Optimize for screen readers and voice assistants',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(12).sp,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    value: _screenReaderMode,
                    onChanged: (value) {
                      setState(() {
                        _screenReaderMode = value;
                      });
                      if (value) {
                        HapticFeedback.lightImpact();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Quick Actions
          Card(
            elevation: 2,
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(16).sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Reset Settings
                  ListTile(
                    leading: Icon(
                      Icons.restore,
                      color: const Color(0xFF1E2A78),
                    ),
                    title: Text(
                      'Reset to Defaults',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Reset all accessibility settings',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(12).sp,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    onTap: () {
                      _showResetDialog();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                  ),

                  Divider(),

                  // Test Accessibility
                  ListTile(
                    leading: Icon(
                      Icons.visibility,
                      color: const Color(0xFF1E2A78),
                    ),
                    title: Text(
                      'Test Accessibility',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(14).sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Preview current accessibility settings',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(12).sp,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    onTap: () {
                      _testAccessibility();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Accessibility Info
          Card(
            elevation: 1,
            color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
            child: Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Accessibility Features',
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
                    '• Text scanning and recognition\n• Multi-language translation\n• High contrast and large text modes\n• Haptic feedback for interactions\n• Screen reader optimization\n• Voice-over support',
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

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all accessibility settings to their defaults?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetSettings();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    setState(() {
      _highContrastMode = false;
      _largeTextMode = false;
      _screenReaderMode = false;
      _hapticFeedbackEnabled = true;
      _textScaleFactor = 1.0;
    });
    
    HapticFeedback.lightImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 2.w),
            const Text('Accessibility settings reset to defaults'),
          ],
        ),
        backgroundColor: const Color(0xFF28A745),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _testAccessibility() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accessibility Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Settings:',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            Text('• High Contrast: ${_highContrastMode ? "On" : "Off"}'),
            Text('• Large Text: ${_largeTextMode ? "On (${(_textScaleFactor * 100).round()}%)" : "Off"}'),
            Text('• Screen Reader: ${_screenReaderMode ? "On" : "Off"}'),
            Text('• Haptic Feedback: ${_hapticFeedbackEnabled ? "On" : "Off"}'),
            SizedBox(height: 2.h),
            Text(
              'This is how text will appear with your current settings.',
              style: GoogleFonts.inter(
                fontSize: _largeTextMode ? 16.sp * _textScaleFactor : 14.sp,
                color: _highContrastMode 
                    ? Colors.black
                    : Colors.black.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
