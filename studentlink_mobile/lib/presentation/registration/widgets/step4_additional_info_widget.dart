import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

class Step4AdditionalInfoWidget extends StatefulWidget {
  final Function(DateTime? birthday, String? civilStatus, String? password, String? passwordConfirmation) onDataChanged;

  const Step4AdditionalInfoWidget({
    Key? key,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<Step4AdditionalInfoWidget> createState() => _Step4AdditionalInfoWidgetState();
}

class _Step4AdditionalInfoWidgetState extends State<Step4AdditionalInfoWidget> {
  DateTime? _selectedBirthday;
  String? _selectedCivilStatus;
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  final List<String> _civilStatusOptions = [
    'single',
    'married',
    'widowed',
    'separated',
  ];

  final Map<String, String> _civilStatusLabels = {
    'single': 'Single',
    'married': 'Married',
    'widowed': 'Widowed',
    'separated': 'Separated',
  };

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onDataChanged);
    _passwordConfirmationController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    widget.onDataChanged(
      _selectedBirthday,
      _selectedCivilStatus,
      _passwordController.text.trim().isEmpty ? null : _passwordController.text.trim(),
      _passwordConfirmationController.text.trim().isEmpty ? null : _passwordConfirmationController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Additional Information & Password',
          style: TextStyle(
            fontSize: ResponsiveDesign.getFontSize(5.5).w,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2A78),
          ),
        ),
        
        SizedBox(height: 1.5.h),
        
        Text(
          'Complete your profile with additional information and create a secure password for your account.',
          style: TextStyle(
            fontSize: ResponsiveDesign.getFontSize(3.8).w,
            color: Color(0xFF757575),
            height: 1.4,
          ),
        ),
        
        SizedBox(height: 3.h),
          
        // Birthday
        _buildBirthdayField(),
        
        SizedBox(height: 1.5.h),
        
        // Civil Status
        _buildCivilStatusField(),
        
        SizedBox(height: 1.5.h),
        
        // Password
        _buildPasswordField(),
        
        SizedBox(height: 1.5.h),
        
        // Password Confirmation
        _buildPasswordConfirmationField(),
        
        SizedBox(height: 1.5.h),
        
        // Password requirements
        _buildPasswordRequirements(),
        
        SizedBox(height: 1.5.h),
          
        // Information note
        Container(
          padding: ResponsiveDesign.getPadding(all: 2.5.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2A78).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
            border: Border.all(color: const Color(0xFF1E2A78).withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.security,
                color: const Color(0xFF1E2A78),
                size: 3.5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Security',
                      style: TextStyle(
                        fontSize: ResponsiveDesign.getFontSize(3).w,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2A78),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '• Your password is encrypted and stored securely\n'
                      '• Use a strong password to protect your account\n'
                      '• You can change your password later in settings\n'
                      '• Keep your login credentials confidential',
                      style: TextStyle(
                        fontSize: ResponsiveDesign.getFontSize(3.2).w,
                        color: const Color(0xFF1E2A78),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ],
      );
  }

  Widget _buildBirthdayField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.cake,
              color: const Color(0xFF1E2A78),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Birthday',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                fontWeight: FontWeight.w600,
                color: Color(0xFF757575),
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                color: const Color(0xFFE22824),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 1.h),
        
        InkWell(
          onTap: _selectBirthday,
          child: Container(
            width: double.infinity,
            padding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Color(0xFF757575).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(color: Color(0xFF757575).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedBirthday != null
                        ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                        : 'Select your birthday',
                    style: TextStyle(
                      fontSize: ResponsiveDesign.getFontSize(3).w,
                      color: _selectedBirthday != null ? Color(0xFF757575) : Color(0xFF757575),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Color(0xFF757575),
                  size: 4.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCivilStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline,
              color: const Color(0xFF1E2A78),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Civil Status',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                fontWeight: FontWeight.w600,
                color: Color(0xFF757575),
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                color: const Color(0xFFE22824),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 1.h),
        
        InkWell(
          onTap: _selectCivilStatus,
          child: Container(
            width: double.infinity,
            padding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Color(0xFF757575).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              border: Border.all(color: Color(0xFF757575).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedCivilStatus != null
                        ? _civilStatusLabels[_selectedCivilStatus]!
                        : 'Select your civil status',
                    style: TextStyle(
                      fontSize: ResponsiveDesign.getFontSize(3).w,
                      color: _selectedCivilStatus != null ? Color(0xFF757575) : Color(0xFF757575),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF757575),
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lock,
              color: const Color(0xFF1E2A78),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Password',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                fontWeight: FontWeight.w600,
                color: Color(0xFF757575),
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                color: const Color(0xFFE22824),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 1.h),
        
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            hintStyle: TextStyle(
              color: Color(0xFF757575),
              fontSize: ResponsiveDesign.getFontSize(3.5).w,
            ),
            filled: true,
            fillColor: Color(0xFF757575).withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              borderSide: BorderSide(color: Color(0xFF757575).withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              borderSide: BorderSide(color: Color(0xFF757575).withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              borderSide: BorderSide(
                color: const Color(0xFF1E2A78),
                width: 2,
              ),
            ),
            contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w,
              vertical: 3.h,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFF757575),
                size: 4.w,
              ),
            ),
          ),
          style: TextStyle(
            fontSize: ResponsiveDesign.getFontSize(3.5).w,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordConfirmationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lock_outline,
              color: const Color(0xFF1E2A78),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                fontWeight: FontWeight.w600,
                color: Color(0xFF757575),
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(3.5).w,
                color: const Color(0xFFE22824),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 1.h),
        
        TextFormField(
          controller: _passwordConfirmationController,
          obscureText: _obscurePasswordConfirmation,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            hintStyle: TextStyle(
              color: Color(0xFF757575),
              fontSize: ResponsiveDesign.getFontSize(3.5).w,
            ),
            filled: true,
            fillColor: Color(0xFF757575).withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              borderSide: BorderSide(color: Color(0xFF757575).withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              borderSide: BorderSide(color: Color(0xFF757575).withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
              borderSide: BorderSide(
                color: const Color(0xFF1E2A78),
                width: 2,
              ),
            ),
            contentPadding: ResponsiveDesign.getPadding(horizontal: 4.w,
              vertical: 3.h,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePasswordConfirmation = !_obscurePasswordConfirmation;
                });
              },
              icon: Icon(
                _obscurePasswordConfirmation ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFF757575),
                size: 4.w,
              ),
            ),
          ),
          style: TextStyle(
            fontSize: ResponsiveDesign.getFontSize(3.5).w,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 2.5.w),
      decoration: BoxDecoration(
        color: const Color(0xFF28A745).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
        border: Border.all(color: const Color(0xFF28A745).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFF28A745),
                size: 3.5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Password Requirements',
                style: TextStyle(
                  fontSize: ResponsiveDesign.getFontSize(3).w,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF28A745),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 1.5.h),
          
          _buildRequirementItem('At least 8 characters long', _passwordController.text.length >= 8),
          _buildRequirementItem('Contains uppercase letter', _passwordController.text.contains(RegExp(r'[A-Z]'))),
          _buildRequirementItem('Contains lowercase letter', _passwordController.text.contains(RegExp(r'[a-z]'))),
          _buildRequirementItem('Contains number', _passwordController.text.contains(RegExp(r'[0-9]'))),
          _buildRequirementItem('Passwords match', _passwordController.text == _passwordConfirmationController.text && _passwordController.text.isNotEmpty),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: ResponsiveDesign.getPadding(bottom: 0.8.h),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? const Color(0xFF28A745) : Color(0xFF757575),
            size: 3.5.w,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveDesign.getFontSize(3.2).w,
              color: isMet ? const Color(0xFF28A745) : Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)), // At least 13 years old
    );
    
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        _onDataChanged();
      });
    }
  }

  void _selectCivilStatus() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: ResponsiveDesign.getPadding(all: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Civil Status',
              style: TextStyle(
                fontSize: ResponsiveDesign.getFontSize(5).w,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E2A78),
              ),
            ),
            
            SizedBox(height: 3.h),
            
            ..._civilStatusOptions.map((status) => ListTile(
              title: Text(
                _civilStatusLabels[status]!,
                style: TextStyle(fontSize: ResponsiveDesign.getFontSize(4).w),
              ),
              onTap: () {
                setState(() {
                  _selectedCivilStatus = status;
                  _onDataChanged();
                });
                Navigator.pop(context);
              },
              trailing: _selectedCivilStatus == status
                  ? Icon(Icons.check, color: const Color(0xFF1E2A78))
                  : null,
            )).toList(),
          ],
        ),
      ),
    );
  }
}
