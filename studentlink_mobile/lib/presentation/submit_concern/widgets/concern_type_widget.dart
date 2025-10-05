import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/custom_icon_widget.dart';

class ConcernTypeWidget extends StatelessWidget {
  final String? selectedType;
  final Function(String?) onChanged;
  final String? errorText;

  const ConcernTypeWidget({
    Key? key,
    required this.selectedType,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> concernTypes = [
      {'name': 'Academic Issue', 'value': 'academic', 'icon': 'school', 'color': const Color(0xFF1E2A78)},
      {
        'name': 'Administrative',
        'value': 'administrative',
        'icon': 'account_balance_wallet',
        'color': const Color(0xFF28A745)
      },
      {'name': 'Technical Support', 'value': 'technical', 'icon': 'computer', 'color': const Color(0xFF28A745)},
      {'name': 'Health & Safety', 'value': 'health', 'icon': 'health_and_safety', 'color': const Color(0xFFE22824)},
      {'name': 'Safety Concern', 'value': 'safety', 'icon': 'security', 'color': const Color(0xFF28A745)},
      {'name': 'Other', 'value': 'other', 'icon': 'help_outline', 'color': Color(0xFF757575)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Concern Type *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null
                  ? const Color(0xFFE22824)
                  : Color(0xFF300300300),
            ),
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
          ),
          child: Column(
            children: [
              ...concernTypes.map((type) {
                final isSelected = selectedType == type['value'];
                return InkWell(
                  onTap: () => onChanged(type['value']),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
                  child: Container(
                    padding:
                        ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E2A78)
                              .withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: ResponsiveDesign.getPadding(all: 2.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? type['color']
                                : (type['color'] as Color)
                                    .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8.0)),
                          ),
                          child: CustomIconWidget(
                            iconName: type['icon'],
                            color: isSelected ? Colors.white : type['color'],
                            size: ResponsiveDesign.getIconSize(18),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            type['name'],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color: isSelected
                                  ? const Color(0xFF1E2A78)
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF1E2A78),
                            size: ResponsiveDesign.getIconSize(20),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: ResponsiveDesign.getPadding(top: 1.h, left: 3.w),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFE22824),
              ),
            ),
          ),
      ],
    );
  }
}
