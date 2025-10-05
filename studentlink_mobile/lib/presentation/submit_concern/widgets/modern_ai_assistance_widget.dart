import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/ai_writing_service.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernAiAssistanceWidget extends StatefulWidget {
  final TextEditingController textController;
  final Function(String) onSuggestionApplied;
  final String? concernType;
  final String? department;
  final String? priority;

  const ModernAiAssistanceWidget({
    Key? key,
    required this.textController,
    required this.onSuggestionApplied,
    this.concernType,
    this.department,
    this.priority,
  }) : super(key: key);

  @override
  State<ModernAiAssistanceWidget> createState() => _ModernAiAssistanceWidgetState();
}

class _ModernAiAssistanceWidgetState extends State<ModernAiAssistanceWidget> {
  bool _isExpanded = false;
  bool _isGenerating = false;
  String? _suggestion;
  final AiWritingService _aiWritingService = AiWritingService();

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
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              child: Container(
                padding: ResponsiveDesign.getPadding(all: 16),
                child: Row(
                  children: [
                    Container(
                      padding: ResponsiveDesign.getPadding(all: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2480EA).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: const Color(0xFF2480EA),
                        size: ResponsiveDesign.getIconSize(20),
                      ),
                    ),
                    ResponsiveSpacing(height: 0, width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Writing Assistant',
                            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                            ),
                          ),
                          Text(
                            'Get help improving your concern description',
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      size: ResponsiveDesign.getIconSize(20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expanded content
          if (_isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Padding(
              padding: ResponsiveDesign.getPadding(all: 16),
              child: Column(
                children: [
                  // Generate suggestion button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateSuggestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                        ),
                        padding: ResponsiveDesign.getPadding(vertical: 12),
                      ),
                      icon: _isGenerating
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                              ),
                            )
                          : Icon(
                              Icons.auto_awesome_rounded,
                              size: ResponsiveDesign.getIconSize(18),
                            ),
                      label: Text(
                        _isGenerating ? 'Generating...' : 'Improve My Text',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Suggestion display
                  if (_suggestion != null) ...[
                    ResponsiveSpacing(height: 16),
                    Container(
                      width: double.infinity,
                      padding: ResponsiveDesign.getPadding(all: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: ResponsiveDesign.getIconSize(16),
                              ),
                              ResponsiveSpacing(height: 0, width: 8),
                              Text(
                                'AI Suggestion',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          ResponsiveSpacing(height: 8),
                          SelectableText(
                            _suggestion!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              height: 1.4,
                            ),
                          ),
                          ResponsiveSpacing(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    widget.onSuggestionApplied(_suggestion!);
                                    setState(() {
                                      _suggestion = null;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.check_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: ResponsiveDesign.getIconSize(16),
                                  ),
                                  label: Text(
                                    'Use This',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveSpacing(height: 0, width: 8),
                              OutlinedButton.icon(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Clipboard.setData(ClipboardData(text: _suggestion!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Suggestion copied to clipboard'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                                  ),
                                ),
                                icon: Icon(
                    Icons.copy_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                                label: Text(
                                  'Copy',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ResponsiveSpacing(height: 0, width: 8),
                              OutlinedButton.icon(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    _suggestion = null;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                                  ),
                                ),
                                icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                                label: Text(
                                  'Dismiss',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _generateSuggestion() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final currentText = widget.textController.text;
      
      // Generate contextual AI suggestion
      final suggestion = await _aiWritingService.generateConcernSuggestion(
        userInput: currentText,
        concernType: widget.concernType,
        department: widget.department,
        priority: widget.priority,
      );

      setState(() {
        _suggestion = suggestion;
        _isGenerating = false;
      });
    } catch (e) {
      print('Error generating AI suggestion: $e');
      
      // Fallback to basic suggestion
      final currentText = widget.textController.text;
      final fallbackSuggestion = currentText.isEmpty
          ? "I am writing to report a concern regarding [specific issue]. This matter has been affecting [who/what is affected] and I believe it requires attention from the appropriate department. I would appreciate your assistance in resolving this matter promptly."
          : "I am writing to report a concern regarding $currentText. This matter requires attention and I would appreciate your assistance in resolving it promptly. Please let me know if you need any additional information.";
      
      setState(() {
        _suggestion = fallbackSuggestion;
        _isGenerating = false;
      });
    }
  }
}
