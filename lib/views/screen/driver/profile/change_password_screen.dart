import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _fromKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _userProfileController = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Change Password"),
      body: Form(
        key: _fromKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          children: [
            CustomTextField(
              controller: oldPasswordController,
              hintText: "Old Password",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your password";
                } else if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: newPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your password";
                } else if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
              hintText: "New Password",
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your password";
                } else if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 84),
            Obx(
              () => CustomButton(
                loading: _userProfileController.changePasswordLoading.value,
                onTap: () {
                  if (_fromKey.currentState!.validate()) {
                    _userProfileController.changePassword(
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text,
                    );
                  }
                },
                text: "changeNow".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }



}
