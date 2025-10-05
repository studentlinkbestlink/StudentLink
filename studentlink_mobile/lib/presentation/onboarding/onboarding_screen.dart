import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../services/onboarding_service.dart';
import 'widgets/onboarding_page_widget.dart';
import 'widgets/onboarding_progress_indicator.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../providers/theme_provider.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  final int _totalPages = 5;

  // Modern onboarding content with new images
  List<OnboardingPageData> _getPages(BuildContext context) => [
        OnboardingPageData(
          title: "Welcome to StudentLink",
          subtitle: "Your Academic Support Hub",
          description:
              "Connect with your institution, get instant help, and stay updated with all your academic needs in one place.",
          icon: Icons.school_rounded,
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context).colorScheme.secondary,
          illustrationPath: "assets/images/first.png", // First onboarding image
        ),
        OnboardingPageData(
          title: "Submit Concerns",
          subtitle: "Get Help When You Need It",
          description:
              "Report academic issues, technical problems, or any concerns directly to your department with real-time tracking.",
          icon: Icons.support_agent_rounded,
          primaryColor: Theme.of(context).colorScheme.secondary,
          secondaryColor: Theme.of(context).colorScheme.primary,
          illustrationPath:
              "assets/images/second.png", // Second onboarding image
        ),
        OnboardingPageData(
          title: "AI Assistant",
          subtitle: "Instant Answers & Support",
          description:
              "Get immediate answers to your questions with our intelligent AI assistant available 24/7 for academic guidance.",
          icon: Icons.psychology_rounded,
          primaryColor: Theme.of(context).colorScheme.tertiary,
          secondaryColor: Theme.of(context).colorScheme.tertiary,
          illustrationPath: "assets/images/third.png", // Third onboarding image
        ),
        OnboardingPageData(
          title: "Emergency Help",
          subtitle: "Quick Access to Urgent Support",
          description:
              "One-tap access to emergency contacts and urgent support services. Your safety and well-being are our priority.",
          icon: Icons.emergency_rounded,
          primaryColor: Theme.of(context).colorScheme.error,
          secondaryColor: Theme.of(context).colorScheme.primary,
          illustrationPath:
              "assets/images/fourth.png", // Fourth onboarding image
        ),
        OnboardingPageData(
          title: "Stay Connected",
          subtitle: "Real-time Updates & Announcements",
          description:
              "Receive instant notifications about important announcements, concern updates, and institutional news.",
          icon: Icons.notifications_active_rounded,
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context).colorScheme.secondary,
          illustrationPath: "assets/images/fifth.png", // Fifth onboarding image
        ),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    HapticFeedback.lightImpact();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.selectionClick();
    _completeOnboarding();
  }

  void _completeOnboarding() {
    HapticFeedback.heavyImpact();
    _markOnboardingCompleted();
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _markOnboardingCompleted() {
    OnboardingService.markOnboardingCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Compact header
              _buildCompactHeader(),

              // Main content area with optimized spacing
              Expanded(
                child: Container(
                  margin: ResponsiveDesign.getMargin(horizontal: 5.w),
                  child: Column(
                    children: [
                      // Compact progress indicator
                      ResponsiveSpacing(height: 16),
                      OnboardingProgressIndicator(
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                      ),

                      ResponsiveSpacing(height: 24),

                      // Page content with better space utilization
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: _totalPages,
                          itemBuilder: (context, index) {
                            return OnboardingPageWidget(
                              data: _getPages(context)[index],
                              isActive: _currentPage == index,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Modern navigation section
              _buildModernNavigationSection(),

              // Bottom spacing
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 5.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App logo/brand - more compact
          Padding(
            padding:
                ResponsiveDesign.getPadding(horizontal: 3.w, vertical: 0.8.h),
            child: Text(
              'STUDENTLINK',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                color: Theme.of(context).textTheme.titleMedium?.color,
                letterSpacing: 1.2,
                fontSize: ResponsiveDesign.getFontSize(18),
              ),
            ),
          ),

          // Theme toggle and skip button
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeToggle(),
              SizedBox(width: 2.w),
              _buildCompactSkipButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              themeProvider.toggleTheme();
            },
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            child: Padding(
              padding:
                  ResponsiveDesign.getPadding(horizontal: 3.w, vertical: 1.h),
              child: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: Theme.of(context).textTheme.bodySmall?.color,
                size: 4.w,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactSkipButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _skipOnboarding,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        child: Padding(
          padding: ResponsiveDesign.getPadding(horizontal: 3.w, vertical: 1.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Skip',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(width: 1.w),
              Icon(
                Icons.arrow_forward_rounded,
                color: Theme.of(context).textTheme.bodySmall?.color,
                size: 3.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernNavigationSection() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 5.w, vertical: 1.h),
      child: Column(
        children: [
          // Modern navigation buttons with better proportions
          Row(
            children: [
              // Previous button - only show if not on first page
              if (_currentPage > 0) ...[
                Expanded(
                  child: _buildNavigationButton(
                    text: 'Previous',
                    icon: Icons.arrow_back_ios_rounded,
                    isPrimary: false,
                    onTap: _previousPage,
                  ),
                ),
                SizedBox(width: 3.w),
              ],

              // Next/Get Started button
              Expanded(
                flex: _currentPage > 0 ? 1 : 2,
                child: _buildNavigationButton(
                  text:
                      _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
                  icon: _currentPage == _totalPages - 1
                      ? Icons.check_rounded
                      : Icons.arrow_forward_ios_rounded,
                  isPrimary: true,
                  onTap: _nextPage,
                ),
              ),
            ],
          ),

          // Page counter - more subtle
          ResponsiveSpacing(height: 12),
          Text(
            '${_currentPage + 1} of $_totalPages',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 5.h,
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary
                ],
              )
            : null,
        color: isPrimary ? null : Theme.of(context).scaffoldBackgroundColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
        border: isPrimary
            ? null
            : Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2),
                width: 1.5,
              ),
        boxShadow: isPrimary && Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isPrimary) ...[
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveDesign.getFontSize(13),
                      ),
                ),
                SizedBox(width: 1.w),
                Icon(
                  icon,
                  size: 3.w,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ] else ...[
                Icon(
                  icon,
                  size: 3.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 1.w),
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveDesign.getFontSize(13),
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Enhanced onboarding page data class with vector illustration support
class OnboardingPageData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String? illustrationPath; // Support for vector illustrations

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.illustrationPath,
  });
}
