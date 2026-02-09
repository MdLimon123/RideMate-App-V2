import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/user/setUpProfile/user_personal_info_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserGetStartScreen extends StatefulWidget {
  const UserGetStartScreen({super.key});

  @override
  State<UserGetStartScreen> createState() => _UserGetStartScreenState();
}

class _UserGetStartScreenState extends State<UserGetStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png'),
            const Text(
              "1 Of 3",
              style: TextStyle(
                color: Color(0xFF012F64),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 134),
            Center(child: SvgPicture.asset('assets/icons/ride2.svg')),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "Let’s Set Up Your Driver Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "A few quick steps to start earning with us",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
                Get.to(() => const UserPersonalInfoScreen());
              },
              text: "Next",
            ),
          ],
        ),
      ),
    );
  }
}
