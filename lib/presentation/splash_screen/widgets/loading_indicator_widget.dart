import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Loading indicator widget for splash screen
/// Shows initialization progress with platform-specific styling
class LoadingIndicatorWidget extends StatelessWidget {
  final String loadingText;
  final bool showProgress;

  const LoadingIndicatorWidget({
    super.key,
    this.loadingText = 'Initializing RoadCare...',
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showProgress) ...[
          SizedBox(
            width: 8.w,
            height: 8.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 3.h),
        ],
        Text(
          loadingText,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.8),
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
