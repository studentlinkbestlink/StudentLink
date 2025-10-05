import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernQuickActionsCard extends StatelessWidget {
  final VoidCallback onSubmitConcern;

  const ModernQuickActionsCard({
    Key? key,
    required this.onSubmitConcern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 24),
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        boxShadow: Theme.of(context).brightness == Brightness.light ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(24),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          
          ResponsiveSpacing(height: 20),
          
          // Action buttons grid
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.add_rounded,
                  title: 'Submit Concern',
                  subtitle: 'Report an issue',
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onSubmitConcern();
                  },
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.chat_rounded,
                  title: 'AI Assistant',
                  subtitle: 'Get help instantly',
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/ai-chat-assistant');
                  },
                ),
              ),
            ],
          ),
          
          ResponsiveSpacing(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.assignment_rounded,
                  title: 'My Concerns',
                  subtitle: 'View all issues',
                  color: Theme.of(context).colorScheme.tertiary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/my-concerns');
                  },
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.campaign_rounded,
                  title: 'Announcements',
                  subtitle: 'Latest updates',
                  color: Theme.of(context).colorScheme.tertiary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/announcements');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        child: Container(
          padding: ResponsiveDesign.getPadding(all: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: ResponsiveDesign.getIconSize(20),
                ),
              ),
              ResponsiveSpacing(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: ResponsiveDesign.getFontSize(14),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              ResponsiveSpacing(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: ResponsiveDesign.getFontSize(12),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
