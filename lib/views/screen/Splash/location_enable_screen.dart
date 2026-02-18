import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/splash_controller.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_selected_languge_screen.dart';
import 'package:flutter_extension/views/screen/user/auth/user_selected_language_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LocationEnableScreen extends StatefulWidget {
  final String role;
  const LocationEnableScreen({super.key, required this.role});

  @override
  State<LocationEnableScreen> createState() => _LocationEnableScreenState();
}

class _LocationEnableScreenState extends State<LocationEnableScreen> {
  final _splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Center(child: SvgPicture.asset('assets/icons/location_enable.svg')),
            const SizedBox(height: 44),
            const Center(
              child: Text(
                "Enable Your Location",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Center(
              child: Text(
                "Chose your location to start find the request around you",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF545454),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            Obx(
              () => CustomButton(
                loading: _splashController.isLoading.value,
                onTap: () async {
                  final position = await _splashController
                      .getLocationWithLoading();

                  if (position == null) {
                    showCustomSnackBar(
                      "Please enable location to continue",
                      isError: true,
                    );
                    return;
                  }

                  if (widget.role == "USER") {
                    Get.offAll(() => const UserSelectedLanguageScreen());
                  } else if (widget.role == "DRIVER") {
                    Get.offAll(() => const DriverSelectedLangugeScreen());
                  }
                },
                text: "Next",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
