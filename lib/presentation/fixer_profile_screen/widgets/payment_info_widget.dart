import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentInfoWidget extends StatelessWidget {
  final Map<String, dynamic> paymentInfo;
  final VoidCallback onEditPayment;

  const PaymentInfoWidget({
    super.key,
    required this.paymentInfo,
    required this.onEditPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Payment Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onEditPayment,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                tooltip: 'Edit Payment Info',
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildPaymentMethod(
            icon: 'account_balance',
            title: 'UPI ID',
            value: paymentInfo['upiId'] as String? ?? 'Not configured',
            isVerified: paymentInfo['upiVerified'] as bool? ?? false,
            onTap: () => _showUpiDetails(context),
          ),
          SizedBox(height: 2.h),
          _buildPaymentMethod(
            icon: 'credit_card',
            title: 'Bank Account',
            value: _formatBankAccount(
                paymentInfo['bankAccount'] as Map<String, dynamic>?),
            isVerified: paymentInfo['bankVerified'] as bool? ?? false,
            onTap: () => _showBankDetails(context),
          ),
          SizedBox(height: 3.h),
          _buildEarningsOverview(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required String icon,
    required String title,
    required String value,
    required bool isVerified,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: isVerified
                ? AppTheme.successLight.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isVerified) ...[
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.w),
                          decoration: BoxDecoration(
                            color: AppTheme.successLight,
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'verified',
                                color: Colors.white,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Verified',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsOverview() {
    final double totalEarnings =
        (paymentInfo['totalEarnings'] as num?)?.toDouble() ?? 0.0;
    final double pendingPayouts =
        (paymentInfo['pendingPayouts'] as num?)?.toDouble() ?? 0.0;
    final double thisMonthEarnings =
        (paymentInfo['thisMonthEarnings'] as num?)?.toDouble() ?? 0.0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earnings Overview',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildEarningsStat(
                  icon: 'payments',
                  label: 'Total Earned',
                  value: '\$${totalEarnings.toStringAsFixed(2)}',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildEarningsStat(
                  icon: 'schedule',
                  label: 'Pending',
                  value: '\$${pendingPayouts.toStringAsFixed(2)}',
                  color: AppTheme.warningLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildEarningsStat(
            icon: 'trending_up',
            label: 'This Month',
            value: '\$${thisMonthEarnings.toStringAsFixed(2)}',
            color: AppTheme.successLight,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsStat({
    required String icon,
    required String label,
    required String value,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: isFullWidth
          ? Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      value,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 6.w,
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }

  String _formatBankAccount(Map<String, dynamic>? bankAccount) {
    if (bankAccount == null) return 'Not configured';

    final String accountNumber = bankAccount['accountNumber'] as String? ?? '';
    final String bankName = bankAccount['bankName'] as String? ?? '';

    if (accountNumber.isEmpty) return 'Not configured';

    final maskedAccount = accountNumber.length > 4
        ? '****${accountNumber.substring(accountNumber.length - 4)}'
        : accountNumber;

    return bankName.isNotEmpty ? '$bankName - $maskedAccount' : maskedAccount;
  }

  void _showUpiDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UPI Payment Details',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'account_balance',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('UPI ID'),
              subtitle:
                  Text(paymentInfo['upiId'] as String? ?? 'Not configured'),
              trailing: paymentInfo['upiVerified'] == true
                  ? CustomIconWidget(
                      iconName: 'verified',
                      color: AppTheme.successLight,
                      size: 5.w,
                    )
                  : null,
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onEditPayment();
                },
                child: const Text('Update UPI ID'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBankDetails(BuildContext context) {
    final bankAccount = paymentInfo['bankAccount'] as Map<String, dynamic>?;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Account Details',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            if (bankAccount != null) ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'account_balance',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: const Text('Bank Name'),
                subtitle:
                    Text(bankAccount['bankName'] as String? ?? 'Not provided'),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'credit_card',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: const Text('Account Number'),
                subtitle: Text(_formatBankAccount(bankAccount)),
                trailing: paymentInfo['bankVerified'] == true
                    ? CustomIconWidget(
                        iconName: 'verified',
                        color: AppTheme.successLight,
                        size: 5.w,
                      )
                    : null,
              ),
            ],
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onEditPayment();
                },
                child: Text(bankAccount == null
                    ? 'Add Bank Account'
                    : 'Update Bank Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
