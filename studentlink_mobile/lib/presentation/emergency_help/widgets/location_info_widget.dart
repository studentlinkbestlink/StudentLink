import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../theme/app_theme.dart';

class LocationInfoWidget extends StatelessWidget {
  final Map<String, dynamic> service;

  const LocationInfoWidget({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color serviceColor =
        service['color'] as Color? ?? Theme.of(context).colorScheme.primary;

    return Container(
      padding: ResponsiveDesign.getPadding(all: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.black
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
            ),
          ),

          SizedBox(height: 3.h),

          // Header
          Row(
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 2.w),
                decoration: BoxDecoration(
                  color: serviceColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Icon(
                  Icons.location_on,
                  color: serviceColor,
                  size: ResponsiveDesign.getIconSize(24),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: serviceColor,
                      ),
                    ),
                    Text(
                      service['name'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Location Details Card
          Container(
            width: double.infinity,
            padding: ResponsiveDesign.getPadding(all: 4.w),
            decoration: BoxDecoration(
              color: serviceColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(
                color: serviceColor.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Building', 'Main Building', Theme.of(context).colorScheme.primary, context),
                SizedBox(height: 2.h),
                _buildDetailRow('Building', 'Main Building', Theme.of(context).colorScheme.primary, context),
                SizedBox(height: 2.h),
                _buildDetailRow('Building', 'Main Building', Theme.of(context).colorScheme.primary, context),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Navigation Instructions
          Container(
            padding: ResponsiveDesign.getPadding(all: 3.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: Theme.of(context).colorScheme.primary,
                      size: ResponsiveDesign.getIconSize(20),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'How to get there',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  _getDirections(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                  label: Text('Close'),
                  style: OutlinedButton.styleFrom(
                    padding: ResponsiveDesign.getPadding(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // In a real app, this would open maps
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening campus map...'),
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.map,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                  label: Text('Open Map'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: serviceColor,
                    foregroundColor: Colors.white,
                    padding: ResponsiveDesign.getPadding(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildDetailRow(label, value, color, context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20.w,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  String _getDirections() {
    final String serviceName = service['name'] ?? '';
    if (serviceName.contains('Medical') || serviceName.contains('Clinic')) {
      return 'Enter through the main lobby of the Administration Building. The Medical Clinic is located on the ground floor, immediately to your right after entering.';
    } else if (serviceName.contains('Security')) {
      return 'The Security Office is located at the main campus entrance (Gate 1). Look for the security booth next to the vehicle checkpoint.';
    } else if (serviceName.contains('Guidance')) {
      return 'Go to the Student Affairs Building, take the stairs or elevator to the 2nd floor. The Guidance Office is in Room 201, next to the Registrar\'s Office.';
    }
    return 'Follow campus signage to locate this service.';
  }
}
