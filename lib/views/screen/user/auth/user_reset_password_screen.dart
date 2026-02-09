import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/user/auth/user_login_screen.dart';
import 'package:get/get.dart';

class UserResetPasswordScreen extends StatefulWidget {
  const UserResetPasswordScreen({super.key});

  @override
  State<UserResetPasswordScreen> createState() =>
      _UserResetPasswordScreenState();
}

class _UserResetPasswordScreenState extends State<UserResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                CustomButton(
                  onTap: () {
                
                      Get.to(() => const UserLoginScreen());
              
                  },
                  text: "changeNow".tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
