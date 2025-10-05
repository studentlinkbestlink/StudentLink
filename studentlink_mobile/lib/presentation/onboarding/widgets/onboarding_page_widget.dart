import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../onboarding_screen.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class OnboardingPageWidget extends StatefulWidget {
  final OnboardingPageData data;
  final bool isActive;

  const OnboardingPageWidget({
    Key? key,
    required this.data,
    required this.isActive,
  }) : super(key: key);

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with TickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late AnimationController _textAnimationController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _iconScaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.elasticOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isActive) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(OnboardingPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _iconAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _textAnimationController.forward();
    });
  }

  void _stopAnimations() {
    _iconAnimationController.reset();
    _textAnimationController.reset();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          // Vector illustration area with optimized spacing
          Expanded(
            flex: 3,
            child: _buildIllustrationSection(),
          ),
          
          // Content section with better proportions
          Expanded(
            flex: 2,
            child: _buildContentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Minimal background decoration - just a subtle circle
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  widget.data.primaryColor.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
              shape: BoxShape.circle,
            ),
          ),
          
          // Main illustration container - now displays the actual image
          ScaleTransition(
            scale: _iconScaleAnimation,
            child: Container(
              width: 60.w,
              height: 60.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Display the actual onboarding image
                  if (widget.data.illustrationPath != null)
                    _buildVectorIllustration()
                  else
                    _buildIconIllustration(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVectorIllustration() {
    // Clean onboarding image without background - showing transparent PNG properly
    return Container(
      width: 50.w,
      height: 50.w,
      child: Image.asset(
        widget.data.illustrationPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Simple fallback without background
          return Container(
            width: 50.w,
            height: 50.w,
            child: Icon(
              widget.data.icon,
              size: 20.w,
              color: widget.data.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconIllustration() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
      ),
      child: Icon(
        widget.data.icon,
        size: 20.w,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildContentSection() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textFadeAnimation,
        child: Container(
          width: double.infinity,
          padding: ResponsiveDesign.getPadding(horizontal: 2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title with better typography
              Text(
                widget.data.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              
              ResponsiveSpacing(height: 12),
              
              // Subtitle with modern styling
              Container(
                padding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: widget.data.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                  border: Border.all(
                    color: widget.data.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.data.subtitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.data.primaryColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              ResponsiveSpacing(height: 16),
              
              // Description with improved readability
              Text(
                widget.data.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              ResponsiveSpacing(height: 20),
              
              // Feature highlights with modern design
              _buildFeatureHighlights(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    final features = _getFeatureHighlights();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: features.map((feature) {
        return Container(
          margin: ResponsiveDesign.getPadding(horizontal: 1.w),
          padding: ResponsiveDesign.getPadding(horizontal: 3.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            border: Border.all(
              color: widget.data.primaryColor.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: Theme.of(context).brightness == Brightness.light ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 3.5.w,
                color: widget.data.primaryColor,
              ),
              SizedBox(width: 1.5.w),
              Text(
                feature,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<String> _getFeatureHighlights() {
    switch (widget.data.title) {
      case "Welcome to StudentLink":
        return ["Academic Support", "Real-time Updates"];
      case "Submit Concerns":
        return ["Track Progress", "Quick Response"];
      case "AI Assistant":
        return ["24/7 Available", "Smart Guidance"];
      case "Emergency Help":
        return ["One-tap Access", "Urgent Support"];
      case "Stay Connected":
        return ["Real-time Alerts", "Important Updates"];
      default:
        return ["Feature 1", "Feature 2"];
    }
  }
}
