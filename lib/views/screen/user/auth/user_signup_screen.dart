import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_auth_controller.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _userAuthController = Get.put(UserAuthController());

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneTextController = TextEditingController();

  /// E.164-style full number from country picker + national digits.
  String _completePhone = '';

  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar2(),
      body: SafeArea(
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    "signup".tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: emailTextController,

                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    isEmail: true,
                    hintText: "Enter your email",
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: passwordTextController,

                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    hintText: "Enter Password",
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: confirmPasswordController,

                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    hintText: "Confirm Password",
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: IntlPhoneField(
                      controller: phoneTextController,
                      initialCountryCode: 'GB',
                      cursorColor: AppColors.primaryColor,
                      disableLengthCheck: false,
                      invalidNumberMessage: 'Please enter a valid phone number',
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        fillColor: const Color(0xFFE6E6E6),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter your phone number',
                        hintStyle: const TextStyle(
                          color: Color(0xFF545454),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        counterText: '',
                      ),
                      onChanged: (phone) {
                        _completePhone = phone.completeNumber;
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                  Obx(
                    () => CustomButton(
                      loading: _userAuthController.isLoading.value,
                      onTap: () {
                        if (_fromKey.currentState!.validate()) {
                          _userAuthController.signup(
                            email: emailTextController.text.trim(),
                            password: passwordTextController.text.trim(),
                            phone: _completePhone,
                          );
                        }
                      },
                      text: "signup".tr,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "alreadyHaveAndAccount".tr,
                        style: const TextStyle(
                          color: Color(0xFF5A5A5A),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: "login".tr,
                            style: const TextStyle(
                              color: Color(0xFF145788),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAllNamed(AppRoutes.userLoginScreen);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
