
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:get/get.dart';

class UserForgetScreen extends StatefulWidget {
  const UserForgetScreen({super.key});

  @override
  State<UserForgetScreen> createState() => _UserForgetScreenState();
}

class _UserForgetScreenState extends State<UserForgetScreen> {
  final emailTextController = TextEditingController();
  final _userAuthController = Get.put(UserAuthController());

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
            const SizedBox(height: 50),
            Text(
              "forget".tr,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: emailTextController,
              keyboardType: TextInputType.emailAddress,
              isEmail: true,
              hintText: "Enter your email",
            ),

            const Spacer(),

            Obx(()=>
               CustomButton(
                loading: _userAuthController.isForgetLoading.value,
                onTap: () {
                  _userAuthController.forgetPassword(
                    email: emailTextController.text,
                  );
                },
                text: "sendOTP".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
