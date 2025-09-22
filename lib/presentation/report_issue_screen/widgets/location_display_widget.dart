import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Location display widget with GPS coordinates and accuracy
class LocationDisplayWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final VoidCallback onEditLocation;
  final bool isLoading;

  const LocationDisplayWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.accuracy,
    required this.onEditLocation,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onEditLocation,
                child: Text(
                  'Edit Location',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: isLoading
              ? Row(
                  children: [
                    SizedBox(
                      width: 4.w,
                      height: 4.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Getting location...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                )
              : latitude != null && longitude != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lat: ${latitude!.toStringAsFixed(6)}',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Lng: ${longitude!.toStringAsFixed(6)}',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (accuracy != null) ...[
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: accuracy! <= 10
                                    ? 'gps_fixed'
                                    : 'gps_not_fixed',
                                color: accuracy! <= 10
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : AppTheme.lightTheme.colorScheme.tertiary,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Accuracy: ${accuracy!.toStringAsFixed(0)}m',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    )
                  : Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_off',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Location not available. Tap "Edit Location" to set manually.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }
}
