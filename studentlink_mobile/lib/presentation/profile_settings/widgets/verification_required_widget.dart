import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/api_service.dart';
import '../../../utils/error_handler.dart';
import '../../../utils/responsive_design.dart';

class VerificationRequiredWidget extends StatefulWidget {
  final List<String> fieldsToVerify;
  final VoidCallback onVerified;
  final VoidCallback onCancelled;

  const VerificationRequiredWidget({
    Key? key,
    required this.fieldsToVerify,
    required this.onVerified,
    required this.onCancelled,
  }) : super(key: key);

  @override
  State<VerificationRequiredWidget> createState() => _VerificationRequiredWidgetState();
}

class _VerificationRequiredWidgetState extends State<VerificationRequiredWidget> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _verificationMethod;
  String? _verificationTarget;

  @override
  void initState() {
    super.initState();
    _determineVerificationMethod();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _determineVerificationMethod() {
    // Determine which verification method to use based on fields being changed
    if (widget.fieldsToVerify.contains('personal_email')) {
      _verificationMethod = 'email';
      _verificationTarget = 'personal email';
    } else if (widget.fieldsToVerify.contains('phone')) {
      _verificationMethod = 'sms';
      _verificationTarget = 'phone number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Verification Required',
        style: GoogleFonts.inter(
          fontSize: ResponsiveDesign.getFontSize(5).w,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To change your $_verificationTarget, we need to verify your identity.',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.black,
            ),
          ),
          
          SizedBox(height: 3.h),
          
          Text(
            'We will send a verification code to your current $_verificationTarget.',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(3.5).w,
              color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
            ),
          ),
          
          SizedBox(height: 3.h),
          
          if (_errorMessage != null) ...[
            Container(
              padding: ResponsiveDesign.getPadding(all: 3.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE22824).withValues(alpha: 0.1),
                border: Border.all(color: const Color(0xFFE22824).withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: const Color(0xFFE22824), size: 4.w),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(3.5).w,
                        color: const Color(0xFFE22824),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],
          
          TextFormField(
            controller: _otpController,
            enabled: !_isLoading,
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Verification Code',
              hintText: 'Enter 6-digit code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              ),
              counterText: '',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : widget.onCancelled,
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _sendVerificationCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E2A78),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
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
                  'Send Code',
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveDesign.getFontSize(4).w,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF28A745),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
          ),
          child: Text(
            'Verify',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendVerificationCode() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await apiService.sendVerificationCode(_verificationMethod!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to your $_verificationTarget'),
            backgroundColor: const Color(0xFF28A745),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e is AppError ? e.message : 'Failed to send verification code';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyCode() async {
    if (_otpController.text.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit code';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await apiService.verifyCode(_otpController.text, _verificationMethod!);

      if (mounted) {
        widget.onVerified();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e is AppError ? e.message : 'Invalid verification code';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
