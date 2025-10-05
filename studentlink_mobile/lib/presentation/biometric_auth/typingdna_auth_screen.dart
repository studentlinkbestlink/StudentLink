import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../services/biometric_auth_service.dart';
import 'widgets/typing_pattern_widget.dart';
import 'widgets/biometric_background_widget.dart';
import '../../theme/app_theme.dart';

class TypingDnaAuthScreen extends StatefulWidget {
  const TypingDnaAuthScreen({Key? key}) : super(key: key);

  @override
  State<TypingDnaAuthScreen> createState() => _TypingDnaAuthScreenState();
}

class _TypingDnaAuthScreenState extends State<TypingDnaAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  final BiometricAuthService _biometricService = BiometricAuthService();
  bool _isAuthenticating = false;
  String? _userId;
  int _failedAttempts = 0;
  static const int _maxFailedAttempts = 3;
  
  // Typing patterns for authentication
  final List<String> _authTexts = [
    'Welcome to StudentLink',
    'Secure authentication system',
    'Type this text to verify your identity',
  ];
  
  int _currentTextIndex = 0;
  List<String> _collectedPatterns = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = await _biometricService.getTypingDnaUserId();
      setState(() {
        _userId = userId;
      });
    } catch (e) {
      print('Error loading user data: $e');
      _navigateToLogin();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithTypingPattern(String pattern) async {
    if (_isAuthenticating || _userId == null) return;

    setState(() {
      _isAuthenticating = true;
    });

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    try {
      final currentText = _authTexts[_currentTextIndex];
      final result = await _biometricService.authenticateWithTypingDna(
        _userId!,
        currentText,
        pattern,
      );
      
      switch (result) {
        case TypingDnaResult.success:
          // Success haptic feedback
          HapticFeedback.heavyImpact();
          
          // Show success message
          _showSuccessMessage();
          
          // Navigate to dashboard after a short delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/dashboard-home');
            }
          });
          break;
          
        case TypingDnaResult.failed:
          _failedAttempts++;
          HapticFeedback.lightImpact();
          
          if (_failedAttempts >= _maxFailedAttempts) {
            _showMaxAttemptsReached();
          } else {
            _showFailedMessage();
          }
          break;
          
        case TypingDnaResult.setupComplete:
          // First time setup completed
          _showSetupCompleteMessage();
          break;
          
        case TypingDnaResult.notEnabled:
        case TypingDnaResult.error:
          _navigateToLogin();
          break;
      }
    } catch (e) {
      print('Error during TypingDNA authentication: $e');
      _navigateToLogin();
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _onPatternCollected(String pattern) {
    _collectedPatterns.add(pattern);
    
    if (_collectedPatterns.length >= 2) {
      // We have enough patterns, authenticate
      _authenticateWithTypingPattern(pattern);
    } else {
      // Move to next text
      setState(() {
        _currentTextIndex = (_currentTextIndex + 1) % _authTexts.length;
      });
    }
  }

  void _onPatternCollectionComplete() {
    // All patterns collected, authenticate with the last pattern
    if (_collectedPatterns.isNotEmpty) {
      _authenticateWithTypingPattern(_collectedPatterns.last);
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showSuccessMessage() {
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
            const Text('Typing pattern authentication successful!'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }

  void _showFailedMessage() {
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
            const Text('Typing pattern authentication failed. Try again.'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }

  void _showSetupCompleteMessage() {
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
            const Text('Typing pattern setup completed!'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );

    // Navigate to dashboard after setup
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  void _showMaxAttemptsReached() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
                    Icons.block_rounded,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
            ResponsiveSpacing(height: 0, width: 8),
            const Text('Too many failed attempts. Please login manually.'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );

    // Navigate to login after showing message
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            const BiometricBackgroundWidget(),
            
            // Main content
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: ResponsiveDesign.getPadding(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App logo
                      _buildAppLogo(),
                      
                      SizedBox(height: 4.h),
                      
                      // Title and description
                      _buildTitleAndDescription(),
                      
                      SizedBox(height: 4.h),
                      
                      // Typing pattern widget
                      _buildTypingPatternWidget(),
                      
                      SizedBox(height: 4.h),
                      
                      // Action buttons
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveDesign.getBorderRadius(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.keyboard_rounded,
        size: ResponsiveDesign.getIconSize(32),
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Column(
      children: [
        Text(
          'Typing Pattern Authentication',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: 2.h),
        
        Text(
          'Type the text below to authenticate using your unique typing pattern',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
            height: 1.5,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
        
        if (_failedAttempts > 0) ...[
          SizedBox(height: 2.h),
          Container(
            padding: ResponsiveDesign.getPadding(horizontal: 4.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveDesign.getBorderRadius(8),
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Failed attempts: $_failedAttempts/$_maxFailedAttempts',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypingPatternWidget() {
    return TypingPatternWidget(
      text: _authTexts[_currentTextIndex],
      onPatternCollected: _onPatternCollected,
      onComplete: _onPatternCollectionComplete,
      isEnabled: !_isAuthenticating,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Use Password button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _navigateToLogin,
            style: OutlinedButton.styleFrom(
              padding: ResponsiveDesign.getPadding(vertical: ResponsiveDesign.getButtonHeight() * 0.6,
              ),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
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
                  Icons.lock_rounded,
                  size: ResponsiveDesign.getIconSize(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Use Password Instead',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 2.h),
        
        // Help text
        Text(
          'Type the text above to authenticate with your unique typing pattern',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
