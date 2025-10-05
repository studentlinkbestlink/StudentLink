import 'package:flutter/material.dart';

import '../../../widgets/modern_dropdown_widget.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../services/form_validation_service.dart';
import '../../../widgets/validation_indicator_widget.dart';

/// Modern step 2 widget for personal information
class ModernStep2PersonalInfoWidget extends StatefulWidget {
  final Function(
      String? firstName,
      String? middleName,
      String? lastName,
      String? suffix,
      String? course,
      String? yearLevel,
      DateTime? birthday,
      String? civilStatus) onDataChanged;

  const ModernStep2PersonalInfoWidget({
    Key? key,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<ModernStep2PersonalInfoWidget> createState() =>
      _ModernStep2PersonalInfoWidgetState();
}

class _ModernStep2PersonalInfoWidgetState
    extends State<ModernStep2PersonalInfoWidget> {
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();

  String? _selectedProgram;
  String? _selectedYearLevel;
  DateTime? _selectedBirthday;
  String? _selectedCivilStatus;

  // Validation states
  String? _firstNameError;
  String? _lastNameError;
  String? _programError;
  String? _yearLevelError;
  String? _birthdayError;
  String? _civilStatusError;

  final List<String> _programs = [
    'BSAIS',
    'BSBA-FM',
    'BSBA-HRM',
    'BSBA-MM',
    'BSCpE',
    'BSCrim',
    'BSEntrep',
    'BSHM',
    'BSIT',
    'BSOA',
    'BSPsych',
    'BSTM',
    'BLIS',
    'BPED',
    'BEED',
    'BSED-English',
    'BSED-Filipino',
    'BSED-Math',
    'BSED-Science',
    'BSED-Social Studies',
    'BSED-Values',
    'BTLED',
  ];

  final List<String> _yearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  final List<String> _civilStatuses = [
    'Single',
    'Married',
    'Widowed',
    'Divorced',
    'Separated',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_onDataChanged);
    _middleNameController.addListener(_onDataChanged);
    _lastNameController.addListener(_onDataChanged);
    _suffixController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    // Validate fields
    _validateFields();

    widget.onDataChanged(
      _firstNameController.text.trim().isEmpty
          ? null
          : _firstNameController.text.trim(),
      _middleNameController.text.trim().isEmpty
          ? null
          : _middleNameController.text.trim(),
      _lastNameController.text.trim().isEmpty
          ? null
          : _lastNameController.text.trim(),
      _suffixController.text.trim().isEmpty
          ? null
          : _suffixController.text.trim(),
      _selectedProgram,
      _selectedYearLevel,
      _selectedBirthday,
      _selectedCivilStatus,
    );
  }

  void _validateFields() {
    setState(() {
      _firstNameError = FormValidationService.validateName(
        _firstNameController.text.trim().isEmpty
            ? null
            : _firstNameController.text.trim(),
        'First name',
      );
      _lastNameError = FormValidationService.validateName(
        _lastNameController.text.trim().isEmpty
            ? null
            : _lastNameController.text.trim(),
        'Last name',
      );
      _programError =
          FormValidationService.validateDropdown(_selectedProgram, 'Program');
      _yearLevelError = FormValidationService.validateDropdown(
          _selectedYearLevel, 'Year level');
      _birthdayError =
          FormValidationService.validateDate(_selectedBirthday, 'Birthday');
      _civilStatusError = FormValidationService.validateDropdown(
          _selectedCivilStatus, 'Civil status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern header
        Container(
          padding: ResponsiveDesign.getPadding(all: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                          Theme.of(context).colorScheme.primary,
                          const Color(0xFF2480EA),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
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
                          'Personal Information',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color ??
                                    Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        ResponsiveSpacing(height: 4),
                        Text(
                          'Tell us about yourself',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color ??
                                        Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
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

        // Description
        Text(
          'Please provide your personal information as it appears on your official documents.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    Theme.of(context).textTheme.bodySmall?.color,
                height: 1.5,
              ),
        ),

        ResponsiveSpacing(height: 24),

        // Form fields
        _buildModernTextField(
          controller: _firstNameController,
          label: 'First Name',
          hint: 'Enter your first name',
          icon: Icons.person_rounded,
          isRequired: true,
          errorMessage: _firstNameError,
        ),

        ResponsiveSpacing(height: 16),

        _buildModernTextField(
          controller: _middleNameController,
          label: 'Middle Name',
          hint: 'Enter your middle name (optional)',
          icon: Icons.person_outline_rounded,
          isRequired: false,
        ),

        ResponsiveSpacing(height: 16),

        _buildModernTextField(
          controller: _lastNameController,
          label: 'Last Name',
          hint: 'Enter your last name',
          icon: Icons.person_rounded,
          isRequired: true,
          errorMessage: _lastNameError,
        ),

        ResponsiveSpacing(height: 16),

        _buildModernTextField(
          controller: _suffixController,
          label: 'Suffix',
          hint: 'Jr., Sr., III, etc. (optional)',
          icon: Icons.title_rounded,
          isRequired: false,
        ),

        ResponsiveSpacing(height: 16),

        _buildModernProgramDropdown(),

        ResponsiveSpacing(height: 16),

        _buildModernYearLevelDropdown(),

        ResponsiveSpacing(height: 16),

        _buildModernBirthdayField(),

        ResponsiveSpacing(height: 16),

        _buildModernCivilStatusDropdown(),

        ResponsiveSpacing(height: 24),

        // Information note
        Container(
          padding: ResponsiveDesign.getPadding(all: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(20),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important Notes',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    ResponsiveSpacing(height: 8),
                    Text(
                      '• Use your legal name as it appears on official documents\n'
                      '• Middle name is optional but recommended\n'
                      '• Suffix (Jr., Sr., III, etc.) is optional\n'
                      '• Program and year level are required for enrollment\n'
                      '• This information will be used for official records',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.4,
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

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isRequired,
    String? errorMessage,
  }) {
    final hasError = errorMessage != null && errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(18),
            ),
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
            if (isRequired)
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
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  color: Theme.of(context).colorScheme.error,
                  width: 2,
                ),
              ),
              contentPadding:
                  ResponsiveDesign.getPadding(horizontal: 16, vertical: 16),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
            textCapitalization: TextCapitalization.words,
            validator: isRequired
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
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

  Widget _buildModernProgramDropdown() {
    final hasError = _programError != null && _programError!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.school_rounded,
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(18),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Program',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.titleMedium?.color ??
                            Colors.black,
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
          errorMessage: _programError,
          child: ModernDropdownWidget<String>(
            value: _selectedProgram,
            onChanged: (String? newValue) {
              setState(() {
                _selectedProgram = newValue;
                _onDataChanged();
              });
            },
            hint: 'Select your program',
            prefixIcon: Icon(
              Icons.school_outlined,
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            items: _programs.map((String program) {
              return DropdownMenuItem<String>(
                value: program,
                child: Text(
                  program,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.titleMedium?.color ??
                            Colors.black,
                      ),
                ),
              );
            }).toList(),
          ),
        ),
        if (hasError) ...[
          ResponsiveSpacing(height: 8),
          ValidationIndicatorWidget(
            errorMessage: _programError,
            state: ValidationState.invalid,
            showIcon: true,
            showMessage: true,
          ),
        ],
      ],
    );
  }

  Widget _buildModernYearLevelDropdown() {
    final hasError = _yearLevelError != null && _yearLevelError!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.grade_rounded,
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(18),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Year Level',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.titleMedium?.color ??
                            Colors.black,
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
          errorMessage: _yearLevelError,
          child: ModernDropdownWidget<String>(
            value: _selectedYearLevel,
            onChanged: (String? newValue) {
              setState(() {
                _selectedYearLevel = newValue;
                _onDataChanged();
              });
            },
            hint: 'Select your year level',
            prefixIcon: Icon(
              Icons.grade_outlined,
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            items: _yearLevels.map((String yearLevel) {
              return DropdownMenuItem<String>(
                value: yearLevel,
                child: Text(
                  yearLevel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.titleMedium?.color ??
                            Colors.black,
                      ),
                ),
              );
            }).toList(),
          ),
        ),
        if (hasError) ...[
          ResponsiveSpacing(height: 8),
          ValidationIndicatorWidget(
            errorMessage: _yearLevelError,
            state: ValidationState.invalid,
            showIcon: true,
            showMessage: true,
          ),
        ],
      ],
    );
  }

  Widget _buildModernBirthdayField() {
    final hasError = _birthdayError != null && _birthdayError!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.cake_rounded,
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Birthday',
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
          errorMessage: _birthdayError,
          child: GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedBirthday ?? DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme,
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != _selectedBirthday) {
                setState(() {
                  _selectedBirthday = picked;
                  _onDataChanged();
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding:
                  ResponsiveDesign.getPadding(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                border: Border.all(
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedBirthday != null
                          ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                          : 'Select your birthday',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: _selectedBirthday != null
                                ? Theme.of(context).textTheme.titleMedium?.color
                                : Theme.of(context).textTheme.bodySmall?.color,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    color: hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.bodySmall?.color,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          ResponsiveSpacing(height: 8),
          ValidationIndicatorWidget(
            errorMessage: _birthdayError,
            state: ValidationState.invalid,
            showIcon: true,
            showMessage: true,
          ),
        ],
      ],
    );
  }

  Widget _buildModernCivilStatusDropdown() {
    final hasError = _civilStatusError != null && _civilStatusError!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.family_restroom_rounded,
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Civil Status',
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
          errorMessage: _civilStatusError,
          child: DropdownButtonFormField<String>(
            value: _selectedCivilStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCivilStatus = newValue;
                _onDataChanged();
              });
            },
            decoration: InputDecoration(
              hintText: 'Select your civil status',
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
                  color: Theme.of(context).colorScheme.error,
                  width: 2,
                ),
              ),
              contentPadding:
                  ResponsiveDesign.getPadding(horizontal: 16, vertical: 16),
              prefixIcon: Icon(
                Icons.family_restroom_rounded,
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            items: _civilStatuses.map((String civilStatus) {
              return DropdownMenuItem<String>(
                value: civilStatus,
                child: Text(
                  civilStatus,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                ),
              );
            }).toList(),
          ),
        ),
        if (hasError) ...[
          ResponsiveSpacing(height: 8),
          ValidationIndicatorWidget(
            errorMessage: _civilStatusError,
            state: ValidationState.invalid,
            showIcon: true,
            showMessage: true,
          ),
        ],
      ],
    );
  }
}
