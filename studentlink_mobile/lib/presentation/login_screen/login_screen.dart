import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../services/biometric_auth_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import './widgets/modern_background_widget.dart';
import './widgets/modern_logo_widget.dart';
import './widgets/modern_login_form_widget.dart';
import '../theme_selection/theme_selection_modal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Authenticate with the backend API
      await apiService.login(email, password);
      
      // Login successful if we get here without exception
      // Success haptic feedback
      HapticFeedback.mediumImpact();
      
      // Register FCM token for push notifications
      try {
        print('🔔 Registering FCM token after successful login...');
        await NotificationService().registerTokenAfterLogin();
        print('✅ FCM token registered successfully');
      } catch (e) {
        print('⚠️ Failed to register FCM token: $e');
        // Don't let FCM registration failure prevent login
      }

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
                const Text('Login successful!'),
              ],
            ),
            backgroundColor: AppTheme.successLight,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            margin: ResponsiveDesign.getPadding(all: 16),
          ),
        );

        // Check if biometric authentication should be enabled
        await _handlePostLoginBiometric(email, password);
        
        // Navigate to dashboard
        Navigator.pushReplacementNamed(context, '/dashboard-home');
        
        // Show theme selection modal after a brief delay
        Future.delayed(const Duration(milliseconds: 800), () {
          _showThemeSelectionModal();
        });
      }
    } catch (e) {
      // Network or other errors
      setState(() {
        _errorMessage =
            'Unable to connect to the server. Please check your internet connection and try again.';
      });

      HapticFeedback.heavyImpact();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showThemeSelectionModal() {
    // Check if user has already set a theme preference
    // Only show for first-time users or users who haven't customized their theme
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ThemeSelectionModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: _buildLoginContent(context),
    );
  }
  
  Widget _buildLoginContent(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme, // Force light theme for login screen
      child: Scaffold(
        backgroundColor: Colors.black, // Dark background for better contrast
        resizeToAvoidBottomInset: false,
        body: Stack(
        children: [
          // Enhanced animated background - positioned to fill entire screen
          Positioned.fill(
            child: const ModernBackgroundWidget(),
          ),

          // Safe area for content with scrollable layout for small screens
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: ResponsiveDesign.getPadding(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ResponsiveSpacing(height: 40), // Reduced from 60

                    // Enhanced logo and branding
                    const ModernLogoWidget(),

                    ResponsiveSpacing(height: 32), // Reduced from 40

                    // Error message with improved styling
                    if (_errorMessage != null) _buildErrorMessage(),

                    // Enhanced login form
                    ModernLoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    ResponsiveSpacing(height: 24), // Reduced from 32

                    // Enhanced registration option
                    _buildRegistrationOption(),

                    ResponsiveSpacing(height: 32), // Reduced from 40
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

  Widget _buildErrorMessage() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 20),
      margin: ResponsiveDesign.getPadding(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.emergencyLight.withValues(alpha: 0.15),
            AppTheme.emergencyLight.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: AppTheme.emergencyLight.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.emergencyLight.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: ResponsiveDesign.getPadding(all: 8),
            decoration: BoxDecoration(
              color: AppTheme.emergencyLight.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: AppTheme.emergencyLight,
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 16),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationOption() {
    return Column(
      children: [
        // Enhanced divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: ResponsiveDesign.getPadding(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
        ResponsiveSpacing(height: 24),
        
        // Enhanced registration button
        Container(
          width: double.infinity,
          height: 50, // Reduced from 56 for better small screen compatibility
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : _navigateToRegistration,
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: ResponsiveDesign.getIconSize(22),
                    ),
                    ResponsiveSpacing(height: 0, width: 12),
                    Text(
                      'Create New Account',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  void _navigateToRegistration() {
    // Add haptic feedback
    HapticFeedback.lightImpact();
    
    // Navigate to registration screen
    Navigator.of(context).pushNamed('/registration');
  }

  Future<void> _handlePostLoginBiometric(String email, String password) async {
    try {
      final biometricService = BiometricAuthService();
      
      // Check what biometric options are available
      final availability = await biometricService.checkBiometricAvailability();
      print('🔍 Biometric availability: $availability');
      
      if (availability == BiometricAvailability.deviceBiometric) {
        // Device biometric is available (like GCash/PayMaya)
        print('🔐 Enabling device biometric authentication...');
        final enabled = await biometricService.enableDeviceBiometricAuth();
        print('🔐 Device biometric enabled: $enabled');
        if (enabled) {
          _showDeviceBiometricEnabledMessage();
        } else {
          _showBiometricEnableFailedMessage();
        }
      } else if (availability == BiometricAvailability.typingPattern) {
        // Only TypingDNA is available
        print('⌨️ Enabling TypingDNA authentication...');
        final enabled = await biometricService.enableTypingDnaAuth(email);
        print('⌨️ TypingDNA enabled: $enabled');
        if (enabled) {
          _showTypingDnaEnabledMessage();
        } else {
          _showTypingDnaEnableFailedMessage();
        }
      } else {
        // No biometric authentication available
        print('❌ No biometric authentication available');
        _showBiometricNotAvailableMessage();
      }
    } catch (e) {
      print('❌ Error handling post-login biometric: $e');
    }
  }



  void _showBiometricEnableFailedMessage() {
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
            const Text('Failed to enable biometric authentication'),
          ],
        ),
        backgroundColor: AppTheme.warningLight,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }

  void _showDeviceBiometricEnabledMessage() {
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
            const Text('Device biometric authentication enabled!'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }

  void _showTypingDnaEnabledMessage() {
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
            const Text('Typing pattern authentication enabled!'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }

  void _showTypingDnaEnableFailedMessage() {
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
            const Text('Failed to enable typing pattern authentication'),
          ],
        ),
        backgroundColor: AppTheme.warningLight,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }

  void _showBiometricNotAvailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
                    Icons.info_rounded,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
            ResponsiveSpacing(height: 0, width: 8),
            const Text('Biometric authentication not available on this device'),
          ],
        ),
        backgroundColor: AppTheme.warningLight,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        margin: ResponsiveDesign.getPadding(all: 16),
      ),
    );
  }
}
