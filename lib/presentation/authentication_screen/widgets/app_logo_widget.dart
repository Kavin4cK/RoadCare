import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AppLogoWidget extends StatelessWidget {
  final double? size;
  final bool showText;

  const AppLogoWidget({
    super.key,
    this.size,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoSize = size ?? 20.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Container
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(logoSize * 0.2),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Road icon background
              CustomIconWidget(
                iconName: 'route',
                color: Colors.white.withValues(alpha: 0.2),
                size: logoSize * 0.6,
              ),
              // Main road icon
              CustomIconWidget(
                iconName: 'construction',
                color: Colors.white,
                size: logoSize * 0.4,
              ),
            ],
          ),
        ),

        if (showText) ...[
          SizedBox(height: 3.h),

          // App Name
          Text(
            'RoadCare',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 1.h),

          // Tagline
          Text(
            'Building Better Communities Together',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
