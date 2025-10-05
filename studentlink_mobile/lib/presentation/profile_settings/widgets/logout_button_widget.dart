import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/custom_icon_widget.dart';

class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButtonWidget({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: ResponsiveDesign.getPadding(all: 4.w),
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE22824).withValues(alpha: 0.1),
          foregroundColor: const Color(0xFFE22824),
          elevation: 0,
          padding: ResponsiveDesign.getPadding(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            side: BorderSide(
              color: const Color(0xFFE22824).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'logout',
              color: const Color(0xFFE22824),
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE22824),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'logout',
                color: const Color(0xFFE22824),
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Logout',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE22824),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout? You will need to login again to access your account.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE22824),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                ),
              ),
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
