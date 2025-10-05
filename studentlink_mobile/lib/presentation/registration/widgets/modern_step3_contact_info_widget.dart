import 'package:flutter/material.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../services/form_validation_service.dart';
import '../../../widgets/validation_indicator_widget.dart';

class ModernStep3ContactInfoWidget extends StatefulWidget {
  final String? schoolEmail;
  final Function(String? personalEmail, String? contactNumber) onDataChanged;

  const ModernStep3ContactInfoWidget({
    Key? key,
    required this.schoolEmail,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<ModernStep3ContactInfoWidget> createState() =>
      _ModernStep3ContactInfoWidgetState();
}

class _ModernStep3ContactInfoWidgetState
    extends State<ModernStep3ContactInfoWidget> {
  final _personalEmailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _personalEmailFocusNode = FocusNode();
  final _contactNumberFocusNode = FocusNode();

  // Validation states
  String? _personalEmailError;
  String? _contactNumberError;

  @override
  void initState() {
    super.initState();
    _personalEmailController.addListener(_onDataChanged);
    _contactNumberController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _personalEmailController.dispose();
    _contactNumberController.dispose();
    _personalEmailFocusNode.dispose();
    _contactNumberFocusNode.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    // Validate fields
    _validateFields();

    widget.onDataChanged(
      _personalEmailController.text.trim().isEmpty
          ? null
          : _personalEmailController.text.trim(),
      _contactNumberController.text.trim().isEmpty
          ? null
          : _contactNumberController.text.trim(),
    );
  }

  void _validateFields() {
    setState(() {
      _personalEmailError = FormValidationService.validateEmail(
        _personalEmailController.text.trim().isEmpty
            ? null
            : _personalEmailController.text.trim(),
      );
      _contactNumberError = FormValidationService.validatePhone(
        _contactNumberController.text.trim().isEmpty
            ? null
            : _contactNumberController.text.trim(),
      );
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
                      Icons.contact_phone_rounded,
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
                          'Contact Information',
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
                          'Provide your contact details for communication and account recovery.',
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

        // School Email (read-only) - if available
        if (widget.schoolEmail != null) ...[
          _buildModernReadOnlyField(
            label: 'School Email',
            value: widget.schoolEmail!,
            icon: Icons.school_rounded,
            color: const Color(0xFF28A745),
          ),
          ResponsiveSpacing(height: 20),
        ],

        // Personal Email
        _buildModernTextField(
          controller: _personalEmailController,
          focusNode: _personalEmailFocusNode,
          label: 'Personal Email',
          hint: 'Enter your personal email address',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
          errorMessage: _personalEmailError,
        ),

        ResponsiveSpacing(height: 20),

        // Contact Number
        _buildModernTextField(
          controller: _contactNumberController,
          focusNode: _contactNumberFocusNode,
          label: 'Contact Number',
          hint: 'Enter your phone number',
          icon: Icons.phone_rounded,
          keyboardType: TextInputType.phone,
          isRequired: true,
          errorMessage: _contactNumberError,
        ),

        ResponsiveSpacing(height: 24),

        // Modern Information Cards
        _buildModernInfoCards(),
      ],
    );
  }

  Widget _buildModernReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveDesign.getIconSize(12),
              ),
            ),
            ResponsiveSpacing(height: 0, width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            ResponsiveSpacing(height: 0, width: 12),
            Container(
              padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
              ),
              child: Text(
                'Auto-generated',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        ResponsiveSpacing(height: 12),
        Container(
          width: double.infinity,
          padding: ResponsiveDesign.getPadding(all: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required bool isRequired,
    String? errorMessage,
  }) {
    final hasError = errorMessage != null && errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: hasError
                    ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
                    : Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(12),
              ),
            ),
            ResponsiveSpacing(height: 0, width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
          ],
        ),
        ResponsiveSpacing(height: 12),
        AnimatedValidationField(
          hasError: hasError,
          errorMessage: errorMessage,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
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
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                borderSide: BorderSide(
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.outline,
                  width: 1,
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
                  color: Theme.of(context).colorScheme.error,
                  width: 2,
                ),
              ),
              contentPadding:
                  ResponsiveDesign.getPadding(horizontal: 16, vertical: 16),
              prefixIcon: Icon(
                icon,
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : focusNode.hasFocus
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodySmall?.color,
                size: ResponsiveDesign.getIconSize(20),
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
            validator: isRequired
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    if (keyboardType == TextInputType.emailAddress) {
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  }
                : null,
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

  Widget _buildModernInfoCards() {
    return Column(
      children: [
        // Email Information Card
        Container(
          padding: ResponsiveDesign.getPadding(all: 20),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
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
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
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
                      'Email Information',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    ResponsiveSpacing(height: 8),
                    Text(
                      '• School Email: Used for official communications\n'
                      '• Personal Email: Used for account recovery\n'
                      '• Both emails will be verified during registration',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        ResponsiveSpacing(height: 16),

        // Contact Number Card
        Container(
          padding: ResponsiveDesign.getPadding(all: 20),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
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
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone_android_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: ResponsiveDesign.getIconSize(20),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Number',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    ResponsiveSpacing(height: 8),
                    Text(
                      '• Include country code (e.g., +63 for Philippines)\n'
                      '• Used for SMS notifications and account recovery\n'
                      '• Must be a valid, active phone number',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
