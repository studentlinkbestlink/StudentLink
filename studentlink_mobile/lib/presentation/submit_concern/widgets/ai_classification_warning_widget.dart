import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class AiClassificationWarningWidget extends StatelessWidget {
  final String message;
  final String? suggestion;
  final VoidCallback? onDismiss;
  final VoidCallback? onImprove;

  const AiClassificationWarningWidget({
    Key? key,
    required this.message,
    this.suggestion,
    this.onDismiss,
    this.onImprove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getMargin(bottom: 16),
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: const Color(0xFFFFC107).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xFFFFC107),
                  size: ResponsiveDesign.getIconSize(16),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 8),
              Expanded(
                child: Text(
                  'AI Classification Notice',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFFC107),
                  ),
                ),
              ),
              if (onDismiss != null)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onDismiss!();
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: const Color(0xFFFFC107),
                    size: ResponsiveDesign.getIconSize(18),
                  ),
                ),
            ],
          ),
          ResponsiveSpacing(height: 8),
          Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF300300300),
              height: 1.4,
            ),
          ),
          if (suggestion != null) ...[
            ResponsiveSpacing(height: 8),
            Container(
              padding: ResponsiveDesign.getPadding(all: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                border: Border.all(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: const Color(0xFFFFC107),
                    size: ResponsiveDesign.getIconSize(14),
                  ),
                  ResponsiveSpacing(height: 0, width: 8),
                  Expanded(
                    child: Text(
                      suggestion!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (onImprove != null) ...[
            ResponsiveSpacing(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onImprove!();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: const Color(0xFFFFC107)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                  ),
                  padding: ResponsiveDesign.getPadding(vertical: 8),
                ),
                icon: Icon(
                  Icons.edit_rounded,
                  color: const Color(0xFFFFC107),
                  size: ResponsiveDesign.getIconSize(16),
                ),
                label: Text(
                  'Improve Description',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFFFC107),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
