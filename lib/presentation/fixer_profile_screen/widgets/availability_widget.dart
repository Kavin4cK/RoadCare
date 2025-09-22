import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvailabilityWidget extends StatefulWidget {
  final bool isAvailable;
  final Map<String, dynamic> schedule;
  final Function(bool) onAvailabilityChanged;
  final Function(Map<String, dynamic>) onScheduleChanged;

  const AvailabilityWidget({
    super.key,
    required this.isAvailable,
    required this.schedule,
    required this.onAvailabilityChanged,
    required this.onScheduleChanged,
  });

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  late bool _isAvailable;
  late Map<String, dynamic> _schedule;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.isAvailable;
    _schedule = Map<String, dynamic>.from(widget.schedule);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Availability',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Switch(
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                  widget.onAvailabilityChanged(value);
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _isAvailable
                  ? AppTheme.successLight.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: _isAvailable
                    ? AppTheme.successLight.withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: _isAvailable
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  _isAvailable
                      ? 'Available for new fixes'
                      : 'Currently unavailable',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _isAvailable
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (_isAvailable) ...[
            SizedBox(height: 3.h),
            Text(
              'Working Hours',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildScheduleSelector(),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleSelector() {
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final List<String> fullDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final fullDay = fullDays[index];
            final isSelected = (_schedule['workingDays'] as List?)
                    ?.contains(fullDay.toLowerCase()) ??
                false;

            return GestureDetector(
              onTap: () => _toggleDay(fullDay.toLowerCase()),
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: _buildTimeSelector(
                label: 'Start Time',
                time: _schedule['startTime'] as String? ?? '09:00',
                onTimeChanged: (time) {
                  setState(() {
                    _schedule['startTime'] = time;
                  });
                  widget.onScheduleChanged(_schedule);
                },
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildTimeSelector(
                label: 'End Time',
                time: _schedule['endTime'] as String? ?? '17:00',
                onTimeChanged: (time) {
                  setState(() {
                    _schedule['endTime'] = time;
                  });
                  widget.onScheduleChanged(_schedule);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required String time,
    required Function(String) onTimeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () => _selectTime(context, time, onTimeChanged),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  time,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _toggleDay(String day) {
    setState(() {
      final workingDays =
          (_schedule['workingDays'] as List?)?.cast<String>() ?? <String>[];
      if (workingDays.contains(day)) {
        workingDays.remove(day);
      } else {
        workingDays.add(day);
      }
      _schedule['workingDays'] = workingDays;
    });
    widget.onScheduleChanged(_schedule);
  }

  Future<void> _selectTime(BuildContext context, String currentTime,
      Function(String) onTimeChanged) async {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      final formattedTime =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      onTimeChanged(formattedTime);
    }
  }
}
