import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/responsive_design.dart';

/// Widget for displaying quick suggestion chips
class QuickSuggestionsWidget extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  const QuickSuggestionsWidget({
    Key? key,
    required this.suggestions,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ResponsiveDesign.getPadding(horizontal: 4.w),
          child: Text(
            'Quick suggestions:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: ResponsiveDesign.getPadding(horizontal: 4.w),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return Container(
                margin: ResponsiveDesign.getPadding(right: 2.w),
                child: ActionChip(
                  label: Text(
                    suggestions[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.1),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveDesign.getBorderRadius(20)),
                  ),
                  onPressed: () => onSuggestionTap(suggestions[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
