import 'package:flutter/material.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

/// Modern step 4 widget for additional information
class ModernStep4AdditionalInfoWidget extends StatelessWidget {
  final Function(DateTime? birthday, String? civilStatus, String? password,
      String? passwordConfirmation) onDataChanged;

  const ModernStep4AdditionalInfoWidget({
    Key? key,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          ResponsiveSpacing(height: 16),
          Text(
            'This step will be implemented with modern UI design.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color ??
                      const Color(0xFF757575),
                ),
          ),
        ],
      ),
    );
  }
}
