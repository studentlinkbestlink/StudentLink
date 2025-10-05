import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const SettingsTileWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.iconName,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.lightTheme.primaryColor)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: iconColor ?? AppTheme.lightTheme.primaryColor,
            size: 5.w,
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black,
              ),
            )
          : null,
      trailing: trailing ??
          CustomIconWidget(
            iconName: 'chevron_right',
            color: Colors.black,
            size: 5.w,
          ),
    );
  }
}
