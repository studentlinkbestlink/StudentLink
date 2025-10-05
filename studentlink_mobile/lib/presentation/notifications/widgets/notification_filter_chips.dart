import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class NotificationFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final int unreadCount;
  final int totalCount;

  const NotificationFilterChips({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.unreadCount,
    required this.totalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'label': 'All', 'count': totalCount},
      {'label': 'Unread', 'count': unreadCount},
      {'label': 'Read', 'count': totalCount - unreadCount},
    ];

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter['label'];
            final count = filter['count'] as int;
            
            return Container(
              margin: ResponsiveDesign.getPadding(right: 8),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onFilterChanged(filter['label'] as String);
                },
                child: Container(
                  padding: ResponsiveDesign.getPadding(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF1E2A78) 
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF1E2A78) 
                          : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: const Color(0xFF1E2A78).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filter['label'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      if (count > 0) ...[
                        ResponsiveSpacing(height: 0, width: 6),
                        Container(
                          padding: ResponsiveDesign.getPadding(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Colors.white.withValues(alpha: 0.2)
                                : const Color(0xFF1E2A78).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
                          ),
                          child: Text(
                            count.toString(),
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveDesign.getFontSize(11),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
