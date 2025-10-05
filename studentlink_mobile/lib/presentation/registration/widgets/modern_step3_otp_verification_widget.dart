import 'package:flutter/material.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

/// Modern step 3 OTP verification widget
class ModernStep3OtpVerificationWidget extends StatelessWidget {
  final String personalEmail;
  final String contactNumber;
  final Function(String? emailOtp, String? phoneOtp) onDataChanged;
  final Function(String error) onError;

  const ModernStep3OtpVerificationWidget({
    Key? key,
    required this.personalEmail,
    required this.contactNumber,
    required this.onDataChanged,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OTP Verification',
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
