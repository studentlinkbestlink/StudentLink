import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/custom_icon_widget.dart';

class ContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> concern;
  final VoidCallback? onShareStatus;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onSetNotifications;
  final VoidCallback? onDelete;
  final VoidCallback? onClose;

  const ContextMenuWidget({
    Key? key,
    required this.concern,
    this.onShareStatus,
    this.onDownloadPdf,
    this.onSetNotifications,
    this.onDelete,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: ResponsiveDesign.getPadding(all: 4.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A78)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    concern['title'] ?? 'Concern Options',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E2A78),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close,
                    size: ResponsiveDesign.getIconSize(20),
                    color: const Color(0xFF1E2A78),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: ResponsiveDesign.getPadding(all: 2.w),
            child: Column(
              children: [
                _buildMenuItem('Edit', Icons.edit, () => _editConcern(), context),
                Divider(
                    height: 1,
                    color: Color(0xFF300300300)
                        .withValues(alpha: 0.2)),
                _buildMenuItem('Delete', Icons.delete, () => _deleteConcern(), context, isDestructive: true),
                Divider(
                    height: 1,
                    color: Color(0xFF300300300)
                        .withValues(alpha: 0.2)),
                _buildMenuItem('Share', Icons.share, () => _shareConcern(), context),
                Divider(
                    height: 1,
                    color: Color(0xFF300300300)
                        .withValues(alpha: 0.2)),
                _buildMenuItem('Archive', Icons.archive, () => _archiveConcern(), context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap, BuildContext context, {bool isDestructive = false, String? subtitle}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
      child: Padding(
        padding: ResponsiveDesign.getPadding(horizontal: 2.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              padding: ResponsiveDesign.getPadding(all: 2.w),
              decoration: BoxDecoration(
                color: isDestructive 
                    ? const Color(0xFFE22824).withValues(alpha: 0.1)
                    : const Color(0xFF1E2A78)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              ),
              child: Icon(
                icon,
                size: ResponsiveDesign.getIconSize(20),
                color: isDestructive 
                    ? const Color(0xFFE22824)
                    : const Color(0xFF1E2A78),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? const Color(0xFFE22824) : null,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              size: ResponsiveDesign.getIconSize(20),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _editConcern() {
    // TODO: Implement edit concern functionality
  }

  void _deleteConcern() {
    // TODO: Implement delete concern functionality
  }

  void _shareConcern() {
    // TODO: Implement share concern functionality
  }

  void _archiveConcern() {
    // TODO: Implement archive concern functionality
  }
}
