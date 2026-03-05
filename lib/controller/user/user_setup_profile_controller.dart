import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/user/auth/setUpProfile/user_capture_image_screen.dart';
import 'package:flutter_extension/views/screen/user/auth/setUpProfile/user_verify_screen.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class UserSetupProfileController extends GetxController {
  Rx<File?> userProfileImage = Rx<File?>(null);
  Rx<File?> nIdfrontImage = Rx<File?>(null);
  Rx<File?> nIdbackImage = Rx<File?>(null);
  var selectedGender = ''.obs;

  var isLoading = false.obs;

  Map<String, String> genderMap = {"Male": "Male", "Female": "Female"};

  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  XFile? capturedImage;
  RxBool isPermissionGranted = false.obs;
  RxBool isPermissionDenied = false.obs;

  Future<void> pickNIDFrontImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      nIdfrontImage.value = pickedFile;
    }
  }

  Future<void> pickNIDBackImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      nIdbackImage.value = pickedFile;
    }
  }

  Future<void> pickUserImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      userProfileImage.value = pickedFile;
    }
  }

  Future<bool> requestCameraPermission() async {
    isPermissionDenied.value = false;
    var status = await Permission.camera.status;

    if (status.isGranted) {
      isPermissionGranted.value = true;
      await initCamera();
      return true;
    }

    if (status.isDenied) {
      status = await Permission.camera.request();
      if (status.isGranted) {
        isPermissionGranted.value = true;
        if (Platform.isAndroid) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        await initCamera();
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      isPermissionDenied.value = true;
      Get.snackbar(
        "Permission Denied",
        "Please enable camera permission from settings.",
      );
      return false;
    }

    isPermissionDenied.value = true;
    Get.snackbar(
      "Permission Denied",
      "Camera permission is required to verify your identity.",
    );
    return false;
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      CameraDescription? frontCamera;
      try {
        frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
      } catch (_) {
        frontCamera = cameras.isNotEmpty ? cameras.first : null;
      }

      if (frontCamera == null) {
        Get.snackbar("Camera Error", "No cameras found on device.");
        return;
      }

      final controller = CameraController(frontCamera, ResolutionPreset.medium);
      await controller.initialize();

      cameraController = controller;
      isCameraInitialized.value = true;
    } catch (e) {
      Get.snackbar("Camera Error", e.toString());
    }
  }

  ///  Step 3: Capture selfie safely
  Future<void> captureSelfie() async {
    final controller = cameraController;

    if (controller == null || !controller.value.isInitialized) {
      Get.snackbar("Error", "Camera not ready!");
      return;
    }

    try {
      final image = await controller.takePicture();
      capturedImage = image;

      isCameraInitialized.value = false;

      await Future.delayed(const Duration(milliseconds: 300));

      await controller.dispose();
      cameraController = null;
      showCustomSnackBar("Selfie captured successfully!", isError: false);
    } catch (e) {
      showCustomSnackBar("Selfie capture failed!", isError: true);
    }
  }

  ///  Step 4: Retake selfie safely
  Future<void> retakeSelfie() async {
    try {
      final controller = cameraController;
      cameraController = null;
      isCameraInitialized.value = false;

      await controller?.dispose();

      capturedImage = null;

      await Future.delayed(const Duration(milliseconds: 200));
      await initCamera();
    } catch (e) {
      Get.snackbar("Camera Error", e.toString());
    }
  }

  Future<void> setupUserProfile({
    required String avatar,
    required String nIdFornt,
    required String nIdBack,
    required String name,
    required String dateOfBirth,
    required String gender,
  }) async {
    isLoading(true);
    List<MultipartBody> multipartBody = [];

    if (avatar.isNotEmpty) {
      multipartBody.add(MultipartBody('avatar', File(avatar)));
    }

    if (nIdFornt.isNotEmpty) {
      multipartBody.add(MultipartBody('nid_photos', File(nIdFornt)));
    }

    if (nIdBack.isNotEmpty) {
      multipartBody.add(MultipartBody('nid_photos', File(nIdBack)));
    }

    Map<String, String> fromData = {
      "name": name,
      "date_of_birth": dateOfBirth,
      "gender": gender,
    };

    final response = await ApiClient.postMultipartData(
      "/profile/setup-user-profile",
      fromData,
      multipartBody: multipartBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      Get.offAll(() => const UserCaptureImageScreen());
    } else {
      showCustomSnackBar(response.statusText);
    }

    isLoading(false);
  }

  Future<void> uploadCaptureImage({required String imagePath}) async {
    isLoading(true);

    List<MultipartBody> multipartBody = [];

    if (imagePath.isNotEmpty) {
      multipartBody.add(MultipartBody('avatar', File(imagePath)));
    }

    final response = await ApiClient.postMultipartData(
      "/profile/upload-capture-avatar",
      {},
      multipartBody: multipartBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      Get.offAll(() => const UserVerifyScreen());
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLoading(false);
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
