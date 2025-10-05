import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

class TypingPatternWidget extends StatefulWidget {
  final String text;
  final Function(String) onPatternCollected;
  final VoidCallback? onComplete;
  final bool isEnabled;

  const TypingPatternWidget({
    Key? key,
    required this.text,
    required this.onPatternCollected,
    this.onComplete,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<TypingPatternWidget> createState() => _TypingPatternWidgetState();
}

class _TypingPatternWidgetState extends State<TypingPatternWidget>
    with TickerProviderStateMixin {
  late TextEditingController _textController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  List<int> _keyPressTimes = [];
  List<int> _keyReleaseTimes = [];
  String _currentText = '';
  bool _isCollecting = false;
  int _requiredPatterns = 2;
  int _currentPattern = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _currentText = widget.text;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startPatternCollection() {
    if (!widget.isEnabled) return;
    
    setState(() {
      _isCollecting = true;
      _keyPressTimes.clear();
      _keyReleaseTimes.clear();
      _textController.clear();
    });

    // Add haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _onKeyPress(RawKeyEvent event) {
    if (!_isCollecting) return;
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _keyPressTimes.add(timestamp);
  }

  // Note: Key release tracking can be implemented for more advanced pattern analysis

  void _onTextChanged(String text) {
    if (!_isCollecting) return;
    
    // Check if user has typed the required text
    if (text == widget.text) {
      _completePatternCollection();
    }
  }

  void _completePatternCollection() {
    if (_keyPressTimes.length < 3 || _keyReleaseTimes.length < 3) {
      _showInsufficientDataMessage();
      return;
    }

    // Generate typing pattern
    final typingPattern = _generateTypingPattern();
    
    setState(() {
      _isCollecting = false;
      _currentPattern++;
    });

    // Add haptic feedback
    HapticFeedback.heavyImpact();

    // Call the callback with the pattern
    widget.onPatternCollected(typingPattern);

    if (_currentPattern >= _requiredPatterns) {
      // All patterns collected
      widget.onComplete?.call();
    } else {
      // Reset for next pattern
      _resetForNextPattern();
    }
  }

  String _generateTypingPattern() {
    // Create a simplified typing pattern based on key press/release times
    final pattern = <String>[];
    
    for (int i = 0; i < _keyPressTimes.length && i < _keyReleaseTimes.length; i++) {
      final pressTime = _keyPressTimes[i];
      final releaseTime = _keyReleaseTimes[i];
      final duration = releaseTime - pressTime;
      
      // Convert to a simple pattern representation
      if (duration < 100) {
        pattern.add('f'); // fast
      } else if (duration < 300) {
        pattern.add('m'); // medium
      } else {
        pattern.add('s'); // slow
      }
    }
    
    return pattern.join('');
  }

  void _resetForNextPattern() {
    setState(() {
      _keyPressTimes.clear();
      _keyReleaseTimes.clear();
      _textController.clear();
    });
  }

  void _showInsufficientDataMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please type more carefully to capture your typing pattern'),
        backgroundColor: const Color(0xFF28A745),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: ResponsiveDesign.getPadding(all: 4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveDesign.getBorderRadius(16),
            ),
            border: Border.all(
              color: const Color(0xFF300300300),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(),
              
              SizedBox(height: 3.h),
              
              // Text to type
              _buildTextToType(),
              
              SizedBox(height: 3.h),
              
              // Input field
              _buildInputField(),
              
              SizedBox(height: 2.h),
              
              // Progress indicator
              _buildProgressIndicator(),
              
              SizedBox(height: 2.h),
              
              // Action button
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.keyboard_rounded,
          color: const Color(0xFF1E2A78),
          size: ResponsiveDesign.getIconSize(24),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Typing Pattern Authentication',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Type the text below to create your unique typing pattern',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextToType() {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(all: 3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveDesign.getBorderRadius(12),
        ),
        border: Border.all(
          color: const Color(0xFF1E2A78).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        _currentText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF1E2A78),
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInputField() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _onKeyPress,
      child: TextField(
        controller: _textController,
        onChanged: _onTextChanged,
        enabled: _isCollecting,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          letterSpacing: 1.2,
        ),
        decoration: InputDecoration(
          hintText: _isCollecting ? 'Start typing...' : 'Tap "Start Typing" to begin',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.black.withValues(alpha: 0.7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveDesign.getBorderRadius(12),
            ),
            borderSide: BorderSide(
              color: _isCollecting 
                  ? const Color(0xFF1E2A78) 
                  : const Color(0xFF300300300),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveDesign.getBorderRadius(12),
            ),
            borderSide: BorderSide(
              color: _isCollecting 
                  ? const Color(0xFF1E2A78) 
                  : const Color(0xFF300300300),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveDesign.getBorderRadius(12),
            ),
            borderSide: BorderSide(
              color: const Color(0xFF1E2A78),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: _isCollecting 
              ? const Color(0xFF1E2A78).withValues(alpha: 0.05)
              : Colors.white,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pattern Collection Progress',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$_currentPattern/$_requiredPatterns',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF1E2A78),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: _currentPattern / _requiredPatterns,
          backgroundColor: const Color(0xFF300300300),
          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF1E2A78)),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isCollecting ? null : _startPatternCollection,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isCollecting 
              ? Colors.black 
              : const Color(0xFF1E2A78),
          foregroundColor: Colors.white,
          padding: ResponsiveDesign.getPadding(vertical: ResponsiveDesign.getButtonHeight() * 0.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveDesign.getBorderRadius(12),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isCollecting ? Icons.timer_rounded : Icons.play_arrow_rounded,
              size: ResponsiveDesign.getIconSize(20),
            ),
            SizedBox(width: 2.w),
            Text(
              _isCollecting 
                  ? 'Typing in progress...' 
                  : _currentPattern == 0 
                      ? 'Start Typing Pattern' 
                      : 'Continue Pattern Collection',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
