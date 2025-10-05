import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/form_validation_service.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernConcernTypeWidget extends StatefulWidget {
  final String? selectedType;
  final Function(String?) onChanged;
  final String? errorText;
  final bool enabled;

  const ModernConcernTypeWidget({
    Key? key,
    required this.selectedType,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<ModernConcernTypeWidget> createState() => _ModernConcernTypeWidgetState();
}

class _ModernConcernTypeWidgetState extends State<ModernConcernTypeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _hoveredType;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final concernTypes = [
      'Academic',
      'Administrative',
      'Technical',
      'Financial',
      'Facility',
      'Other',
    ];

    final fieldRules = FormValidationService.getFieldRules('concernType');
    final helpText = fieldRules['helpText'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            Icon(
              Icons.category_rounded,
              color: widget.errorText != null 
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(20),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Concern Type *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.errorText != null 
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
        
        ResponsiveSpacing(height: 8),
        
        // Help text
        if (helpText != null)
          Padding(
            padding: ResponsiveDesign.getPadding(bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  size: ResponsiveDesign.getIconSize(16),
                ),
                ResponsiveSpacing(height: 0, width: 4),
                Expanded(
                  child: Text(
                    helpText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // Concern type chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: concernTypes.map((type) {
            return _buildConcernTypeChip(type);
          }).toList(),
        ),
        
        // Error message
        if (widget.errorText != null) ...[
          ResponsiveSpacing(height: 8),
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.error,
                size: ResponsiveDesign.getIconSize(16),
              ),
              ResponsiveSpacing(height: 0, width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildConcernTypeChip(String type) {
    final isSelected = widget.selectedType == type.toLowerCase();
    final isHovered = _hoveredType == type;
    final isDisabled = !widget.enabled;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isHovered ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: isDisabled ? null : () {
              HapticFeedback.lightImpact();
              _animationController.forward().then((_) {
                _animationController.reverse();
              });
              widget.onChanged(type.toLowerCase());
            },
            onTapDown: isDisabled ? null : (_) {
              setState(() {
                _hoveredType = type;
              });
            },
            onTapUp: isDisabled ? null : (_) {
              setState(() {
                _hoveredType = null;
              });
            },
            onTapCancel: isDisabled ? null : () {
              setState(() {
                _hoveredType = null;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDisabled
                    ? Theme.of(context).colorScheme.surface
                    : isSelected 
                        ? const Color(0xFF1E2A78) 
                        : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
                border: Border.all(
                  color: isDisabled
                      ? const Color(0xFFE5E7EB)
                      : isSelected 
                          ? const Color(0xFF1E2A78) 
                          : const Color(0xFFE5E7EB),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected && !isDisabled ? [
                  BoxShadow(
                    color: const Color(0xFF1E2A78).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : isHovered && !isDisabled ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selection indicator
                  if (isSelected && !isDisabled)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: ResponsiveDesign.getIconSize(14),
                      ),
                    )
                  else
                    Icon(
                      _getTypeIcon(type),
                      color: isDisabled
                          ? Theme.of(context).textTheme.bodySmall?.color
                          : isSelected 
                              ? Colors.white 
                              : Theme.of(context).colorScheme.primary,
                      size: ResponsiveDesign.getIconSize(16),
                    ),
                  
                  ResponsiveSpacing(height: 0, width: 8),
                  
                  Text(
                    type,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDisabled
                          ? Theme.of(context).textTheme.bodySmall?.color
                          : isSelected 
                              ? Colors.white 
                              : Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'academic':
        return Icons.school_rounded;
      case 'administrative':
        return Icons.admin_panel_settings_rounded;
      case 'technical':
        return Icons.build_rounded;
      case 'financial':
        return Icons.account_balance_wallet_rounded;
      case 'facility':
        return Icons.location_on_rounded;
      case 'other':
        return Icons.help_outline_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
