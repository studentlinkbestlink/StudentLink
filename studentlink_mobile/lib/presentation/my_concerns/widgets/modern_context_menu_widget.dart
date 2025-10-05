import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> concern;
  final VoidCallback onShareStatus;
  final VoidCallback onDownloadPdf;
  final VoidCallback onSetNotifications;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const ModernContextMenuWidget({
    Key? key,
    required this.concern,
    required this.onShareStatus,
    required this.onDownloadPdf,
    required this.onSetNotifications,
    required this.onDelete,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: ResponsiveDesign.getPadding(all: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A78).withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.more_horiz_rounded,
                  color: const Color(0xFF1E2A78),
                  size: ResponsiveDesign.getIconSize(20),
                ),
                ResponsiveSpacing(height: 0, width: 8),
                Expanded(
                  child: Text(
                    'Concern Options',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onClose();
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: Color(0xFF757575),
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          
          // Menu items
          Padding(
            padding: ResponsiveDesign.getPadding(vertical: 8),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.share_rounded,
                  title: 'Share Status',
                  subtitle: 'Share concern status with others',
                  onTap: onShareStatus,
                ),
                _buildMenuItem(
                  icon: Icons.download_rounded,
                  title: 'Download PDF',
                  subtitle: 'Export concern as PDF document',
                  onTap: onDownloadPdf,
                ),
                _buildMenuItem(
                  icon: Icons.notifications_rounded,
                  title: 'Set Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: onSetNotifications,
                ),
                const Divider(
                  height: 1,
                  color: Color(0xFFE5E7EB),
                  indent: 16,
                  endIndent: 16,
                ),
                _buildMenuItem(
                  icon: Icons.delete_rounded,
                  title: 'Delete Concern',
                  subtitle: 'Permanently remove this concern',
                  onTap: onDelete,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xFFE22824) : Color(0xFF757575);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveDesign.getIconSize(20),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? const Color(0xFFE22824) : Colors.black,
                      ),
                    ),
                    ResponsiveSpacing(height: 2),
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF757575),
                size: ResponsiveDesign.getIconSize(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
