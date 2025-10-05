import 'package:flutter/material.dart';
import '../utils/responsive_layout_helper.dart';

/// 🎯 RESPONSIVE WIDGETS: Pre-built responsive widgets for consistent sizing

/// Responsive button that adapts to screen size
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool isOutlined;
  final bool isTextButton;
  final Widget? icon;
  final bool isLoading;
  final double? width;
  final double? height;

  const ResponsiveButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style,
    this.isOutlined = false,
    this.isTextButton = false,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutHelper.responsiveButton(
      text: text,
      onPressed: onPressed,
      style: style,
      isOutlined: isOutlined,
      isTextButton: isTextButton,
      icon: icon,
      isLoading: isLoading,
      width: width,
      height: height,
    );
  }
}

/// Responsive text input field
class ResponsiveTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final double? height;

  const ResponsiveTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutHelper.responsiveTextField(
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      readOnly: readOnly,
      height: height,
    );
  }
}

/// Responsive card widget
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final double? borderRadius;

  const ResponsiveCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutHelper.responsiveCard(
      child: child,
      padding: padding,
      margin: margin,
      color: color,
      elevation: elevation,
      onTap: onTap,
      borderRadius: borderRadius,
    );
  }
}

/// Responsive icon button
class ResponsiveIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;
  final double? size;

  const ResponsiveIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutHelper.responsiveIconButton(
      icon: icon,
      onPressed: onPressed,
      color: color,
      backgroundColor: backgroundColor,
      tooltip: tooltip,
      size: size,
    );
  }
}

/// Responsive text widget
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const ResponsiveText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutHelper.responsiveText(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

/// Responsive spacing widget
class ResponsiveSpacing extends StatelessWidget {
  final double height;
  final double? width;

  const ResponsiveSpacing({
    Key? key,
    required this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutHelper.responsiveSpacing(
      height: height,
      width: width,
    );
  }
}

/// Responsive container with consistent padding
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final BoxBorder? border;
  final double? maxWidth;
  final List<BoxShadow>? boxShadow;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.maxWidth,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutHelper.responsiveContainer(
      child: child,
      maxWidth: maxWidth,
      padding: padding,
      margin: margin,
      color: color,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );
  }
}
