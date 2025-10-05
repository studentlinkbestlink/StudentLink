import 'dart:async';
import 'package:flutter/material.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

/// Modern chat input widget with sleek, minimalistic design
class ModernChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSendMessage;
  final Function() onShowQuickSuggestions;
  final bool isEnabled;

  const ModernChatInputWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onSendMessage,
    required this.onShowQuickSuggestions,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<ModernChatInputWidget> createState() => _ModernChatInputWidgetState();
}

class _ModernChatInputWidgetState extends State<ModernChatInputWidget> {
  bool _hasText = false;
  bool _isKeyboardVisible = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (_hasText != hasText) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _hasText = hasText;
          });
        }
      });
    }
  }

  void _onFocusChanged() {
    final isKeyboardVisible = widget.focusNode.hasFocus;
    if (_isKeyboardVisible != isKeyboardVisible) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _isKeyboardVisible = isKeyboardVisible;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldShowActive = _hasText && _isKeyboardVisible;
    
    return RepaintBoundary(
      child: Container(
        // 🚀 KEYBOARD FIX: Add bottom padding when keyboard is visible
        padding: ResponsiveDesign.getPadding(bottom: _isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
          border: Border.all(
            color: shouldShowActive 
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.outline,
            width: shouldShowActive ? 2 : 1,
          ),
          boxShadow: shouldShowActive ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ] : [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Theme.of(context).textTheme.titleMedium?.color?.withValues(alpha: 0.04) ?? Colors.black.withValues(alpha: 0.04)
                  : Theme.of(context).shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Attachment button
            Container(
              margin: ResponsiveDesign.getPadding(left: 12),
              child: IconButton(
                onPressed: widget.isEnabled ? widget.onShowQuickSuggestions : null,
                icon: Icon(
                  Icons.add_rounded,
                  color: shouldShowActive 
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                  size: ResponsiveDesign.getIconSize(20),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: shouldShowActive 
                      ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  shape: const CircleBorder(),
                  padding: ResponsiveDesign.getPadding(all: 8),
                ),
              ),
            ),
            
            ResponsiveSpacing(height: 0, width: 8),
            
            // Text input field
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                enabled: widget.isEnabled,
                maxLines: 5,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (text) => _handleSend(),
                decoration: InputDecoration(
                  hintText: 'Ask me anything about college...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: ResponsiveDesign.getFontSize(15),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 12),
                ),
                style: TextStyle(
                  fontSize: ResponsiveDesign.getFontSize(15),
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            ),
            
            ResponsiveSpacing(height: 0, width: 8),
            
            // Send button
            Container(
              margin: ResponsiveDesign.getPadding(right: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: shouldShowActive
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  shape: BoxShape.circle,
                  boxShadow: shouldShowActive ? [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ] : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                    onTap: widget.isEnabled && _hasText ? () => _handleSend() : null,
                    child: Icon(
                      Icons.send_rounded,
                      color: shouldShowActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodySmall?.color,
                      size: ResponsiveDesign.getIconSize(18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty && widget.isEnabled) {
      widget.onSendMessage(text);
    }
  }
}
