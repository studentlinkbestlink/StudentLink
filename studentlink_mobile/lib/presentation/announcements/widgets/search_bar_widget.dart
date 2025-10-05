import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../theme/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
              ),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search announcements...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
                prefixIcon: Padding(
                  padding: ResponsiveDesign.getPadding(all: 3.w),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller.clear();
                          onChanged('');
                        },
                        child: Padding(
                          padding: ResponsiveDesign.getPadding(all: 3.w),
                          child: Icon(
                            Icons.clear,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: ResponsiveDesign.getIconSize(20),
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w,
                  vertical: 1.5.h,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            padding: ResponsiveDesign.getPadding(all: 3.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A78)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(
                color: const Color(0xFF1E2A78)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              Icons.filter_list,
              color: const Color(0xFF1E2A78),
              size: ResponsiveDesign.getIconSize(24),
            ),
          ),
        ),
      ],
    );
  }
}
