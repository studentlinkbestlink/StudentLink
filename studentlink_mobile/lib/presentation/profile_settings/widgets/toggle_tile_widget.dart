import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ToggleTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  const ToggleTileWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.value,
    required this.onChanged,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.lightTheme.primaryColor)
              .withAlpha(26),
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
          color: Colors.black,
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor:
            AppTheme.lightTheme.primaryColor.withAlpha(77),
        inactiveThumbColor: Theme.of(context).textTheme.bodySmall?.color ?? Color(0xFF757575),
        inactiveTrackColor: Theme.of(context).textTheme.bodySmall?.color ?? Color(0xFF300300300),
      ),
    );
  }
}
