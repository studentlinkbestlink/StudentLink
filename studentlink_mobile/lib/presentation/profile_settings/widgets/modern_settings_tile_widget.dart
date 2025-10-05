import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernSettingsTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Widget? trailing;

  const ModernSettingsTileWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        child: Container(
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleSmall?.color,
                      ),
                    ),
                    if (subtitle != null) ...[
                      ResponsiveSpacing(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Trailing widget or default arrow
              trailing ?? Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).textTheme.bodySmall?.color,
                size: ResponsiveDesign.getIconSize(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
