import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class DriverOtpVerifyScreen extends StatefulWidget {
  final String email;
  const DriverOtpVerifyScreen({super.key, required this.email});

  @override
  State<DriverOtpVerifyScreen> createState() => _DriverOtpVerifyScreenState();
}

class _DriverOtpVerifyScreenState extends State<DriverOtpVerifyScreen> {
  final _driverAuthController = Get.put(DriverAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar2(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              "enterOTP".tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 32),
            OtpTextField(
              numberOfFields: 6,
              fieldWidth: 45,
              fieldHeight: 45,
              borderColor: const Color(0xFFE6E6E6),
              enabledBorderColor: const Color(0xFFE6E6E6),
              disabledBorderColor: const Color(0xFFE6E6E6),
              focusedBorderColor: const Color(0xFFE6E6E6),
              cursorColor: AppColors.primaryColor,
              filled: true,
              fillColor: const Color(0xFFE6E6E6),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                _driverAuthController.isForgetOtp.value = verificationCode;
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                    TextSpan(
                      text: "Resend again",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _driverAuthController.resendOtpVerify(
                            email: widget.email,
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => CustomButton(
                loading: _driverAuthController.isVerify.value,
                onTap: () {
                  _driverAuthController.otpForgetVerify(email: widget.email);
                },
                text: "verify".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
