import 'package:flutter/material.dart';

import 'terms_of_service_widget.dart';
import 'privacy_policy_widget.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../services/form_validation_service.dart';
import '../../../widgets/validation_indicator_widget.dart';

class ModernStep5AccountCreationWidget extends StatefulWidget {
  final Function(String? password, String? passwordConfirmation) onDataChanged;
  final Function(bool agreeToTerms, bool agreeToPrivacy)? onTermsChanged;

  const ModernStep5AccountCreationWidget({
    Key? key,
    required this.onDataChanged,
    this.onTermsChanged,
  }) : super(key: key);

  @override
  State<ModernStep5AccountCreationWidget> createState() =>
      _ModernStep5AccountCreationWidgetState();
}

class _ModernStep5AccountCreationWidgetState
    extends State<ModernStep5AccountCreationWidget> {
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Validation states
  String? _passwordError;
  String? _passwordConfirmationError;
  String? _termsError;
  String? _privacyError;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onDataChanged);
    _passwordConfirmationController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    // Validate fields
    _validateFields();

    widget.onDataChanged(
      _passwordController.text.trim().isEmpty
          ? null
          : _passwordController.text.trim(),
      _passwordConfirmationController.text.trim().isEmpty
          ? null
          : _passwordConfirmationController.text.trim(),
    );
  }

  void _validateFields() {
    setState(() {
      _passwordError = FormValidationService.validatePassword(
        _passwordController.text.trim().isEmpty
            ? null
            : _passwordController.text.trim(),
      );
      _passwordConfirmationError =
          FormValidationService.validatePasswordConfirmation(
        _passwordConfirmationController.text.trim().isEmpty
            ? null
            : _passwordConfirmationController.text.trim(),
        _passwordController.text.trim().isEmpty
            ? null
            : _passwordController.text.trim(),
      );
      _termsError = FormValidationService.validateTermsAgreement(
          _agreeToTerms, 'Terms of Service');
      _privacyError = FormValidationService.validateTermsAgreement(
          _agreeToPrivacy, 'Privacy Policy');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      Icons.account_circle_rounded,
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
                          'Create Your Account',
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
                          'Review your information and agree to the terms to complete your registration.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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

        // Password fields
        _buildModernPasswordField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_rounded,
          isVisible: _isPasswordVisible,
          errorMessage: _passwordError,
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),

        ResponsiveSpacing(height: 20),

        _buildModernPasswordField(
          controller: _passwordConfirmationController,
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          icon: Icons.lock_reset_rounded,
          isVisible: _isConfirmPasswordVisible,
          errorMessage: _passwordConfirmationError,
          onToggleVisibility: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),

        ResponsiveSpacing(height: 24),

        // Account summary
        _buildModernAccountSummary(),

        ResponsiveSpacing(height: 20),

        // Terms and conditions
        _buildModernTermsSection(),

        ResponsiveSpacing(height: 20),

        // Information note
        _buildModernInfoCard(),

        ResponsiveSpacing(height: 16),

        // Validation message
        if (!_agreeToTerms || !_agreeToPrivacy) _buildModernValidationMessage(),
      ],
    );
  }

  Widget _buildModernAccountSummary() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_circle_rounded,
                  color: const Color(0xFF1E2A78),
                  size: ResponsiveDesign.getIconSize(20),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 16),
              Text(
                'Account Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          ResponsiveSpacing(height: 20),
          Text(
            'Your account will be created with the following information:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
          ),
          ResponsiveSpacing(height: 20),
          _buildModernSummaryItem('Student ID', 'Auto-generated unique ID'),
          _buildModernSummaryItem(
              'School Email', 'Auto-generated school email'),
          _buildModernSummaryItem(
              'Personal Information', 'Name, birthday, civil status'),
          _buildModernSummaryItem(
              'Contact Information', 'Personal email and phone number'),
          _buildModernSummaryItem(
              'Account Security', 'Secure password protection'),
        ],
      ),
    );
  }

  Widget _buildModernSummaryItem(String title, String description) {
    return Padding(
      padding: ResponsiveDesign.getPadding(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF28A745).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: const Color(0xFF28A745),
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTermsSection() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
          ),

          ResponsiveSpacing(height: 20),

          // Terms agreement
          _buildModernCheckboxTile(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
                _validateFields();
              });
              widget.onTermsChanged?.call(_agreeToTerms, _agreeToPrivacy);
            },
            title: 'I agree to the ',
            linkText: 'Terms of Service',
            onLinkTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfServiceWidget(),
                ),
              );
            },
            hasError: _termsError != null && _termsError!.isNotEmpty,
            errorMessage: _termsError,
          ),

          ResponsiveSpacing(height: 16),

          // Privacy agreement
          _buildModernCheckboxTile(
            value: _agreeToPrivacy,
            onChanged: (value) {
              setState(() {
                _agreeToPrivacy = value ?? false;
                _validateFields();
              });
              widget.onTermsChanged?.call(_agreeToTerms, _agreeToPrivacy);
            },
            title: 'I agree to the ',
            linkText: 'Privacy Policy',
            onLinkTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyWidget(),
                ),
              );
            },
            hasError: _privacyError != null && _privacyError!.isNotEmpty,
            errorMessage: _privacyError,
          ),
        ],
      ),
    );
  }

  Widget _buildModernCheckboxTile({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    required String linkText,
    required VoidCallback onLinkTap,
    bool hasError = false,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              checkColor: Theme.of(context).colorScheme.onPrimary,
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary;
                }
                return Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.surface;
              }),
              side: BorderSide(
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(4)),
              ),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Expanded(
              child: GestureDetector(
                onTap: onLinkTap,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: hasError
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                    children: [
                      TextSpan(text: title),
                      TextSpan(
                        text: linkText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: hasError
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (hasError) ...[
          ResponsiveSpacing(height: 8),
          ValidationIndicatorWidget(
            errorMessage: errorMessage,
            state: ValidationState.invalid,
            showIcon: true,
            showMessage: true,
          ),
        ],
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
              color:
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: Theme.of(context).colorScheme.tertiary,
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to Create Account',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                ResponsiveSpacing(height: 8),
                Text(
                  'Once you create your account, you will be automatically logged in and can start using the StudentLink app immediately.',
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

  Widget _buildModernValidationMessage() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error,
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            child: Text(
              'Please agree to the Terms of Service and Privacy Policy to continue.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? errorMessage,
  }) {
    final hasError = errorMessage != null && errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(20)),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.titleMedium?.color,
                  ),
            ),
            Text(
              ' *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
        ResponsiveSpacing(height: 8),
        AnimatedValidationField(
          hasError: hasError,
          errorMessage: errorMessage,
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error, width: 2),
              ),
              contentPadding:
                  ResponsiveDesign.getPadding(horizontal: 16, vertical: 16),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).textTheme.bodySmall?.color,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              if (label == 'Confirm Password' &&
                  value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
        if (hasError) ...[
          ResponsiveSpacing(height: 8),
          ValidationIndicatorWidget(
            errorMessage: errorMessage,
            state: ValidationState.invalid,
            showIcon: true,
            showMessage: true,
          ),
        ],
      ],
    );
  }
}
