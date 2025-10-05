import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ModernLogoWidget extends StatefulWidget {
  const ModernLogoWidget({Key? key}) : super(key: key);

  @override
  State<ModernLogoWidget> createState() => _ModernLogoWidgetState();
}

class _ModernLogoWidgetState extends State<ModernLogoWidget> {
  // All animations removed for cleaner, accessible design

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Clean, static logo with significantly increased size and no circular background
        Center(
          child: Container(
            width: ResponsiveDesign.getIconSize(240), // Significantly increased from 180 to 240 (33% larger)
            height: ResponsiveDesign.getIconSize(240), // Significantly increased from 180 to 240 (33% larger)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
              // Completely removed all background effects for clean design
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
              child: Container(
                decoration: BoxDecoration(
                  // Removed background color for completely clean look
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(24)),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/img_app_logo.png',
                    width: ResponsiveDesign.getIconSize(200), // Significantly increased from 140 to 200 (43% larger)
                    height: ResponsiveDesign.getIconSize(200), // Significantly increased from 140 to 200 (43% larger)
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Enhanced fallback with Inter font
                      return Text(
                        'SL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3.0,
                          fontSize: ResponsiveDesign.getFontSize(80), // Increased from 56 to 80 (43% larger)
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        
        ResponsiveSpacing(height: 24),
        
        // Static STUDENTLINK title with enhanced typography (no animations)
        Text(
          'STUDENTLINK',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900, // Black weight for maximum impact
            color: Colors.white,
            letterSpacing: 3.0, // Optimized spacing
            fontSize: ResponsiveDesign.getFontSize(36), // Strong presence
            shadows: [
              Shadow(
                color: AppTheme.textPrimaryLight.withValues(alpha: 0.6), // Strong contrast
                blurRadius: 8, // Sharp text
                offset: const Offset(0, 2), // Clean shadow
              ),
            ],
          ),
        ),
        
        // Decorative line removed for cleaner design
      ],
    );
  }
}
