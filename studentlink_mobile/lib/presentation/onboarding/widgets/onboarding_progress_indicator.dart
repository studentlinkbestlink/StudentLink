import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class OnboardingProgressIndicator extends StatefulWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingProgressIndicator({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  State<OnboardingProgressIndicator> createState() => _OnboardingProgressIndicatorState();
}

class _OnboardingProgressIndicatorState extends State<OnboardingProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOutCubic,
    ));
    _progressAnimationController.forward();
  }

  @override
  void didUpdateWidget(OnboardingProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      _progressAnimationController.reset();
      _progressAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          // Modern progress bar
          _buildProgressBar(),
          
          ResponsiveSpacing(height: 12),
          
          // Compact page indicators
          _buildPageIndicators(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (widget.currentPage + 1) / widget.totalPages * _progressAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalPages, (index) {
        final isActive = index == widget.currentPage;
        final isCompleted = index < widget.currentPage;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: ResponsiveDesign.getPadding(horizontal: 1.w),
          child: _buildPageIndicator(
            index: index,
            isActive: isActive,
            isCompleted: isCompleted,
          ),
        );
      }),
    );
  }

  Widget _buildPageIndicator({
    required int index,
    required bool isActive,
    required bool isCompleted,
  }) {
    if (isCompleted) {
      return Container(
        width: 4.5.w, // Reduced from 6.w to 4.5.w (25% smaller)
        height: 4.5.w, // Reduced from 6.w to 4.5.w (25% smaller)
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 3, // Reduced from 4 to 3
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 2.2.w, // Reduced from 3.w to 2.2.w
        ),
      );
    } else if (isActive) {
      return Container(
        width: 4.5.w, // Reduced from 6.w to 4.5.w (25% smaller)
        height: 4.5.w, // Reduced from 6.w to 4.5.w (25% smaller)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          ),
          shape: BoxShape.circle,
          boxShadow: Theme.of(context).brightness == Brightness.light ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: 4, // Reduced from 6 to 4
              offset: const Offset(0, 1), // Reduced from (0, 2) to (0, 1)
            ),
          ] : null,
        ),
        child: Center(
          child: Container(
            width: 1.2.w, // Reduced from 1.5.w to 1.2.w
            height: 1.2.w, // Reduced from 1.5.w to 1.2.w
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 3.5.w, // Reduced from 4.5.w to 3.5.w (22% smaller)
        height: 3.5.w, // Reduced from 4.5.w to 3.5.w (22% smaller)
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
      );
    }
  }
}
