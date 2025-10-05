import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../login_screen/widgets/modern_background_widget.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

  late AnimationController _slideController;
  late AnimationController _successController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _successController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
  }

  Future<void> _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    try {
      await apiService.requestPasswordReset(_emailController.text.trim());

      // Success haptic feedback
      HapticFeedback.mediumImpact();

      setState(() {
        _isSuccess = true;
        _message =
            'Password reset instructions have been sent to your email address.';
      });

      // Trigger success animation
      _successController.forward();
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();

      setState(() {
        _isSuccess = false;
        _message = e.toString().contains('Exception:')
            ? e.toString().replaceAll('Exception: ', '')
            : 'Failed to send password reset email. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _slideController.dispose();
    _successController.dispose();
    super.dispose();
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
      data: AppTheme.lightTheme, // Force light theme for forgot password screen
      child: Scaffold(
        backgroundColor: Colors.black, // Dark background for better contrast
        appBar: _buildModernAppBar(),
        body: Stack(
          children: [
            // Enhanced animated background - positioned to fill entire screen
            Positioned.fill(
              child: const ModernBackgroundWidget(),
            ),

            // Safe area for content with optimized spacing for small screens
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: ResponsiveDesign.getPadding(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ResponsiveSpacing(height: 40), // Reduced from 60

                      // Enhanced header
                      _buildModernHeader(),

                      ResponsiveSpacing(height: 32), // Reduced from 40

                      // Message Display
                      if (_message != null) _buildModernMessageDisplay(),

                      ResponsiveSpacing(height: 24), // Reduced from 32

                      // Enhanced form
                      SlideTransition(
                        position: _slideAnimation,
                        child: _buildModernForm(),
                      ),

                      ResponsiveSpacing(height: 32), // Reduced from 40

                      // Enhanced help text
                      _buildModernHelpText(),

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

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: Text(
        'Reset Password',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
          size: ResponsiveDesign.getIconSize(20),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Column(
      children: [
        // Clean, static logo with increased size and no circular background (matching login screen)
        Center(
          child: Container(
            width: ResponsiveDesign.getIconSize(
                180), // Increased to match login screen
            height: ResponsiveDesign.getIconSize(
                180), // Increased to match login screen
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
              // Completely removed all background effects for clean design
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
              child: Container(
                decoration: BoxDecoration(
                  // Removed background color for completely clean look
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(24)),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/img_app_logo.png',
                    width: ResponsiveDesign.getIconSize(
                        140), // Increased to match login screen
                    height: ResponsiveDesign.getIconSize(
                        140), // Increased to match login screen
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Enhanced fallback with Inter font
                      return Text(
                        'SL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3.0,
                          fontSize: ResponsiveDesign.getFontSize(
                              56), // Increased to match login screen
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        ResponsiveSpacing(height: 32),

        // Enhanced title with stronger typography
        Text(
          'Forgot Your Password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight
                .w900, // Changed from w800 to w900 for stronger presence
            color: Colors.white,
            letterSpacing: 1.0, // Increased from 0.5 to 1.0 for better spacing
            fontSize:
                ResponsiveDesign.getFontSize(26), // Increased from 24 to 26
            shadows: [
              Shadow(
                color: Colors.black.withValues(
                    alpha: 0.6), // Increased opacity for better contrast
                blurRadius: 8, // Reduced blur for sharper text
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        ResponsiveSpacing(height: 16),

        // Enhanced description
        Text(
          'Enter your email address and we\'ll send you instructions to reset your password.',
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernForm() {
    return Container(
      margin: ResponsiveDesign.getMargin(horizontal: 4), // Reduced from 8
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: ResponsiveDesign.getPadding(all: 24), // Reduced from 32
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.15),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email Field
                _buildModernEmailField(),

                ResponsiveSpacing(height: 24), // Reduced from 32

                // Reset Password Button
                _buildModernResetButton(),

                ResponsiveSpacing(height: 20), // Reduced from 24

                // Back to Login Button
                _buildModernBackButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
        ),
        ResponsiveSpacing(height: 10), // Reduced from 12
        ClipRRect(
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: ResponsiveDesign.getIconSize(22),
                  ),
                  filled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide(
                      color: AppTheme.emergencyLight.withValues(alpha: 0.8),
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide(
                      color: AppTheme.emergencyLight,
                      width: 2,
                    ),
                  ),
                  contentPadding:
                      ResponsiveDesign.getPadding(horizontal: 20, vertical: 18),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernMessageDisplay() {
    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isSuccess ? _successAnimation.value : 1.0,
          child: Container(
            width: double.infinity,
            padding: ResponsiveDesign.getPadding(all: 20),
            margin: ResponsiveDesign.getMargin(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isSuccess
                    ? [
                        AppTheme.successLight.withValues(alpha: 0.15),
                        AppTheme.successLight.withValues(alpha: 0.05),
                      ]
                    : [
                        AppTheme.emergencyLight.withValues(alpha: 0.15),
                        AppTheme.emergencyLight.withValues(alpha: 0.05),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              border: Border.all(
                color: _isSuccess
                    ? AppTheme.successLight.withValues(alpha: 0.3)
                    : AppTheme.emergencyLight.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isSuccess
                          ? AppTheme.successLight
                          : AppTheme.emergencyLight)
                      .withValues(alpha: 0.1),
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
                    color: (_isSuccess
                            ? AppTheme.successLight
                            : AppTheme.emergencyLight)
                        .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isSuccess
                        ? Icons.check_circle_rounded
                        : Icons.error_rounded,
                    color: _isSuccess
                        ? AppTheme.successLight
                        : AppTheme.emergencyLight,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                ),
                ResponsiveSpacing(height: 0, width: 16),
                Expanded(
                  child: Text(
                    _message!,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernResetButton() {
    return Container(
      width: double.infinity,
      height: 50, // Reduced from 56 for better small screen compatibility
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryLight,
            AppTheme.secondaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryLight.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading || _isSuccess ? null : _handlePasswordReset,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: ResponsiveDesign.getIconSize(24),
                height: ResponsiveDesign.getIconSize(24),
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSuccess ? 'Email Sent' : 'Send Reset Instructions',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (!_isSuccess) ...[
                    ResponsiveSpacing(height: 0, width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: ResponsiveDesign.getIconSize(20),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildModernBackButton() {
    return Container(
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
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
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
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: ResponsiveDesign.getIconSize(20),
                ),
                ResponsiveSpacing(height: 0, width: 8),
                Text(
                  'Back to Login',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }

  Widget _buildModernHelpText() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        'Still having trouble? Contact support at\nstudentlink.bestlink@gmail.com',
        textAlign: TextAlign.center,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
          height: 1.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
