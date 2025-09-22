import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Camera overlay widget with top controls (close, flash toggle)
class CameraOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onFlashToggle;
  final bool isFlashOn;
  final bool showFlash;

  const CameraOverlayWidget({
    super.key,
    required this.onClose,
    required this.onFlashToggle,
    required this.isFlashOn,
    this.showFlash = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),

                // Flash toggle button (only show on mobile)
                if (showFlash)
                  GestureDetector(
                    onTap: onFlashToggle,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: isFlashOn ? 'flash_on' : 'flash_off',
                          color: isFlashOn
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(width: 10.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
