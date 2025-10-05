import 'package:flutter/material.dart';

/// 🎯 RESPONSIVE DESIGN: Smart scaling system that adapts to different screen sizes and densities
/// This ensures UI elements are appropriately sized for all devices, especially small screens < 550dp
class ResponsiveDesign {
  ResponsiveDesign._();

  /// Get screen width in logical pixels
  static double get screenWidth {
    final context = WidgetsBinding.instance.platformDispatcher.views.first;
    return context.physicalSize.width / context.devicePixelRatio;
  }

  /// Get screen height in logical pixels
  static double get screenHeight {
    final context = WidgetsBinding.instance.platformDispatcher.views.first;
    return context.physicalSize.height / context.devicePixelRatio;
  }

  /// Check if device is very small screen (< 360dp)
  static bool get isVerySmallScreen => screenWidth < 360;

  /// Check if device is small screen (< 550dp)
  static bool get isSmallScreen => screenWidth < 550;

  /// Check if device is medium screen (550dp - 768dp)
  static bool get isMediumScreen => screenWidth >= 550 && screenWidth < 768;

  /// Check if device is large screen (>= 768dp)
  static bool get isLargeScreen => screenWidth >= 768;

  /// Get responsive font size based on screen size and device density
  static double getFontSize(double baseSize) {
    double scaleFactor = 1.0;
    
    // More aggressive scaling for small screens
    if (isVerySmallScreen) {
      // Very small screens (< 360dp) - significant reduction
      scaleFactor = 0.75;
    } else if (isSmallScreen) {
      // Small screens (< 550dp) - moderate reduction
      scaleFactor = 0.85;
    } else if (isMediumScreen) {
      // Medium screens - slight reduction
      scaleFactor = 0.95;
    } else if (isLargeScreen) {
      // Large screens - increase size slightly
      scaleFactor = 1.1;
    }
    
    // Adjust based on device density
    final context = WidgetsBinding.instance.platformDispatcher.views.first;
    final devicePixelRatio = context.devicePixelRatio;
    if (devicePixelRatio > 3.0) {
      // High density screens - reduce size to prevent oversized elements
      scaleFactor *= 0.9;
    } else if (devicePixelRatio < 2.0) {
      // Low density screens - increase size slightly
      scaleFactor *= 1.05;
    }
    
    return (baseSize * scaleFactor).clamp(8.0, 32.0);
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getPadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    double scaleFactor = 1.0;
    
    // More aggressive scaling for small screens
    if (isVerySmallScreen) {
      scaleFactor = 0.6; // Much smaller padding for very small screens
    } else if (isSmallScreen) {
      scaleFactor = 0.75; // Smaller padding for small screens
    } else if (isMediumScreen) {
      scaleFactor = 0.9; // Slightly smaller padding for medium screens
    } else if (isLargeScreen) {
      scaleFactor = 1.2; // Larger padding for large screens
    }
    
    return EdgeInsets.only(
      top: (top ?? vertical ?? all ?? 0) * scaleFactor,
      bottom: (bottom ?? vertical ?? all ?? 0) * scaleFactor,
      left: (left ?? horizontal ?? all ?? 0) * scaleFactor,
      right: (right ?? horizontal ?? all ?? 0) * scaleFactor,
    );
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    double scaleFactor = 1.0;
    
    // More aggressive scaling for small screens
    if (isVerySmallScreen) {
      scaleFactor = 0.6; // Much smaller margins for very small screens
    } else if (isSmallScreen) {
      scaleFactor = 0.75; // Smaller margins for small screens
    } else if (isMediumScreen) {
      scaleFactor = 0.9; // Slightly smaller margins for medium screens
    } else if (isLargeScreen) {
      scaleFactor = 1.2; // Larger margins for large screens
    }
    
    return EdgeInsets.only(
      top: (top ?? vertical ?? all ?? 0) * scaleFactor,
      bottom: (bottom ?? vertical ?? all ?? 0) * scaleFactor,
      left: (left ?? horizontal ?? all ?? 0) * scaleFactor,
      right: (right ?? horizontal ?? all ?? 0) * scaleFactor,
    );
  }

  /// Get responsive border radius
  static double getBorderRadius(double baseRadius) {
    double scaleFactor = 1.0;
    
    // More aggressive scaling for small screens
    if (isVerySmallScreen) {
      scaleFactor = 0.7; // Smaller border radius for very small screens
    } else if (isSmallScreen) {
      scaleFactor = 0.8; // Smaller border radius for small screens
    } else if (isMediumScreen) {
      scaleFactor = 0.9; // Slightly smaller border radius for medium screens
    } else if (isLargeScreen) {
      scaleFactor = 1.2; // Larger border radius for large screens
    }
    
    return (baseRadius * scaleFactor).clamp(2.0, 32.0);
  }

  /// Get responsive icon size
  static double getIconSize(double baseSize) {
    double scaleFactor = 1.0;
    
    // More aggressive scaling for small screens
    if (isVerySmallScreen) {
      scaleFactor = 0.7; // Smaller icons for very small screens
    } else if (isSmallScreen) {
      scaleFactor = 0.8; // Smaller icons for small screens
    } else if (isMediumScreen) {
      scaleFactor = 0.9; // Slightly smaller icons for medium screens
    } else if (isLargeScreen) {
      scaleFactor = 1.1; // Larger icons for large screens
    }
    
    return (baseSize * scaleFactor).clamp(12.0, 40.0);
  }

  /// Get responsive button height
  static double getButtonHeight() {
    if (isVerySmallScreen) {
      return 36.0; // Much smaller buttons for very small screens
    } else if (isSmallScreen) {
      return 40.0; // Smaller buttons for small screens
    } else if (isMediumScreen) {
      return 44.0; // Medium buttons for medium screens
    } else if (isLargeScreen) {
      return 56.0; // Larger buttons for large screens
    }
    return 48.0; // Standard button height
  }

  /// Get responsive input field height
  static double getInputHeight() {
    if (isVerySmallScreen) {
      return 36.0; // Much smaller input fields for very small screens
    } else if (isSmallScreen) {
      return 40.0; // Smaller input fields for small screens
    } else if (isMediumScreen) {
      return 44.0; // Medium input fields for medium screens
    } else if (isLargeScreen) {
      return 56.0; // Larger input fields for large screens
    }
    return 50.0; // Standard input height
  }

  /// Get responsive spacing
  static double getSpacing(double baseSpacing) {
    double scaleFactor = 1.0;
    
    // More aggressive scaling for small screens
    if (isVerySmallScreen) {
      scaleFactor = 0.6; // Much smaller spacing for very small screens
    } else if (isSmallScreen) {
      scaleFactor = 0.75; // Smaller spacing for small screens
    } else if (isMediumScreen) {
      scaleFactor = 0.9; // Slightly smaller spacing for medium screens
    } else if (isLargeScreen) {
      scaleFactor = 1.2; // Larger spacing for large screens
    }
    
    return baseSpacing * scaleFactor;
  }

  /// Get responsive container width (for cards, modals, etc.)
  static double getContainerWidth(double baseWidth) {
    if (isVerySmallScreen) {
      return screenWidth * 0.95; // Use 95% of screen width for very small screens
    } else if (isSmallScreen) {
      return screenWidth * 0.9; // Use 90% of screen width for small screens
    } else if (isMediumScreen) {
      return baseWidth * 0.9; // Slightly smaller for medium screens
    } else if (isLargeScreen) {
      return baseWidth * 1.1; // Larger for large screens
    }
    return baseWidth;
  }

  /// Get responsive max width for content
  static double getMaxContentWidth() {
    if (isVerySmallScreen) {
      return screenWidth * 0.95;
    } else if (isSmallScreen) {
      return screenWidth * 0.9;
    } else if (isMediumScreen) {
      return screenWidth * 0.85;
    } else {
      return 600.0; // Max width for large screens
    }
  }

  /// Get responsive horizontal padding for screens
  static double getScreenHorizontalPadding() {
    if (isVerySmallScreen) {
      return 8.0; // Minimal padding for very small screens
    } else if (isSmallScreen) {
      return 12.0; // Small padding for small screens
    } else if (isMediumScreen) {
      return 16.0; // Medium padding for medium screens
    } else {
      return 20.0; // Standard padding for large screens
    }
  }

  /// Get responsive vertical padding for screens
  static double getScreenVerticalPadding() {
    if (isVerySmallScreen) {
      return 8.0; // Minimal padding for very small screens
    } else if (isSmallScreen) {
      return 12.0; // Small padding for small screens
    } else if (isMediumScreen) {
      return 16.0; // Medium padding for medium screens
    } else {
      return 20.0; // Standard padding for large screens
    }
  }
}

/// 🎯 RESPONSIVE DESIGN: Extension methods for easy responsive sizing
/// Note: Removed .w and .sp extensions to avoid conflicts with SizerExt
extension ResponsiveExtensions on num {
  /// Get responsive padding
  EdgeInsets get p => ResponsiveDesign.getPadding(all: toDouble());
  
  /// Get responsive margin
  EdgeInsets get m => ResponsiveDesign.getMargin(all: toDouble());
  
  /// Get responsive border radius
  double get r => ResponsiveDesign.getBorderRadius(toDouble());
  
  /// Get responsive icon size
  double get i => ResponsiveDesign.getIconSize(toDouble());
  
  /// Get responsive spacing
  double get s => ResponsiveDesign.getSpacing(toDouble());
  
  /// Get responsive button height
  double get bh => ResponsiveDesign.getButtonHeight();
  
  /// Get responsive input height
  double get ih => ResponsiveDesign.getInputHeight();
}

/// 🎯 RESPONSIVE DESIGN: Extension methods for EdgeInsets
extension ResponsiveEdgeInsets on EdgeInsets {
  /// Get responsive padding
  static EdgeInsets responsive({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) => ResponsiveDesign.getPadding(
    all: all,
    horizontal: horizontal,
    vertical: vertical,
    top: top,
    bottom: bottom,
    left: left,
    right: right,
  );
  
  /// Get responsive margin
  static EdgeInsets responsiveMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) => ResponsiveDesign.getMargin(
    all: all,
    horizontal: horizontal,
    vertical: vertical,
    top: top,
    bottom: bottom,
    left: left,
    right: right,
  );
}

/// 🎯 RESPONSIVE DESIGN: Responsive text style builder
class ResponsiveTextStyle {
  static TextStyle get({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: ResponsiveDesign.getFontSize(fontSize),
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }
}

/// 🎯 RESPONSIVE DESIGN: Responsive button style builder
class ResponsiveButtonStyle {
  static ButtonStyle get({
    required Color backgroundColor,
    required Color foregroundColor,
    double? height,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      minimumSize: Size(double.infinity, height ?? ResponsiveDesign.getButtonHeight()),
      padding: padding ?? ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveDesign.getBorderRadius(12),
        ),
      ),
    );
  }
}

/// 🎯 RESPONSIVE DESIGN: Responsive input decoration builder
class ResponsiveInputDecoration {
  static InputDecoration get({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: fillColor,
      filled: true,
      contentPadding: contentPadding ?? ResponsiveDesign.getPadding(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveDesign.getBorderRadius(12),
        ),
        borderSide: BorderSide(color: borderColor ?? const Color(0xFF757575)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveDesign.getBorderRadius(12),
        ),
        borderSide: BorderSide(color: borderColor ?? const Color(0xFF757575)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveDesign.getBorderRadius(12),
        ),
        borderSide: BorderSide(color: borderColor ?? const Color(0xFF1E2A78), width: 2),
      ),
    );
  }
}
