import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatisticsCardsWidget extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const StatisticsCardsWidget({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Performance Statistics',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: 'handyman',
                  title: 'Total Fixes',
                  value: '${statistics['totalFixes'] ?? 0}',
                  subtitle: 'Completed',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: 'star',
                  title: 'Rating',
                  value:
                      '${(statistics['rating'] as num?)?.toStringAsFixed(1) ?? '0.0'}',
                  subtitle: '${statistics['totalReviews'] ?? 0} reviews',
                  color: AppTheme.warningLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: 'schedule',
                  title: 'Avg Response',
                  value: '${statistics['avgResponseTime'] ?? 0}h',
                  subtitle: 'Response time',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: 'payments',
                  title: 'Earnings',
                  value: '\$${statistics['totalEarnings'] ?? 0}',
                  subtitle: 'Total earned',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
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
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 6.w,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'trending_up',
                      color: AppTheme.successLight,
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '+12%',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
