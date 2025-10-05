import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'terms_of_service_widget.dart';
import 'privacy_policy_widget.dart';
import '../../../utils/responsive_design.dart';

class Step5AccountCreationWidget extends StatefulWidget {
  final Function(String? password, String? passwordConfirmation) onDataChanged;

  const Step5AccountCreationWidget({
    Key? key,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<Step5AccountCreationWidget> createState() =>
      _Step5AccountCreationWidgetState();
}

class _Step5AccountCreationWidgetState
    extends State<Step5AccountCreationWidget> {
  bool _isTermsAccepted = false;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Create Your Account',
          style: TextStyle(
            fontSize: ResponsiveDesign.getFontSize(5.5).w,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        SizedBox(height: 1.5.h),

        Text(
          'Review your information and agree to the terms to complete your registration.',
          style: TextStyle(
            fontSize: ResponsiveDesign.getFontSize(3.8).w,
            color: Theme.of(context).textTheme.bodySmall?.color,
            height: 1.4,
          ),
        ),

        SizedBox(height: 3.h),

        // Account summary
        Container(
          padding: ResponsiveDesign.getPadding(all: 2.5.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 3.5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Account Summary',
                    style: TextStyle(
                      fontSize: ResponsiveDesign.getFontSize(3.5).w,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              Text(
                'Your account will be created with the following information:',
                style: TextStyle(
                  fontSize: ResponsiveDesign.getFontSize(3.2).w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 1.5.h),
              _buildSummaryItem('Student ID', 'Auto-generated unique ID'),
              _buildSummaryItem('School Email', 'Auto-generated school email'),
              _buildSummaryItem(
                  'Personal Information', 'Name, birthday, civil status'),
              _buildSummaryItem(
                  'Contact Information', 'Personal email and phone number'),
              _buildSummaryItem(
                  'Account Security', 'Secure password protection'),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Terms and conditions
        Container(
          padding: ResponsiveDesign.getPadding(all: 2.5.w),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
            border: Border.all(
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.3) ??
                    Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: ResponsiveDesign.getFontSize(3.5).w,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),

              SizedBox(height: 1.5.h),

              // Terms agreement
              CheckboxListTile(
                  value: _isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  checkColor: Theme.of(context).colorScheme.onPrimary,
                  fillColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.surface;
                  }),
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.outline,
                    width: 1.5,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'I agree to the ',
                          style: TextStyle(
                            fontSize: ResponsiveDesign.getFontSize(3.2).w,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TermsOfServiceWidget(),
                            ),
                          );
                        },
                        child: Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontSize: ResponsiveDesign.getFontSize(3.2).w,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero),

              // Privacy agreement
              CheckboxListTile(
                  value: _isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _agreeToPrivacy = value ?? false;
                    });
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  checkColor: Theme.of(context).colorScheme.onPrimary,
                  fillColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.surface;
                  }),
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.outline,
                    width: 1.5,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'I agree to the ',
                          style: TextStyle(
                            fontSize: ResponsiveDesign.getFontSize(3.2).w,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyWidget(),
                            ),
                          );
                        },
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: ResponsiveDesign.getFontSize(3.2).w,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Information note
        Container(
          padding: ResponsiveDesign.getPadding(all: 2.5.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(ResponsiveDesign.getBorderRadius(10)),
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.tertiary,
                size: 3.5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Create Account',
                      style: TextStyle(
                        fontSize: ResponsiveDesign.getFontSize(3.5).w,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Once you create your account, you will be automatically logged in and can start using the StudentLink app immediately.',
                      style: TextStyle(
                        fontSize: ResponsiveDesign.getFontSize(3.2).w,
                        color: Theme.of(context).colorScheme.tertiary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.5.h),

        // Validation message
        if (!_agreeToTerms || !_agreeToPrivacy)
          Container(
            padding: ResponsiveDesign.getPadding(all: 2.5.w),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .errorContainer
                  .withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Theme.of(context).colorScheme.error,
                  size: 3.5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Please agree to the Terms of Service and Privacy Policy to continue.',
                    style: TextStyle(
                      fontSize: ResponsiveDesign.getFontSize(3.2).w,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryItem(String title, String description) {
    return Padding(
      padding: ResponsiveDesign.getPadding(bottom: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.tertiary,
            size: 3.5.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveDesign.getFontSize(3.2).w,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: ResponsiveDesign.getFontSize(2.8).w,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
