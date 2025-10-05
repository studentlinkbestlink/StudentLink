import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../services/biometric_auth_service.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernBiometricAuthScreen extends StatefulWidget {
  const ModernBiometricAuthScreen({Key? key}) : super(key: key);

  @override
  State<ModernBiometricAuthScreen> createState() => _ModernBiometricAuthScreenState();
}

class _ModernBiometricAuthScreenState extends State<ModernBiometricAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanningController;
  late AnimationController _successController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanningAnimation;
  late Animation<double> _successAnimation;
  
  final BiometricAuthService _biometricService = BiometricAuthService();
  bool _isAuthenticating = false;
  bool _isScanning = false;
  String _biometricType = 'Fingerprint';
  int _failedAttempts = 0;
  static const int _maxFailedAttempts = 3;
  String _statusMessage = '';

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

    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
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

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadBiometricInfo() async {
    try {
      final biometricType = await _biometricService.getBiometricTypeString();
      setState(() {
        _biometricType = biometricType;
      });
    } catch (e) {
      debugPrint('Error loading biometric info: $e');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanningController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _isScanning = true;
      _statusMessage = 'Authenticating...';
    });

    _scanningController.repeat();

    try {
      final result = await _biometricService.authenticateWithBiometric();
      
      switch (result) {
        case BiometricAuthResult.success:
          debugPrint('✅ Biometric authentication successful');
          HapticFeedback.heavyImpact();
          
          setState(() {
            _isScanning = false;
            _statusMessage = 'Authentication successful!';
          });
          
          _scanningController.stop();
          _successController.forward();
          
          // Navigate to dashboard after success animation
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
          
          setState(() {
            _isScanning = false;
            _statusMessage = 'Authentication failed. Please try again.';
          });
          
          _scanningController.stop();
          
          if (_failedAttempts >= _maxFailedAttempts) {
            _showMaxAttemptsReached();
          }
          break;
          
        case BiometricAuthResult.userCancel:
        case BiometricAuthResult.systemCancel:
          debugPrint('🚫 Biometric authentication cancelled by user');
          setState(() {
            _isScanning = false;
            _statusMessage = 'Authentication cancelled';
          });
          _scanningController.stop();
          break;
          
        case BiometricAuthResult.notAvailable:
        case BiometricAuthResult.notEnrolled:
        case BiometricAuthResult.notEnabled:
        case BiometricAuthResult.error:
        case BiometricAuthResult.deviceNotSupported:
          debugPrint('❌ Biometric authentication error: $result');
          setState(() {
            _isScanning = false;
            _statusMessage = 'Biometric authentication not available';
          });
          _scanningController.stop();
          _navigateToLogin();
          break;
      }
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      setState(() {
        _isScanning = false;
        _statusMessage = 'Authentication error. Please try again.';
      });
      _scanningController.stop();
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _showMaxAttemptsReached() {
    setState(() {
      _statusMessage = 'Too many failed attempts. Please use password.';
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.03),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: Column(
            children: [
              // Top spacing
              SizedBox(height: 8.h),
              
              // App logo/brand
              _buildAppLogo(),
              
              SizedBox(height: 4.h),
              
              // Main biometric section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Modern biometric icon with animation
                    _buildModernBiometricIcon(),
                    
                    SizedBox(height: 3.h),
                    
                    // Title and description
                    _buildModernTitleAndDescription(),
                    
                    SizedBox(height: 4.h),
                    
                    // Modern authentication button
                    _buildModernAuthButton(),
                    
                    SizedBox(height: 2.h),
                    
                    // Status message
                    _buildModernStatusMessage(),
                  ],
                ),
              ),
              
              // Bottom section
              Container(
                padding: ResponsiveDesign.getPadding(horizontal: 5.w, vertical: 3.h),
                child: Column(
                  children: [
                    // Modern "Use Password Instead" button
                    _buildModernPasswordButton(),
                    
                    SizedBox(height: 2.h),
                    
                    // Help text
                    _buildHelpText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.school_rounded,
        size: ResponsiveDesign.getIconSize(40),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildModernBiometricIcon() {
    return GestureDetector(
      onTap: _authenticateWithBiometric,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring for scanning animation
                if (_isScanning)
                  AnimatedBuilder(
                    animation: _scanningAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: CircularProgressIndicator(
                          value: _scanningAnimation.value,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                
                // Success animation
                if (_successController.isCompleted)
                  AnimatedBuilder(
                    animation: _successAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _successAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                
                // Main biometric icon
                if (!_successController.isCompleted)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _biometricType.toLowerCase().contains('face') 
                          ? Icons.face_rounded 
                          : Icons.fingerprint_rounded,
                      size: ResponsiveDesign.getIconSize(50),
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernTitleAndDescription() {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Use your $_biometricType to sign in',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildModernAuthButton() {
    return Container(
      width: double.infinity,
      margin: ResponsiveDesign.getPadding(horizontal: 8.w),
      child: ElevatedButton(
        onPressed: _isAuthenticating ? null : _authenticateWithBiometric,
        style: ElevatedButton.styleFrom(
          padding: ResponsiveDesign.getPadding(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isScanning)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(
                _biometricType.toLowerCase().contains('face') 
                    ? Icons.face_rounded 
                    : Icons.fingerprint_rounded,
                size: ResponsiveDesign.getIconSize(20),
              ),
            ResponsiveSpacing(height: 0, width: 12),
            Text(
              _isScanning ? 'Scanning...' : 'Authenticate with $_biometricType',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatusMessage() {
    if (_statusMessage.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 8.w),
      padding: ResponsiveDesign.getPadding(all: 12),
      decoration: BoxDecoration(
        color: _statusMessage.contains('successful') 
            ? Colors.green.withValues(alpha: 0.1)
            : _statusMessage.contains('failed') || _statusMessage.contains('error')
                ? Colors.red.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: _statusMessage.contains('successful') 
              ? Colors.green.withValues(alpha: 0.3)
              : _statusMessage.contains('failed') || _statusMessage.contains('error')
                  ? Colors.red.withValues(alpha: 0.3)
                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _statusMessage.contains('successful') 
                ? Icons.check_circle_rounded
                : _statusMessage.contains('failed') || _statusMessage.contains('error')
                    ? Icons.error_rounded
                    : Icons.info_rounded,
            color: _statusMessage.contains('successful') 
                ? Colors.green
                : _statusMessage.contains('failed') || _statusMessage.contains('error')
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
            size: ResponsiveDesign.getIconSize(16),
          ),
          ResponsiveSpacing(height: 0, width: 8),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(14),
                fontWeight: FontWeight.w500,
                color: _statusMessage.contains('successful') 
                    ? Colors.green
                    : _statusMessage.contains('failed') || _statusMessage.contains('error')
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPasswordButton() {
    return Container(
      width: double.infinity,
      margin: ResponsiveDesign.getPadding(horizontal: 8.w),
      child: OutlinedButton(
        onPressed: _isAuthenticating ? null : _navigateToLogin,
        style: OutlinedButton.styleFrom(
          padding: ResponsiveDesign.getPadding(vertical: 16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 12),
            Text(
              'Use Password Instead',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(16),
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpText() {
    return Text(
      'Tap the icon above or use the button to authenticate',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        fontSize: ResponsiveDesign.getFontSize(12),
      ),
      textAlign: TextAlign.center,
    );
  }
}
