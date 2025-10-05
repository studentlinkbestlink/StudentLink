import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

class BiometricAuthService {
  static final BiometricAuthService _instance = BiometricAuthService._internal();
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  // TypingDNA API configuration (Free tier - unlimited for development)
  static const String _typingDnaApiKey = '7e35d16962e1588a19431644920508d9';
  static const String _typingDnaApiSecret = 'a767a4849dd126f60d66c7dbf4bcab2b';
  static const String _typingDnaBaseUrl = 'https://api.typingdna.com';
  
  // TypingDNA endpoints
  static const String _typingDnaSaveEndpoint = '/save';
  static const String _typingDnaVerifyEndpoint = '/verify';
  static const String _typingDnaCheckEndpoint = '/check';
  
  // Storage keys
  static const String _typingDnaUserIdKey = 'typingdna_user_id';
  static const String _typingDnaEnabledKey = 'typingdna_enabled';
  static const String _deviceBiometricEnabledKey = 'device_biometric_enabled';
  
  // Local Auth instance
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available
  Future<BiometricAvailability> checkBiometricAvailability() async {
    try {
      debugPrint('🔍 Checking biometric availability...');
      
      // Check device biometric availability first (like GCash/PayMaya)
      final isDeviceAvailable = await _localAuth.canCheckBiometrics;
      debugPrint('🔍 Device can check biometrics: $isDeviceAvailable');
      
      if (isDeviceAvailable) {
        final availableBiometrics = await _localAuth.getAvailableBiometrics();
        debugPrint('🔍 Available biometrics: $availableBiometrics');
        
        if (availableBiometrics.isNotEmpty) {
          debugPrint('✅ Device biometric available');
          return BiometricAvailability.deviceBiometric;
        } else {
          debugPrint('⚠️ Device biometric not available - no biometric types found');
        }
      } else {
        debugPrint('⚠️ Device cannot check biometrics');
      }
      
      // Check if device has biometric hardware but no enrolled biometrics
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      debugPrint('🔍 Device supported: $isDeviceSupported');
      
      if (isDeviceSupported) {
        debugPrint('⚠️ Device supports biometrics but none are enrolled');
        return BiometricAvailability.notEnrolled;
      }
      
      // Fallback to TypingDNA if device biometrics not available
      debugPrint('⌨️ Falling back to TypingDNA');
      return BiometricAvailability.typingPattern;
    } catch (e) {
      debugPrint('❌ Error checking biometric availability: $e');
      return BiometricAvailability.notAvailable;
    }
  }

  /// Check if TypingDNA is enabled for the user
  Future<bool> isTypingDnaEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_typingDnaEnabledKey) ?? false;
    } catch (e) {
      debugPrint('Error checking TypingDNA enabled status: $e');
      return false;
    }
  }

  /// Enable TypingDNA authentication for the user
  Future<bool> enableTypingDnaAuth(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_typingDnaEnabledKey, true);
      await prefs.setString(_typingDnaUserIdKey, userId);
      return true;
    } catch (e) {
      debugPrint('Error enabling TypingDNA auth: $e');
      return false;
    }
  }

  /// Disable TypingDNA authentication
  Future<void> disableTypingDnaAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_typingDnaEnabledKey, false);
      await prefs.remove(_typingDnaUserIdKey);
    } catch (e) {
      debugPrint('Error disabling TypingDNA auth: $e');
    }
  }

  /// Save typing pattern to TypingDNA
  Future<TypingDnaResult> saveTypingPattern(String userId, String text, String typingPattern) async {
    try {
      final response = await http.post(
        Uri.parse('$_typingDnaBaseUrl$_typingDnaSaveEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _getTypingDnaAuthHeader(),
        },
        body: json.encode({
          'tp': typingPattern,
          'text': text,
        }),
      );

      if (response.statusCode == 200) {
        return TypingDnaResult.success;
      } else {
        debugPrint('TypingDNA save failed: ${response.statusCode} - ${response.body}');
        return TypingDnaResult.error;
      }
    } catch (e) {
      debugPrint('Error saving typing pattern: $e');
      return TypingDnaResult.error;
    }
  }

  /// Verify typing pattern with TypingDNA
  Future<TypingDnaResult> verifyTypingPattern(String userId, String text, String typingPattern) async {
    try {
      final response = await http.post(
        Uri.parse('$_typingDnaBaseUrl$_typingDnaVerifyEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _getTypingDnaAuthHeader(),
        },
        body: json.encode({
          'tp': typingPattern,
          'text': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'] ?? 0;
        return result == 1 ? TypingDnaResult.success : TypingDnaResult.failed;
      } else {
        debugPrint('TypingDNA verify failed: ${response.statusCode} - ${response.body}');
        return TypingDnaResult.error;
      }
    } catch (e) {
      debugPrint('Error verifying typing pattern: $e');
      return TypingDnaResult.error;
    }
  }

  /// Check if user has enough typing patterns saved
  Future<bool> checkTypingPatternCount(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_typingDnaBaseUrl$_typingDnaCheckEndpoint'),
        headers: {
          'Authorization': _getTypingDnaAuthHeader(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final count = data['count'] ?? 0;
        return count >= 2; // Need at least 2 patterns for reliable authentication
      } else {
        debugPrint('TypingDNA check failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error checking typing pattern count: $e');
      return false;
    }
  }

  /// Get TypingDNA authentication header
  String _getTypingDnaAuthHeader() {
    final credentials = base64Encode(utf8.encode('$_typingDnaApiKey:$_typingDnaApiSecret'));
    return 'Basic $credentials';
  }

  /// Authenticate with TypingDNA typing patterns
  Future<TypingDnaResult> authenticateWithTypingDna(String userId, String text, String typingPattern) async {
    try {
      // Check if TypingDNA is enabled
      final isEnabled = await isTypingDnaEnabled();
      if (!isEnabled) {
        return TypingDnaResult.notEnabled;
      }

      // Check if user has enough patterns saved
      final hasEnoughPatterns = await checkTypingPatternCount(userId);
      if (!hasEnoughPatterns) {
        // Save this pattern and return success (first time setup)
        final saveResult = await saveTypingPattern(userId, text, typingPattern);
        return saveResult == TypingDnaResult.success ? TypingDnaResult.setupComplete : TypingDnaResult.error;
      }

      // Verify the typing pattern
      return await verifyTypingPattern(userId, text, typingPattern);
    } catch (e) {
      debugPrint('Error in TypingDNA authentication: $e');
      return TypingDnaResult.error;
    }
  }

  /// Get user ID for TypingDNA
  Future<String?> getTypingDnaUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_typingDnaUserIdKey);
    } catch (e) {
      debugPrint('Error getting TypingDNA user ID: $e');
      return null;
    }
  }

  /// Check if device biometric authentication is enabled
  Future<bool> isDeviceBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_deviceBiometricEnabledKey) ?? false;
    } catch (e) {
      debugPrint('Error checking device biometric enabled status: $e');
      return false;
    }
  }

  /// Enable device biometric authentication
  Future<bool> enableDeviceBiometricAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_deviceBiometricEnabledKey, true);
      return true;
    } catch (e) {
      debugPrint('Error enabling device biometric auth: $e');
      return false;
    }
  }

  /// Disable device biometric authentication
  Future<void> disableDeviceBiometricAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_deviceBiometricEnabledKey, false);
    } catch (e) {
      debugPrint('Error disabling device biometric auth: $e');
    }
  }

  /// Authenticate with device biometrics (like GCash/PayMaya)
  Future<BiometricAuthResult> authenticateWithDeviceBiometric() async {
    try {
      debugPrint('🔐 Starting device biometric authentication...');
      
      // Check if biometrics are available
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        debugPrint('❌ Biometrics not available on device');
        return BiometricAuthResult.notAvailable;
      }

      // Check if user has enrolled biometrics
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        debugPrint('❌ No biometrics enrolled on device');
        return BiometricAuthResult.notEnrolled;
      }

      // Check if biometric auth is enabled in app settings
      final isEnabled = await isDeviceBiometricEnabled();
      if (!isEnabled) {
        debugPrint('❌ Device biometric not enabled in app settings');
        return BiometricAuthResult.notEnabled;
      }

      debugPrint('🔐 Attempting biometric authentication...');
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Use your biometric to access StudentLink',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );

      if (authenticated) {
        debugPrint('✅ Biometric authentication successful');
        return BiometricAuthResult.success;
      } else {
        debugPrint('❌ Biometric authentication failed');
        return BiometricAuthResult.failed;
      }
    } catch (e) {
      debugPrint('❌ Error during device biometric authentication: $e');
      
      // Handle specific error types
      if (e.toString().contains('NotAvailable')) {
        return BiometricAuthResult.notAvailable;
      } else if (e.toString().contains('NotEnrolled')) {
        return BiometricAuthResult.notEnrolled;
      } else if (e.toString().contains('UserCancel')) {
        return BiometricAuthResult.userCancel;
      } else if (e.toString().contains('SystemCancel')) {
        return BiometricAuthResult.systemCancel;
      }
      
      return BiometricAuthResult.error;
    }
  }

  /// Get device biometric type string
  Future<String> getDeviceBiometricTypeString() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return 'Fingerprint';
      } else if (availableBiometrics.contains(BiometricType.face)) {
        return 'Face ID';
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        return 'Iris';
      } else {
        return 'Biometric';
      }
    } catch (e) {
      debugPrint('Error getting biometric type: $e');
      return 'Biometric';
    }
  }

  /// Get device biometric icon
  Future<String> getDeviceBiometricIcon() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return 'fingerprint';
      } else if (availableBiometrics.contains(BiometricType.face)) {
        return 'face';
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        return 'visibility';
      } else {
        return 'security';
      }
    } catch (e) {
      debugPrint('Error getting biometric icon: $e');
      return 'security';
    }
  }

  /// Check if should use device biometric authentication
  Future<bool> shouldUseDeviceBiometricAuth() async {
    try {
      // Check if user is logged in
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');
      
      if (authToken == null || authToken.isEmpty) {
        debugPrint('No auth token found for device biometric check');
        return false; // User is not logged in
      }

      // Check if device biometric is available and enabled
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        debugPrint('Device biometric not available');
        return false;
      }

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        debugPrint('No biometric types available on device');
        return false;
      }

      final isEnabled = await isDeviceBiometricEnabled();
      debugPrint('Device biometric enabled: $isEnabled');
      
      if (!isEnabled) {
        debugPrint('Device biometric not enabled by user');
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('Error in shouldUseDeviceBiometricAuth logic: $e');
      return false;
    }
  }

  /// Check if should use TypingDNA authentication
  Future<bool> shouldUseTypingDnaAuth() async {
    try {
      // Check if user is logged in
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');
      
      if (authToken == null || authToken.isEmpty) {
        debugPrint('No auth token found for TypingDNA check');
        return false; // User is not logged in
      }

      // Check if TypingDNA is enabled
      final isEnabled = await isTypingDnaEnabled();
      if (!isEnabled) {
        debugPrint('TypingDNA not enabled');
        return false;
      }

      // Check if user has enough patterns
      final userId = await getTypingDnaUserId();
      if (userId == null) {
        debugPrint('No TypingDNA user ID found');
        return false;
      }

      final hasEnoughPatterns = await checkTypingPatternCount(userId);
      debugPrint('TypingDNA has enough patterns: $hasEnoughPatterns');
      return hasEnoughPatterns;
    } catch (e) {
      debugPrint('Error checking TypingDNA auth status: $e');
      return false;
    }
  }

  /// Check if should prompt for biometric authentication
  Future<bool> shouldPromptForBiometric() async {
    try {
      // Check device biometric first (preferred like GCash/PayMaya)
      final shouldUseDevice = await shouldUseDeviceBiometricAuth();
      if (shouldUseDevice) {
        return true;
      }

      // Fallback to TypingDNA
      final shouldUseTypingDna = await shouldUseTypingDnaAuth();
      return shouldUseTypingDna;
    } catch (e) {
      debugPrint('Error in shouldPromptForBiometric logic: $e');
      return false;
    }
  }

  /// Legacy method for compatibility - redirects to TypingDNA
  Future<bool> isBiometricEnabled() async {
    return await isTypingDnaEnabled();
  }

  /// Legacy method for compatibility - redirects to TypingDNA
  Future<bool> enableBiometricAuth() async {
    // This method is kept for compatibility but should not be used
    // Use enableTypingDnaAuth(userId) instead
    debugPrint('Warning: enableBiometricAuth() is deprecated. Use enableTypingDnaAuth(userId) instead.');
    return false;
  }

  /// Legacy method for compatibility - redirects to TypingDNA
  Future<void> disableBiometricAuth() async {
    await disableTypingDnaAuth();
  }
}

enum BiometricAvailability {
  notAvailable,
  deviceBiometric,
  typingPattern,
  notEnrolled,
}

enum BiometricAuthResult {
  success,
  failed,
  notAvailable,
  notEnrolled,
  userCancel,
  systemCancel,
  deviceNotSupported,
  notEnabled,
  error,
}

enum TypingDnaResult {
  success,
  failed,
  notEnabled,
  setupComplete,
  error,
}

// Legacy methods for compatibility with existing UI code
extension BiometricAuthServiceLegacy on BiometricAuthService {
  /// Get biometric type string (prioritizes device biometric)
  Future<String> getBiometricTypeString() async {
    final deviceEnabled = await isDeviceBiometricEnabled();
    if (deviceEnabled) {
      return await getDeviceBiometricTypeString();
    }
    return 'Typing Pattern';
  }

  /// Get biometric icon (prioritizes device biometric)
  Future<String> getBiometricIcon() async {
    final deviceEnabled = await isDeviceBiometricEnabled();
    if (deviceEnabled) {
      return await getDeviceBiometricIcon();
    }
    return 'keyboard';
  }

  /// Check if biometric is enabled (checks both device and TypingDNA)
  Future<bool> isBiometricEnabled() async {
    final deviceEnabled = await isDeviceBiometricEnabled();
    final typingDnaEnabled = await isTypingDnaEnabled();
    return deviceEnabled || typingDnaEnabled;
  }

  /// Enable biometric authentication (prioritizes device biometric)
  Future<bool> enableBiometricAuth() async {
    // Try device biometric first (preferred like GCash/PayMaya)
    final deviceEnabled = await enableDeviceBiometricAuth();
    if (deviceEnabled) {
      return true;
    }

    // Fallback to TypingDNA
    final userId = await getTypingDnaUserId();
    if (userId != null) {
      return await enableTypingDnaAuth(userId);
    }
    return false;
  }

  /// Disable biometric authentication (disables both)
  Future<void> disableBiometricAuth() async {
    await disableDeviceBiometricAuth();
    await disableTypingDnaAuth();
  }

  /// Authenticate with biometric (prioritizes device biometric)
  Future<BiometricAuthResult> authenticateWithBiometric() async {
    try {
      // Try device biometric first (like GCash/PayMaya)
      final deviceEnabled = await isDeviceBiometricEnabled();
      if (deviceEnabled) {
        return await authenticateWithDeviceBiometric();
      }

      // Fallback to TypingDNA
      final userId = await getTypingDnaUserId();
      if (userId != null) {
        // For TypingDNA, we need to implement the typing pattern collection
        // For now, return success as a placeholder
        return BiometricAuthResult.success;
      }

      return BiometricAuthResult.notEnabled;
    } catch (e) {
      debugPrint('Error in biometric authentication: $e');
      return BiometricAuthResult.error;
    }
  }
}
