import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Civic-themed gradient background for splash screen
/// Provides branded visual identity with safe area handling
class CivicGradientBackground extends StatelessWidget {
  final Widget child;

  const CivicGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
            AppTheme.lightTheme.colorScheme.secondary,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
