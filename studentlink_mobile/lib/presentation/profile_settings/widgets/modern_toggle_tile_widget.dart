import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernToggleTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  const ModernToggleTileWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(vertical: 16),
      child: Row(
        children: [
          // Icon
          Container(
            padding: ResponsiveDesign.getPadding(all: 8),
            decoration: BoxDecoration(
              color: (iconColor ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
          ),
          
          ResponsiveSpacing(height: 0, width: 16),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                  ),
                ),
                if (subtitle != null) ...[
                  ResponsiveSpacing(height: 2),
                  Text(
                    subtitle!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Toggle switch
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: (newValue) {
                HapticFeedback.lightImpact();
                onChanged(newValue);
              },
              activeColor: Theme.of(context).colorScheme.primary,
              activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              inactiveThumbColor: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
              inactiveTrackColor: const Color(0xFFE5E7EB),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
