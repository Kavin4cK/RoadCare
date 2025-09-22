import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/phone_otp_widget.dart';
import './widgets/register_form_widget.dart';
import './widgets/social_login_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _loginTabController;
  int _currentIndex = 0;
  int _loginMethodIndex = 0; // 0: Email, 1: Phone OTP

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loginTabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() => _currentIndex = _tabController.index);
    });

    _loginTabController.addListener(() {
      setState(() => _loginMethodIndex = _loginTabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginTabController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildForgotPasswordSheet(),
    );
  }

  Widget _buildForgotPasswordSheet() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            'Reset Password',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset link sent to your email'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Send Reset Link',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 2.h),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/splash-screen',
                        (route) => false,
                      ),
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // App Logo
                  const Center(child: AppLogoWidget()),

                  SizedBox(height: 6.h),

                  // Main Tab Bar (Login/Register)
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.all(4),
                      labelColor: theme.colorScheme.onPrimary,
                      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                      labelStyle: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle:
                          theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Register'),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Tab Content
                  SizedBox(
                    height: _currentIndex == 0
                        ? (_loginMethodIndex == 0 ? 50.h : 45.h)
                        : 60.h,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Login Tab
                        Column(
                          children: [
                            // Login Method Tabs (Email/Phone)
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TabBar(
                                controller: _loginTabController,
                                indicator: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.shadow
                                          .withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorPadding: const EdgeInsets.all(2),
                                labelColor: theme.colorScheme.primary,
                                unselectedLabelColor:
                                    theme.colorScheme.onSurfaceVariant,
                                labelStyle:
                                    theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelStyle:
                                    theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                                tabs: const [
                                  Tab(text: 'Email'),
                                  Tab(text: 'Phone OTP'),
                                ],
                              ),
                            ),

                            SizedBox(height: 4.h),

                            // Login Method Content
                            Expanded(
                              child: TabBarView(
                                controller: _loginTabController,
                                children: [
                                  // Email Login
                                  LoginFormWidget(
                                    onForgotPasswordPressed:
                                        _handleForgotPassword,
                                  ),

                                  // Phone OTP Login
                                  const PhoneOtpWidget(),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Register Tab
                        const RegisterFormWidget(),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Social Login
                  const SocialLoginWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
