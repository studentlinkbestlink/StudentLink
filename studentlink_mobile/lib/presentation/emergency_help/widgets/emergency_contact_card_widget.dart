import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import './service_status_widget.dart';
import '../../../utils/responsive_design.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmergencyContactCardWidget extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onCallTap;
  final VoidCallback onLocationTap;

  const EmergencyContactCardWidget({
    Key? key,
    required this.service,
    required this.onCallTap,
    required this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color serviceColor =
        service['color'] as Color? ?? const Color(0xFF1E2A78);

    return Card(
      margin: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          gradient: LinearGradient(
            colors: [
              serviceColor.withValues(alpha: 0.05),
              serviceColor.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              decoration: BoxDecoration(
                color: serviceColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 3.w),
                    decoration: BoxDecoration(
                      color: serviceColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                    child: Icon(
                      Icons.help,
                      color: serviceColor,
                      size: ResponsiveDesign.getIconSize(32),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['name'] ?? 'Service',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: serviceColor,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        ServiceStatusWidget(
                          status: service['status'] ?? 'Unknown',
                          nextAvailable: service['nextAvailable'],
                        ),
                      ],
                    ),
                  ),
                  // Emergency Call Button
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE22824),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE22824).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          onCallTap();
                        },
                        child: Container(
                          padding: ResponsiveDesign.getPadding(all: 3.w),
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: ResponsiveDesign.getIconSize(24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    service['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Contact Info Grid
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 3.w),
                    decoration: BoxDecoration(
                      color: serviceColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                      border: Border.all(
                        color: serviceColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Phone',
                          'call',
                          service['contact'] ?? '',
                          serviceColor,
                          context,
                          () => _copyToClipboard(
                              context, service['contact'] ?? ''),
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          'Hours',
                          'schedule',
                          service['hours'] ?? '',
                          serviceColor,
                          context,
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          'Location',
                          'location_on',
                          '${service['location'] ?? ''}\n${service['room'] ?? ''}',
                          serviceColor,
                          context,
                          onLocationTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String iconName,
    String value,
    Color color,
    BuildContext context, [
    VoidCallback? onTap,
  ]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: ResponsiveDesign.getPadding(vertical: 1.h),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: color,
              size: ResponsiveDesign.getIconSize(20),
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            if (onTap != null) ...[
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'touch_app',
                color: color.withValues(alpha: 0.6),
                size: ResponsiveDesign.getIconSize(16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: ResponsiveDesign.getPadding(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Phone number copied to clipboard'),
        backgroundColor: const Color(0xFF28A745),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
