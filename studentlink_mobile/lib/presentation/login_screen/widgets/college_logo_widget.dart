import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/responsive_design.dart';

class CollegeLogoWidget extends StatelessWidget {
  const CollegeLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(bottom: 4.h),
      child: Column(
        children: [
          Container(
            width: ResponsiveDesign.getIconSize(80),
            height: ResponsiveDesign.getIconSize(80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: AppTheme.secondaryLight.withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
              child: Image.asset(
                'assets/images/img_app_logo.png',
                width: ResponsiveDesign.getIconSize(80),
                height: ResponsiveDesign.getIconSize(80),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Enhanced fallback with gradient text
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryLight,
                          AppTheme.secondaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
                    ),
                    child: Center(
                      child: Text(
                        'SL',
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveDesign.getFontSize(24),
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'STUDENTLINK',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(18).sp,
              fontWeight: FontWeight.w800,
              color: AppTheme.lightTheme.primaryColor,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
