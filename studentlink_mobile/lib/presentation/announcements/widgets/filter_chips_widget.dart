import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

class FilterChipsWidget extends StatelessWidget {
  final String categoryFilter;
  final VoidCallback onClearAll;

  const FilterChipsWidget({
    Key? key,
    required this.categoryFilter,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryFilter == 'All') {
      return SizedBox.shrink();
    }

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters (1)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: onClearAll,
                child: Text(
                  'Clear All',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFFE22824),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 0.5.h,
            children: [
              Chip(
                label: Text(
                  'Category: $categoryFilter',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF1E2A78),
                  ),
                ),
                backgroundColor:
                    const Color(0xFF1E2A78).withValues(alpha: 0.1),
                side: BorderSide(
                  color: const Color(0xFF1E2A78),
                  width: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
