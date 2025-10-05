import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

/// Enhanced progress indicator widget with step visualization
class EnhancedProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double completionPercentage;
  final VoidCallback? onStepTap;
  final bool showStepLabels;
  final bool showPercentage;

  const EnhancedProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.completionPercentage,
    this.onStepTap,
    this.showStepLabels = true,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress bar and percentage
          Row(
            children: [
              Expanded(
                child: _buildProgressBar(),
              ),
              if (showPercentage) ...[
                ResponsiveSpacing(height: 0, width: 12),
                _buildPercentageIndicator(context),
              ],
            ],
          ),
          
          if (showStepLabels) ...[
            ResponsiveSpacing(height: 16),
            _buildStepLabels(context),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Builder(
      builder: (context) => Container(
        height: 6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(3)),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: completionPercentage,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(3)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPercentageIndicator(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
      ),
      child: Text(
        '${(completionPercentage * 100).round()}%',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStepLabels(BuildContext context) {
    final stepLabels = [
      'Subject',
      'Department',
      'Type',
      'Priority',
      'Options',
      'Description',
    ];

    return Stack(
      children: [
        // Connector lines
        Positioned(
          top: 16,
          left: 16,
          right: 16,
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
          children: stepLabels.take(totalSteps).map((label) {
            final stepIndex = stepLabels.indexOf(label);
            final stepNumber = stepIndex + 1;
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
                                color: isCurrent ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: ResponsiveDesign.getFontSize(14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 8),
                  
                  // Step title
                  _buildStepTitle(label, context, isActive: isCompleted || isCurrent),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepTitle(String title, BuildContext context, {required bool isActive}) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: ResponsiveDesign.getFontSize(12),
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).textTheme.bodySmall?.color,
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

/// Compact progress indicator for smaller spaces
class CompactProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double completionPercentage;

  const CompactProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.completionPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Progress bar
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: completionPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
                  ),
                ),
              ),
            ),
          ),
          
          ResponsiveSpacing(height: 0, width: 8),
          
          // Step counter
          Text(
            'Step $currentStep of $totalSteps',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
