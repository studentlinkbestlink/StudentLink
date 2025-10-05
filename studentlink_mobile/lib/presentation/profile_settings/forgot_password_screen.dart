import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../utils/error_handler.dart';
import '../../utils/responsive_design.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  String? _successMessage;
  
  int _currentStep = 1; // 1: Choose method, 2: Enter code, 3: Reset password
  String? _selectedMethod; // 'email' or 'phone'
  String? _verificationTarget;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: AppTheme.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveDesign.getPadding(all: 4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              _buildProgressIndicator(),
              
              SizedBox(height: 4.h),

              // Step Content
              if (_currentStep == 1) _buildStep1ChooseMethod(),
              if (_currentStep == 2) _buildStep2EnterCode(),
              if (_currentStep == 3) _buildStep3ResetPassword(),

              SizedBox(height: 4.h),

              // Error/Success Messages
              if (_errorMessage != null) _buildErrorMessage(),
              if (_successMessage != null) _buildSuccessMessage(),

              SizedBox(height: 4.h),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressStep(1, 'Method', _currentStep >= 1),
        Expanded(child: _buildProgressLine(_currentStep >= 2)),
        _buildProgressStep(2, 'Verify', _currentStep >= 2),
        Expanded(child: _buildProgressLine(_currentStep >= 3)),
        _buildProgressStep(3, 'Reset', _currentStep >= 3),
      ],
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isActive 
                ? AppTheme.primaryLight 
                : Color(0xFF300300300),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: GoogleFonts.inter(
                fontSize: ResponsiveDesign.getFontSize(4).w,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Color(0xFF757575),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(3).w,
            color: isActive 
                ? AppTheme.primaryLight 
                : Color(0xFF757575),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive 
          ? AppTheme.primaryLight 
          : Color(0xFF300300300),
    );
  }

  Widget _buildStep1ChooseMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Recovery Method',
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(6).w,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryLight,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        Text(
          'Select how you would like to receive your verification code:',
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(4).w,
            color: Color(0xFF757575),
          ),
        ),
        
        SizedBox(height: 4.h),
        
        // Email Option
        _buildMethodOption(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'Send code to your registered email',
          isSelected: _selectedMethod == 'email',
          onTap: () {
            setState(() {
              _selectedMethod = 'email';
              _verificationTarget = 'email';
            });
          },
        ),
        
        SizedBox(height: 2.h),
        
        // Phone Option
        _buildMethodOption(
          icon: Icons.phone,
          title: 'Phone Number',
          subtitle: 'Send code via SMS to your registered phone',
          isSelected: _selectedMethod == 'phone',
          onTap: () {
            setState(() {
              _selectedMethod = 'phone';
              _verificationTarget = 'phone number';
            });
          },
        ),
      ],
    );
  }

  Widget _buildStep2EnterCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Verification Code',
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(6).w,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryLight,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        Text(
          'We sent a 6-digit code to your $_verificationTarget. Enter it below:',
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(4).w,
            color: Color(0xFF757575),
          ),
        ),
        
        SizedBox(height: 4.h),
        
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          enabled: !_isLoading,
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(6).w,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Verification Code',
            hintText: '000000',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the verification code';
            }
            if (value.length != 6) {
              return 'Please enter a valid 6-digit code';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStep3ResetPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create New Password',
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(6).w,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryLight,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        Text(
          'Enter your new password below:',
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(4).w,
            color: Color(0xFF757575),
          ),
        ),
        
        SizedBox(height: 4.h),
        
        // Password Requirements Info
        Container(
          padding: ResponsiveDesign.getPadding(all: 4.w),
          decoration: BoxDecoration(
            color: Colors.blue[50]!,
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[600]!,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Password Requirements',
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(4).w,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700]!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'Choose one of the following options:\n\n'
                'Option A: At least 15 characters\n'
                'Option B: At least 8 characters including:\n'
                '• At least one number\n'
                '• At least one lowercase letter',
                style: GoogleFonts.inter(
                  fontSize: ResponsiveDesign.getFontSize(3.5).w,
                  color: Colors.blue[700]!,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 4.h),
        
        // New Password Field
        _buildPasswordField(
          controller: _newPasswordController,
          label: 'New Password',
          hint: 'Enter your new password',
          obscureText: _obscureNewPassword,
          onToggleVisibility: () {
            setState(() {
              _obscureNewPassword = !_obscureNewPassword;
            });
          },
          validator: _validateNewPassword,
        ),
        
        SizedBox(height: 3.h),
        
        // Confirm Password Field
        _buildPasswordField(
          controller: _confirmPasswordController,
          label: 'Confirm New Password',
          hint: 'Confirm your new password',
          obscureText: _obscureConfirmPassword,
          onToggleVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new password';
            }
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
      child: Container(
        padding: ResponsiveDesign.getPadding(all: 4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryLight 
                : const Color(0xFF300300300),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          color: isSelected 
              ? AppTheme.primaryLight.withValues(alpha: 0.1)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppTheme.primaryLight 
                  : Color(0xFF757575),
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(4).w,
                      fontWeight: FontWeight.w600,
                      color: isSelected 
                          ? AppTheme.primaryLight 
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(3.5).w,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryLight,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(4).w,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enabled: !_isLoading,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(4).w,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              color: Color(0xFF500500500),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w,
              vertical: 3.h,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFF757575),
                size: 5.w,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(all: 3.w),
      decoration: BoxDecoration(
        color: Colors.red[50]!,
        border: Border.all(color: Colors.red[200]!),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 4.w),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(all: 3.w),
      decoration: BoxDecoration(
        color: Colors.green[50]!,
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 4.w),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _successMessage!,
              style: GoogleFonts.inter(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_currentStep > 1)
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : _goToPreviousStep,
              style: OutlinedButton.styleFrom(
                padding: ResponsiveDesign.getPadding(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                ),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.inter(
                  fontSize: ResponsiveDesign.getFontSize(4).w,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        
        if (_currentStep > 1) SizedBox(width: 3.w),
        
        Expanded(
          flex: _currentStep == 1 ? 1 : 1,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              padding: ResponsiveDesign.getPadding(vertical: 3.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 4.w,
                    width: 4.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _getButtonText(),
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(4).w,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  String _getButtonText() {
    switch (_currentStep) {
      case 1:
        return 'Send Code';
      case 2:
        return 'Verify Code';
      case 3:
        return 'Reset Password';
      default:
        return 'Next';
    }
  }

  void _goToPreviousStep() {
    setState(() {
      _currentStep--;
      _errorMessage = null;
      _successMessage = null;
    });
  }

  Future<void> _handleNextStep() async {
    if (_currentStep == 1) {
      if (_selectedMethod == null) {
        setState(() {
          _errorMessage = 'Please select a recovery method';
        });
        return;
      }
      await _sendVerificationCode();
    } else if (_currentStep == 2) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      await _verifyCode();
    } else if (_currentStep == 3) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      await _resetPassword();
    }
  }

  Future<void> _sendVerificationCode() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      String target = _selectedMethod == 'email' 
          ? _emailController.text 
          : _phoneController.text;

      await apiService.sendPasswordResetCode(_selectedMethod!, target);

      setState(() {
        _currentStep = 2;
        _successMessage = 'Verification code sent to your $_verificationTarget';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e is AppError ? e.message : 'Failed to send verification code';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await apiService.verifyPasswordResetCode(_otpController.text);

      setState(() {
        _currentStep = 3;
        _successMessage = 'Code verified successfully';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e is AppError ? e.message : 'Invalid verification code';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await apiService.resetPasswordWithCode(
        _otpController.text,
        _newPasswordController.text,
      );

      setState(() {
        _successMessage = 'Password reset successfully! You can now sign in with your new password.';
      });

      // Navigate back to login after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login-screen');
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e is AppError ? e.message : 'Failed to reset password';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }

    // Option A: At least 15 characters
    if (value.length >= 15) {
      return null;
    }

    // Option B: At least 8 characters with number and lowercase letter
    if (value.length >= 8) {
      bool hasNumber = value.contains(RegExp(r'[0-9]'));
      bool hasLowercase = value.contains(RegExp(r'[a-z]'));
      
      if (hasNumber && hasLowercase) {
        return null;
      }
    }

    return 'Password must be at least 15 characters OR at least 8 characters with a number and lowercase letter';
  }
}
