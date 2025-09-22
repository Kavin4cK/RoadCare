import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BeforeAfterComparisonWidget extends StatefulWidget {
  final String beforeImage;
  final String afterImage;

  const BeforeAfterComparisonWidget({
    super.key,
    required this.beforeImage,
    required this.afterImage,
  });

  @override
  State<BeforeAfterComparisonWidget> createState() =>
      _BeforeAfterComparisonWidgetState();
}

class _BeforeAfterComparisonWidgetState
    extends State<BeforeAfterComparisonWidget> {
  bool _showBefore = true;

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
                iconName: 'compare',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Before & After',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Fixed',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildComparisonView(),
          SizedBox(height: 2.h),
          _buildToggleButtons(),
        ],
      ),
    );
  }

  Widget _buildComparisonView() {
    return Container(
      height: 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: CustomImageWidget(
                key: ValueKey(_showBefore ? 'before' : 'after'),
                imageUrl: _showBefore ? widget.beforeImage : widget.afterImage,
                width: double.infinity,
                height: 25.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 2.h,
              left: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _showBefore ? 'BEFORE' : 'AFTER',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'swipe_horizontal',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _showBefore = true),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: _showBefore
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _showBefore
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'photo_camera',
                    color: _showBefore
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Before',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: _showBefore
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _showBefore = false),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: !_showBefore
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !_showBefore
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: !_showBefore
                        ? AppTheme.lightTheme.colorScheme.onSecondary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'After',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: !_showBefore
                          ? AppTheme.lightTheme.colorScheme.onSecondary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
