import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhoneOtpWidget extends StatefulWidget {
  final VoidCallback? onVerifyPressed;

  const PhoneOtpWidget({
    super.key,
    this.onVerifyPressed,
  });

  @override
  State<PhoneOtpWidget> createState() => _PhoneOtpWidgetState();
}

class _PhoneOtpWidgetState extends State<PhoneOtpWidget> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String _selectedCountryCode = '+1';
  bool _isOtpSent = false;
  bool _isLoading = false;
  int _resendTimer = 30;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+81', 'country': 'JP'},
    {'code': '+49', 'country': 'DE'},
    {'code': '+33', 'country': 'FR'},
    {'code': '+39', 'country': 'IT'},
    {'code': '+34', 'country': 'ES'},
    {'code': '+7', 'country': 'RU'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    return _phoneController.text.length >= 10;
  }

  bool get _isOtpValid {
    return _otpController.text.length == 6;
  }

  Future<void> _sendOtp() async {
    if (!_isPhoneValid) return;

    setState(() => _isLoading = true);

    try {
      // Simulate OTP sending
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isOtpSent = true;
        _resendTimer = 30;
      });

      _startResendTimer();
      _showSuccessMessage(
          'OTP sent to $_selectedCountryCode ${_phoneController.text}');
    } catch (e) {
      _showErrorMessage('Failed to send OTP. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpValid) return;

    setState(() => _isLoading = true);

    try {
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));

      // Mock OTP verification (accept 123456 as valid OTP)
      if (_otpController.text == '123456') {
        HapticFeedback.lightImpact();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/splash-screen',
            (route) => false,
          );
        }
      } else {
        _showErrorMessage('Invalid OTP. Please try again.');
      }
    } catch (e) {
      _showErrorMessage('Verification failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startResendTimer();
      }
    });
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

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_isOtpSent) ...[
          // Phone Number Input
          Text(
            'Enter your phone number',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              // Country Code Selector
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    isDense: true,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() => _selectedCountryCode = value!);
                          },
                    items: _countryCodes.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['code'],
                        child: Text(
                          '${country['country']} ${country['code']}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Phone Number Field
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  enabled: !_isLoading,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _sendOtp(),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '1234567890',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Send OTP Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isPhoneValid && !_isLoading ? _sendOtp : null,
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Send OTP',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ] else ...[
          // OTP Verification
          Text(
            'Enter verification code',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'We sent a 6-digit code to $_selectedCountryCode ${_phoneController.text}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 4.h),

          // OTP Input
          Pinput(
            controller: _otpController,
            length: 6,
            enabled: !_isLoading,
            onChanged: (_) => setState(() {}),
            onCompleted: (_) => _verifyOtp(),
            defaultPinTheme: PinTheme(
              width: 12.w,
              height: 6.h,
              textStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 12.w,
              height: 6.h,
              textStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 12.w,
              height: 6.h,
              textStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                border: Border.all(color: theme.colorScheme.primary),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Resend OTP
          Center(
            child: _resendTimer > 0
                ? Text(
                    'Resend OTP in ${_resendTimer}s',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() => _isOtpSent = false);
                            _otpController.clear();
                          },
                    child: Text(
                      'Resend OTP',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),

          SizedBox(height: 4.h),

          // Verify Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isOtpValid && !_isLoading ? _verifyOtp : null,
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Verify OTP',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 2.h),

          // Back to Phone Number
          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        _isOtpSent = false;
                        _otpController.clear();
                      });
                    },
              child: Text(
                'Change phone number',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
