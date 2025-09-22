import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({super.key});

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);

    try {
      // Simulate Google OAuth process
      await Future.delayed(const Duration(seconds: 2));

      HapticFeedback.lightImpact();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/splash-screen',
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorMessage('Google login failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handleFacebookLogin() async {
    setState(() => _isFacebookLoading = true);

    try {
      // Simulate Facebook OAuth process
      await Future.delayed(const Duration(seconds: 2));

      HapticFeedback.lightImpact();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/splash-screen',
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorMessage('Facebook login failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isFacebookLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Google Login Button
        SizedBox(
          height: 6.h,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isGoogleLoading || _isFacebookLoading
                ? null
                : _handleGoogleLogin,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isGoogleLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageWidget(
                        imageUrl:
                            'https://developers.google.com/identity/images/g-logo.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Continue with Google',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        SizedBox(height: 3.h),

        // Facebook Login Button
        SizedBox(
          height: 6.h,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isGoogleLoading || _isFacebookLoading
                ? null
                : _handleFacebookLogin,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isFacebookLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1877F2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'facebook',
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Continue with Facebook',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        SizedBox(height: 4.h),

        // Privacy Notice
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'By continuing, you agree to our Terms of Service and Privacy Policy. Your data is protected and secure.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
