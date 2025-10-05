import 'package:flutter/material.dart';
import 'responsive_design.dart';

/// 🎯 RESPONSIVE LAYOUT HELPER: Comprehensive layout utilities for responsive design
/// This class provides easy-to-use methods for creating responsive layouts
class ResponsiveLayoutHelper {
  ResponsiveLayoutHelper._();

  /// Create a responsive container with proper constraints
  static Widget responsiveContainer({
    required Widget child,
    double? maxWidth,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? borderRadius,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? ResponsiveDesign.getMaxContentWidth(),
      ),
      padding: padding ?? ResponsiveDesign.getPadding(all: 16),
      margin: margin ?? ResponsiveDesign.getMargin(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveDesign.getBorderRadius(12),
        ),
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }

  /// Create a responsive card with proper sizing
  static Widget responsiveCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? elevation,
    VoidCallback? onTap,
    double? borderRadius,
  }) {
    Widget card = Card(
      color: color,
      elevation: elevation ?? 0,
      margin: margin ?? ResponsiveDesign.getMargin(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveDesign.getBorderRadius(12),
        ),
      ),
      child: Padding(
        padding: padding ?? ResponsiveDesign.getPadding(all: 16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveDesign.getBorderRadius(12),
        ),
        child: card,
      );
    }

    return card;
  }

  /// Create a responsive button with proper sizing
  static Widget responsiveButton({
    required String text,
    required VoidCallback? onPressed,
    ButtonStyle? style,
    bool isOutlined = false,
    bool isTextButton = false,
    Widget? icon,
    bool isLoading = false,
    double? width,
    double? height,
  }) {
    final buttonHeight = height ?? ResponsiveDesign.getButtonHeight();
    
    Widget button;
    
    if (isTextButton) {
      button = TextButton(
        onPressed: isLoading ? null : onPressed,
        style: style ?? TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: Size(width ?? double.infinity, buttonHeight),
          padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
        ),
        child: _buildButtonContent(text, icon, isLoading),
      );
    } else if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ?? OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: Size(width ?? double.infinity, buttonHeight),
          padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
          side: BorderSide(width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
        ),
        child: _buildButtonContent(text, icon, isLoading),
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ?? ElevatedButton.styleFrom(
          minimumSize: Size(width ?? double.infinity, buttonHeight),
          padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
        ),
        child: _buildButtonContent(text, icon, isLoading),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: button,
    );
  }

  /// Create a responsive text field with proper sizing
  static Widget responsiveTextField({
    String? label,
    String? hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    int? maxLines,
    int? minLines,
    bool enabled = true,
    bool readOnly = false,
    double? height,
  }) {
    final fieldHeight = height ?? ResponsiveDesign.getInputHeight();
    
    return SizedBox(
      height: maxLines != null && maxLines > 1 ? null : fieldHeight,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        maxLines: maxLines,
        minLines: minLines,
        enabled: enabled,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: ResponsiveDesign.getFontSize(14),
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hint ?? '',
          labelText: label,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          contentPadding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
        ),
      ),
    );
  }

  /// Create a responsive spacing widget
  static Widget responsiveSpacing({
    required double height,
    double? width,
  }) {
    return SizedBox(
      height: ResponsiveDesign.getSpacing(height),
      width: width != null ? ResponsiveDesign.getSpacing(width) : null,
    );
  }

  /// Create a responsive icon button
  static Widget responsiveIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
    Color? backgroundColor,
    String? tooltip,
    double? size,
  }) {
    final iconSize = size ?? ResponsiveDesign.getIconSize(20);
    
    Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
        color: color,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
  }

  /// Create a responsive text widget
  static Widget responsiveText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return Text(
      text,
      style: style ?? TextStyle(
        fontSize: fontSize != null 
          ? ResponsiveDesign.getFontSize(fontSize) 
          : ResponsiveDesign.getFontSize(14),
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Create a responsive screen wrapper with proper padding
  static Widget responsiveScreenWrapper({
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool scrollable = true,
    ScrollPhysics? physics,
  }) {
    final screenPadding = padding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveDesign.getScreenHorizontalPadding(),
      vertical: ResponsiveDesign.getScreenVerticalPadding(),
    );

    if (scrollable) {
      return SingleChildScrollView(
        physics: physics ?? const BouncingScrollPhysics(),
        padding: screenPadding,
        child: child,
      );
    }

    return Padding(
      padding: screenPadding,
      child: child,
    );
  }

  /// Create a responsive grid layout
  static Widget responsiveGrid({
    required List<Widget> children,
    int? crossAxisCount,
    double? childAspectRatio,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
  }) {
    int columns = crossAxisCount ?? _getResponsiveColumns();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: childAspectRatio ?? 1.0,
        crossAxisSpacing: crossAxisSpacing ?? ResponsiveDesign.getSpacing(12),
        mainAxisSpacing: mainAxisSpacing ?? ResponsiveDesign.getSpacing(12),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  /// Create a responsive list layout
  static Widget responsiveList({
    required List<Widget> children,
    double? spacing,
    bool shrinkWrap = true,
    ScrollPhysics? physics,
  }) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      separatorBuilder: (context, index) => SizedBox(
        height: spacing ?? ResponsiveDesign.getSpacing(12),
      ),
      itemBuilder: (context, index) => children[index],
    );
  }

  /// Get responsive number of columns for grid
  static int _getResponsiveColumns() {
    if (ResponsiveDesign.isVerySmallScreen) {
      return 1; // Single column for very small screens
    } else if (ResponsiveDesign.isSmallScreen) {
      return 2; // Two columns for small screens
    } else if (ResponsiveDesign.isMediumScreen) {
      return 3; // Three columns for medium screens
    } else {
      return 4; // Four columns for large screens
    }
  }

  /// Build button content helper
  static Widget _buildButtonContent(String text, Widget? icon, bool isLoading) {
    if (isLoading) {
      return SizedBox(
        height: ResponsiveDesign.getIconSize(16),
        width: ResponsiveDesign.getIconSize(16),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: ResponsiveDesign.getSpacing(8)),
          Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveDesign.getFontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: ResponsiveDesign.getFontSize(14),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
