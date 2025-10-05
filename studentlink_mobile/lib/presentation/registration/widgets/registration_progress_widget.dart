import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

class RegistrationProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDesign.getPadding(all: 4.w),
      child: Column(
        children: [
          // Progress text
          Text(
            'Step $currentStep of $totalSteps',
            style: TextStyle(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E2A78),
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Progress bar
          Row(
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < currentStep;
              final isCurrent = stepNumber == currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    // Step circle
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted || isCurrent
                            ? const Color(0xFF1E2A78)
                            : Color(0xFF757575),
                        border: Border.all(
                          color: isCompleted || isCurrent
                              ? const Color(0xFF1E2A78)
                              : Color(0xFF757575),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 4.w,
                              )
                            : Text(
                                stepNumber.toString(),
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : Color(0xFF757575),
                                  fontSize: ResponsiveDesign.getFontSize(3.5).w,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    // Connector line
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? const Color(0xFF1E2A78)
                              : Color(0xFF757575),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          
          SizedBox(height: 2.h),
          
          // Step titles
          Row(
            children: [
              Expanded(
                child: _buildStepTitle('ID', currentStep >= 1),
              ),
              Expanded(
                child: _buildStepTitle('Personal', currentStep >= 2),
              ),
              Expanded(
                child: _buildStepTitle('Contact', currentStep >= 3),
              ),
              Expanded(
                child: _buildStepTitle('Verify', currentStep >= 4),
              ),
              Expanded(
                child: _buildStepTitle('Additional', currentStep >= 5),
              ),
              Expanded(
                child: _buildStepTitle('Account', currentStep >= 6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, bool isActive) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: ResponsiveDesign.getFontSize(3).w,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive
            ? const Color(0xFF1E2A78)
            : Color(0xFF757575),
      ),
    );
  }
}
