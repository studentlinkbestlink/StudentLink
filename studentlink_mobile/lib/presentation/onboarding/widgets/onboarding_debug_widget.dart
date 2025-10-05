import 'package:flutter/material.dart';
import '../../../services/onboarding_service.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

/// Debug widget for testing onboarding flow
/// This widget can be temporarily added to any screen for testing purposes
class OnboardingDebugWidget extends StatelessWidget {
  const OnboardingDebugWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 16),
      margin: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(color: const Color(0xFF300300300)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Onboarding Debug',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          ResponsiveSpacing(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _resetOnboarding(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset Onboarding'),
              ),
              ElevatedButton(
                onPressed: () => _checkOnboardingStatus(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Check Status'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetOnboarding(BuildContext context) {
    OnboardingService.resetOnboarding();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Onboarding reset! Restart the app to see onboarding again.'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  void _checkOnboardingStatus(BuildContext context) async {
    final isCompleted = await OnboardingService.isOnboardingCompleted();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCompleted 
            ? 'Onboarding is completed' 
            : 'Onboarding is not completed',
        ),
        backgroundColor: isCompleted ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}
