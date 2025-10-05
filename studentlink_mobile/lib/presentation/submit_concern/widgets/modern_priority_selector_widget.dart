import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernPrioritySelectorWidget extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onChanged;

  const ModernPrioritySelectorWidget({
    Key? key,
    required this.selectedPriority,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priorities = [
      {'label': 'Low', 'value': 'low', 'color': Theme.of(context).colorScheme.tertiary},
      {'label': 'Medium', 'value': 'medium', 'color': const Color(0xFFFFC107)},
      {'label': 'High', 'value': 'high', 'color': Theme.of(context).colorScheme.error},
      {'label': 'Urgent', 'value': 'urgent', 'color': Theme.of(context).colorScheme.error},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.priority_high_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Priority Level',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
              ),
            ),
          ],
        ),
        ResponsiveSpacing(height: 12),
        // Create a 2x2 grid for 4 priority options
        Column(
          children: [
            // First row: Low and Medium
            Row(
              children: priorities.take(2).map((priority) {
                final isSelected = selectedPriority == priority['value'];
                final color = priority['color'] as Color;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onChanged(priority['value'] as String);
                    },
                    child: Container(
                      margin: ResponsiveDesign.getPadding(right: 8, bottom: 8),
                      padding: ResponsiveDesign.getPadding(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? color 
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                        border: Border.all(
                          color: isSelected 
                              ? color 
                              : const Color(0xFFE5E7EB),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getPriorityIcon(priority['value'] as String),
                            color: isSelected ? Colors.white : color,
                            size: ResponsiveDesign.getIconSize(20),
                          ),
                          ResponsiveSpacing(height: 4),
                          Text(
                            priority['label'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: isSelected ? Colors.white : color,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            // Second row: High and Urgent
            Row(
              children: priorities.skip(2).map((priority) {
                final isSelected = selectedPriority == priority['value'];
                final color = priority['color'] as Color;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onChanged(priority['value'] as String);
                    },
                    child: Container(
                      margin: ResponsiveDesign.getPadding(right: 8),
                      padding: ResponsiveDesign.getPadding(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? color 
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                        border: Border.all(
                          color: isSelected 
                              ? color 
                              : const Color(0xFFE5E7EB),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getPriorityIcon(priority['value'] as String),
                            color: isSelected ? Colors.white : color,
                            size: ResponsiveDesign.getIconSize(20),
                          ),
                          ResponsiveSpacing(height: 4),
                          Text(
                            priority['label'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: isSelected ? Colors.white : color,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        ResponsiveSpacing(height: 8),
        Text(
          'Select the urgency level of your concern',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Icons.keyboard_arrow_down_rounded;
      case 'medium':
        return Icons.remove_rounded;
      case 'high':
        return Icons.priority_high_rounded;
      case 'urgent':
        return Icons.warning_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
