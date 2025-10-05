import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/form_validation_service.dart';

import '../../utils/error_handler.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../widgets/validation_indicator_widget.dart';
import 'widgets/modern_registration_progress_widget.dart';
import 'widgets/modern_step1_student_id_generation_widget.dart';
import 'widgets/modern_step2_personal_info_widget.dart';
import 'widgets/modern_step3_contact_info_widget.dart';
import 'widgets/modern_step4_otp_verification_widget.dart';
import 'widgets/modern_step5_account_creation_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 1;
  bool _isLoading = false;
  String? _errorMessage;
  bool _showValidationSummary = false;

  // Registration data
  String? _generatedStudentId;
  String? _generatedSchoolEmail;
  String? _firstName;
  String? _middleName;
  String? _lastName;
  String? _suffix;
  String? _course;
  String? _yearLevel;
  String? _personalEmail;
  String? _contactNumber;
  String? _emailOtp;
  String? _phoneOtp;
  DateTime? _birthday;
  String? _civilStatus;
  String? _password;
  String? _passwordConfirmation;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Theme-aware background
      resizeToAvoidBottomInset: false,
      appBar: _buildModernAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Modern progress indicator
            ModernRegistrationProgressWidget(
              currentStep: _currentStep,
              totalSteps: 6,
            ),

            // Modern error message
            if (_errorMessage != null) _buildModernErrorMessage(),

            // Step content with modern styling
            Expanded(
              child: RepaintBoundary(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: ResponsiveDesign.getPadding(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 200,
                    ),
                    child: _buildModernStepContent(),
                  ),
                ),
              ),
            ),

            // Modern navigation buttons
            _buildModernNavigationButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      title: Text(
        'Student Registration',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_rounded),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).textTheme.bodySmall?.color ??
              Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  Widget _buildModernErrorMessage() {
    return Container(
      width: double.infinity,
      margin: ResponsiveDesign.getMargin(horizontal: 20, vertical: 8),
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
        border: Border.all(
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.error.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.error.withValues(alpha: 0.5)),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).colorScheme.error,
            size: ResponsiveDesign.getIconSize(20),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _errorMessage = null),
            icon: Icon(
              Icons.close_rounded,
              color: Theme.of(context).colorScheme.error,
              size: ResponsiveDesign.getIconSize(20),
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
              padding: ResponsiveDesign.getPadding(all: 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStepContent() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Modern divider
          Container(
            margin: ResponsiveDesign.getMargin(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
            ),
          ),
          Padding(
            padding: ResponsiveDesign.getPadding(all: 24),
            child: Column(
              children: [
                _buildStepContent(),
                if (_showValidationSummary) ...[
                  ResponsiveSpacing(height: 16),
                  ValidationSummaryWidget(
                    missingFields: _getMissingFields(),
                    onRetry: () {
                      setState(() {
                        _showValidationSummary = false;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return ModernStep1StudentIdGenerationWidget(
          onStudentIdGenerated: (studentId, schoolEmail) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _generatedStudentId = studentId;
                _generatedSchoolEmail = schoolEmail;
                _errorMessage = null;
              });
            });
          },
          onError: (error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => _errorMessage = error);
            });
          },
        );
      case 2:
        return ModernStep2PersonalInfoWidget(
          onDataChanged: (firstName, middleName, lastName, suffix, course,
              yearLevel, birthday, civilStatus) {
            setState(() {
              _firstName = firstName;
              _middleName = middleName;
              _lastName = lastName;
              _suffix = suffix;
              _course = course;
              _yearLevel = yearLevel;
              _birthday = birthday;
              _civilStatus = civilStatus;
              _errorMessage = null;
            });
          },
        );
      case 3:
        return ModernStep3ContactInfoWidget(
          schoolEmail: _generatedSchoolEmail,
          onDataChanged: (personalEmail, contactNumber) {
            setState(() {
              _personalEmail = personalEmail;
              _contactNumber = contactNumber;
              _errorMessage = null;
            });
          },
        );
      case 4:
        return ModernStep4OtpVerificationWidget(
          personalEmail: _personalEmail ?? '',
          contactNumber: _contactNumber ?? '',
          onDataChanged: (emailOtp, phoneOtp) {
            setState(() {
              _emailOtp = emailOtp;
              _phoneOtp = phoneOtp;
              _errorMessage = null;
            });
          },
          onError: (error) {
            setState(() => _errorMessage = error);
          },
        );
      case 5:
        return ModernStep5AccountCreationWidget(
          onDataChanged: (password, passwordConfirmation) {
            setState(() {
              _password = password;
              _passwordConfirmation = passwordConfirmation;
              _errorMessage = null;
            });
          },
          onTermsChanged: (agreeToTerms, agreeToPrivacy) {
            setState(() {
              _agreeToTerms = agreeToTerms;
              _agreeToPrivacy = agreeToPrivacy;
              _errorMessage = null;
            });
          },
        );
      case 6:
        return ModernStep5AccountCreationWidget(
          onDataChanged: (password, passwordConfirmation) {
            setState(() {
              _password = password;
              _passwordConfirmation = passwordConfirmation;
              _errorMessage = null;
            });
          },
          onTermsChanged: (agreeToTerms, agreeToPrivacy) {
            setState(() {
              _agreeToTerms = agreeToTerms;
              _agreeToPrivacy = agreeToPrivacy;
              _errorMessage = null;
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildModernNavigationButtons() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 1)
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: ResponsiveDesign.getPadding(vertical: 16),
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(12)),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          if (_currentStep > 1) ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            flex: _currentStep == 1 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: ResponsiveDesign.getPadding(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(12)),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: ResponsiveDesign.getIconSize(20),
                      height: ResponsiveDesign.getIconSize(20),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep == 6 ? 'Create Account' : 'Continue',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        _errorMessage = null;
      });
    }
  }

  void _nextStep() {
    if (_canProceedToNextStep()) {
      if (_currentStep < 6) {
        setState(() {
          _currentStep++;
          _errorMessage = null;
          _showValidationSummary = false;
        });
      } else {
        _createAccount();
      }
    } else {
      setState(() {
        _showValidationSummary = true;
        _errorMessage =
            'Please complete all required fields before proceeding.';
      });
    }
  }

  bool _canProceedToNextStep() {
    final currentData = _getCurrentStepData();
    return FormValidationService.isStepValid(_currentStep, currentData);
  }

  Map<String, dynamic> _getCurrentStepData() {
    return {
      'firstName': _firstName,
      'lastName': _lastName,
      'course': _course,
      'yearLevel': _yearLevel,
      'birthday': _birthday,
      'civilStatus': _civilStatus,
      'personalEmail': _personalEmail,
      'contactNumber': _contactNumber,
      'emailOtp': _emailOtp,
      'phoneOtp': _phoneOtp,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
      'agreeToTerms': _agreeToTerms,
      'agreeToPrivacy': _agreeToPrivacy,
    };
  }

  List<String> _getMissingFields() {
    final currentData = _getCurrentStepData();
    return FormValidationService.getMissingFields(_currentStep, currentData);
  }

  Future<void> _createAccount() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final registrationData = {
        'student_id': _generatedStudentId,
        'first_name': _firstName,
        'middle_name': _middleName,
        'last_name': _lastName,
        'suffix': _suffix,
        'course': _course,
        'year_level': _yearLevel,
        'personal_email': _personalEmail,
        'contact_number': _contactNumber,
        'email_otp': _emailOtp,
        'phone_otp': _phoneOtp,
        'birthday': _birthday!.toIso8601String().split('T')[0],
        'civil_status': _civilStatus,
        'password': _password,
        'password_confirmation': _passwordConfirmation,
      };

      final result = await apiService.createStudentAccount(registrationData);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Account created successfully! Welcome, ${result['name']}'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to main app
        Navigator.of(context).pushReplacementNamed('/dashboard-home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e is AppError
              ? e.message
              : 'Failed to create account. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
