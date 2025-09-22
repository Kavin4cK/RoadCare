import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IssueMetadataWidget extends StatelessWidget {
  final Map<String, dynamic> issueData;

  const IssueMetadataWidget({
    super.key,
    required this.issueData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCategoryBadge(context),
              SizedBox(width: 3.w),
              _buildPriorityBadge(context),
              Spacer(),
              _buildShareButton(context),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            issueData["title"] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                _formatDate(issueData["reportDate"] as DateTime),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Reported by ${issueData["reporterName"] as String}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () => _openInMaps(context),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    issueData["address"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'open_in_new',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    final category = issueData["category"] as String;
    Color badgeColor;
    IconData categoryIcon;

    switch (category.toLowerCase()) {
      case 'pothole':
        badgeColor = AppTheme.lightTheme.colorScheme.error;
        categoryIcon = Icons.warning;
        break;
      case 'garbage':
        badgeColor = AppTheme.lightTheme.colorScheme.secondary;
        categoryIcon = Icons.delete_outline;
        break;
      case 'streetlight':
        badgeColor = Colors.amber;
        categoryIcon = Icons.lightbulb_outline;
        break;
      case 'drain':
        badgeColor = Colors.blue;
        categoryIcon = Icons.water_drop_outlined;
        break;
      default:
        badgeColor = AppTheme.lightTheme.colorScheme.primary;
        categoryIcon = Icons.report_problem_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            categoryIcon,
            size: 16,
            color: badgeColor,
          ),
          SizedBox(width: 1.w),
          Text(
            category,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final priority = issueData["priority"] as String;
    Color priorityColor;

    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = AppTheme.lightTheme.colorScheme.error;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      case 'low':
        priorityColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      default:
        priorityColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$priority Priority',
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: priorityColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return IconButton(
      onPressed: () => _shareIssue(context),
      icon: CustomIconWidget(
        iconName: 'share',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      tooltip: 'Share Issue',
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

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

  void _openInMaps(BuildContext context) {
    final latitude = issueData["latitude"] as double;
    final longitude = issueData["longitude"] as double;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening location: $latitude, $longitude'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareIssue(BuildContext context) {
    final title = issueData["title"] as String;
    final address = issueData["address"] as String;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: $title at $address'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
