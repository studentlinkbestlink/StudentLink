import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/responsive_design.dart';

class ProfileInfoCardWidget extends StatelessWidget {
  final List<Widget> children;

  const ProfileInfoCardWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF757575).withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: ResponsiveDesign.getPadding(all: 4.w),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
