import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusTimelineWidget extends StatelessWidget {
  final String currentStatus;
  final List<Map<String, dynamic>> statusHistory;

  const StatusTimelineWidget({
    super.key,
    required this.currentStatus,
    required this.statusHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timeline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Status Timeline',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildTimelineItems(context),
        ],
      ),
    );
  }

  Widget _buildTimelineItems(BuildContext context) {
    final allStatuses = ['Reported', 'Validated', 'In Progress', 'Fixed'];

    return Column(
      children: allStatuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = _isStatusCompleted(status);
        final isCurrent = status.toLowerCase() == currentStatus.toLowerCase();
        final isLast = index == allStatuses.length - 1;

        final statusData = statusHistory.firstWhere(
          (item) =>
              (item["status"] as String).toLowerCase() == status.toLowerCase(),
          orElse: () => <String, dynamic>{},
        );

        return _buildTimelineItem(
          context: context,
          status: status,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          isLast: isLast,
          timestamp: statusData.isNotEmpty
              ? statusData["timestamp"] as DateTime?
              : null,
          responsibleParty: statusData.isNotEmpty
              ? statusData["responsibleParty"] as String?
              : null,
          description: statusData.isNotEmpty
              ? statusData["description"] as String?
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required String status,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
    DateTime? timestamp,
    String? responsibleParty,
    String? description,
  }) {
    Color statusColor;
    IconData statusIcon;

    if (isCompleted) {
      statusColor = AppTheme.lightTheme.colorScheme.secondary;
      statusIcon = Icons.check_circle;
    } else if (isCurrent) {
      statusColor = AppTheme.lightTheme.colorScheme.primary;
      statusIcon = Icons.radio_button_checked;
    } else {
      statusColor = AppTheme.lightTheme.colorScheme.outline;
      statusIcon = Icons.radio_button_unchecked;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: statusColor, width: 2),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getIconName(statusIcon),
                  color: statusColor,
                  size: 16,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 6.h,
                color: statusColor.withValues(alpha: 0.3),
                margin: EdgeInsets.symmetric(vertical: 1.h),
              ),
          ],
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isCompleted || isCurrent
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (timestamp != null) ...[
                SizedBox(height: 0.5.h),
                Text(
                  _formatTimestamp(timestamp),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (responsibleParty != null) ...[
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        responsibleParty,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (description != null) ...[
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (!isLast) SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }

  bool _isStatusCompleted(String status) {
    final statusOrder = ['Reported', 'Validated', 'In Progress', 'Fixed'];
    final currentIndex = statusOrder.indexWhere(
      (s) => s.toLowerCase() == currentStatus.toLowerCase(),
    );
    final statusIndex = statusOrder.indexWhere(
      (s) => s.toLowerCase() == status.toLowerCase(),
    );

    return statusIndex <= currentIndex && currentIndex != -1;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.check_circle) return 'check_circle';
    if (icon == Icons.radio_button_checked) return 'radio_button_checked';
    return 'radio_button_unchecked';
  }
}
