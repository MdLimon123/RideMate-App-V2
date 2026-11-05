import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final _userProfileController = Get.put(UserProfileController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProfileController.fetchAboutUsInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "About Us"),
      body: Obx(
        () => _userProfileController.aboutUsModel.value.content == null
            ? Center(child: CustomLoading(color: AppColors.primaryColor))
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                children: [
                  Html(
                    data: _userProfileController.aboutUsModel.value.content!,
                    style: {
                      "p": Style(
                        fontSize: FontSize(14),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF5A5A5A),
                      ),
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
