import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final _driverProfileController = Get.put(DriverProfileController());

  @override
  void initState() {
    _driverProfileController.fetchPrivacyInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Privacy Policy"),
      body: Obx(
        () => _driverProfileController.privacyModel.value.content == null
            ? Center(child: CustomLoading(color: AppColors.primaryColor))
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                children: [
                  Html(
                    data: _driverProfileController.termModel.value.content!,
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
