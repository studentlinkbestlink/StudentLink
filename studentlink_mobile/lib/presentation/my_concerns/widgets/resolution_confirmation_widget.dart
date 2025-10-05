import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/api_service.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ResolutionConfirmationWidget extends StatefulWidget {
  final Map<String, dynamic> concern;
  final VoidCallback onResolutionUpdated;

  const ResolutionConfirmationWidget({
    Key? key,
    required this.concern,
    required this.onResolutionUpdated,
  }) : super(key: key);

  @override
  State<ResolutionConfirmationWidget> createState() => _ResolutionConfirmationWidgetState();
}

class _ResolutionConfirmationWidgetState extends State<ResolutionConfirmationWidget> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _disputeController = TextEditingController();
  bool _isLoading = false;
  int _rating = 0;

  @override
  void dispose() {
    _notesController.dispose();
    _disputeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(all: 16),
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: const Color(0xFF1E2A78).withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: const Color(0xFF1E2A78),
                  size: ResponsiveDesign.getIconSize(24),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resolution Confirmation',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
                      ),
                    ),
                    ResponsiveSpacing(height: 4),
                    Text(
                      'Staff has marked this concern as resolved. Please confirm if your issue has been addressed.',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          ResponsiveSpacing(height: 24),
          
          // Action buttons
          Row(
            children: [
              // Confirm button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleConfirmResolution,
                  icon: _isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.check_rounded, size: 18),
                  label: Text(_isLoading ? 'Confirming...' : 'Confirm Resolved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A745),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                    padding: ResponsiveDesign.getPadding(vertical: 16),
                  ),
                ),
              ),
              
              ResponsiveSpacing(height: 0, width: 12),
              
              // Dispute button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleDisputeResolution,
                  icon: const Icon(Icons.report_problem_rounded, size: 18),
                  label: const Text('Dispute'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE22824),
                    side: BorderSide(color: const Color(0xFFE22824)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                    ),
                    padding: ResponsiveDesign.getPadding(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleConfirmResolution() async {
    HapticFeedback.lightImpact();
    
    // Show confirmation dialog with notes option
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _buildConfirmationDialog(),
    );
    
    if (result != null) {
      await _confirmResolution(result['notes'] as String?, result['rating'] as int?);
    }
  }

  void _handleDisputeResolution() async {
    HapticFeedback.lightImpact();
    
    // Show dispute dialog
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _buildDisputeDialog(),
    );
    
    if (result != null && result.isNotEmpty) {
      await _disputeResolution(result);
    }
  }

  Widget _buildConfirmationDialog() {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: const Color(0xFF28A745),
            size: ResponsiveDesign.getIconSize(24),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          const Text('Confirm Resolution'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you satisfied with how this concern was resolved?',
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          ResponsiveSpacing(height: 16),
          Text(
            'Rate the resolution:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          ResponsiveSpacing(height: 8),
          _buildRatingStars(),
          ResponsiveSpacing(height: 16),
          Text(
            'Optional notes:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          ResponsiveSpacing(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any additional comments about the resolution...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'notes': _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
            'rating': _rating > 0 ? _rating : null,
          }),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF28A745),
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildDisputeDialog() {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.report_problem_rounded,
            color: const Color(0xFFE22824),
            size: ResponsiveDesign.getIconSize(24),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          const Text('Dispute Resolution'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please explain why you believe this concern has not been properly resolved:',
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          ResponsiveSpacing(height: 16),
          TextField(
            controller: _disputeController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe what still needs to be addressed...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_disputeController.text.trim().isNotEmpty) {
              Navigator.pop(context, _disputeController.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE22824),
            foregroundColor: Colors.white,
          ),
          child: const Text('Submit Dispute'),
        ),
      ],
    );
  }

  Future<void> _confirmResolution(String? notes, int? rating) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await apiService.confirmResolution(
        widget.concern['id'],
        notes: notes,
        rating: rating,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Resolution confirmed successfully!'),
            backgroundColor: const Color(0xFF28A745),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        widget.onResolutionUpdated();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to confirm resolution: ${e.toString()}'),
            backgroundColor: const Color(0xFFE22824),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _disputeResolution(String reason) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await apiService.disputeResolution(
        widget.concern['id'],
        reason,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Resolution disputed successfully!'),
            backgroundColor: const Color(0xFFFFC107),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        widget.onResolutionUpdated();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to dispute resolution: ${e.toString()}'),
            backgroundColor: const Color(0xFFE22824),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: Container(
            padding: ResponsiveDesign.getPadding(all: 4),
            child: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: index < _rating ? const Color(0xFF28A745) : Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
              size: ResponsiveDesign.getIconSize(32),
            ),
          ),
        );
      }),
    );
  }
}
