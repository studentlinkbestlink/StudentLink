class FormValidationService {
  static const int minPasswordLength = 8;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^(63|0)?9[0-9]{9}$';

  /// Validates a required text field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates phone number format
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(phoneRegex).hasMatch(value)) {
      return 'Please enter a valid phone number (e.g., 09123456789)';
    }
    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates name fields (first name, last name)
  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  /// Validates date selection
  static String? validateDate(DateTime? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    if (value.isAfter(DateTime.now())) {
      return '$fieldName cannot be in the future';
    }
    return null;
  }

  /// Validates dropdown selection
  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates terms agreement
  static String? validateTermsAgreement(bool value, String fieldName) {
    if (!value) {
      return 'You must agree to $fieldName';
    }
    return null;
  }

  /// Gets validation state for a field
  static ValidationState getValidationState(String? error) {
    if (error == null) {
      return ValidationState.valid;
    } else if (error.isEmpty) {
      return ValidationState.valid;
    } else {
      return ValidationState.invalid;
    }
  }

  /// Checks if all required fields are filled for a step
  static Map<String, String> validateStep(int step, Map<String, dynamic> data) {
    Map<String, String> errors = {};

    switch (step) {
      case 1:
        // Student ID generation step - no validation needed
        break;
      case 2:
        // Personal information
        errors['firstName'] =
            validateName(data['firstName'], 'First name') ?? '';
        errors['lastName'] = validateName(data['lastName'], 'Last name') ?? '';
        errors['course'] = validateDropdown(data['course'], 'Program') ?? '';
        errors['yearLevel'] =
            validateDropdown(data['yearLevel'], 'Year level') ?? '';
        errors['birthday'] = validateDate(data['birthday'], 'Birthday') ?? '';
        errors['civilStatus'] =
            validateDropdown(data['civilStatus'], 'Civil status') ?? '';
        break;
      case 3:
        // Contact information
        errors['personalEmail'] = validateEmail(data['personalEmail']) ?? '';
        errors['contactNumber'] = validatePhone(data['contactNumber']) ?? '';
        break;
      case 4:
        // OTP verification
        errors['emailOtp'] =
            validateRequired(data['emailOtp'], 'Email OTP') ?? '';
        errors['phoneOtp'] =
            validateRequired(data['phoneOtp'], 'Phone OTP') ?? '';
        break;
      case 5:
        // Account creation
        errors['password'] = validatePassword(data['password']) ?? '';
        errors['passwordConfirmation'] = validatePasswordConfirmation(
                data['passwordConfirmation'], data['password']) ??
            '';
        errors['agreeToTerms'] =
            validateTermsAgreement(data['agreeToTerms'], 'Terms of Service') ??
                '';
        errors['agreeToPrivacy'] =
            validateTermsAgreement(data['agreeToPrivacy'], 'Privacy Policy') ??
                '';
        break;
    }

    // Remove empty error messages
    errors.removeWhere((key, value) => value.isEmpty);
    return errors;
  }

  /// Gets list of missing required fields for a step
  static List<String> getMissingFields(int step, Map<String, dynamic> data) {
    Map<String, String> errors = validateStep(step, data);
    return errors.keys.toList();
  }

  /// Checks if step is valid
  static bool isStepValid(int step, Map<String, dynamic> data) {
    return validateStep(step, data).isEmpty;
  }
}

enum ValidationState {
  valid,
  invalid,
  empty,
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final ValidationState state;

  ValidationResult({
    required this.isValid,
    this.errorMessage,
    required this.state,
  });

  factory ValidationResult.valid() {
    return ValidationResult(
      isValid: true,
      state: ValidationState.valid,
    );
  }

  factory ValidationResult.invalid(String errorMessage) {
    return ValidationResult(
      isValid: false,
      errorMessage: errorMessage,
      state: ValidationState.invalid,
    );
  }

  factory ValidationResult.empty() {
    return ValidationResult(
      isValid: false,
      state: ValidationState.empty,
    );
  }
}
