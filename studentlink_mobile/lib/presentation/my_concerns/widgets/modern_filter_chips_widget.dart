import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernFilterChipsWidget extends StatelessWidget {
  final String statusFilter;
  final VoidCallback onClearAll;

  const ModernFilterChipsWidget({
    Key? key,
    required this.statusFilter,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
          ),
          ResponsiveSpacing(height: 0, width: 8),

          // Active filter chip
          Container(
            padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getStatusLabel(statusFilter),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveDesign.getFontSize(12),
                      ),
                ),
                ResponsiveSpacing(height: 0, width: 4),
                Icon(
                  Icons.check_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
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
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              child: Container(
                padding:
                    ResponsiveDesign.getPadding(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(8)),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.clear_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: ResponsiveDesign.getIconSize(14),
                    ),
                    ResponsiveSpacing(height: 0, width: 4),
                    Text(
                      'Clear',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
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

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'in_progress':
        return 'In Progress';
      case 'staff_resolved':
        return 'Staff Resolved';
      case 'student_confirmed':
        return 'Student Confirmed';
      case 'disputed':
        return 'Disputed';
      case 'closed':
        return 'Closed';
      case 'cancelled':
        return 'Cancelled';
      case 'all':
        return 'All';
      default:
        return status;
    }
  }
}
