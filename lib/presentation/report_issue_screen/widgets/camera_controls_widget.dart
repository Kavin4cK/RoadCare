import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Bottom camera controls with capture, gallery, and flip buttons
class CameraControlsWidget extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final VoidCallback onFlipCamera;
  final bool showFlipCamera;

  const CameraControlsWidget({
    super.key,
    required this.onCapture,
    required this.onGallery,
    required this.onFlipCamera,
    this.showFlipCamera = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gallery button
                GestureDetector(
                  onTap: onGallery,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'photo_library',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),

                // Capture button (large, centered)
                GestureDetector(
                  onTap: onCapture,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // Camera flip button
                if (showFlipCamera)
                  GestureDetector(
                    onTap: onFlipCamera,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'flip_camera_ios',
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(width: 12.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
