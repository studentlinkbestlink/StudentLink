import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../theme/app_theme.dart';

class ModernEmergencyHelpCard extends StatelessWidget {
  const ModernEmergencyHelpCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(horizontal: 24, vertical: 12),
      padding: ResponsiveDesign.getPadding(all: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE22824),
            const Color(0xFFE22824).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE22824).withValues(alpha: 0.3),
            blurRadius: 20,
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
                ),
                child: Icon(
                    Icons.emergency_rounded,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(20),
                  ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Help',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: ResponsiveDesign.getFontSize(18),
                      ),
                    ),
                    Text(
                      'Get immediate assistance',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: ResponsiveDesign.getFontSize(14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          ResponsiveSpacing(height: 16),
          
          // Emergency contact buttons
          Row(
            children: [
              Expanded(
                child: _buildEmergencyButton(
                  icon: Icons.phone_rounded,
                  title: 'Call Security',
                  subtitle: 'Emergency Line',
                  onTap: () => _makePhoneCall('+63-2-1234-5678'),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: _buildEmergencyButton(
                  icon: Icons.medical_services_rounded,
                  title: 'Medical Help',
                  subtitle: 'Health Center',
                  onTap: () => _makePhoneCall('+63-2-1234-5679'),
                ),
              ),
            ],
          ),
          
          ResponsiveSpacing(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildEmergencyButton(
                  icon: Icons.admin_panel_settings_rounded,
                  title: 'Admin Office',
                  subtitle: 'Administration',
                  onTap: () => _makePhoneCall('+63-2-1234-5680'),
                ),
              ),
              ResponsiveSpacing(height: 0, width: 12),
              Expanded(
                child: _buildEmergencyButton(
                  icon: Icons.support_agent_rounded,
                  title: 'IT Support',
                  subtitle: 'Technical Help',
                  onTap: () => _makePhoneCall('+63-2-1234-5681'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        child: Container(
          padding: ResponsiveDesign.getPadding(all: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: ResponsiveDesign.getIconSize(20),
              ),
              ResponsiveSpacing(height: 8),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: ResponsiveDesign.getFontSize(12),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              ResponsiveSpacing(height: 2),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: ResponsiveDesign.getFontSize(10),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
