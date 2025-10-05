import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  const PrivacyPolicyWidget({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget>
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
        'Privacy Policy',
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

            // Privacy Content
            _buildPrivacyContent(),

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
              Icons.privacy_tip_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: ResponsiveDesign.getIconSize(32),
            ),
          ),
          ResponsiveSpacing(height: 20),
          Text(
            'StudentLink Privacy Policy',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing(height: 12),
          Container(
            padding: ResponsiveDesign.getPadding(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Last Updated: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      children: [
        _buildModernSection(
          '1. Information We Collect',
          'We collect various types of information to provide and improve our services:\n\n• Personal Information: Full name, student ID, email address, phone number, date of birth, civil status, address\n• Academic Information: Course/program, year level, department, academic records, enrollment status\n• Usage Data: App interactions, feature usage, time spent, navigation patterns, device information\n• Communication Data: Messages, concerns, feedback, support requests, announcements\n• Device Information: Device type, operating system, app version, unique device identifiers, IP address\n• Location Data: General location for emergency services (with explicit consent)\n• Biometric Data: Fingerprint or facial recognition for authentication (stored locally on device)',
          Icons.info_outline_rounded,
        ),
        _buildModernSection(
          '2. How We Use Your Information',
          'We use your information for the following purposes:\n\n• Service Provision: Process concerns, facilitate communication, provide academic support\n• Account Management: Create and maintain user accounts, verify identity, manage preferences\n• Communication: Send notifications, updates, announcements, and respond to inquiries\n• Service Improvement: Analyze usage patterns, enhance features, optimize performance\n• Security: Prevent fraud, detect unauthorized access, protect user safety\n• Legal Compliance: Meet regulatory requirements, respond to legal requests\n• Emergency Services: Provide location data during emergencies (with consent)\n• Analytics: Generate reports for institutional improvement (anonymized data)',
          Icons.settings_rounded,
        ),
        _buildModernSection(
          '3. Information Sharing and Disclosure',
          'We do not sell, trade, or rent your personal information. We may share information only in these circumstances:\n\n• Academic Personnel: Department heads, faculty, and administrators for academic purposes\n• Institutional Services: Registrar, student affairs, counseling services for support\n• Legal Requirements: When required by law, court order, or government request\n• Safety and Security: To protect rights, property, or safety of users and the institution\n• Service Providers: Trusted third parties who assist in app functionality (under strict agreements)\n• Emergency Situations: To emergency services when necessary for safety\n• Consent: When you explicitly authorize sharing for specific purposes',
          Icons.share_rounded,
        ),
        _buildModernSection(
          '4. Data Security and Protection',
          'We implement comprehensive security measures to protect your information:\n\n• Encryption: End-to-end encryption for sensitive data transmission and storage\n• Access Controls: Role-based access with multi-factor authentication\n• Secure Infrastructure: Protected servers, databases, and cloud storage\n• Regular Audits: Security assessments and vulnerability testing\n• Staff Training: Data protection training for all personnel\n• Incident Response: Procedures for handling security breaches\n• Data Minimization: Collecting only necessary information\n• Retention Policies: Secure deletion of data when no longer needed',
          Icons.security_rounded,
        ),
        _buildModernSection(
          '5. Data Retention and Deletion',
          'We retain your information based on the following principles:\n\n• Academic Records: Retained for the duration of enrollment plus regulatory requirements\n• Account Data: Maintained while account is active and for reasonable period after\n• Communication Data: Stored for service provision and institutional record-keeping\n• Usage Analytics: Anonymized data may be retained for institutional improvement\n• Legal Requirements: Some data must be retained per Philippine educational regulations\n• User Requests: Data deletion requests will be processed within 30 days (subject to legal requirements)\n• Secure Disposal: Proper destruction of physical and digital records',
          Icons.schedule_rounded,
        ),
        _buildModernSection(
          '6. Your Privacy Rights',
          'Under the Data Privacy Act of 2012 (Republic Act No. 10173), you have the following rights:\n\n• Right to Access: Request copies of your personal information\n• Right to Rectification: Correct inaccurate or incomplete data\n• Right to Erasure: Request deletion of your data (subject to legal requirements)\n• Right to Restrict Processing: Limit how we use your information\n• Right to Data Portability: Receive your data in a structured format\n• Right to Object: Opt out of certain data processing activities\n• Right to Withdraw Consent: Revoke consent for data processing\n• Right to Complain: File complaints with the National Privacy Commission',
          Icons.account_balance_rounded,
        ),
        _buildModernSection(
          '7. Cookies and Tracking Technologies',
          'StudentLink uses various technologies to enhance your experience:\n\n• Essential Cookies: Required for app functionality and security\n• Performance Cookies: Help us understand app usage and improve performance\n• Preference Cookies: Remember your settings and preferences\n• Analytics Tools: Google Analytics and similar services (anonymized data)\n• Device Identifiers: Unique identifiers for app functionality\n• Local Storage: Store preferences and temporary data on your device\n• Third-Party Services: Integration with educational and communication platforms',
          Icons.cookie_rounded,
        ),
        _buildModernSection(
          '8. Third-Party Services and Integrations',
          'Our app integrates with third-party services for enhanced functionality:\n\n• Cloud Storage: Secure data backup and synchronization\n• Communication Platforms: Email and messaging services\n• Analytics Services: Usage tracking and performance monitoring\n• Authentication Services: Secure login and identity verification\n• Notification Services: Push notifications and alerts\n• Educational Tools: Learning management systems and academic resources\n\nEach third-party service has its own privacy policy. We ensure all partners meet our security standards and comply with applicable privacy laws.',
          Icons.integration_instructions_rounded,
        ),
        _buildModernSection(
          '9. Children\'s Privacy Protection',
          'StudentLink is designed for students of Bestlink College of the Philippines. Our privacy practices include:\n\n• Age Verification: We verify student enrollment and age appropriateness\n• Parental Consent: Required for students under 18 for certain data processing\n• Limited Data Collection: Minimal data collection for younger users\n• Enhanced Protection: Additional safeguards for minors\' personal information\n• Educational Focus: All data processing serves legitimate educational purposes\n• No Commercial Use: We do not use children\'s data for commercial purposes\n• Compliance: Adherence to COPPA and local child protection laws',
          Icons.child_care_rounded,
        ),
        _buildModernSection(
          '10. International Data Transfers',
          'Your personal information is primarily processed within the Philippines. When international transfers are necessary:\n\n• Adequacy Decisions: We only transfer to countries with adequate protection\n• Standard Contractual Clauses: Use approved data transfer agreements\n• Binding Corporate Rules: Internal policies for multinational operations\n• User Consent: Explicit consent for transfers to third countries\n• Safeguards: Additional security measures for international transfers\n• Local Storage: Preference for processing data within the Philippines',
          Icons.public_rounded,
        ),
        _buildModernSection(
          '11. Data Breach Notification',
          'In the event of a data breach, we will:\n\n• Immediate Response: Act within 24 hours to contain and assess the breach\n• User Notification: Inform affected users within 72 hours of discovery\n• Authority Notification: Report to National Privacy Commission as required\n• Investigation: Conduct thorough investigation of the incident\n• Remediation: Implement measures to prevent future breaches\n• Support: Provide assistance to affected users\n• Documentation: Maintain detailed records of the incident and response',
          Icons.warning_rounded,
        ),
        _buildModernSection(
          '12. Changes to This Privacy Policy',
          'We may update this Privacy Policy to reflect changes in our practices or legal requirements:\n\n• Notification Methods: In-app notifications, email, or website updates\n• Material Changes: Special notice for significant policy changes\n• Review Period: 30-day notice for major changes\n• Continued Use: Your continued use constitutes acceptance of changes\n• Version History: Previous versions available upon request\n• Effective Date: Clear indication of when changes take effect',
          Icons.update_rounded,
        ),
        _buildModernSection(
          '13. Contact Information and Data Protection Officer',
          'For privacy-related questions, concerns, or requests, please contact:\n\nBestlink College of the Philippines\nData Protection Officer\nEmail: studentlink.bestlink@gmail.com\nPhone: (02) 8XXX-XXXX\nAddress: [College Address]\n\nResponse Time: We aim to respond to all privacy inquiries within 24-48 hours during business days.\n\nNational Privacy Commission\nWebsite: privacy.gov.ph\nEmail: info@privacy.gov.ph\nPhone: (02) 8234-2228',
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
            : Theme.of(context).colorScheme.surface,
        borderRadius:
            BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
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
                        color: Theme.of(context).colorScheme.onSurface,
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
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
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
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: Colors.green,
              size: ResponsiveDesign.getIconSize(24),
            ),
          ),
          ResponsiveSpacing(height: 16),
          Text(
            'Privacy Commitment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          ResponsiveSpacing(height: 12),
          Text(
            'Your privacy and data security are our top priorities. We are committed to protecting your personal information in accordance with the highest standards, applicable laws, and best practices in data protection. We continuously review and enhance our privacy practices to ensure your trust and confidence.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
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
