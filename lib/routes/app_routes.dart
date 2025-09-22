import 'package:flutter/material.dart';
import '../presentation/report_issue_screen/report_issue_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/issue_details_screen/issue_details_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/fixer_profile_screen/fixer_profile_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String reportIssue = '/report-issue-screen';
  static const String splash = '/splash-screen';
  static const String issueDetails = '/issue-details-screen';
  static const String authentication = '/authentication-screen';
  static const String fixerProfile = '/fixer-profile-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    reportIssue: (context) => const ReportIssueScreen(),
    splash: (context) => const SplashScreen(),
    issueDetails: (context) => const IssueDetailsScreen(),
    authentication: (context) => const AuthenticationScreen(),
    fixerProfile: (context) => const FixerProfileScreen(),
    // TODO: Add your other routes here
  };
}
