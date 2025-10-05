import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/responsive_design.dart';

class AnnouncementCategoryFilterBar extends StatefulWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategorySelected;
  final ScrollController? scrollController;

  const AnnouncementCategoryFilterBar({
    Key? key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
    this.scrollController,
  }) : super(key: key);

  @override
  State<AnnouncementCategoryFilterBar> createState() => _AnnouncementCategoryFilterBarState();
}

class _AnnouncementCategoryFilterBarState extends State<AnnouncementCategoryFilterBar> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: ResponsiveDesign.getPadding(horizontal: 24, vertical: 8),
      child: Stack(
        children: [
          // Main scrollable filter bar
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: widget.categories.map((category) {
                final isSelected = category == widget.selectedCategory;
                return Padding(
                  padding: ResponsiveDesign.getPadding(right: 8),
                  child: _buildCategoryPill(category, isSelected),
                );
              }).toList(),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onCategorySelected(category);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: ResponsiveDesign.getPadding(horizontal: 12, vertical: 10),
        constraints: BoxConstraints(
          minHeight: 36,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: 1,
          ),
          boxShadow: Theme.of(context).brightness == Brightness.light ? (isSelected ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ]) : null,
        ),
        child: Text(
          _getCategoryDisplayName(category),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected 
                ? Colors.white 
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected 
                ? FontWeight.w600 
                : FontWeight.w500,
            fontSize: ResponsiveDesign.getFontSize(13),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    // Return full category names for better clarity
    switch (category) {
      case 'All':
        return 'All';
      case 'Academic Modules':
        return 'Academic Modules';
      case 'Class Schedules & Exams':
        return 'Class Schedules & Exams';
      case 'Enrollment & Clearance':
        return 'Enrollment & Clearance';
      case 'Scholarships & Financial Aid':
        return 'Scholarships & Financial Aid';
      case 'Student Activities & Events':
        return 'Student Activities & Events';
      case 'Emergency Notices':
        return 'Emergency Notices';
      case 'Administrative Updates':
        return 'Administrative Updates';
      case 'OJT & Career Services':
        return 'OJT & Career Services';
      case 'Campus Ministry':
        return 'Campus Ministry';
      case 'Faculty Announcements':
        return 'Faculty Announcements';
      case 'System Maintenance':
        return 'System Maintenance';
      case 'Student Services':
        return 'Student Services';
      default:
        return category;
    }
  }
}
