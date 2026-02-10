import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_login_screen.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _driverAuthController = Get.put(DriverAuthController());

  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar2(),
      body: SafeArea(
        child: Form(
          key: _fromKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  "new_Password".tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: newPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your new password";
                    }
                    return null;
                  },
                  hintText: "Set new password",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your confirm password";
                    }
                    return null;
                  },
                  hintText: "Confirm new password",
                ),
                const Spacer(),
                Obx(
                  () => CustomButton(
                    loading: _driverAuthController.isResetLoading.value,
                    onTap: () {
                      if (_fromKey.currentState!.validate()) {
                        _driverAuthController.resetPassword(
                          passwordText: newPasswordController.text,
                        );
                      }
                    },
                    text: "changeNow".tr,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
