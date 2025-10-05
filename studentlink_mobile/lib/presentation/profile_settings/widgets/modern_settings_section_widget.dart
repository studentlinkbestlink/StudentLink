import 'package:flutter/material.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernSettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ModernSettingsSectionWidget({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
          
          // Section content
          ...children.map((child) => Padding(
            padding: ResponsiveDesign.getPadding(horizontal: 20),
            child: child,
          )).toList(),
          
          ResponsiveSpacing(height: 20),
        ],
      ),
    );
  }
}
