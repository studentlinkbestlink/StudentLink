import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/api_service.dart';
import '../../../utils/responsive_design.dart';
import '../../../widgets/modern_dropdown_widget.dart';

class DepartmentSelectionWidget extends StatefulWidget {
  final String? selectedDepartment;
  final Function(String?) onChanged;
  final String? errorText;

  const DepartmentSelectionWidget({
    Key? key,
    required this.selectedDepartment,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  State<DepartmentSelectionWidget> createState() => _DepartmentSelectionWidgetState();
}

class _DepartmentSelectionWidgetState extends State<DepartmentSelectionWidget> {
  List<Map<String, dynamic>> _departments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadDepartments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      debugPrint('Loading departments from API...');
      final departments = await apiService.getDepartments();
      debugPrint('Departments loaded: ${departments.length}');
      
      if (mounted) {
        setState(() {
          _departments = departments;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading departments: $e');
      
      // Fallback to hardcoded departments if API fails
      final fallbackDepartments = [
        {'id': 1, 'name': 'Administration'},
        {'id': 2, 'name': 'BS Information Technology'},
        {'id': 3, 'name': 'BS Computer Engineering'},
        {'id': 4, 'name': 'BS Business Administration'},
        {'id': 5, 'name': 'BS Criminology'},
        {'id': 6, 'name': 'Bachelor of Elementary Education'},
        {'id': 7, 'name': 'BS Hospitality Management'},
        {'id': 8, 'name': 'Registrar Office'},
        {'id': 9, 'name': 'MIS Department'},
        {'id': 10, 'name': 'Prefect of Discipline'},
        {'id': 11, 'name': 'Library'},
        {'id': 12, 'name': 'Security'},
      ];
      
      if (mounted) {
        setState(() {
          _departments = fallbackDepartments;
          _isLoading = false;
          _error = null; // Clear error since we have fallback data
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isLoading)
          Container(
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF300300300)),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF1E2A78),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Loading departments...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        else if (_error != null && _departments.isEmpty)
          Container(
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE22824)),
              borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: const Color(0xFFE22824),
                    size: ResponsiveDesign.getIconSize(20),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Failed to load departments',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFE22824),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _loadDepartments,
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              if (_error != null && _departments.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.h),
                  margin: ResponsiveDesign.getPadding(bottom: 1.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28A745).withValues(alpha: 0.1),
                    border: Border.all(color: const Color(0xFF28A745)),
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8.0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: const Color(0xFF28A745), size: 16),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Using offline department list. Tap to retry.',
                          style: TextStyle(color: const Color(0xFF28A745), fontSize: ResponsiveDesign.getFontSize(12)),
                        ),
                      ),
                      GestureDetector(
                        onTap: _loadDepartments,
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: const Color(0xFF28A745),
                            fontSize: ResponsiveDesign.getFontSize(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ModernDropdownWidget<String>(
                value: widget.selectedDepartment,
                onChanged: widget.onChanged,
                label: 'Department *',
                hint: 'Select your department',
                errorText: widget.errorText,
                prefixIcon: Icon(
                  Icons.school_outlined,
                  color: const Color(0xFF1E2A78),
                ),
                items: _departments.map((dept) {
                  final name = dept['name'] as String;
                  return DropdownMenuItem<String>(
                    value: widget.selectedDepartment,
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
        ),
      ],
    );
  }
}
