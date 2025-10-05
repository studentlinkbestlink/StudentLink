import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class TermsOfServiceWidget extends StatefulWidget {
  const TermsOfServiceWidget({Key? key}) : super(key: key);

  @override
  State<TermsOfServiceWidget> createState() => _TermsOfServiceWidgetState();
}

class _TermsOfServiceWidgetState extends State<TermsOfServiceWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildModernAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildContent(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: Text(
        'Terms of Service',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
          size: ResponsiveDesign.getIconSize(20),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: ResponsiveDesign.getPadding(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveSpacing(height: 24),

            // Modern Header
            _buildModernHeader(),

            ResponsiveSpacing(height: 32),

            // Terms Content
            _buildTermsContent(),

            ResponsiveSpacing(height: 32),

            // Modern Footer
            _buildModernFooter(),

            ResponsiveSpacing(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(all: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: ResponsiveDesign.getPadding(all: 16),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(32),
            ),
          ),
          ResponsiveSpacing(height: 20),
          Text(
            'StudentLink Terms of Service',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).textTheme.headlineSmall?.color,
                  letterSpacing: 0.5,
                ),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing(height: 12),
          Container(
            padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Last Updated: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsContent() {
    return Column(
      children: [
        _buildModernSection(
          '1. Acceptance of Terms',
          'By accessing and using the StudentLink mobile application, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to abide by the above, please do not use this service.',
          Icons.check_circle_outline_rounded,
        ),
        _buildModernSection(
          '2. Description of Service',
          'StudentLink is a comprehensive digital platform designed for Bestlink College of the Philippines. The service enables students to submit academic and administrative concerns, track their status, communicate with department heads, access announcements, and utilize various educational tools and resources.',
          Icons.school_rounded,
        ),
        _buildModernSection(
          '3. User Accounts and Registration',
          'To use StudentLink, you must create an account with accurate and complete information. You are responsible for:\n\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use\n• Ensuring your information remains current and accurate\n• Complying with all applicable laws and regulations',
          Icons.person_add_rounded,
        ),
        _buildModernSection(
          '4. Acceptable Use Policy',
          'You agree to use StudentLink only for lawful purposes and in accordance with these Terms. Prohibited activities include:\n\n• Submitting false, misleading, or fraudulent information\n• Harassing, abusing, or harming other users or staff\n• Attempting to gain unauthorized access to systems\n• Using the service for commercial purposes without permission\n• Violating any applicable laws or institutional policies\n• Sharing inappropriate, offensive, or illegal content\n• Circumventing security measures or technical limitations',
          Icons.security_rounded,
        ),
        _buildModernSection(
          '5. Privacy and Data Protection',
          'Your privacy is paramount to us. We collect, use, and protect your personal information in accordance with our Privacy Policy and applicable data protection laws, including the Data Privacy Act of 2012 (Republic Act No. 10173). We implement industry-standard security measures to safeguard your data.',
          Icons.privacy_tip_rounded,
        ),
        _buildModernSection(
          '6. Intellectual Property Rights',
          'The StudentLink application, including its design, functionality, content, and underlying technology, is protected by intellectual property laws. You may not:\n\n• Copy, modify, or distribute the application\n• Create derivative works without explicit permission\n• Reverse engineer or attempt to extract source code\n• Use our trademarks or branding without authorization',
          Icons.copyright_rounded,
        ),
        _buildModernSection(
          '7. User-Generated Content',
          'You retain ownership of content you submit through StudentLink. By submitting content, you grant us a non-exclusive license to use, display, and distribute your content for the purpose of providing our services. You are responsible for ensuring your content does not violate any third-party rights.',
          Icons.edit_rounded,
        ),
        _buildModernSection(
          '8. Limitation of Liability',
          'StudentLink is provided "as is" without warranties of any kind. To the maximum extent permitted by law, we shall not be liable for any direct, indirect, incidental, special, or consequential damages arising from your use of the service, including but not limited to loss of data, profits, or business opportunities.',
          Icons.warning_rounded,
        ),
        _buildModernSection(
          '9. Service Availability',
          'We strive to maintain continuous service availability but cannot guarantee uninterrupted access. We reserve the right to modify, suspend, or discontinue any part of the service with reasonable notice. We are not liable for any downtime or service interruptions.',
          Icons.schedule_rounded,
        ),
        _buildModernSection(
          '10. Account Termination',
          'We reserve the right to terminate or suspend your account at any time for violations of these Terms or for any other reason at our sole discretion. Upon termination, your right to use the service ceases immediately, and we may delete your account and associated data.',
          Icons.block_rounded,
        ),
        _buildModernSection(
          '11. Changes to Terms',
          'We reserve the right to modify these Terms at any time. Material changes will be communicated through the application or via email. Your continued use of the service after changes constitutes acceptance of the modified Terms. We encourage you to review these Terms periodically.',
          Icons.update_rounded,
        ),
        _buildModernSection(
          '12. Governing Law and Dispute Resolution',
          'These Terms shall be governed by and construed in accordance with the laws of the Republic of the Philippines. Any disputes shall be resolved through:\n\n• Good faith negotiations between parties\n• Mediation if negotiations fail\n• Binding arbitration as a final resort\n• Philippine courts for matters not subject to arbitration',
          Icons.gavel_rounded,
        ),
        _buildModernSection(
          '13. Contact Information',
          'For questions, concerns, or legal notices regarding these Terms of Service, please contact:\n\nBestlink College of the Philippines\nStudentLink Support Team\nEmail: studentlink.bestlink@gmail.com\nPhone: (02) 8XXX-XXXX\nAddress: [College Address]\n\nWe aim to respond to all inquiries within 24-48 hours during business days.',
          Icons.contact_support_rounded,
        ),
      ],
    );
  }

  Widget _buildModernSection(String title, String content, IconData icon) {
    return Container(
      margin: ResponsiveDesign.getMargin(bottom: 20),
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: ResponsiveDesign.getPadding(all: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: ResponsiveDesign.getIconSize(20),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        letterSpacing: 0.3,
                      ),
                ),
              ),
            ],
          ),
          ResponsiveSpacing(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFooter() {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(all: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: ResponsiveDesign.getPadding(all: 12),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_rounded,
              color: Theme.of(context).colorScheme.tertiary,
              size: ResponsiveDesign.getIconSize(24),
            ),
          ),
          ResponsiveSpacing(height: 16),
          Text(
            'Agreement Acknowledgment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
          ),
          ResponsiveSpacing(height: 12),
          Text(
            'By using StudentLink, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service. Your continued use of the service constitutes acceptance of any future modifications.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
