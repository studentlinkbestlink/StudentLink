import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

class EmergencyHelpCard extends StatelessWidget {
  const EmergencyHelpCard({Key? key}) : super(key: key);

  void _handleEmergencyAction(BuildContext context, String service) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to $service...'),
        backgroundColor: const Color(0xFFE22824),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE22824),
              const Color(0xFFE22824).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        ),
        padding: ResponsiveDesign.getPadding(all: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: ResponsiveDesign.getIconSize(24),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Emergency Help',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildEmergencyButton(
                    context,
                    'Clinic',
                    'local_hospital',
                    () => _handleEmergencyAction(context, 'Clinic'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildEmergencyButton(
                    context,
                    'Security',
                    'security',
                    () => _handleEmergencyAction(context, 'Security'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildEmergencyButton(
                    context,
                    'Guidance',
                    'psychology',
                    () => _handleEmergencyAction(context, 'Guidance'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 8.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              color: Colors.white,
              size: ResponsiveDesign.getIconSize(20),
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
