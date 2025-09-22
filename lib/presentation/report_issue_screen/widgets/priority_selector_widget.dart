import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Priority selector with visual severity indicators
class PrioritySelectorWidget extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onPrioritySelected;

  const PrioritySelectorWidget({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  static const List<Map<String, dynamic>> priorities = [
    {
      'id': 'low',
      'name': 'Low',
      'description': 'Minor inconvenience',
      'color': Color(0xFF81C784),
      'icon': 'keyboard_arrow_down',
    },
    {
      'id': 'medium',
      'name': 'Medium',
      'description': 'Moderate concern',
      'color': Color(0xFFFFB74D),
      'icon': 'remove',
    },
    {
      'id': 'high',
      'name': 'High',
      'description': 'Significant issue',
      'color': Color(0xFFFF8A65),
      'icon': 'keyboard_arrow_up',
    },
    {
      'id': 'urgent',
      'name': 'Urgent',
      'description': 'Safety hazard',
      'color': Color(0xFFE57373),
      'icon': 'priority_high',
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
            'Priority Level',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: priorities.map((priority) {
              final isSelected = selectedPriority == priority['id'];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onPrioritySelected(priority['id']),
                  child: Container(
                    margin: EdgeInsets.only(right: 2.w),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? priority['color'].withValues(alpha: 0.2)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: isSelected
                            ? priority['color']
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: priority['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: priority['icon'],
                              color: Colors.white,
                              size: 3.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          priority['name'],
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? priority['color']
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        Text(
                          priority['description'],
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
