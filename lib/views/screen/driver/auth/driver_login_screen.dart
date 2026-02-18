import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_auth_controller.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_forget_screen.dart';
import 'package:get/get.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
              children: [
                const SizedBox(height: 50),

                Text(
                  "login".tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
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

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const DriverForgetScreen());
                    },
                    child: Text(
                      "forget".tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF345983),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                Obx(()=>
                   CustomButton(
                    text: "login".tr, 
                    loading: _driverAuthController.isLoading.value,
                    onTap: () {
                    if (_fromKey.currentState!.validate()) {
                      _driverAuthController.login(
                        email: emailTextController.text.trim(),
                        password: passwordTextController.text.trim(),
                      );
                    }
                  }),
                ),

                const SizedBox(height: 20),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "dontHaveAccount".tr,
                      style: const TextStyle(
                        color: Color(0xFF5A5A5A),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: "signup".tr,
                          style: const TextStyle(
                            color: Color(0xFF145788),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(AppRoutes.driverSignupScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
