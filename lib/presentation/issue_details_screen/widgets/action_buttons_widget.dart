import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final String issueStatus;
  final bool isUserFixer;
  final bool isIssueClaimed;
  final String? claimedBy;
  final Function() onClaimIssue;
  final Function() onUpdateStatus;
  final Function() onEscalateToAuthorities;

  const ActionButtonsWidget({
    super.key,
    required this.issueStatus,
    required this.isUserFixer,
    required this.isIssueClaimed,
    this.claimedBy,
    required this.onClaimIssue,
    required this.onUpdateStatus,
    required this.onEscalateToAuthorities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_shouldShowClaimButton()) _buildClaimButton(context),
            if (_shouldShowUpdateButton()) _buildUpdateButton(context),
            if (_shouldShowEscalateButton()) _buildEscalateButton(context),
            if (_shouldShowMultipleActions()) _buildMultipleActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onClaimIssue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'handyman',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Claim to Fix',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onUpdateStatus,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'update',
              color: AppTheme.lightTheme.colorScheme.onSecondary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              _getUpdateButtonText(),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEscalateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: OutlinedButton(
        onPressed: onEscalateToAuthorities,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.lightTheme.colorScheme.error,
          side: BorderSide(
            color: AppTheme.lightTheme.colorScheme.error,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'report_problem',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Escalate to Authorities',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleActions(BuildContext context) {
    return Row(
      children: [
        if (_shouldShowClaimButton()) ...[
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 6.h,
              child: ElevatedButton(
                onPressed: onClaimIssue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'handyman',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 18,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Claim',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
        ],
        Expanded(
          child: SizedBox(
            height: 6.h,
            child: OutlinedButton(
              onPressed: onEscalateToAuthorities,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'report_problem',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 18,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Escalate',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
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

  bool _shouldShowClaimButton() {
    return isUserFixer &&
        !isIssueClaimed &&
        (issueStatus.toLowerCase() == 'validated' ||
            issueStatus.toLowerCase() == 'reported');
  }

  bool _shouldShowUpdateButton() {
    return isUserFixer &&
        isIssueClaimed &&
        issueStatus.toLowerCase() != 'fixed';
  }

  bool _shouldShowEscalateButton() {
    return !isUserFixer && issueStatus.toLowerCase() != 'fixed';
  }

  bool _shouldShowMultipleActions() {
    return _shouldShowClaimButton() && _shouldShowEscalateButton();
  }

  String _getUpdateButtonText() {
    switch (issueStatus.toLowerCase()) {
      case 'validated':
        return 'Start Working';
      case 'in progress':
        return 'Mark as Fixed';
      default:
        return 'Update Status';
    }
  }
}
