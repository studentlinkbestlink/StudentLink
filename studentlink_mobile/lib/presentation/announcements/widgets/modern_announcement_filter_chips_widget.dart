import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernAnnouncementFilterChipsWidget extends StatelessWidget {
  final String categoryFilter;
  final VoidCallback onClearAll;

  const ModernAnnouncementFilterChipsWidget({
    Key? key,
    required this.categoryFilter,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Filter label
          Icon(
            Icons.filter_list_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: ResponsiveDesign.getIconSize(16),
          ),
          ResponsiveSpacing(height: 0, width: 8),
          Text(
            'Filtered by:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          ResponsiveSpacing(height: 0, width: 8),
          
          // Active filter chip
          Container(
            padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getCategoryLabel(categoryFilter),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveDesign.getFontSize(12),
                  ),
                ),
                ResponsiveSpacing(height: 0, width: 4),
                Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: ResponsiveDesign.getIconSize(14),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Clear all button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onClearAll();
              },
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              child: Container(
                padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.clear_rounded,
                      color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                      size: ResponsiveDesign.getIconSize(14),
                    ),
                    ResponsiveSpacing(height: 0, width: 4),
                    Text(
                      'Clear',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveDesign.getFontSize(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'academic modules':
        return 'Academic Modules';
      case 'class schedules & exams':
        return 'Class Schedules & Exams';
      case 'enrollment & clearance':
        return 'Enrollment & Clearance';
      case 'scholarships & financial aid':
        return 'Scholarships & Financial Aid';
      case 'student activities & events':
        return 'Student Activities & Events';
      case 'emergency notices':
        return 'Emergency Notices';
      case 'administrative updates':
        return 'Administrative Updates';
      case 'ojt & career services':
        return 'OJT & Career Services';
      case 'campus ministry':
        return 'Campus Ministry';
      case 'faculty announcements':
        return 'Faculty Announcements';
      case 'system maintenance':
        return 'System Maintenance';
      case 'student services':
        return 'Student Services';
      case 'all':
        return 'All';
      default:
        return category;
    }
  }
}
