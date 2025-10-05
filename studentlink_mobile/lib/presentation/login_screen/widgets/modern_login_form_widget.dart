import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../../theme/app_theme.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernLoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const ModernLoginFormWidget({
    Key? key,
    required this.onLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<ModernLoginFormWidget> createState() => _ModernLoginFormWidgetState();
}

class _ModernLoginFormWidgetState extends State<ModernLoginFormWidget>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  
  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final isValid = email.isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
        child: Container(
          margin: ResponsiveDesign.getMargin(horizontal: 4), // Reduced from 8
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
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
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimaryLight.withValues(alpha: 0.1),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Text
                    _buildWelcomeText(),
                    
                    ResponsiveSpacing(height: 24), // Reduced from 32

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'Enter your email address',
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    
                    ResponsiveSpacing(height: 20), // Reduced from 24

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_rounded,
                      obscureText: !_isPasswordVisible,
                      textInputAction: TextInputAction.done,
                      validator: _validatePassword,
                      onSubmitted: (_) => _isFormValid ? _handleLogin() : null,
                      suffixIcon: IconButton(
                        onPressed: widget.isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                                HapticFeedback.lightImpact();
                              },
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: ResponsiveDesign.getIconSize(20),
                        ),
                      ),
                    ),
                    
                    ResponsiveSpacing(height: 16), // Reduced from 20

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: widget.isLoading
                            ? null
                            : () {
                                HapticFeedback.lightImpact();
                                Navigator.pushNamed(context, '/forgot-password');
                              },
                        child: ResponsiveText(
                          'Forgot Password?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    ResponsiveSpacing(height: 24), // Reduced from 32

                    // Login Button
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        ResponsiveSpacing(height: 8),
        ResponsiveText(
          'Sign in to continue to your account',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 50, // Fixed height for better small screen compatibility
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryLight,
                AppTheme.secondaryLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryLight.withValues(alpha: 0.3 + (_glowAnimation.value * 0.2)),
                blurRadius: 20 + (_glowAnimation.value * 10),
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: (_isFormValid && !widget.isLoading) ? _handleLogin : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              ),
            ),
            child: widget.isLoading
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
                      ResponsiveText(
                        'Sign In',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      ResponsiveSpacing(height: 0, width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: ResponsiveDesign.getIconSize(20),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
        ),
        ResponsiveSpacing(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
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
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                obscureText: obscureText,
                enabled: !widget.isLoading,
                onFieldSubmitted: onSubmitted,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveDesign.getFontSize(14),
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: ResponsiveDesign.getFontSize(14),
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: ResponsiveDesign.getIconSize(22),
                  ),
                  suffixIcon: suffixIcon,
                  filled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide(
                      color: AppTheme.emergencyLight.withValues(alpha: 0.8),
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                    borderSide: BorderSide(
                      color: AppTheme.emergencyLight,
                      width: 2,
                    ),
                  ),
                  contentPadding: ResponsiveDesign.getPadding(horizontal: 20, vertical: 18),
                ),
                validator: validator,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
