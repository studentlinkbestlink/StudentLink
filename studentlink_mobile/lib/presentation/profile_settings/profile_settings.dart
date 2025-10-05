import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import '../../services/settings_service.dart';

import '../../utils/error_handler.dart';
import '../../providers/theme_provider.dart';
import './widgets/modern_logout_button_widget.dart';
import './widgets/modern_profile_header_widget.dart';
import './widgets/modern_settings_section_widget.dart';
import './widgets/modern_settings_tile_widget.dart';
import './widgets/modern_toggle_tile_widget.dart';
import '../../utils/responsive_design.dart';
import '../../../widgets/responsive_widgets.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // Services
  final SettingsService _settingsService = SettingsService();
  final ImagePicker _imagePicker = ImagePicker();

  // Student data will be loaded from API/preferences
  Map<String, dynamic> studentData = {
    "id": 0,
    "name": "Student Name",
    "studentId": "Loading...",
    "course": "Loading...",
    "yearLevel": "Loading...",
    "email": "Loading...",
    "phone": "Loading...",
    "avatar": "",
  };
  bool _isLoading = false;

  // Notification preferences
  bool concernUpdates = true;
  bool announcementAlerts = true;
  bool emergencyNotifications = true;
  bool aiAssistantMessages = false;

  // App settings
  bool isFilipino = false;
  bool wifiOnlyData = false;
  bool biometricAuth = false;

  // Privacy settings
  bool anonymousDefault = false;
  bool dataSharing = true;

  @override
  void initState() {
    super.initState();
    _loadStudentProfile();
    _loadSettings();
  }

  Future<void> _loadStudentProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading user profile from API...');
      // Load user profile from API
      final userProfile = await apiService.getCurrentUser();
      print('Loaded user profile: $userProfile');

      setState(() {
        studentData = {
          "id": userProfile['id'] ?? 0,
          "name": userProfile['name'] ?? "Student Name",
          "studentId":
              userProfile['display_id'] ?? userProfile['student_id'] ?? "N/A",
          "course": userProfile['program'] ??
              userProfile['department'] ??
              'Not specified',
          "yearLevel": userProfile['year_level'] ?? "Student",
          "email": userProfile['email'] ?? "N/A",
          "phone": userProfile['phone'] ?? 'Not provided',
          "avatar": userProfile['avatar'] ?? "",
        };
      });
    } catch (e) {
      print('Error loading student profile: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: Duration(seconds: 5),
          ),
        );
      }
      // Show error state instead of loading
      setState(() {
        studentData = {
          "id": 0,
          "name": "Error Loading",
          "studentId": "Unable to load",
          "course": "Unable to load",
          "yearLevel": "Unable to load",
          "email": "Unable to load",
          "phone": "Unable to load",
          "avatar": "",
        };
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Load all settings from the settings service
  Future<void> _loadSettings() async {
    try {
      // Load notification settings
      final notificationSettings =
          await _settingsService.getNotificationSettings();
      setState(() {
        concernUpdates = notificationSettings['concernUpdates'] ?? true;
        announcementAlerts = notificationSettings['announcementAlerts'] ?? true;
        emergencyNotifications =
            notificationSettings['emergencyNotifications'] ?? true;
        aiAssistantMessages =
            notificationSettings['aiAssistantMessages'] ?? false;
      });

      // Load app settings
      final appSettings = await _settingsService.getAppSettings();
      setState(() {
        isFilipino = appSettings['isFilipino'] ?? false;
        wifiOnlyData = appSettings['wifiOnlyData'] ?? false;
        biometricAuth = appSettings['biometricAuth'] ?? false;
      });

      // Load privacy settings
      final privacySettings = await _settingsService.getPrivacySettings();
      setState(() {
        anonymousDefault = privacySettings['anonymousDefault'] ?? false;
        dataSharing = privacySettings['dataSharing'] ?? true;
      });

      debugPrint('✅ Settings loaded successfully');
    } catch (e) {
      debugPrint('❌ Error loading settings: $e');
      _showErrorMessage('Failed to load settings');
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: studentData['name'],
              ),
              onChanged: (value) {
                setState(() {
                  studentData['name'] = value;
                });
              },
            ),
            ResponsiveSpacing(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: studentData['phone'],
              ),
              onChanged: (value) {
                setState(() {
                  studentData['phone'] = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveProfileChanges();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    try {
      // TODO: Implement API call to update profile
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Theme-aware background
      appBar: _buildModernAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSpacing(height: 16),

                  // Modern Profile Header
                  Padding(
                    padding: ResponsiveDesign.getPadding(horizontal: 16),
                    child: ModernProfileHeaderWidget(
                      studentName: studentData["name"] as String,
                      studentId: studentData["studentId"] as String,
                      course: studentData["course"] as String,
                      avatarUrl: studentData["avatar"] as String,
                      onEditPressed: _showEditProfileDialog,
                      onAvatarTap: _showAvatarOptions,
                    ),
                  ),

                  ResponsiveSpacing(height: 24),

                  // Account Section
                  ModernSettingsSectionWidget(
                    title: 'Account',
                    children: [
                      ModernSettingsTileWidget(
                        icon: Icons.person_rounded,
                        title: 'Personal Information',
                        subtitle: 'Name, email, phone number',
                        onTap: _showPersonalInfoDialog,
                      ),
                      ModernSettingsTileWidget(
                        icon: Icons.school_rounded,
                        title: 'Academic Details',
                        subtitle:
                            '${studentData["course"]}, ${studentData["yearLevel"]}',
                        onTap: _showAcademicDetailsDialog,
                      ),
                      ModernSettingsTileWidget(
                        icon: Icons.lock_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your account password',
                        onTap: _showChangePasswordDialog,
                      ),
                    ],
                  ),

                  // Notification Preferences
                  ModernSettingsSectionWidget(
                    title: 'Notifications',
                    children: [
                      ModernToggleTileWidget(
                        icon: Icons.notifications_rounded,
                        title: 'Concern Updates',
                        subtitle: 'Get notified about concern status changes',
                        value: concernUpdates,
                        onChanged: (value) =>
                            _updateNotificationSetting('concernUpdates', value),
                      ),
                      ModernToggleTileWidget(
                        icon: Icons.campaign_rounded,
                        title: 'Announcement Alerts',
                        subtitle: 'Receive campus announcements',
                        value: announcementAlerts,
                        onChanged: (value) => _updateNotificationSetting(
                            'announcementAlerts', value),
                      ),
                      ModernToggleTileWidget(
                        icon: Icons.warning_rounded,
                        title: 'Emergency Notifications',
                        subtitle: 'Critical campus alerts and emergencies',
                        iconColor: Theme.of(context).colorScheme.error,
                        value: emergencyNotifications,
                        onChanged: (value) => _updateNotificationSetting(
                            'emergencyNotifications', value),
                      ),
                      ModernToggleTileWidget(
                        icon: Icons.smart_toy_rounded,
                        title: 'Message Notifications',
                        subtitle: 'Tips and suggestions from support chat',
                        value: aiAssistantMessages,
                        onChanged: (value) => _updateNotificationSetting(
                            'aiAssistantMessages', value),
                      ),
                    ],
                  ),

                  // App Settings
                  ModernSettingsSectionWidget(
                    title: 'App Settings',
                    children: [
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return ModernSettingsTileWidget(
                            icon: _getThemeIcon(themeProvider.themeMode),
                            title: 'Theme',
                            subtitle:
                                _getThemeSubtitle(themeProvider.themeMode),
                            onTap: () => _showThemeSelectionDialog(
                                context, themeProvider),
                          );
                        },
                      ),
                      ModernToggleTileWidget(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: isFilipino ? 'Filipino' : 'English',
                        value: isFilipino,
                        onChanged: (value) => _updateLanguageSetting(value),
                      ),
                      ModernToggleTileWidget(
                        icon: Icons.wifi_rounded,
                        title: 'Wi-Fi Only Data',
                        subtitle:
                            'Use cellular data for essential features only',
                        value: wifiOnlyData,
                        onChanged: (value) => _updateWifiOnlySetting(value),
                      ),
                      ModernToggleTileWidget(
                        icon: Icons.fingerprint_rounded,
                        title: 'Biometric Authentication',
                        subtitle: 'Use Face/Touch ID to unlock app',
                        value: biometricAuth,
                        onChanged: (value) =>
                            _updateBiometricAuthSetting(value),
                      ),
                    ],
                  ),

                  // Privacy Section
                  ModernSettingsSectionWidget(
                    title: 'Privacy',
                    children: [
                      ModernToggleTileWidget(
                        icon: Icons.visibility_off_rounded,
                        title: 'Anonymous Submission Default',
                        subtitle: 'Submit concerns anonymously by default',
                        value: anonymousDefault,
                        onChanged: (value) =>
                            _updatePrivacySetting('anonymousDefault', value),
                      ),
                      ModernToggleTileWidget(
                        icon: Icons.share_rounded,
                        title: 'Data Sharing',
                        subtitle: 'Share usage data to improve app experience',
                        value: dataSharing,
                        onChanged: (value) =>
                            _updatePrivacySetting('dataSharing', value),
                      ),
                      ModernSettingsTileWidget(
                        icon: Icons.delete_forever_rounded,
                        title: 'Account Deletion',
                        subtitle: 'Permanently delete your account',
                        iconColor: Theme.of(context).colorScheme.error,
                        onTap: _showDeleteAccountDialog,
                      ),
                    ],
                  ),

                  // Support Section
                  ModernSettingsSectionWidget(
                    title: 'Support',
                    children: [
                      ModernSettingsTileWidget(
                        icon: Icons.help_rounded,
                        title: 'Help Center',
                        subtitle: 'FAQs and troubleshooting guides',
                        onTap: _showHelpCenter,
                      ),
                      ModernSettingsTileWidget(
                        icon: Icons.support_agent_rounded,
                        title: 'Contact Support',
                        subtitle: 'Get help from our support team',
                        onTap: () =>
                            Navigator.pushNamed(context, '/submit-concern'),
                      ),
                      ModernSettingsTileWidget(
                        icon: Icons.star_rounded,
                        title: 'Rate App',
                        subtitle: 'Rate StudentLink on Google Play Store',
                        onTap: _rateApp,
                      ),
                      ModernSettingsTileWidget(
                        icon: Icons.info_rounded,
                        title: 'About',
                        subtitle: 'App version and information',
                        onTap: _showAboutDialog,
                      ),
                    ],
                  ),

                  // Logout Button
                  ModernLogoutButtonWidget(
                    onLogout: _handleLogout,
                  ),

                  ResponsiveSpacing(height: 32),
                ],
              ),
            ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: ResponsiveDesign.getPadding(all: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    const Color(0xFF300300300),
                borderRadius:
                    BorderRadius.circular(ResponsiveDesign.getBorderRadius(2)),
              ),
            ),
            ResponsiveSpacing(height: 24),
            Text(
              'Change Profile Picture',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            ResponsiveSpacing(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption('Camera', 'camera_alt', () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                }),
                _buildAvatarOption('Gallery', 'photo_library', () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                }),
                _buildAvatarOption('Remove', 'delete', () {
                  Navigator.pop(context);
                  _removeProfilePicture();
                }),
              ],
            ),
            ResponsiveSpacing(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(25),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
            ),
            child: Center(
              child: Icon(
                _getIconFromName(iconName),
                color: Theme.of(context).colorScheme.primary,
                size: ResponsiveDesign.getIconSize(28),
              ),
            ),
          ),
          ResponsiveSpacing(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  void _showPersonalInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16))),
        title: Text('Personal Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', studentData["name"] as String),
            _buildInfoRow('Email', studentData["email"] as String),
            _buildInfoRow('Phone', studentData["phone"] as String),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Edit functionality coming soon');
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAcademicDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16))),
        title: Text('Academic Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Student ID', studentData["studentId"] as String),
            _buildInfoRow('Course', studentData["course"] as String),
            _buildInfoRow('Year Level', studentData["yearLevel"] as String),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: ResponsiveDesign.getPadding(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          ResponsiveSpacing(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16))),
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(8)),
                ),
              ),
            ),
            ResponsiveSpacing(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(8)),
                ),
              ),
            ),
            ResponsiveSpacing(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      ResponsiveDesign.getBorderRadius(8)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Password changed successfully');
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16))),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Theme.of(context).colorScheme.error,
              size: ResponsiveDesign.getIconSize(24),
            ),
            ResponsiveSpacing(height: 0, width: 8),
            Text(
              'Delete Account',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
        content: Text(
          'This action cannot be undone. All your data including concerns, messages, and profile information will be permanently deleted.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Account deletion request submitted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16))),
        title: Text('Help Center'),
        content: Text(
          'Help Center with FAQs and troubleshooting guides will be available in the next update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    _showSuccessMessage('Redirecting to Google Play Store...');
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(16))),
        title: Text('About StudentLink'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'StudentLink',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'Version: 1.0.0',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            ResponsiveSpacing(height: 8),
            Text(
              'Build: 2025.01.05',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            ResponsiveSpacing(height: 16),
            Text(
              'A comprehensive mobile application for student concern management and campus support services at STUDENTLINK.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            ResponsiveSpacing(height: 16),
            Text(
              '© 2025 STUDENTLINK',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      // Logout from API
      await apiService.logout();

      // Clear any stored data and navigate to login
      Navigator.pushReplacementNamed(context, '/login-screen');
      _showSuccessMessage('Logged out successfully');
    } catch (e) {
      // Even if API logout fails, still navigate to login
      Navigator.pushReplacementNamed(context, '/login-screen');
      _showSuccessMessage('Logged out successfully');
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.onTertiary,
                size: ResponsiveDesign.getIconSize(20),
              ),
              ResponsiveSpacing(height: 0, width: 8),
              Text(message),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
          margin: ResponsiveDesign.getMargin(all: 16),
        ),
      );
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'camera_alt':
        return Icons.camera_alt_rounded;
      case 'photo_library':
        return Icons.photo_library_rounded;
      case 'delete':
        return Icons.delete_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: Text(
        'Profile Settings',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: _loadStudentProfile,
          icon: Icon(
            Icons.refresh_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: ResponsiveDesign.getIconSize(24),
          ),
          tooltip: 'Refresh Profile',
        ),
        IconButton(
          onPressed: _showEditProfileDialog,
          icon: Icon(
            Icons.edit_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: ResponsiveDesign.getIconSize(24),
          ),
          tooltip: 'Edit Profile',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  // ==================== TOGGLE HANDLER METHODS ====================

  /// Update notification setting
  Future<void> _updateNotificationSetting(String key, bool value) async {
    try {
      // Update local state immediately for responsive UI
      setState(() {
        switch (key) {
          case 'concernUpdates':
            concernUpdates = value;
            break;
          case 'announcementAlerts':
            announcementAlerts = value;
            break;
          case 'emergencyNotifications':
            emergencyNotifications = value;
            break;
          case 'aiAssistantMessages':
            aiAssistantMessages = value;
            break;
        }
      });

      // Update in settings service
      final currentSettings = await _settingsService.getNotificationSettings();
      currentSettings[key] = value;

      final success =
          await _settingsService.updateNotificationSettings(currentSettings);

      if (success) {
        HapticFeedback.lightImpact();
        _showSuccessMessage(
            '${_getNotificationSettingName(key)} ${value ? 'enabled' : 'disabled'}');
      } else {
        // Revert on failure
        setState(() {
          switch (key) {
            case 'concernUpdates':
              concernUpdates = !value;
              break;
            case 'announcementAlerts':
              announcementAlerts = !value;
              break;
            case 'emergencyNotifications':
              emergencyNotifications = !value;
              break;
            case 'aiAssistantMessages':
              aiAssistantMessages = !value;
              break;
          }
        });
        _showErrorMessage('Failed to update notification setting');
      }
    } catch (e) {
      debugPrint('❌ Error updating notification setting: $e');
      _showErrorMessage('Failed to update notification setting');
    }
  }

  /// Update language setting
  Future<void> _updateLanguageSetting(bool value) async {
    try {
      // Update local state immediately
      setState(() {
        isFilipino = value;
      });

      // Update in settings service
      final success = await _settingsService.updateLanguageSetting(value);

      if (success) {
        HapticFeedback.lightImpact();
        _showSuccessMessage(
            'Language changed to ${value ? 'Filipino' : 'English'}');
      } else {
        // Revert on failure
        setState(() {
          isFilipino = !value;
        });
        _showErrorMessage('Failed to update language setting');
      }
    } catch (e) {
      debugPrint('❌ Error updating language setting: $e');
      _showErrorMessage('Failed to update language setting');
    }
  }

  /// Update Wi-Fi only setting
  Future<void> _updateWifiOnlySetting(bool value) async {
    try {
      // Update local state immediately
      setState(() {
        wifiOnlyData = value;
      });

      // Update in settings service
      final success = await _settingsService.updateWifiOnlySetting(value);

      if (success) {
        HapticFeedback.lightImpact();
        _showSuccessMessage(
            'Wi-Fi only data ${value ? 'enabled' : 'disabled'}');
      } else {
        // Revert on failure
        setState(() {
          wifiOnlyData = !value;
        });
        _showErrorMessage('Failed to update Wi-Fi setting');
      }
    } catch (e) {
      debugPrint('❌ Error updating Wi-Fi setting: $e');
      _showErrorMessage('Failed to update Wi-Fi setting');
    }
  }

  /// Update biometric authentication setting
  Future<void> _updateBiometricAuthSetting(bool value) async {
    try {
      // Check if biometric is available before enabling
      if (value) {
        final isAvailable = await _settingsService.isBiometricAvailable();
        if (!isAvailable) {
          _showErrorMessage(
              'Biometric authentication is not available on this device');
          return;
        }
      }

      // Update local state immediately
      setState(() {
        biometricAuth = value;
      });

      // Update in settings service
      final success = await _settingsService.updateBiometricAuthSetting(value);

      if (success) {
        HapticFeedback.mediumImpact();
        _showSuccessMessage(
            'Biometric authentication ${value ? 'enabled' : 'disabled'}');
      } else {
        // Revert on failure
        setState(() {
          biometricAuth = !value;
        });
        _showErrorMessage('Failed to update biometric setting');
      }
    } catch (e) {
      debugPrint('❌ Error updating biometric setting: $e');
      // Revert on failure
      setState(() {
        biometricAuth = !value;
      });
      _showErrorMessage('Failed to update biometric setting: ${e.toString()}');
    }
  }

  /// Update privacy setting
  Future<void> _updatePrivacySetting(String key, bool value) async {
    try {
      // Update local state immediately
      setState(() {
        switch (key) {
          case 'anonymousDefault':
            anonymousDefault = value;
            break;
          case 'dataSharing':
            dataSharing = value;
            break;
        }
      });

      // Update in settings service
      final currentSettings = await _settingsService.getPrivacySettings();
      currentSettings[key] = value;

      final success =
          await _settingsService.updatePrivacySettings(currentSettings);

      if (success) {
        HapticFeedback.lightImpact();
        _showSuccessMessage(
            '${_getPrivacySettingName(key)} ${value ? 'enabled' : 'disabled'}');
      } else {
        // Revert on failure
        setState(() {
          switch (key) {
            case 'anonymousDefault':
              anonymousDefault = !value;
              break;
            case 'dataSharing':
              dataSharing = !value;
              break;
          }
        });
        _showErrorMessage('Failed to update privacy setting');
      }
    } catch (e) {
      debugPrint('❌ Error updating privacy setting: $e');
      _showErrorMessage('Failed to update privacy setting');
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Get notification setting display name
  String _getNotificationSettingName(String key) {
    switch (key) {
      case 'concernUpdates':
        return 'Concern updates';
      case 'announcementAlerts':
        return 'Announcement alerts';
      case 'emergencyNotifications':
        return 'Emergency notifications';
      case 'aiAssistantMessages':
        return 'AI assistant messages';
      default:
        return 'Notification';
    }
  }

  /// Get privacy setting display name
  String _getPrivacySettingName(String key) {
    switch (key) {
      case 'anonymousDefault':
        return 'Anonymous submission';
      case 'dataSharing':
        return 'Data sharing';
      default:
        return 'Privacy setting';
    }
  }

  /// Show error message
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_rounded,
                color: Theme.of(context).colorScheme.onError,
                size: ResponsiveDesign.getIconSize(20),
              ),
              ResponsiveSpacing(height: 0, width: 8),
              Text(message),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
          ),
          margin: ResponsiveDesign.getMargin(all: 16),
        ),
      );
    }
  }

  // Image picker methods
  Future<void> _pickImageFromCamera() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      if (cameraStatus != PermissionStatus.granted) {
        _showErrorMessage('Camera permission is required to take photos');
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _uploadProfilePicture(File(image.path));
      }
    } catch (e) {
      _showErrorMessage('Failed to take photo: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      // Request photo library permission
      final photoStatus = await Permission.photos.request();
      if (photoStatus != PermissionStatus.granted) {
        _showErrorMessage(
            'Photo library permission is required to select images');
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _uploadProfilePicture(File(image.path));
      }
    } catch (e) {
      _showErrorMessage('Failed to select image: $e');
    }
  }

  Future<void> _uploadProfilePicture(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final apiService = ApiService();
      final result = await apiService.uploadProfilePicture(imageFile);

      final avatarUrl = result['avatar_url'];
      if (avatarUrl is String && avatarUrl.isNotEmpty) {
        setState(() {
          studentData['avatar'] = avatarUrl;
        });

        // Save to preferences
        await _settingsService.saveStudentData(studentData);

        _showSuccessMessage('Profile picture updated successfully!');
      } else {
        _showErrorMessage('Failed to upload profile picture');
      }
    } catch (e) {
      String errorMessage = 'Failed to upload profile picture';
      if (e is AppError) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Failed to upload profile picture: $e';
      }
      _showErrorMessage(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeProfilePicture() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Update profile to remove avatar
      final apiService = ApiService();
      await apiService.updateUserProfile({'avatar': null});

      setState(() {
        studentData['avatar'] = '';
      });

      // Save to preferences
      await _settingsService.saveStudentData(studentData);

      _showSuccessMessage('Profile picture removed successfully!');
    } catch (e) {
      String errorMessage = 'Failed to remove profile picture';
      if (e is AppError) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Failed to remove profile picture: $e';
      }
      _showErrorMessage(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Theme helper methods
  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  String _getThemeSubtitle(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Always light';
      case ThemeMode.dark:
        return 'Always dark';
      case ThemeMode.system:
        return 'Follow system';
    }
  }

  void _showThemeSelectionDialog(
      BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                context,
                'Light Mode',
                'Always use light theme',
                Icons.light_mode_rounded,
                ThemeMode.light,
                themeProvider,
              ),
              SizedBox(height: 12),
              _buildThemeOption(
                context,
                'Dark Mode',
                'Always use dark theme',
                Icons.dark_mode_rounded,
                ThemeMode.dark,
                themeProvider,
              ),
              SizedBox(height: 12),
              _buildThemeOption(
                context,
                'System Default',
                'Follow device setting',
                Icons.brightness_auto_rounded,
                ThemeMode.system,
                themeProvider,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    ThemeMode mode,
    ThemeProvider themeProvider,
  ) {
    final isSelected = themeProvider.themeMode == mode;

    return InkWell(
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Theme changed to $title'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).textTheme.titleMedium?.color,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
