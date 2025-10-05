import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api_service.dart';
import '../../utils/error_handler.dart';
import './widgets/simple_profile_header_widget.dart';
import './widgets/profile_info_card_widget.dart';
import './widgets/editable_field_widget.dart';
import './widgets/verification_required_widget.dart';
import '../../utils/responsive_design.dart';
import '../../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';

class EnhancedProfileScreen extends StatefulWidget {
  const EnhancedProfileScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen> {
  String _firstName = '';
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isEditing = false;
  Map<String, dynamic> _editableFields = {};

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final userData = await apiService.getCurrentUser();
      
      if (mounted) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e is AppError ? e.message : 'Failed to load profile';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1E2A78),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _startEditing,
            )
          else
            Row(
              children: [
                TextButton(
                  onPressed: _cancelEditing,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: _saveChanges,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : _userData != null
                  ? _buildProfileContent()
                  : const Center(child: Text('No profile data available')),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 15.w,
            color: const Color(0xFFE22824),
          ),
          SizedBox(height: 3.h),
          Text(
            'Error Loading Profile',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(6).w,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE22824),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
            ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: _loadUserProfile,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: ResponsiveDesign.getPadding(all: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          SimpleProfileHeaderWidget(
            name: _userData!['name'] ?? 'Unknown',
            studentId: _userData!['student_id'] ?? 'N/A',
            course: _userData!['course'] ?? 'N/A',
            yearLevel: _userData!['year_level'] ?? 'N/A',
            avatar: _userData!['avatar'],
          ),

          SizedBox(height: 4.h),

          // Personal Information Section
          _buildSectionTitle('Personal Information'),
          SizedBox(height: 2.h),

          ProfileInfoCardWidget(
            children: [
              // Student ID (Not editable)
              _buildInfoRow(
                icon: Icons.badge,
                label: 'Student ID',
                value: _firstName,
                isEditable: false,
              ),
              
              Divider(height: 2.h),
              
              // Name (Not editable)
              _buildInfoRow(
                icon: Icons.person,
                label: 'Full Name',
                value: _firstName,
                isEditable: false,
              ),
              
              Divider(height: 2.h),
              
              // Course (Editable)
              _buildEditableInfoRow(
                icon: Icons.school,
                label: 'Course',
                value: _firstName,
                fieldKey: 'course',
                isEditable: true,
              ),
              
              Divider(height: 2.h),
              
              // Year Level (Editable)
              _buildEditableInfoRow(
                icon: Icons.grade,
                label: 'Year Level',
                value: _firstName,
                fieldKey: 'year_level',
                isEditable: true,
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Contact Information Section
          _buildSectionTitle('Contact Information'),
          SizedBox(height: 2.h),

          ProfileInfoCardWidget(
            children: [
              // School Email (Not editable)
              _buildInfoRow(
                icon: Icons.email,
                label: 'School Email',
                value: _firstName,
                isEditable: false,
              ),
              
              Divider(height: 2.h),
              
              // Personal Email (Editable with verification)
              _buildEditableInfoRow(
                icon: Icons.email_outlined,
                label: 'Personal Email',
                value: _firstName,
                fieldKey: 'personal_email',
                isEditable: true,
                requiresVerification: true,
              ),
              
              Divider(height: 2.h),
              
              // Contact Number (Editable with verification)
              _buildEditableInfoRow(
                icon: Icons.phone,
                label: 'Contact Number',
                value: _firstName,
                fieldKey: 'phone',
                isEditable: true,
                requiresVerification: true,
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Additional Information Section
          _buildSectionTitle('Additional Information'),
          SizedBox(height: 2.h),

          ProfileInfoCardWidget(
            children: [
              // Birthday (Not editable)
              _buildInfoRow(
                icon: Icons.cake,
                label: 'Birthday',
                value: _userData!['birthday'] != null 
                    ? DateTime.parse(_userData!['birthday']).toLocal().toString().split(' ')[0]
                    : 'N/A',
                isEditable: false,
              ),
              
              Divider(height: 2.h),
              
              // Civil Status (Not editable)
              _buildInfoRow(
                icon: Icons.family_restroom,
                label: 'Civil Status',
                value: _userData!['civil_status'] != null 
                    ? _userData!['civil_status'].toString().toUpperCase()
                    : 'N/A',
                isEditable: false,
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Account Management Section
          _buildSectionTitle('Account Management'),
          SizedBox(height: 2.h),

          ProfileInfoCardWidget(
            children: [
              // Dark Mode Toggle
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: Text(
                      'Dark Mode',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(4).w,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    subtitle: Text(
                      'Switch between light and dark themes',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(3.5).w,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: const Color(0xFF1E2A78),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
              
              Divider(height: 1.h),
              
              ListTile(
                leading: Icon(
                  Icons.lock,
                  color: const Color(0xFF1E2A78),
                ),
                title: Text(
                  'Change Password',
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveDesign.getFontSize(4).w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Update your account password',
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveDesign.getFontSize(3.5).w,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _navigateToChangePassword,
              ),
              
              Divider(height: 1.h),
              
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: const Color(0xFFE22824),
                ),
                title: Text(
                  'Sign Out',
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveDesign.getFontSize(4).w,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFE22824),
                  ),
                ),
                subtitle: Text(
                  'Sign out of your account',
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveDesign.getFontSize(3.5).w,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _handleLogout,
              ),
            ],
          ),

          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: ResponsiveDesign.getFontSize(5).w,
        fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E2A78),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isEditable,
  }) {
    return Padding(
      padding: ResponsiveDesign.getPadding(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
                    color: const Color(0xFF1E2A78),
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveDesign.getFontSize(3.5).w,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveDesign.getFontSize(4).w,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (!isEditable)
                  Padding(
                    padding: ResponsiveDesign.getPadding(top: 0.5.h),
                    child: Text(
                      'Not editable',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(3).w,
                        color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF757575),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required String fieldKey,
    required bool isEditable,
    bool requiresVerification = false,
  }) {
    return Padding(
      padding: ResponsiveDesign.getPadding(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
                    color: const Color(0xFF1E2A78),
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(3.5).w,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    if (requiresVerification) ...[
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.verified_user,
                        size: 3.5.w,
                        color: const Color(0xFF28A745),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                if (_isEditing)
                  EditableFieldWidget(
                    initialValue: _firstName,
                    fieldKey: fieldKey,
                    onChanged: (newValue) {
                      _editableFields[fieldKey] = newValue;
                    },
                    requiresVerification: requiresVerification,
                  )
                else
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveDesign.getFontSize(4).w,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                if (requiresVerification)
                  Padding(
                    padding: ResponsiveDesign.getPadding(top: 0.5.h),
                    child: Text(
                      'Requires verification to change',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveDesign.getFontSize(3).w,
                        color: const Color(0xFF1B5E20),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _editableFields.clear();
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _editableFields.clear();
    });
  }

  Future<void> _saveChanges() async {
    if (_editableFields.isEmpty) {
      setState(() => _isEditing = false);
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Check if any changes require verification
      bool requiresVerification = _editableFields.containsKey('personal_email') || 
                                 _editableFields.containsKey('phone');

      if (requiresVerification) {
        // Show verification dialog
        final verified = await _showVerificationDialog();
        if (!verified) {
          setState(() => _isLoading = false);
          return;
        }
      }

      // Update profile
      await apiService.updateUserProfile(_editableFields);

      // Reload profile data
      await _loadUserProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: const Color(0xFF28A745),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is AppError ? e.message : 'Failed to update profile'),
            backgroundColor: const Color(0xFFE22824),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _showVerificationDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => VerificationRequiredWidget(
        fieldsToVerify: _editableFields.keys.toList(),
        onVerified: () => Navigator.of(context).pop(true),
        onCancelled: () => Navigator.of(context).pop(false),
      ),
    ) ?? false;
  }

  void _navigateToChangePassword() {
    Navigator.of(context).pushNamed('/change-password');
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await apiService.logout();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login-screen');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to sign out: ${e is AppError ? e.message : 'Unknown error'}'),
              backgroundColor: const Color(0xFFE22824),
            ),
          );
        }
      }
    }
  }
}
