import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Horizontal scrollable category selector for issue types
class IssueCategorySelectorWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const IssueCategorySelectorWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> categories = [
    {
      'id': 'potholes',
      'name': 'Potholes',
      'icon': 'construction',
      'color': Color(0xFFE57373),
    },
    {
      'id': 'garbage',
      'name': 'Garbage',
      'icon': 'delete_outline',
      'color': Color(0xFF81C784),
    },
    {
      'id': 'drains',
      'name': 'Drains',
      'icon': 'water_drop',
      'color': Color(0xFF64B5F6),
    },
    {
      'id': 'streetlights',
      'name': 'Street Lights',
      'icon': 'lightbulb_outline',
      'color': Color(0xFFFFB74D),
    },
    {
      'id': 'traffic',
      'name': 'Traffic Signs',
      'icon': 'traffic',
      'color': Color(0xFFBA68C8),
    },
    {
      'id': 'other',
      'name': 'Other',
      'icon': 'more_horiz',
      'color': Color(0xFF90A4AE),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Issue Category',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category['id'];

              return GestureDetector(
                onTap: () => onCategorySelected(category['id']),
                child: Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category['color'].withValues(alpha: 0.2)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(
                      color: isSelected
                          ? category['color']
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? category['color']
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: category['icon'],
                            color: Colors.white,
                            size: 4.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        category['name'],
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? category['color']
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
