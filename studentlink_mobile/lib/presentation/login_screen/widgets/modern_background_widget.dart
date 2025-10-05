import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'dart:async';

class ModernBackgroundWidget extends StatefulWidget {
  const ModernBackgroundWidget({Key? key}) : super(key: key);

  @override
  State<ModernBackgroundWidget> createState() => _ModernBackgroundWidgetState();
}

class _ModernBackgroundWidgetState extends State<ModernBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _parallaxController;
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _parallaxAnimation;
  late Animation<double> _transitionAnimation;
  Timer? _autoSlideTimer;
  int _currentIndex = 0;
  int _nextIndex = 1;

  // Campus images with their corresponding color themes
  final List<CampusImage> _campusImages = [
    CampusImage(
      path: 'assets/images/Picsart_25-09-29_11-10-13-448.jpg',
      primaryColor: Color(0xFF1E2A78), // Deep blue
      secondaryColor: Color(0xFF2480EA), // Light blue
      accentColor: Color(0xFFE22824), // Red
    ),
    CampusImage(
      path: 'assets/images/Picsart_25-09-29_11-16-33-474.jpg',
      primaryColor: Color(0xFF1E2A78), // Deep blue
      secondaryColor: Color(0xFF2480EA), // Light blue
      accentColor: Color(0xFFFF69B4), // Pink
    ),
    CampusImage(
      path: 'assets/images/Picsart_25-09-29_11-16-46-461.jpg',
      primaryColor: Color(0xFF1E2A78), // Deep blue
      secondaryColor: Color(0xFF2480EA), // Light blue
      accentColor: Color(0xFFFFD700), // Yellow
    ),
    CampusImage(
      path: 'assets/images/Picsart_25-09-29_11-23-19-880.jpg',
      primaryColor: Color(0xFF1E2A78), // Deep blue
      secondaryColor: Color(0xFF2480EA), // Light blue
      accentColor: Color(0xFF32CD32), // Green
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _parallaxController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _parallaxAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _parallaxController,
      curve: Curves.linear,
    ));

    _transitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    _parallaxController.repeat();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _nextIndex = (_currentIndex + 1) % _campusImages.length;
      _transitionController.forward().then((_) {
        setState(() {
          _currentIndex = _nextIndex;
        });
        _transitionController.reset();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _parallaxController.dispose();
    _transitionController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                 children: [
                   // Fade transition carousel
                   Positioned.fill(
                     child: AnimatedBuilder(
                       animation: _transitionAnimation,
                       builder: (context, child) {
                         return Stack(
                           children: [
                             // Current image
                             _buildImageSlide(_campusImages[_currentIndex]),
                             
                             // Next image with fade transition
                             if (_transitionAnimation.value > 0)
                               Opacity(
                                 opacity: _transitionAnimation.value,
                                 child: _buildImageSlide(_campusImages[_nextIndex]),
                               ),
                           ],
                         );
                       },
                     ),
                   ),
                  
                  // Gradient overlay for better text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.textPrimaryLight.withValues(alpha: 0.3),
                            AppTheme.textPrimaryLight.withValues(alpha: 0.5),
                            AppTheme.textPrimaryLight.withValues(alpha: 0.7),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // Geometric patterns completely removed for cleaner design
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSlide(CampusImage campusImage) {
    return AnimatedBuilder(
      animation: Listenable.merge([_parallaxAnimation, _transitionAnimation]),
      builder: (context, child) {
        final offset = _parallaxAnimation.value * 20;
        final scale = 0.98 + (0.02 * (1 - _transitionAnimation.value));
        
        return Transform.translate(
          offset: Offset(offset, -offset * 0.5),
          child: Transform.scale(
            scale: scale,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(campusImage.path),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        campusImage.primaryColor.withValues(alpha: 0.1),
                        campusImage.secondaryColor.withValues(alpha: 0.05),
                        campusImage.accentColor.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

class CampusImage {
  final String path;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  CampusImage({
    required this.path,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });
}

// Geometric pattern painter removed for cleaner design
