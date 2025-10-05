import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'resolution_confirmation_widget.dart';
import 'enhanced_concern_chat_screen.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class EnhancedConcernDetailsModal extends StatefulWidget {
  final Map<String, dynamic> concern;
  final VoidCallback? onResolutionUpdated;
  final bool autoOpenChat;

  const EnhancedConcernDetailsModal({
    Key? key,
    required this.concern,
    this.onResolutionUpdated,
    this.autoOpenChat = false,
  }) : super(key: key);

  @override
  State<EnhancedConcernDetailsModal> createState() =>
      _EnhancedConcernDetailsModalState();
}

class _EnhancedConcernDetailsModalState
    extends State<EnhancedConcernDetailsModal> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-open chat if requested
    if (widget.autoOpenChat) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openChatScreen();
      });
    }
  }

  void _openChatScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedConcernChatScreen(
          concern: widget.concern,
          onResolutionUpdated: () {
            widget.onResolutionUpdated?.call();
            setState(() {}); // Refresh the modal
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final concern = widget.concern;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Enhanced handle bar
          Container(
            margin: ResponsiveDesign.getPadding(top: 16),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(3)),
            ),
          ),

          // Enhanced header with gradient
          Container(
            padding: ResponsiveDesign.getPadding(all: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: ResponsiveDesign.getPadding(all: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(16)),
                  ),
                  child: Icon(
                    Icons.assignment_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: ResponsiveDesign.getIconSize(24),
                  ),
                ),
                ResponsiveSpacing(height: 0, width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Concern Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.color ??
                                  Colors.black,
                              letterSpacing: -0.5,
                            ),
                      ),
                      ResponsiveSpacing(height: 4),
                      Text(
                        'View detailed information about this concern',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color ??
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: ResponsiveDesign.getFontSize(14),
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // Enhanced content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveDesign.getPadding(all: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced status and priority section
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                          ResponsiveDesign.getBorderRadius(16)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status & Priority',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color ??
                                        Colors.black,
                                  ),
                        ),
                        ResponsiveSpacing(height: 16),
                        Row(
                          children: [
                            _buildEnhancedStatusChip(
                                concern['status'] ?? 'pending'),
                            ResponsiveSpacing(height: 0, width: 12),
                            _buildEnhancedPriorityChip(
                                concern['priority'] ?? 'medium'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ResponsiveSpacing(height: 24),

                  // Enhanced title section
                  _buildDetailSection(
                    title: 'Title',
                    content: concern['subject'] ??
                        concern['title'] ??
                        'Untitled Concern',
                    icon: Icons.title_rounded,
                    isTitle: true,
                  ),

                  ResponsiveSpacing(height: 24),

                  // Enhanced description section
                  _buildDetailSection(
                    title: 'Description',
                    content:
                        concern['description'] ?? 'No description provided',
                    icon: Icons.description_rounded,
                    isDescription: true,
                  ),

                  ResponsiveSpacing(height: 24),

                  // Enhanced metadata section
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                          ResponsiveDesign.getBorderRadius(16)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: ResponsiveDesign.getIconSize(20),
                            ),
                            ResponsiveSpacing(height: 0, width: 8),
                            Text(
                              'Additional Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color ??
                                        Colors.black,
                                  ),
                            ),
                          ],
                        ),
                        ResponsiveSpacing(height: 16),

                        // Created date
                        _buildMetadataRow(
                          icon: Icons.access_time_rounded,
                          label: 'Created',
                          value: concern['created_at'] != null
                              ? _formatDate(concern['created_at'])
                              : 'Unknown',
                        ),

                        if (concern['reference_number'] != null) ...[
                          ResponsiveSpacing(height: 12),
                          _buildMetadataRow(
                            icon: Icons.tag_rounded,
                            label: 'Reference Number',
                            value: concern['reference_number'] ?? 'Unknown',
                            isMonospace: true,
                          ),
                        ],

                        if (concern['replies_count'] != null &&
                            concern['replies_count'] > 0) ...[
                          ResponsiveSpacing(height: 12),
                          _buildMetadataRow(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Replies',
                            value: _isExpanded.toString(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Chat access button
                  if (widget.concern['status'] != 'pending' &&
                      widget.concern['status'] != 'cancelled') ...[
                    ResponsiveSpacing(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openChatScreen(),
                        icon: const Icon(Icons.chat_rounded, size: 18),
                        label: const Text('View Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: ResponsiveDesign.getPadding(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveDesign.getBorderRadius(12)),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Resolution confirmation widget (only show for resolved status)
                  if (widget.concern['status'] == 'resolved') ...[
                    ResponsiveSpacing(height: 24),
                    ResolutionConfirmationWidget(
                      concern: widget.concern,
                      onResolutionUpdated: () {
                        widget.onResolutionUpdated?.call();
                        setState(() {}); // Refresh the modal
                      },
                    ),
                  ],

                  ResponsiveSpacing(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatusChip(String status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: ResponsiveDesign.getIconSize(14),
          ),
          ResponsiveSpacing(height: 0, width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveDesign.getFontSize(12),
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPriorityChip(String priority) {
    final color = _getPriorityColor(priority);
    final label = _getPriorityLabel(priority);
    final icon = _getPriorityIcon(priority);

    // Determine text color based on background brightness for better contrast
    final isLightBackground = Theme.of(context).brightness == Brightness.light;
    final textColor =
        isLightBackground ? color : _getContrastingTextColor(color);

    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isLightBackground ? 0.12 : 0.2),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: color.withValues(alpha: isLightBackground ? 0.25 : 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: ResponsiveDesign.getIconSize(14),
          ),
          ResponsiveSpacing(height: 0, width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveDesign.getFontSize(12),
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required String content,
    required IconData icon,
    bool isTitle = false,
    bool isDescription = false,
  }) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(10)),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: ResponsiveDesign.getIconSize(18),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.titleMedium?.color ??
                          Colors.black,
                    ),
              ),
            ],
          ),
          ResponsiveSpacing(height: 16),
          Text(
            content,
            style: isTitle
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.titleMedium?.color ??
                          Colors.black,
                      height: 1.3,
                    )
                : isDescription
                    ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          height: 1.6,
                          fontSize: ResponsiveDesign.getFontSize(15),
                        )
                    : Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w500,
                        ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMonospace = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).textTheme.bodySmall?.color ??
              Theme.of(context).textTheme.bodySmall?.color,
          size: ResponsiveDesign.getIconSize(16),
        ),
        ResponsiveSpacing(height: 0, width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color ??
                          Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                      fontSize: ResponsiveDesign.getFontSize(12),
                    ),
              ),
              ResponsiveSpacing(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color ??
                          Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: isMonospace ? 'monospace' : null,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Theme.of(context).colorScheme.primary;
      case 'approved':
        return Theme.of(context).colorScheme.tertiary;
      case 'in_progress':
        return Theme.of(context).colorScheme.tertiary;
      case 'staff_resolved':
        return Theme.of(context).colorScheme.primary; // Blue for staff resolved
      case 'student_confirmed':
        return Theme.of(context).colorScheme.tertiary;
      case 'disputed':
        return Theme.of(context).colorScheme.error;
      case 'closed':
        return Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
      case 'cancelled':
        return Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
      default:
        return Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'in_progress':
        return 'In Progress';
      case 'staff_resolved':
        return 'Staff Resolved';
      case 'student_confirmed':
        return 'Student Confirmed';
      case 'disputed':
        return 'Disputed';
      case 'closed':
        return 'Closed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'approved':
        return Icons.verified_rounded;
      case 'in_progress':
        return Icons.hourglass_empty_rounded;
      case 'staff_resolved':
        return Icons.engineering_rounded;
      case 'student_confirmed':
        return Icons.check_circle_rounded;
      case 'disputed':
        return Icons.report_problem_rounded;
      case 'closed':
        return Icons.lock_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFDC2626); // Red for urgent
      case 'high':
        return const Color(0xFFEF4444); // Red for high
      case 'medium':
        return const Color(
            0xFFFFA726); // Brighter amber for medium - better contrast
      case 'low':
        return const Color(0xFF10B981); // Green for low
      default:
        return const Color(0xFF6B7280); // Gray for normal
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      default:
        return 'Normal';
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high_rounded;
      case 'medium':
        return Icons.remove_rounded;
      case 'low':
        return Icons.keyboard_arrow_down_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _formatDate(dynamic dateValue) {
    try {
      if (dateValue == null) return 'Unknown';

      DateTime date;
      if (dateValue is String) {
        date = DateTime.parse(dateValue);
      } else if (dateValue is DateTime) {
        date = dateValue;
      } else {
        return 'Unknown';
      }

      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Helper method to get contrasting text color for better visibility in dark mode
  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance to determine if we need light or dark text
    final luminance = backgroundColor.computeLuminance();

    // For dark backgrounds, use light text; for light backgrounds, use dark text
    if (luminance < 0.5) {
      // Dark background - use light text
      return Colors.white;
    } else {
      // Light background - use dark text
      return const Color(
          0xFF1F2937); // Dark gray instead of black for better readability
    }
  }
}
