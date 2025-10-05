import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive_design.dart';

/// 🎯 RESPONSIVE THEME: Optimized theme with responsive sizing for all devices
class ResponsiveTheme {
  ResponsiveTheme._();

  // Colors remain the same as AppTheme
  static const Color primaryLight = Color(0xFF1E2A78);
  static const Color primaryVariantLight = Color(0xFF152055);
  static const Color secondaryLight = Color(0xFF2480EA);
  static const Color secondaryVariantLight = Color(0xFF1A66C7);
  static const Color emergencyLight = Color(0xFFE22824);
  static const Color successLight = Color(0xFF28A745);
  static const Color warningLight = Color(0xFFFFC107);
  static const Color backgroundLight = Colors.white;
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Colors.black;
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color borderSubtleLight = Color(0xFFE0E0E0);

  // Dark mode colors - Improved contrast for better visibility
  static const Color primaryDark =
      Color(0xFF4A5FCF); // Brighter primary for better contrast
  static const Color primaryVariantDark = Color(0xFF3A4FBF);
  static const Color secondaryDark = Color(0xFF4A9EFF); // Brighter secondary
  static const Color secondaryVariantDark = Color(0xFF3A8EEF);
  static const Color emergencyDark = Color(0xFFFF4444); // Brighter red
  static const Color successDark = Color(0xFF4CAF50); // Brighter green
  static const Color warningDark = Color(0xFFFFB74D); // Brighter orange
  static const Color backgroundDark =
      Color(0xFF0D1117); // Slightly lighter background
  static const Color surfaceDark = Color(0xFF161B22); // Better surface contrast
  static const Color textPrimaryDark = Color(0xFFF0F6FC); // Brighter text
  static const Color textSecondaryDark =
      Color(0xFFB1BAC4); // Better secondary text
  static const Color borderSubtleDark =
      Color(0xFF30363D); // Better border visibility
  static const Color cardDark = Color(0xFF21262D); // Better card contrast
  static const Color dialogDark = Color(0xFF21262D);
  static const Color shadowDark = Color(0x60000000); // Stronger shadows
  static const Color dividerDark = Color(0xFF30363D);

  /// 🎯 RESPONSIVE THEME: Light theme with responsive sizing
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryLight,
          onPrimary: Colors.white,
          primaryContainer: primaryVariantLight,
          onPrimaryContainer: Colors.white,
          secondary: secondaryLight,
          onSecondary: Colors.white,
          secondaryContainer: secondaryVariantLight,
          onSecondaryContainer: Colors.white,
          tertiary: successLight,
          onTertiary: Colors.white,
          tertiaryContainer: successLight.withValues(alpha: 0.1),
          onTertiaryContainer: successLight,
          error: emergencyLight,
          onError: Colors.white,
          surface: backgroundLight,
          onSurface: textPrimaryLight,
          onSurfaceVariant: textSecondaryLight,
          outline: borderSubtleLight,
          outlineVariant: borderSubtleLight.withValues(alpha: 0.5),
          shadow: Color(0x1A000000),
          scrim: Colors.black54,
          inverseSurface: Colors.black,
          onInverseSurface: Colors.white,
          inversePrimary: Color(0xFF4A5BC4),
        ),
        scaffoldBackgroundColor: backgroundLight,
        cardColor: backgroundLight,
        dividerColor: borderSubtleLight,

        // 🎯 RESPONSIVE: AppBar with responsive sizing
        appBarTheme: AppBarTheme(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 2.0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(18), // Responsive font size
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.15,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: ResponsiveDesign.getIconSize(20), // Responsive icon size
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
            size: ResponsiveDesign.getIconSize(20),
          ),
          toolbarHeight:
              ResponsiveDesign.getButtonHeight() + 8, // Responsive height
        ),

        // 🎯 RESPONSIVE: Card theme with responsive sizing
        cardTheme: CardThemeData(
          color: backgroundLight,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
          margin: ResponsiveDesign.getMargin(horizontal: 12, vertical: 6),
        ),

        // 🎯 RESPONSIVE: Bottom navigation with responsive sizing
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: backgroundLight,
          selectedItemColor: primaryLight,
          unselectedItemColor: textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w500,
          ),
        ),

        // 🎯 RESPONSIVE: Floating action button with responsive sizing
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: emergencyLight,
          foregroundColor: Colors.white,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),

        // 🎯 RESPONSIVE: Button themes with responsive sizing
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryLight,
            elevation: 0.0,
            minimumSize:
                Size(double.infinity, ResponsiveDesign.getButtonHeight()),
            padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(14),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ).copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) return 0.0;
              if (states.contains(WidgetState.hovered)) return 4.0;
              return 2.0;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return primaryVariantLight;
              }
              if (states.contains(WidgetState.hovered)) {
                return primaryLight.withValues(alpha: 0.9);
              }
              return primaryLight;
            }),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryLight,
            minimumSize:
                Size(double.infinity, ResponsiveDesign.getButtonHeight()),
            padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
            side: BorderSide(color: primaryLight, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(14),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryLight,
            padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(13),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),

        // 🎯 RESPONSIVE: Typography with responsive sizing
        textTheme: _buildResponsiveTextTheme(),

        // 🎯 RESPONSIVE: Input decoration with responsive sizing
        inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceLight,
          filled: true,
          contentPadding:
              ResponsiveDesign.getPadding(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: borderSubtleLight, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: borderSubtleLight, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: primaryLight, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: emergencyLight, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: emergencyLight, width: 2.0),
          ),
          labelStyle: GoogleFonts.inter(
            color: textSecondaryLight,
            fontSize: ResponsiveDesign.getFontSize(14),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.inter(
            color: textSecondaryLight.withValues(alpha: 0.7),
            fontSize: ResponsiveDesign.getFontSize(14),
            fontWeight: FontWeight.w400,
          ),
          errorStyle: GoogleFonts.inter(
            color: emergencyLight,
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w500,
          ),
        ),

        // 🎯 RESPONSIVE: Other interactive elements
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryLight;
            }
            return const Color(0xFF300300300);
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryLight.withValues(alpha: 0.5);
            }
            return const Color(0xFF300300300);
          }),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryLight;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: borderSubtleLight, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryLight;
            }
            return borderSubtleLight;
          }),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: primaryLight,
          linearTrackColor: borderSubtleLight,
          circularTrackColor: borderSubtleLight,
        ),

        sliderTheme: SliderThemeData(
          activeTrackColor: primaryLight,
          thumbColor: primaryLight,
          overlayColor: primaryLight.withValues(alpha: 0.2),
          inactiveTrackColor: borderSubtleLight,
          trackHeight: 4.0,
        ),

        tabBarTheme: TabBarThemeData(
          labelColor: primaryLight,
          unselectedLabelColor: textSecondaryLight,
          indicatorColor: primaryLight,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(13),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(13),
            fontWeight: FontWeight.w400,
          ),
        ),

        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: textPrimaryLight.withValues(alpha: 0.9),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
          ),
          textStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w400,
          ),
          padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 6),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: textPrimaryLight,
          contentTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveDesign.getFontSize(13),
            fontWeight: FontWeight.w400,
          ),
          actionTextColor: secondaryLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
          ),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: surfaceLight,
          selectedColor: primaryLight.withValues(alpha: 0.1),
          labelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w500,
          ),
          padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),
      );

  /// 🎯 RESPONSIVE: Build responsive text theme
  static TextTheme _buildResponsiveTextTheme() {
    return TextTheme(
      // Display styles - responsive sizing
      displayLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(32),
        fontWeight: FontWeight.w700,
        color: textPrimaryLight,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(28),
        fontWeight: FontWeight.w700,
        color: textPrimaryLight,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(24),
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - responsive sizing
      headlineLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(22),
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(20),
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(18),
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - responsive sizing
      titleLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(16),
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(14),
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(13),
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - responsive sizing
      bodyLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(14),
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(13),
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(11),
        fontWeight: FontWeight.w400,
        color: textSecondaryLight,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - responsive sizing
      labelLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(13),
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(11),
        fontWeight: FontWeight.w500,
        color: textSecondaryLight,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(10),
        fontWeight: FontWeight.w400,
        color: textSecondaryLight.withValues(alpha: 0.6),
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// 🎯 RESPONSIVE THEME: Dark theme with responsive sizing
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryDark,
          onPrimary: Colors.white,
          primaryContainer: primaryVariantDark,
          onPrimaryContainer: Colors.white,
          secondary: secondaryDark,
          onSecondary: Colors.white,
          secondaryContainer: secondaryVariantDark,
          onSecondaryContainer: Colors.white,
          tertiary: successDark,
          onTertiary: Colors.white,
          tertiaryContainer: successDark.withValues(alpha: 0.2),
          onTertiaryContainer: successDark,
          error: emergencyDark,
          onError: Colors.white,
          surface: backgroundDark,
          onSurface: textPrimaryDark,
          onSurfaceVariant: textSecondaryDark,
          outline: borderSubtleDark,
          outlineVariant: borderSubtleDark.withValues(alpha: 0.5),
          shadow: shadowDark,
          scrim: Colors.black87,
          inverseSurface: surfaceLight,
          onInverseSurface: textPrimaryLight,
          inversePrimary: primaryLight,
        ),
        scaffoldBackgroundColor: backgroundDark,
        cardColor: cardDark,
        dividerColor: dividerDark,

        // AppBar theme for dark mode
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: textPrimaryDark,
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(18),
            fontWeight: FontWeight.w600,
            color: textPrimaryDark,
            letterSpacing: 0.15,
          ),
          iconTheme: IconThemeData(
            color: textPrimaryDark,
            size: ResponsiveDesign.getIconSize(20),
          ),
          actionsIconTheme: IconThemeData(
            color: textPrimaryDark,
            size: ResponsiveDesign.getIconSize(20),
          ),
          toolbarHeight: ResponsiveDesign.getButtonHeight() + 8,
        ),

        // Card theme for dark mode
        cardTheme: CardThemeData(
          color: cardDark,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
          margin: ResponsiveDesign.getMargin(horizontal: 12, vertical: 6),
        ),

        // Bottom navigation for dark mode
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: primaryDark,
          unselectedItemColor: textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w500,
          ),
        ),

        // Floating action button for dark mode
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: emergencyDark,
          foregroundColor: Colors.white,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),

        // Button themes for dark mode
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryDark,
            elevation: 0.0,
            minimumSize:
                Size(double.infinity, ResponsiveDesign.getButtonHeight()),
            padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(14),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ).copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) return 0.0;
              if (states.contains(WidgetState.hovered)) return 4.0;
              return 2.0;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return primaryVariantDark;
              }
              if (states.contains(WidgetState.hovered)) {
                return primaryDark.withValues(alpha: 0.9);
              }
              return primaryDark;
            }),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryDark,
            minimumSize:
                Size(double.infinity, ResponsiveDesign.getButtonHeight()),
            padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 12),
            side: BorderSide(color: primaryDark, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(14),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryDark,
            padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(13),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),

        // Typography for dark mode
        textTheme: _buildResponsiveDarkTextTheme(),

        // Input decoration for dark mode
        inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceDark,
          filled: true,
          contentPadding:
              ResponsiveDesign.getPadding(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: borderSubtleDark, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: borderSubtleDark, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: primaryDark, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: emergencyDark, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            borderSide: BorderSide(color: emergencyDark, width: 2.0),
          ),
          labelStyle: GoogleFonts.inter(
            color: textSecondaryDark,
            fontSize: ResponsiveDesign.getFontSize(14),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.inter(
            color: textSecondaryDark.withValues(alpha: 0.7),
            fontSize: ResponsiveDesign.getFontSize(14),
            fontWeight: FontWeight.w400,
          ),
          errorStyle: GoogleFonts.inter(
            color: emergencyDark,
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w500,
          ),
        ),

        // Interactive elements for dark mode
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryDark;
            }
            return borderSubtleDark;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryDark.withValues(alpha: 0.5);
            }
            return borderSubtleDark;
          }),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryDark;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: borderSubtleDark, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryDark;
            }
            return borderSubtleDark;
          }),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: primaryDark,
          linearTrackColor: borderSubtleDark,
          circularTrackColor: borderSubtleDark,
        ),

        sliderTheme: SliderThemeData(
          activeTrackColor: primaryDark,
          thumbColor: primaryDark,
          overlayColor: primaryDark.withValues(alpha: 0.2),
          inactiveTrackColor: borderSubtleDark,
          trackHeight: 4.0,
        ),

        tabBarTheme: TabBarThemeData(
          labelColor: primaryDark,
          unselectedLabelColor: textSecondaryDark,
          indicatorColor: primaryDark,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(13),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(13),
            fontWeight: FontWeight.w400,
          ),
        ),

        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(6)),
          ),
          textStyle: GoogleFonts.inter(
            color: textPrimaryDark,
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w400,
          ),
          padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 6),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: surfaceDark,
          contentTextStyle: GoogleFonts.inter(
            color: textPrimaryDark,
            fontSize: ResponsiveDesign.getFontSize(13),
            fontWeight: FontWeight.w400,
          ),
          actionTextColor: primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
          ),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: surfaceDark,
          selectedColor: primaryDark.withValues(alpha: 0.1),
          labelStyle: GoogleFonts.inter(
            fontSize: ResponsiveDesign.getFontSize(11),
            fontWeight: FontWeight.w600,
            color: textPrimaryDark,
          ),
          padding: ResponsiveDesign.getPadding(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: dialogDark,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          ),
        ),
      );

  /// Build responsive dark text theme
  static TextTheme _buildResponsiveDarkTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(32),
        fontWeight: FontWeight.w700,
        color: textPrimaryDark,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(28),
        fontWeight: FontWeight.w700,
        color: textPrimaryDark,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(24),
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(22),
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(20),
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(18),
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(16),
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(14),
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(13),
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(14),
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(13),
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(11),
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(13),
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(11),
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(10),
        fontWeight: FontWeight.w400,
        color: textSecondaryDark.withValues(alpha: 0.6),
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}
