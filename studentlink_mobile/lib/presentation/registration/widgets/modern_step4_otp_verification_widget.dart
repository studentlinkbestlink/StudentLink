import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../services/api_service.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernStep4OtpVerificationWidget extends StatefulWidget {
  final String personalEmail;
  final String contactNumber;
  final Function(String emailOtp, String phoneOtp) onDataChanged;
  final Function(String error) onError;

  const ModernStep4OtpVerificationWidget({
    Key? key,
    required this.personalEmail,
    required this.contactNumber,
    required this.onDataChanged,
    required this.onError,
  }) : super(key: key);

  @override
  State<ModernStep4OtpVerificationWidget> createState() =>
      _ModernStep4OtpVerificationWidgetState();
}

class _ModernStep4OtpVerificationWidgetState
    extends State<ModernStep4OtpVerificationWidget> {
  final _emailOtpController = TextEditingController();
  final _phoneOtpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _emailOtpSent = false;
  bool _phoneOtpSent = false;
  int _emailCountdown = 0;
  int _phoneCountdown = 0;
  Timer? _emailTimer;
  Timer? _phoneTimer;
  Timer? _debounceTimer;
  String? _debugEmailOtp;
  String? _debugPhoneOtp;

  @override
  void initState() {
    super.initState();
    _emailOtpController.addListener(_onDataChanged);
    _phoneOtpController.addListener(_onDataChanged);

    // Auto-send OTPs when widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendEmailOtp();
      _sendPhoneOtp();
    });
  }

  @override
  void dispose() {
    _emailOtpController.dispose();
    _phoneOtpController.dispose();
    _emailTimer?.cancel();
    _phoneTimer?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onDataChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onDataChanged(
        _emailOtpController.text.trim(),
        _phoneOtpController.text.trim(),
      );
    });
  }

  void _copyToClipboard(String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();

    Fluttertoast.showToast(
      msg: '$type code copied to clipboard',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF1E2A78),
      textColor: Colors.white,
      fontSize: ResponsiveDesign.getFontSize(14.0),
    );
  }

  void _startCountdown(bool isEmail) {
    setState(() {
      if (isEmail) {
        _emailCountdown = 60;
      } else {
        _phoneCountdown = 60;
      }
    });

    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (isEmail) {
          _emailCountdown--;
          if (_emailCountdown <= 0) {
            _emailTimer?.cancel();
            _emailTimer = null;
          }
        } else {
          _phoneCountdown--;
          if (_phoneCountdown <= 0) {
            _phoneTimer?.cancel();
            _phoneTimer = null;
          }
        }
      });
    });

    if (isEmail) {
      _emailTimer = timer;
    } else {
      _phoneTimer = timer;
    }
  }

  Future<void> _sendEmailOtp() async {
    if (_emailCountdown > 0) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService().sendEmailOtp(widget.personalEmail);

      if (response['success']) {
        setState(() {
          _emailOtpSent = true;
          _debugEmailOtp = response['debug_otp'];
        });
        _startCountdown(true);

        HapticFeedback.lightImpact();

        String message = 'OTP sent to ${widget.personalEmail}';
        if (response['debug_otp'] != null) {
          message += '\nDebug OTP: ${response['debug_otp']}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF28A745),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
          ),
        );
      } else {
        widget.onError(response['message'] ?? 'Failed to send email OTP');
      }
    } catch (e) {
      widget.onError('Failed to send email OTP: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendPhoneOtp() async {
    if (_phoneCountdown > 0) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService().sendPhoneOtp(widget.contactNumber);

      if (response['success']) {
        setState(() {
          _phoneOtpSent = true;
          _debugPhoneOtp = response['debug_otp'];
        });
        _startCountdown(false);

        HapticFeedback.lightImpact();

        String message = 'OTP sent to ${widget.contactNumber}';
        if (response['debug_otp'] != null) {
          message += '\nDebug OTP: ${response['debug_otp']}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF28A745),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
          ),
        );
      } else {
        widget.onError(response['message'] ?? 'Failed to send phone OTP');
      }
    } catch (e) {
      widget.onError('Failed to send phone OTP: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern header with gradient
          Container(
            padding: ResponsiveDesign.getPadding(all: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E2A78).withValues(alpha: 0.1),
                  const Color(0xFF2480EA).withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1E2A78),
                            const Color(0xFF2480EA),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: Colors.white,
                        size: ResponsiveDesign.getIconSize(20),
                      ),
                    ),
                    ResponsiveSpacing(height: 0, width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify Your Contact Information',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color ??
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ResponsiveDesign.getFontSize(24),
                                ),
                          ),
                          ResponsiveSpacing(height: 4),
                          Text(
                            'We\'ve sent verification codes to your email and phone number. Please enter them below to continue.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color ??
                                      const Color(0xFF757575),
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ResponsiveSpacing(height: 24),

          // Email OTP Section
          _buildModernOtpSection(
            title: 'Email Verification',
            subtitle: 'Enter the 6-digit code sent to',
            contact: widget.personalEmail,
            controller: _emailOtpController,
            isSent: _emailOtpSent,
            countdown: _emailCountdown,
            onSend: _sendEmailOtp,
            icon: Icons.email_rounded,
            color: const Color(0xFF1E2A78),
          ),

          ResponsiveSpacing(height: 20),

          // Phone OTP Section
          _buildModernOtpSection(
            title: 'Phone Verification',
            subtitle: 'Enter the 6-digit code sent to',
            contact: widget.contactNumber,
            controller: _phoneOtpController,
            isSent: _phoneOtpSent,
            countdown: _phoneCountdown,
            onSend: _sendPhoneOtp,
            icon: Icons.phone_rounded,
            color: const Color(0xFF28A745),
          ),

          ResponsiveSpacing(height: 24),

          // Debug OTP Banner (if available)
          if (_debugEmailOtp != null || _debugPhoneOtp != null)
            _buildDebugOtpBanner(),

          if (_debugEmailOtp != null || _debugPhoneOtp != null)
            ResponsiveSpacing(height: 16),

          // Modern Information Card
          _buildModernInfoCard(),
        ],
      ),
    );
  }

  Widget _buildModernOtpSection({
    required String title,
    required String subtitle,
    required String contact,
    required TextEditingController controller,
    required bool isSent,
    required int countdown,
    required VoidCallback onSend,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveDesign.getIconSize(20),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '$subtitle $contact',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    const Color(0xFF757575),
                          ),
                    ),
                  ],
                ),
              ),
              // Status indicator
              Container(
                padding:
                    ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSent
                      ? const Color(0xFF28A745)
                      : const Color(0xFF28A745),
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Text(
                  isSent ? 'Sent' : 'Pending',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),

          ResponsiveSpacing(height: 20),

          // OTP Input Field
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 6,
            enabled: !_isLoading,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              labelText: 'Enter 6-digit code',
              hintText: '000000',
              counterText: '',
              prefixIcon: Icon(
                Icons.security_rounded,
                color: color,
              ),
              suffixIcon: countdown > 0
                  ? Container(
                      padding: ResponsiveDesign.getPadding(all: 16),
                      child: Text(
                        '${countdown}s',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: color,
                      ),
                      onPressed: _isLoading ? null : onSend,
                    ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: color,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: const Color(0xFFE22824),
                  width: 1,
                ),
              ),
              contentPadding: ResponsiveDesign.getPadding(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
            textAlign: TextAlign.center,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the verification code';
              }
              if (value.length != 6) {
                return 'Code must be 6 digits';
              }
              return null;
            },
          ),

          ResponsiveSpacing(height: 16),

          // Resend button
          if (countdown == 0 && isSent)
            Center(
              child: TextButton(
                onPressed: _isLoading ? null : onSend,
                style: TextButton.styleFrom(
                  foregroundColor: color,
                  padding:
                      ResponsiveDesign.getPadding(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Resend Code',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDebugOtpBanner() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF28A745).withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: const Color(0xFF28A745).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report_rounded,
                color: const Color(0xFF28A745),
                size: ResponsiveDesign.getIconSize(20),
              ),
              ResponsiveSpacing(height: 0, width: 8),
              Text(
                'Debug OTP Codes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF28A745),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          ResponsiveSpacing(height: 12),
          if (_debugEmailOtp != null) ...[
            _buildDebugOtpRow('Email OTP', _debugEmailOtp!, 'Email'),
            if (_debugPhoneOtp != null) ResponsiveSpacing(height: 8),
          ],
          if (_debugPhoneOtp != null)
            _buildDebugOtpRow('Phone OTP', _debugPhoneOtp!, 'Phone'),
        ],
      ),
    );
  }

  Widget _buildDebugOtpRow(String label, String otp, String type) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: $otp',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF28A745),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'monospace',
                ),
          ),
        ),
        ResponsiveSpacing(height: 0, width: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF28A745),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _copyToClipboard(otp, type),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              child: Padding(
                padding:
                    ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.copy_rounded,
                      color: Colors.white,
                      size: ResponsiveDesign.getIconSize(16),
                    ),
                    ResponsiveSpacing(height: 0, width: 4),
                    Text(
                      'Copy',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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

  Widget _buildModernInfoCard() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .tertiaryContainer
            .withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF28A745).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: const Color(0xFF28A745),
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Information',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                ResponsiveSpacing(height: 8),
                Text(
                  '• Check your email inbox and SMS messages\n'
                  '• OTP codes expire in 10 minutes\n'
                  '• You can resend codes after 60 seconds\n'
                  '• Contact support if you don\'t receive the codes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
