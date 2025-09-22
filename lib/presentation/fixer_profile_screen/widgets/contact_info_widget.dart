import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactInfoWidget extends StatelessWidget {
  final Map<String, dynamic> contactInfo;
  final VoidCallback onEditContact;

  const ContactInfoWidget({
    super.key,
    required this.contactInfo,
    required this.onEditContact,
  });

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
                iconName: 'contact_phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Contact Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onEditContact,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                tooltip: 'Edit Contact',
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildContactItem(
            icon: 'phone',
            label: 'Phone Number',
            value: contactInfo['phone'] as String? ?? 'Not provided',
            isVerified: contactInfo['phoneVerified'] as bool? ?? false,
            onTap: () => _handlePhoneAction(context),
          ),
          SizedBox(height: 2.h),
          _buildContactItem(
            icon: 'email',
            label: 'Email Address',
            value: contactInfo['email'] as String? ?? 'Not provided',
            isVerified: contactInfo['emailVerified'] as bool? ?? false,
            onTap: () => _handleEmailAction(context),
          ),
          if (contactInfo['socialMedia'] != null) ...[
            SizedBox(height: 2.h),
            _buildSocialMediaSection(
                contactInfo['socialMedia'] as Map<String, dynamic>),
          ],
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required String icon,
    required String label,
    required String value,
    required bool isVerified,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isVerified) ...[
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.w),
                          decoration: BoxDecoration(
                            color: AppTheme.successLight,
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'verified',
                                color: Colors.white,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Verified',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(Map<String, dynamic> socialMedia) {
    final List<Map<String, String>> socialPlatforms = [
      if (socialMedia['facebook'] != null)
        {
          'platform': 'Facebook',
          'icon': 'facebook',
          'url': socialMedia['facebook'] as String
        },
      if (socialMedia['twitter'] != null)
        {
          'platform': 'Twitter',
          'icon': 'alternate_email',
          'url': socialMedia['twitter'] as String
        },
      if (socialMedia['instagram'] != null)
        {
          'platform': 'Instagram',
          'icon': 'camera_alt',
          'url': socialMedia['instagram'] as String
        },
      if (socialMedia['linkedin'] != null)
        {
          'platform': 'LinkedIn',
          'icon': 'work',
          'url': socialMedia['linkedin'] as String
        },
    ];

    if (socialPlatforms.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social Media',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: socialPlatforms.map((platform) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: platform['icon']!,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    platform['platform']!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _handlePhoneAction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'call',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Call'),
              onTap: () {
                Navigator.pop(context);
                // Handle call action
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Send SMS'),
              onTap: () {
                Navigator.pop(context);
                // Handle SMS action
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleEmailAction(BuildContext context) {
    // Handle email action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email client will open'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
