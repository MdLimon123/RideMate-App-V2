import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/user/auth/setUpProfile/user_get_start_screen.dart';
import 'package:get/get.dart';

class UserTermsComditionScreen extends StatefulWidget {
  const UserTermsComditionScreen({super.key});

  @override
  State<UserTermsComditionScreen> createState() =>
      _UserTermsComditionScreenState();
}

class _UserTermsComditionScreenState extends State<UserTermsComditionScreen> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar2(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                "RADEEF is a smart, reliable, and affordable motorbike ride-sharing and parcel delivery platform designed to make everyday travel and delivery easier than ever. Whether you’re commuting to work, meeting friends across town, or sending an urgent package, RADEEF connects you with trusted riders in just a few taps.We believe transportation should be fast, safe, and accessible to everyone. That’s why RADEEF focuses on a simple, cash-friendly system while also preparing for a digital future — combining convenience with flexibility for all users.With features like real-time tracking, secure payments, and a seamless booking experience, RADEEF is more than just a ride — it’s your daily mobility and delivery partner.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF676565),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isCheck,
                    activeColor: AppColors.primaryColor,
                    checkColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF676565), width: 2),
                    onChanged: (value) {
                      setState(() {
                        isCheck = value!;
                      });
                    },
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "You agree to the ",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.textColor,
                              ),
                            ),
                            TextSpan(
                              text: "Terms and conditions",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: " and ",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: " acknowledge you have read the ",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.textColor,
                              ),
                            ),
                            TextSpan(
                              text: "\nPrivacy Policy ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              CustomButton(
                onTap: () {
                  Get.to(() => const UserGetStartScreen());
                },
                text: "start".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
