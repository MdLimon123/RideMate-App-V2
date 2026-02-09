import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_setup_profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_extension/views/screen/user/setUpProfile/user_verify_screen.dart';
import 'package:get/get.dart';

class UserCaptureImageScreen extends StatefulWidget {
  const UserCaptureImageScreen({super.key});

  @override
  State<UserCaptureImageScreen> createState() => _UserCaptureImageScreenState();
}

class _UserCaptureImageScreenState extends State<UserCaptureImageScreen> {
  final _userSetupController = Get.put(UserSetupProfileController());

  @override
  void initState() {
    _userSetupController.requestCameraPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.arrow_back_ios, color: Color(0xFF676769)),
            Image.asset('assets/images/logo.png'),
            const Spacer(),
            const Text(
              "3 Of 3",
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Obx(() {
          // if (_driverSetupController.isPermissionGranted.value) {
          //   return Center(
          //     child: Text(
          //       "Camera permission required to continue.",
          //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //       textAlign: TextAlign.center,
          //     ),
          //   );
          // }

          // Camera initializing
          if (_userSetupController.isCameraInitialized.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CameraPreview(_userSetupController.cameraController!),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: _userSetupController.captureSelfie,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          } else if (_userSetupController.capturedImage != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(
                        File(_userSetupController.capturedImage!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Verify Your Identity",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Take a quick selfie to complete your profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 240),

                CustomButton(
                  onTap: () {
                    Get.offAll(() => const UserVerifyScreen());
                  },
                  text: "Confirm & Continue",
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: _userSetupController.retakeSelfie,
                  child: const Text(
                    "Retake Selfie",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CustomLoading());
          }
        }),
      ),
    );
  }
}
