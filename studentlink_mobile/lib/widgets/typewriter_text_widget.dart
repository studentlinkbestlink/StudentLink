import 'package:flutter/material.dart';

/// A widget that displays text with a typewriter animation effect
class TypewriterTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Duration? cursorBlinkDuration;
  final bool showCursor;
  final VoidCallback? onComplete;
  final bool autoStart;

  const TypewriterTextWidget({
    Key? key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 50),
    this.cursorBlinkDuration,
    this.showCursor = true,
    this.onComplete,
    this.autoStart = true,
  }) : super(key: key);

  @override
  State<TypewriterTextWidget> createState() => _TypewriterTextWidgetState();
}

class _TypewriterTextWidgetState extends State<TypewriterTextWidget>
    with TickerProviderStateMixin {
  late AnimationController _typingController;
  late AnimationController _cursorController;
  late Animation<int> _typingAnimation;
  late Animation<double> _cursorAnimation;

  String _displayedText = '';
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();

    _typingController = AnimationController(
      duration: Duration(
          milliseconds: widget.text.length * widget.duration.inMilliseconds),
      vsync: this,
    );

    _cursorController = AnimationController(
      duration: widget.cursorBlinkDuration ?? const Duration(milliseconds: 500),
      vsync: this,
    );

    _typingAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _typingController,
      curve: Curves.easeInOut,
    ));

    _cursorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cursorController,
      curve: Curves.easeInOut,
    ));

    _typingAnimation.addListener(() {
      setState(() {
        _displayedText = widget.text.substring(0, _typingAnimation.value);
      });
    });

    _typingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isComplete = true;
        });
        widget.onComplete?.call();
      }
    });

    if (widget.autoStart) {
      _startTyping();
    }
  }

  @override
  void dispose() {
    _typingController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  void _startTyping() {
    _typingController.forward();
    _cursorController.repeat(reverse: true);
  }

  void _stopTyping() {
    _typingController.stop();
    _cursorController.stop();
  }

  void _resetTyping() {
    _typingController.reset();
    _cursorController.reset();
    setState(() {
      _displayedText = '';
      _isComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: _displayedText,
            style: widget.style,
          ),
          if (widget.showCursor && _displayedText.isNotEmpty)
            WidgetSpan(
              child: AnimatedBuilder(
                animation: _cursorAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _cursorAnimation.value,
                    child: Text(
                      '|',
                      style: widget.style?.copyWith(
                        color: widget.style?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Start the typewriter animation
  void start() {
    if (!_isComplete) {
      _startTyping();
    }
  }

  /// Stop the typewriter animation
  void stop() {
    _stopTyping();
  }

  /// Reset and restart the typewriter animation
  void reset() {
    _resetTyping();
    _startTyping();
  }
}
