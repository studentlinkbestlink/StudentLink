import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/responsive_design.dart';

class SimpleProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String studentId;
  final String course;
  final String yearLevel;
  final String? avatar;

  const SimpleProfileHeaderWidget({
    Key? key,
    required this.name,
    required this.studentId,
    required this.course,
    required this.yearLevel,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveDesign.getPadding(all: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A78),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF757575).withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 8.w,
            backgroundColor: Colors.white,
            backgroundImage: avatar != null && avatar!.isNotEmpty
                ? NetworkImage(avatar!)
                : null,
            child: avatar == null || avatar!.isEmpty
                ? Icon(
                    Icons.person,
                    size: 10.w,
                    color: const Color(0xFF1E2A78),
                  )
                : null,
          ),
          
          SizedBox(height: 3.h),
          
          // Name
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(5).w,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 1.h),
          
          // Student ID
          Text(
            'ID: $studentId',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(4).w,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 1.h),
          
          // Course and Year Level
          Text(
            '$course - $yearLevel',
            style: GoogleFonts.inter(
              fontSize: ResponsiveDesign.getFontSize(3.5).w,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
