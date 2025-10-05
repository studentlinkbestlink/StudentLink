import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/onboarding_service.dart';
import '../../services/biometric_auth_service.dart';
import '../../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600), // Reduced for faster startup
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start initialization immediately and animation in parallel
    _initializeApp();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Run initialization operations in parallel for faster startup
    final isOnboardingCompleted = await _checkOnboardingStatus();
    await _initializeServices();
    
    // Wait for animation to complete (minimum 600ms)
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (mounted) {
      if (!isOnboardingCompleted) {
        Navigator.pushReplacementNamed(context, "/onboarding");
      } else {
        await _navigateToNextScreen();
      }
    }
  }

  Future<bool> _checkOnboardingStatus() async {
    return await OnboardingService.isOnboardingCompleted();
  }

  Future<void> _initializeServices() async {
    // Initialize services in parallel
    await Future.wait([
      apiService.initialize(),
      // Add other service initializations here
    ]);
  }

  Future<void> _navigateToNextScreen() async {
    try {
      // Quick check for auth token first (fastest operation)
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');
      
      if (authToken == null || authToken.isEmpty) {
        debugPrint('❌ No auth token found, redirecting to login');
        Navigator.pushReplacementNamed(context, '/login-screen');
        return;
      }
      
      // Run biometric checks in parallel for faster processing
      final biometricService = BiometricAuthService();
      final biometricChecks = await Future.wait([
        biometricService.shouldUseDeviceBiometricAuth(),
        biometricService.shouldUseTypingDnaAuth(),
      ]);
      
      final shouldUseDeviceBiometric = biometricChecks[0];
      final shouldUseTypingDna = biometricChecks[1];
      
      if (shouldUseDeviceBiometric) {
        debugPrint('🔐 Redirecting to biometric authentication');
        Navigator.pushReplacementNamed(context, "/biometric-auth");
        return;
      }
      
      if (shouldUseTypingDna) {
        debugPrint('⌨️ Redirecting to TypingDNA authentication');
        Navigator.pushReplacementNamed(context, "/typingdna-auth");
        return;
      }
      
      // Quick token validation (with timeout to prevent hanging)
      try {
        await apiService.getCurrentUser().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            throw Exception('Token validation timeout');
          },
        );
        debugPrint('✅ Token is valid, redirecting to dashboard');
        Navigator.pushReplacementNamed(context, '/dashboard-home');
      } catch (e) {
        debugPrint('❌ Token validation failed: $e');
        
        // Check if biometric authentication is available as fallback
        if (shouldUseDeviceBiometric || shouldUseTypingDna) {
          debugPrint('🔄 Token invalid but biometric available, redirecting to biometric auth');
          if (shouldUseDeviceBiometric) {
            Navigator.pushReplacementNamed(context, "/biometric-auth");
          } else {
            Navigator.pushReplacementNamed(context, "/typingdna-auth");
          }
          return;
        }
        
        // No biometric available, logout and go to login
        await apiService.logout();
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    } catch (e) {
      debugPrint('💥 Error in navigation logic: $e');
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/images/img_app_logo.png',
              width: 25.w,
              height: 25.w,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Enhanced fallback design
                return Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary, // Primary blue
                        Theme.of(context).colorScheme.secondary, // Secondary blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'SL',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 8.w,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
