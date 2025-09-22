import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> fixerData;
  final VoidCallback onEditProfile;
  final VoidCallback onAvatarTap;

  const ProfileHeaderWidget({
    super.key,
    required this.fixerData,
    required this.onEditProfile,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.w),
          bottomRight: Radius.circular(6.w),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Fixer Profile',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onEditProfile,
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                  tooltip: 'Edit Profile',
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                GestureDetector(
                  onTap: onAvatarTap,
                  child: Stack(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: fixerData['avatar'] != null
                              ? CustomImageWidget(
                                  imageUrl: fixerData['avatar'] as String,
                                  width: 20.w,
                                  height: 20.w,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onPrimary
                                      .withValues(alpha: 0.2),
                                  child: CustomIconWidget(
                                    iconName: 'person',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 10.w,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              width: 2,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'camera_alt',
                            color: AppTheme.lightTheme.colorScheme.onTertiary,
                            size: 3.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              fixerData['name'] as String? ?? 'Unknown Fixer',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (fixerData['isVerified'] == true) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'verified',
                                color: Colors.white,
                                size: 4.w,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8),
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              fixerData['location'] as String? ??
                                  'Location not set',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onPrimary
                                    .withValues(alpha: 0.9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.warningLight,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${fixerData['rating']?.toStringAsFixed(1) ?? '0.0'} (${fixerData['totalReviews'] ?? 0} reviews)',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary
                                  .withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
