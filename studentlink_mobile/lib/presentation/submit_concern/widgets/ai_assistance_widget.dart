import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';
import '../../../widgets/custom_icon_widget.dart';

class AiAssistanceWidget extends StatefulWidget {
  final TextEditingController textController;
  final Function(String) onSuggestionApplied;

  const AiAssistanceWidget({
    Key? key,
    required this.textController,
    required this.onSuggestionApplied,
  }) : super(key: key);

  @override
  State<AiAssistanceWidget> createState() => _AiAssistanceWidgetState();
}

class _AiAssistanceWidgetState extends State<AiAssistanceWidget> {
  bool _isLoading = false;

  void _showAiBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAiBottomSheet(),
    );
  }

  Widget _buildAiBottomSheet() {
    final List<Map<String, dynamic>> suggestions = [
      {
        'title': 'Academic Concern',
        'template':
            'I am experiencing difficulties with my academic requirements. Specifically, I need assistance with [describe your specific concern]. This issue is affecting my academic progress and I would appreciate guidance on how to resolve it.',
        'icon': 'school',
      },
      {
        'title': 'Financial Issue',
        'template':
            'I am writing to address a financial concern regarding my student account. The issue involves [describe the financial matter]. I would like to request assistance in resolving this matter as it impacts my enrollment status.',
        'icon': 'account_balance_wallet',
      },
      {
        'title': 'Facility Problem',
        'template':
            'I would like to report a facility-related issue that requires attention. The problem is located at [specify location] and involves [describe the issue]. This affects the learning environment and needs prompt resolution.',
        'icon': 'build',
      },
      {
        'title': 'Technical Support',
        'template':
            'I am encountering technical difficulties with [specify system/service]. The issue prevents me from [describe what you cannot do]. I need technical assistance to resolve this problem and continue with my academic activities.',
        'icon': 'computer',
      },
    ];

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: ResponsiveDesign.getPadding(all: 4.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A78),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'auto_awesome',
                  color: Colors.white,
                  size: ResponsiveDesign.getIconSize(24),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'AI Writing Assistant',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: ResponsiveDesign.getIconSize(24),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveDesign.getPadding(all: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a template to get started:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...suggestions
                      .map((suggestion) => _buildSuggestionCard(suggestion))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return Card(
      margin: ResponsiveDesign.getPadding(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
      ),
      child: InkWell(
        onTap: () {
          widget.onSuggestionApplied(suggestion['template']);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
        child: Padding(
          padding: ResponsiveDesign.getPadding(all: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: ResponsiveDesign.getPadding(all: 2.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2A78)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(8.0)),
                    ),
                    child: CustomIconWidget(
                      iconName: suggestion['icon'],
                      color: const Color(0xFF1E2A78),
                      size: ResponsiveDesign.getIconSize(20),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      suggestion['title'],
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: ResponsiveDesign.getIconSize(16),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                suggestion['template'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDesign.getPadding(top: 1.h),
      child: ElevatedButton.icon(
        onPressed: _showAiBottomSheet,
        icon: _isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : CustomIconWidget(
                iconName: 'auto_awesome',
                color: Colors.white,
                size: ResponsiveDesign.getIconSize(18),
              ),
        label: Text(
          _isLoading ? 'Generating...' : 'AI Writing Assistant',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2480EA),
          foregroundColor: Colors.white,
          padding: ResponsiveDesign.getPadding(horizontal: 4.w, vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(12.0)),
          ),
        ),
      ),
    );
  }
}
