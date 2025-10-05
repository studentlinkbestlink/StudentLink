import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernEmptyStateWidget extends StatelessWidget {
  final VoidCallback onSubmitConcern;

  const ModernEmptyStateWidget({
    Key? key,
    required this.onSubmitConcern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: ResponsiveDesign.getIconSize(60),
              color: const Color(0xFF1E2A78).withValues(alpha: 0.6),
            ),
          ),
          
          ResponsiveSpacing(height: 24),
          
          // Title
          Text(
            'No Concerns Yet',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          
          ResponsiveSpacing(height: 8),
          
          // Description
          Text(
            'You haven\'t submitted any concerns yet.\nStart by reporting an issue or asking a question.',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          ResponsiveSpacing(height: 32),
          
          // Action buttons
          Column(
            children: [
              // Primary action
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onSubmitConcern();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2A78),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: ResponsiveDesign.getIconSize(20),
                      ),
                      ResponsiveSpacing(height: 0, width: 8),
                      Text(
                        'Submit Your First Concern',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              ResponsiveSpacing(height: 16),
              
              // Secondary action
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/ai-chat-assistant');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: const Color(0xFF1E2A78),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_rounded,
                        color: const Color(0xFF1E2A78),
                        size: ResponsiveDesign.getIconSize(18),
                      ),
                      ResponsiveSpacing(height: 0, width: 8),
                      Text(
                        'Chat with STUDENTLINK AI',
                        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF1E2A78),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          ResponsiveSpacing(height: 24),
          
          // Help text
          Container(
            padding: ResponsiveDesign.getPadding(all: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: const Color(0xFFFFC107),
                  size: ResponsiveDesign.getIconSize(24),
                ),
                ResponsiveSpacing(height: 8),
                Text(
                  'Need Help?',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                  ),
                ),
                ResponsiveSpacing(height: 4),
                Text(
                  'You can submit concerns about academic issues, technical problems, or general inquiries.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
