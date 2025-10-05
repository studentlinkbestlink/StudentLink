import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onSubmitConcern;

  const EmptyStateWidget({
    Key? key,
    this.onSubmitConcern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveDesign.getPadding(all: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A78)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'assignment',
                  size: 20.w,
                  color: const Color(0xFF1E2A78),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'No Concerns Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'You haven\'t submitted any concerns yet. Start by submitting your first concern to get help from the campus support team.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSubmitConcern,
                icon: Icon(
                  Icons.add,
                  size: ResponsiveDesign.getIconSize(20),
                  color: Colors.white,
                ),
                label: Text('Submit Your First Concern'),
                style: ElevatedButton.styleFrom(
                  padding: ResponsiveDesign.getPadding(vertical: 2.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
