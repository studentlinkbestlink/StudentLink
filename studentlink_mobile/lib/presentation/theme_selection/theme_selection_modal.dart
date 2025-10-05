import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/theme_provider.dart';
import '../../utils/responsive_design.dart';
import '../../widgets/responsive_widgets.dart';

class ThemeSelectionModal extends StatefulWidget {
  const ThemeSelectionModal({Key? key}) : super(key: key);

  @override
  State<ThemeSelectionModal> createState() => _ThemeSelectionModalState();
}

class _ThemeSelectionModalState extends State<ThemeSelectionModal>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: 90.w,
              constraints: BoxConstraints(
                maxHeight: 70.h,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  _buildHeader(),
                  
                  // Content
                  _buildContent(),
                  
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 5.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveDesign.getBorderRadius(20)),
          topRight: Radius.circular(ResponsiveDesign.getBorderRadius(20)),
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: ResponsiveDesign.getPadding(all: 3.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
            ),
            child: Icon(
              Icons.palette_rounded,
              color: Colors.white,
              size: ResponsiveDesign.getIconSize(32),
            ),
          ),
          
          ResponsiveSpacing(height: 16),
          
          // Title
          Text(
            'Choose Your Experience',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          ResponsiveSpacing(height: 8),
          
          // Subtitle
          Text(
            'Select the theme that works best for you',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 5.w, vertical: 3.h),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Column(
            children: [
              // Theme Options
              _buildThemeOption(
                context,
                'Light Mode',
                'Clean and professional',
                'Perfect for daytime use',
                Icons.light_mode_rounded,
                ThemeMode.light,
                themeProvider,
                Colors.amber,
              ),
              
              ResponsiveSpacing(height: 16),
              
              _buildThemeOption(
                context,
                'Dark Mode',
                'Easy on the eyes',
                'Great for low-light environments',
                Icons.dark_mode_rounded,
                ThemeMode.dark,
                themeProvider,
                Colors.indigo,
              ),
              
              ResponsiveSpacing(height: 16),
              
              _buildThemeOption(
                context,
                'System Default',
                'Follows your device',
                'Automatically switches with your phone',
                Icons.brightness_auto_rounded,
                ThemeMode.system,
                themeProvider,
                Colors.purple,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    IconData icon,
    ThemeMode mode,
    ThemeProvider themeProvider,
    Color accentColor,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        themeProvider.setThemeMode(mode);
        _closeModal();
      },
      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: ResponsiveDesign.getPadding(all: 4.w),
        decoration: BoxDecoration(
          color: isSelected 
            ? accentColor.withValues(alpha: 0.1)
            : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
          border: Border.all(
            color: isSelected 
              ? accentColor
              : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: ResponsiveDesign.getPadding(all: 3.w),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: ResponsiveDesign.getIconSize(24),
              ),
            ),
            
            ResponsiveSpacing(height: 0, width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected 
                        ? accentColor
                        : Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 4),
                  
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  
                  ResponsiveSpacing(height: 2),
                  
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              Container(
                padding: ResponsiveDesign.getPadding(all: 2.w),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: ResponsiveDesign.getIconSize(16),
                ),
              )
            else
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: ResponsiveDesign.getPadding(horizontal: 5.w, vertical: 2.h),
      child: Column(
        children: [
          // Skip button
          TextButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              _closeModal();
            },
            child: Text(
              'Skip for now - you can change this anytime in settings',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _closeModal() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}
