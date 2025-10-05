import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../services/biometric_auth_service.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({Key? key}) : super(key: key);

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanningController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanningAnimation;

  final BiometricAuthService _biometricService = BiometricAuthService();
  bool _isAuthenticating = false;
  bool _isScanning = false;
  String _biometricType = 'Fingerprint';
  int _failedAttempts = 0;
  static const int _maxFailedAttempts = 3;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadBiometricInfo();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scanningController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scanningAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanningController,
      curve: Curves.linear,
    ));

    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadBiometricInfo() async {
    try {
      final biometricType =
          await _biometricService.getDeviceBiometricTypeString();

      setState(() {
        _biometricType = biometricType;
      });
    } catch (e) {
      debugPrint('Error loading biometric info: $e');
      // Fallback to default
      setState(() {
        _biometricType = 'Fingerprint';
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanningController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _isScanning = true;
    });

    // Start scanning animation
    _scanningController.repeat();

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Try device biometric authentication first
      final deviceEnabled = await _biometricService.isDeviceBiometricEnabled();
      debugPrint('🔐 Device biometric enabled: $deviceEnabled');

      BiometricAuthResult result;

      if (deviceEnabled) {
        debugPrint('🔐 Attempting device biometric authentication...');
        result = await _biometricService.authenticateWithDeviceBiometric();
        debugPrint('🔐 Device biometric result: $result');
      } else {
        debugPrint(
            '⌨️ Device biometric not enabled, trying general biometric...');
        // Fallback to general biometric authentication
        result = await _biometricService.authenticateWithBiometric();
        debugPrint('⌨️ General biometric result: $result');
      }

      switch (result) {
        case BiometricAuthResult.success:
          debugPrint('✅ Biometric authentication successful');
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

        case BiometricAuthResult.failed:
          debugPrint('❌ Biometric authentication failed');
          _failedAttempts++;
          HapticFeedback.lightImpact();

          if (_failedAttempts >= _maxFailedAttempts) {
            _showMaxAttemptsReached();
          } else {
            _showFailedMessage();
          }
          break;

        case BiometricAuthResult.userCancel:
        case BiometricAuthResult.systemCancel:
          debugPrint('🚫 Biometric authentication cancelled by user');
          // User cancelled, don't count as failed attempt
          break;

        case BiometricAuthResult.notAvailable:
          debugPrint('❌ Biometric authentication not available');
          _showNotAvailableMessage();
          break;

        case BiometricAuthResult.notEnrolled:
          debugPrint('❌ No biometrics enrolled on device');
          _showNotEnrolledMessage();
          break;

        case BiometricAuthResult.notEnabled:
          debugPrint('❌ Biometric authentication not enabled');
          _showNotEnabledMessage();
          break;

        case BiometricAuthResult.error:
        case BiometricAuthResult.deviceNotSupported:
          debugPrint('❌ Biometric authentication error: $result');
          _showErrorMessage();
          break;
      }
    } catch (e) {
      debugPrint('💥 Error during biometric authentication: $e');
      _navigateToLogin();
    } finally {
      setState(() {
        _isAuthenticating = false;
        _isScanning = false;
      });
      _scanningController.stop();
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
            const Text('Authentication successful!'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getMargin(all: 16),
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
            Text('Authentication failed. Try again.'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getMargin(all: 16),
      ),
    );
  }

  void _showMaxAttemptsReached() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            const Text('Too many failed attempts. Please use password.'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getMargin(all: 16),
      ),
    );

    // Navigate to login after showing message
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  void _showNotAvailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.security_rounded,
              color: Colors.white,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            const Text('Biometric authentication not available on this device'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getMargin(all: 16),
      ),
    );

    // Navigate to login after showing message
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  void _showNotEnrolledMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.fingerprint_rounded,
              color: Colors.white,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            const Text(
                'No biometrics enrolled. Please set up biometrics in device settings'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getMargin(all: 16),
      ),
    );

    // Navigate to login after showing message
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  void _showNotEnabledMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            const Text(
                'Biometric authentication not enabled. Please enable it in settings'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getMargin(all: 16),
      ),
    );

    // Navigate to login after showing message
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            const Text('Biometric authentication error. Please use password'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getMargin(all: 16),
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
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Light gray background
      body: SafeArea(
        child: Stack(
          children: [
            // Background with grid pattern
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _buildGridPattern(),
            ),
            // Main content
            Column(
              children: [
                // Top spacing
                SizedBox(height: 15.h),

                // Main biometric icon and text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Biometric Icon
                      GestureDetector(
                        onTap: _authenticateWithBiometric,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer white ring (scanning animation)
                                  if (_isScanning)
                                    AnimatedBuilder(
                                      animation: _scanningAnimation,
                                      builder: (context, child) {
                                        return Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white
                                                  .withValues(alpha: 0.8),
                                              width: 3,
                                            ),
                                          ),
                                          child: CircularProgressIndicator(
                                            value: _scanningAnimation.value,
                                            strokeWidth: 3,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white
                                                  .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                  // Main blue circle with fingerprint
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.fingerprint_rounded,
                                      size: ResponsiveDesign.getIconSize(50),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      ResponsiveSpacing(height: 32),

                      // Text content
                      Text(
                        _isScanning ? 'Scanning...' : 'Use $_biometricType',
                        style: TextStyle(
                          fontSize: ResponsiveDesign.getFontSize(24).sp,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).textTheme.titleMedium?.color ??
                                  Colors.black,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      ResponsiveSpacing(height: 8),

                      Text(
                        'Quick and secure access',
                        style: TextStyle(
                          fontSize: ResponsiveDesign.getFontSize(16).sp,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Bottom section with password option
                Padding(
                  padding: ResponsiveDesign.getPadding(bottom: 8.h),
                  child: Column(
                    children: [
                      // Use Password Instead button
                      Container(
                        width: double.infinity,
                        margin: ResponsiveDesign.getPadding(horizontal: 8.w),
                        child: OutlinedButton(
                          onPressed:
                              _isAuthenticating ? null : _navigateToLogin,
                          style: OutlinedButton.styleFrom(
                            padding: ResponsiveDesign.getPadding(vertical: 16),
                            side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveDesign.getBorderRadius(12)),
                            ),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: ResponsiveDesign.getIconSize(20),
                              ),
                              ResponsiveSpacing(height: 0, width: 8),
                              Text(
                                'Use Password Instead',
                                style: TextStyle(
                                  fontSize: ResponsiveDesign.getFontSize(16).sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ResponsiveSpacing(height: 24),

                      // Instruction text
                      Text(
                        'Tap the $_biometricType icon above to authenticate',
                        style: TextStyle(
                          fontSize: ResponsiveDesign.getFontSize(12).sp,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Create a subtle grid pattern programmatically
  Widget _buildGridPattern() {
    return CustomPaint(
      painter: GridPatternPainter(),
      size: Size.infinite,
    );
  }
}

// Custom painter for the subtle grid pattern
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF300300300).withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    const spacing = 20.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
