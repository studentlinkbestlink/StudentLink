import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/responsive_design.dart';

class EditableFieldWidget extends StatefulWidget {
  final String initialValue;
  final String fieldKey;
  final Function(String) onChanged;
  final bool requiresVerification;

  const EditableFieldWidget({
    Key? key,
    required this.initialValue,
    required this.fieldKey,
    required this.onChanged,
    this.requiresVerification = false,
  }) : super(key: key);

  @override
  State<EditableFieldWidget> createState() => _EditableFieldWidgetState();
}

class _EditableFieldWidgetState extends State<EditableFieldWidget> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isEditing 
              ? Theme.of(context).colorScheme.primary 
              : Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF300300300),
          width: _isEditing ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              enabled: _isEditing,
              style: GoogleFonts.inter(
                fontSize: ResponsiveDesign.getFontSize(4).w,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: ResponsiveDesign.getPadding(horizontal: 3.w,
                  vertical: 2.h,
                ),
                hintText: 'Enter ${widget.fieldKey.replaceAll('_', ' ')}',
                hintStyle: GoogleFonts.inter(
                  fontSize: ResponsiveDesign.getFontSize(4).w,
                  color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              onChanged: (value) {
                widget.onChanged(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: _isEditing 
                  ? Theme.of(context).colorScheme.tertiary 
                  : Theme.of(context).colorScheme.primary,
              size: 5.w,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  // Save the changes
                  widget.onChanged(_controller.text);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
