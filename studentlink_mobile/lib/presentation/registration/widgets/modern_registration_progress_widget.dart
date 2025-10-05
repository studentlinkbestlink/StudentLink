import 'package:flutter/material.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

/// Modern registration progress widget with sleek design
class ModernRegistrationProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ModernRegistrationProgressWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 20),
      child: Column(
        children: [
          // Progress text
          Text(
            'Step $currentStep of $totalSteps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          ResponsiveSpacing(height: 16),
          
          // Modern progress bar
          Stack(
            children: [
              // Connector lines
              Positioned(
                top: 16,
                left: 32,
                right: 32,
                child: Row(
                  children: List.generate(totalSteps - 1, (index) {
                    final stepNumber = index + 1;
                    final isCompleted = stepNumber < currentStep;
                    
                    return Expanded(
                      child: Container(
                        height: 2,
                        margin: ResponsiveDesign.getPadding(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(1)),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              // Step circles and titles
              Row(
                children: List.generate(totalSteps, (index) {
                  final stepNumber = index + 1;
                  final isCompleted = stepNumber < currentStep;
                  final isCurrent = stepNumber == currentStep;
                  
                  return Expanded(
                    child: Column(
                      children: [
                        // Step circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted || isCurrent
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            boxShadow: isCompleted || isCurrent ? [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ] : null,
                          ),
                          child: Center(
                            child: isCompleted
                                ? Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  )
                                : Text(
                                    stepNumber.toString(),
                                    style: TextStyle(
                                      color: isCurrent ? Colors.white : Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: ResponsiveDesign.getFontSize(14),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        
                        ResponsiveSpacing(height: 8),
                        
                        // Step title
                        _buildStepTitle(_getStepTitle(stepNumber), context, isActive: isCompleted || isCurrent),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int stepNumber) {
    switch (stepNumber) {
      case 1:
        return 'ID';
      case 2:
        return 'Personal';
      case 3:
        return 'Contact';
      case 4:
        return 'Verify';
      case 5:
        return 'Additional';
      case 6:
        return 'Account';
      default:
        return '';
    }
  }

  Widget _buildStepTitle(String title, BuildContext context, {required bool isActive}) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: ResponsiveDesign.getFontSize(12),
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
      ) ?? const TextStyle(),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
