import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;

  const SearchBarWidget({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onFilterPressed,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                border: Border.all(
                  color: Color(0xFF300300300)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search concerns...',
                  prefixIcon: Padding(
                    padding: ResponsiveDesign.getPadding(all: 3.w),
                    child: Icon(
                      Icons.search,
                      size: ResponsiveDesign.getIconSize(20),
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: widget.searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            size: ResponsiveDesign.getIconSize(20),
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black
                        .withValues(alpha: 0.7),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A78),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            child: IconButton(
              onPressed: widget.onFilterPressed,
              icon: CustomIconWidget(
                iconName: 'filter_list',
                size: ResponsiveDesign.getIconSize(24),
                color: Colors.white,
              ),
              tooltip: 'Filter concerns',
            ),
          ),
        ],
      ),
    );
  }
}
