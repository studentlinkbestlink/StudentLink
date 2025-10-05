import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernDepartmentSelectionWidget extends StatelessWidget {
  final String? selectedDepartment;
  final Function(String?) onChanged;
  final String? errorText;

  const ModernDepartmentSelectionWidget({
    Key? key,
    required this.selectedDepartment,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.business_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Department *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
        ResponsiveSpacing(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            border: Border.all(
              color: errorText != null 
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.outline,
              width: errorText != null ? 2 : 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedDepartment,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              onChanged(value);
            },
            decoration: InputDecoration(
              hintText: 'Select your department',
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 14),
              prefixIcon: Icon(
                Icons.business_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(20),
              ),
            ),
            items: [
              'BS in Accounting Information System',
              'BSBA major in Financial Management',
              'BSBA major in Human Resource Management',
              'BSBA major in Marketing Management',
              'BS in Computer Engineering',
              'BS in Information Technology',
              'BS in Criminology',
              'BS in Psychology',
              'BS in Entrepreneurship',
              'BS in Office Administration',
              'BS in Hospitality Management',
              'BS in Tourism Management',
              'Bachelor of Library and Information Science',
              'Bachelor of Physical Education',
              'Bachelor of Elementary Education',
              'Bachelor of Secondary Education - English',
              'Bachelor of Secondary Education - Filipino',
              'Bachelor of Secondary Education - Mathematics',
              'Bachelor of Secondary Education - Science',
              'Bachelor of Secondary Education - Social Studies',
              'Bachelor of Secondary Education - Values Education',
              'Bachelor of Technology and Livelihood Education',
            ].map((String department) {
              return DropdownMenuItem<String>(
                value: department,
                child: Text(
                  department,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (errorText != null) ...[
          ResponsiveSpacing(height: 8),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
