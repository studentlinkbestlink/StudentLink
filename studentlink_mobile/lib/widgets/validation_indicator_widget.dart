import 'package:flutter/material.dart';
import '../services/form_validation_service.dart';
import 'responsive_widgets.dart';
import '../utils/responsive_design.dart';

class ValidationIndicatorWidget extends StatelessWidget {
  final String? errorMessage;
  final ValidationState state;
  final bool showIcon;
  final bool showMessage;

  const ValidationIndicatorWidget({
    Key? key,
    this.errorMessage,
    required this.state,
    this.showIcon = true,
    this.showMessage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == ValidationState.valid) {
      return _buildValidIndicator(context);
    } else if (state == ValidationState.invalid && errorMessage != null) {
      return _buildInvalidIndicator(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildValidIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: ResponsiveDesign.getIconSize(16),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 8),
        ],
        if (showMessage)
          Text(
            'Valid',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
          ),
      ],
    );
  }

  Widget _buildInvalidIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_rounded,
              color: Theme.of(context).colorScheme.error,
              size: ResponsiveDesign.getIconSize(16),
            ),
          ),
          ResponsiveSpacing(height: 0, width: 8),
        ],
        if (showMessage)
          Expanded(
            child: Text(
              errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
      ],
    );
  }
}

class ValidationSummaryWidget extends StatelessWidget {
  final List<String> missingFields;
  final VoidCallback? onRetry;

  const ValidationSummaryWidget({
    Key? key,
    required this.missingFields,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (missingFields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: ResponsiveDesign.getPadding(all: 16),
      padding: ResponsiveDesign.getPadding(all: 16),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: ResponsiveDesign.getIconSize(16),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: Text(
                  'Please complete the following required fields:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          ResponsiveSpacing(height: 12),
          ...missingFields
              .map((field) => _buildMissingFieldItem(context, field)),
          if (onRetry != null) ...[
            ResponsiveSpacing(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Icons.refresh_rounded,
                  size: ResponsiveDesign.getIconSize(18),
                ),
                label: const Text('Check Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  padding:
                      ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        ResponsiveDesign.getBorderRadius(8)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMissingFieldItem(BuildContext context, String field) {
    return Padding(
      padding: ResponsiveDesign.getPadding(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          ResponsiveSpacing(height: 0, width: 12),
          Expanded(
            child: Text(
              _formatFieldName(field),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFieldName(String field) {
    // Convert camelCase to readable format
    String formatted = field.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    );
    return formatted
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

class AnimatedValidationField extends StatefulWidget {
  final Widget child;
  final bool hasError;
  final String? errorMessage;
  final Duration animationDuration;

  const AnimatedValidationField({
    Key? key,
    required this.child,
    required this.hasError,
    this.errorMessage,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<AnimatedValidationField> createState() =>
      _AnimatedValidationFieldState();
}

class _AnimatedValidationFieldState extends State<AnimatedValidationField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void didUpdateWidget(AnimatedValidationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: widget.child,
        );
      },
    );
  }
}
