import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/api_service.dart';

import '../../../utils/error_handler.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

/// Modern step 1 widget for student ID generation
class ModernStep1StudentIdGenerationWidget extends StatefulWidget {
  final Function(String studentId, String schoolEmail) onStudentIdGenerated;
  final Function(String error) onError;

  const ModernStep1StudentIdGenerationWidget({
    super.key,
    required this.onStudentIdGenerated,
    required this.onError,
  });

  @override
  State<ModernStep1StudentIdGenerationWidget> createState() =>
      _ModernStep1StudentIdGenerationWidgetState();
}

class _ModernStep1StudentIdGenerationWidgetState
    extends State<ModernStep1StudentIdGenerationWidget> {
  bool _isGenerating = false;
  String? _generatedStudentId;
  String? _generatedSchoolEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern header
        Container(
          padding: ResponsiveDesign.getPadding(all: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E2A78).withValues(alpha: 0.1),
                const Color(0xFF2480EA).withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E2A78),
                          const Color(0xFF2480EA),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: ResponsiveDesign.getIconSize(24),
                    ),
                  ),
                  ResponsiveSpacing(height: 0, width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate Student ID',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color ??
                                    Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        ResponsiveSpacing(height: 4),
                        Text(
                          'Your unique student identifier',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color ??
                                        const Color(0xFF757575),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        ResponsiveSpacing(height: 24),

        // Description
        Text(
          'Your unique student ID will be automatically generated. This ID will be used for your school email and throughout your academic journey.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    const Color(0xFF757575),
                height: 1.5,
              ),
        ),

        ResponsiveSpacing(height: 32),

        // Generate button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isGenerating ? null : _generateStudentId,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E2A78),
              padding:
                  ResponsiveDesign.getPadding(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            icon: _isGenerating
                ? SizedBox(
                    width: ResponsiveDesign.getIconSize(20),
                    height: ResponsiveDesign.getIconSize(20),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
            label: Text(
              _isGenerating ? 'Generating...' : 'Generate Student ID',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),

        ResponsiveSpacing(height: 32),

        // Generated ID display
        if (_generatedStudentId != null) ...[
          Container(
            width: double.infinity,
            padding: ResponsiveDesign.getPadding(all: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: 0.3)),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Theme.of(context).colorScheme.onTertiary,
                        size: ResponsiveDesign.getIconSize(20),
                      ),
                    ),
                    ResponsiveSpacing(height: 0, width: 12),
                    Expanded(
                      child: Text(
                        'Student ID Generated Successfully!',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ),

                ResponsiveSpacing(height: 20),

                // Student ID
                _buildModernInfoRow(
                  'Student ID',
                  _generatedStudentId!,
                  Icons.badge_rounded,
                  Theme.of(context).colorScheme.primary,
                ),

                ResponsiveSpacing(height: 12),

                // School Email
                _buildModernInfoRow(
                  'School Email',
                  _generatedSchoolEmail!,
                  Icons.email_rounded,
                  Theme.of(context).colorScheme.tertiary,
                ),

                ResponsiveSpacing(height: 20),

                // Info note
                Container(
                  padding: ResponsiveDesign.getPadding(all: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(12)),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: ResponsiveDesign.getIconSize(20),
                      ),
                      ResponsiveSpacing(height: 0, width: 12),
                      Expanded(
                        child: Text(
                          'Please save this information. You will need your Student ID for login and your School Email for official communications.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.4,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ResponsiveSpacing(height: 24),

          // Instructions
          Container(
            padding: ResponsiveDesign.getPadding(all: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF28A745),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Colors.white,
                        size: ResponsiveDesign.getIconSize(20),
                      ),
                    ),
                    ResponsiveSpacing(height: 0, width: 12),
                    Text(
                      'Important Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                ResponsiveSpacing(height: 16),
                _buildModernInstructionItem(
                  'Your Student ID is unique and cannot be changed',
                  Icons.fingerprint_rounded,
                ),
                _buildModernInstructionItem(
                  'The School Email will be used for official communications',
                  Icons.mail_rounded,
                ),
                _buildModernInstructionItem(
                  'Keep this information secure and confidential',
                  Icons.security_rounded,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildModernInfoRow(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                ResponsiveSpacing(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _copyToClipboard(value),
            icon: Icon(
              Icons.copy_rounded,
              color: Theme.of(context).textTheme.bodySmall?.color,
              size: ResponsiveDesign.getIconSize(18),
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              padding: ResponsiveDesign.getPadding(all: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInstructionItem(String text, IconData icon) {
    return Padding(
      padding: ResponsiveDesign.getPadding(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).textTheme.bodySmall?.color,
            size: ResponsiveDesign.getIconSize(18),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateStudentId() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final result = await apiService.generateStudentId();

      setState(() {
        _generatedStudentId = result['student_id'];
        _generatedSchoolEmail = result['school_email'];
      });

      widget.onStudentIdGenerated(_generatedStudentId!, _generatedSchoolEmail!);
    } catch (e) {
      final errorMessage = e is AppError
          ? e.message
          : 'Failed to generate student ID. Please try again.';
      widget.onError(errorMessage);
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _copyToClipboard(String text) async {
    try {
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: text));

      // Show success message
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
                Expanded(
                  child: Text(
                    'Copied to clipboard: $text',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF22C55E),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            margin: ResponsiveDesign.getMargin(all: 16),
          ),
        );
      }
    } catch (e) {
      // Show error message if clipboard access fails
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
                Expanded(
                  child: Text(
                    'Failed to copy to clipboard. Please try again.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFE22824),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            margin: ResponsiveDesign.getMargin(all: 16),
          ),
        );
      }
    }
  }
}
