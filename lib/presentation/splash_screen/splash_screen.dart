import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/civic_gradient_background.dart';
import './widgets/error_retry_widget.dart';
import './widgets/loading_indicator_widget.dart';

/// Splash Screen for RoadCare civic-tech application
/// Handles app initialization, authentication check, and navigation routing
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _loadingText = 'Initializing RoadCare...';
  bool _animationCompleted = false;

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    "isAuthenticated": false,
    "userId": "user_12345",
    "userName": "John Doe",
    "userType": "citizen", // citizen, fixer, admin
    "hasCompletedOnboarding": false,
    "lastLoginDate": "2025-09-20",
    "locationPermissionGranted": false,
    "cameraPermissionGranted": false,
  };

  @override
  void initState() {
    super.initState();
    _setSystemUIOverlay();
    _initializeApp();
  }

  /// Set system UI overlay style for branded experience
  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.lightTheme.colorScheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  /// Initialize app with all required services and checks
  Future<void> _initializeApp() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _loadingText = 'Checking connectivity...';
      });

      // Step 1: Check network connectivity
      await _checkConnectivity();

      setState(() {
        _loadingText = 'Loading user preferences...';
      });

      // Step 2: Load user preferences and authentication status
      await _loadUserPreferences();

      setState(() {
        _loadingText = 'Checking permissions...';
      });

      // Step 3: Check and request essential permissions
      await _checkPermissions();

      setState(() {
        _loadingText = 'Preparing map services...';
      });

      // Step 4: Initialize map services and cached data
      await _initializeMapServices();

      setState(() {
        _loadingText = 'Finalizing setup...';
      });

      // Step 5: Handle deep links if any
      await _handleDeepLinks();

      // Wait for animation to complete before navigation
      if (!_animationCompleted) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Step 6: Navigate based on user state
      await _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage = _getErrorMessage(e);
      });
    }
  }

  /// Check network connectivity
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw Exception('No internet connection available');
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Load user preferences and authentication status
  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Simulate loading user data
    await Future.delayed(const Duration(milliseconds: 800));

    // Check authentication status
    final isAuthenticated =
        prefs.getBool('isAuthenticated') ?? _mockUserData['isAuthenticated'];
    final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ??
        _mockUserData['hasCompletedOnboarding'];

    _mockUserData['isAuthenticated'] = isAuthenticated;
    _mockUserData['hasCompletedOnboarding'] = hasCompletedOnboarding;
  }

  /// Check and request essential permissions
  Future<void> _checkPermissions() async {
    // Check location permission
    final locationStatus = await Permission.location.status;
    _mockUserData['locationPermissionGranted'] = locationStatus.isGranted;

    // Check camera permission
    final cameraStatus = await Permission.camera.status;
    _mockUserData['cameraPermissionGranted'] = cameraStatus.isGranted;

    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// Initialize map services and load cached issue data
  Future<void> _initializeMapServices() async {
    // Simulate map service initialization
    await Future.delayed(const Duration(milliseconds: 700));

    // Mock cached issues data
    final List<Map<String, dynamic>> cachedIssues = [
      {
        "id": "issue_001",
        "title": "Pothole on Main Street",
        "category": "Infrastructure",
        "status": "Open",
        "location": {"lat": 40.7128, "lng": -74.0060},
        "reportedDate": "2025-09-20T10:30:00Z",
        "priority": "High",
      },
      {
        "id": "issue_002",
        "title": "Broken Streetlight",
        "category": "Safety",
        "status": "In Progress",
        "location": {"lat": 40.7589, "lng": -73.9851},
        "reportedDate": "2025-09-19T15:45:00Z",
        "priority": "Medium",
      },
    ];

    // Store cached data
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedIssues', cachedIssues.toString());
  }

  /// Handle deep links for shared issues
  Future<void> _handleDeepLinks() async {
    // Simulate deep link handling
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock deep link data
    final Map<String, dynamic> deepLinkData = {
      "hasDeepLink": false,
      "issueId": null,
      "action": null,
    };

    if (deepLinkData['hasDeepLink'] == true) {
      // Store deep link intent for after authentication
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pendingDeepLink', deepLinkData.toString());
    }
  }

  /// Navigate to appropriate screen based on user state
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    String targetRoute;

    if (_mockUserData['isAuthenticated'] == true) {
      // Authenticated users go to issue details (map dashboard)
      targetRoute = '/issue-details-screen';
    } else if (_mockUserData['hasCompletedOnboarding'] == true) {
      // Returning users who haven't authenticated
      targetRoute = '/authentication-screen';
    } else {
      // New users see authentication with onboarding
      targetRoute = '/authentication-screen';
    }

    // Navigate with fade transition
    Navigator.pushReplacementNamed(context, targetRoute);
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('internet') ||
        error.toString().contains('connection')) {
      return 'Please check your internet connection and try again.';
    } else if (error.toString().contains('permission')) {
      return 'Some permissions are required for the app to work properly.';
    } else if (error.toString().contains('timeout')) {
      return 'The request timed out. Please try again.';
    } else {
      return 'Unable to initialize the app. Please try again.';
    }
  }

  /// Handle retry after error
  void _handleRetry() {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _animationCompleted = false;
    });
    _initializeApp();
  }

  /// Handle animation completion
  void _onAnimationComplete() {
    setState(() {
      _animationCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CivicGradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content up slightly
              const Spacer(flex: 2),

              // Animated logo
              AnimatedLogoWidget(
                onAnimationComplete: _onAnimationComplete,
              ),

              SizedBox(height: 8.h),

              // Loading or error content
              if (_hasError) ...[
                ErrorRetryWidget(
                  errorMessage: _errorMessage,
                  onRetry: _handleRetry,
                ),
              ] else if (_isLoading) ...[
                LoadingIndicatorWidget(
                  loadingText: _loadingText,
                  showProgress: true,
                ),
              ],

              // Spacer to center content
              const Spacer(flex: 3),

              // App version and civic message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    Text(
                      'Empowering Communities',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.7),
                        fontSize: 11.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Version 1.0.0',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.5),
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset system UI overlay
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }
}
