import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/model/driver/driver_profile_model.dart';
import 'package:flutter_extension/data/model/privacy_police_model.dart';
import 'package:flutter_extension/data/model/terms_model.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverProfileController extends GetxController {
  var isLoading = false.obs;
  var driverProfileModel = DriverProfileModel().obs;

  var isLaoding = false.obs;
  var termModel = TermsModel().obs;

  var privacyModel = PrivacyPolicyModel().obs;

  var isWithdrawLoading = false.obs;

  var isConnectLoading = false.obs;

  var changePasswordLoading = false.obs;

  var uploadProfileLoading = false.obs;

  final RxDouble rating = 0.0.obs;

  final _rideController = Get.find<DriverRideController>();

  Rx<File?> driverProfileImage = Rx<File?>(null);

  void updateRating(double value) {
    rating.value = value;
  }

  Future<void> pickDriverProfileImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      driverProfileImage.value = pickedFile;
    }
  }

  Future<void> driverSubmitTripRating({
    required String userId,

    required String tripId,
  }) async {
    isLaoding(true);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "rating": rating.value.toInt(),
      "comment": "Good",
      "ref_trip_id": tripId,
    };

    final response = await ApiClient.postData("/reviews/give-review", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar("Review Submitted", isError: false);

      _rideController.clear();
      Get.offAll(() => const MainDriver());
    } else {
      debugPrint(response.body);
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLaoding(false);
  }

  Future<void> driverSubmitParcelRating({
    required String userId,

    required String tripId,
  }) async {
    isLaoding(true);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "rating": rating.value.toInt(),
      "comment": "Good",
      "ref_parcel_id": tripId,
    };

    final response = await ApiClient.postData("/reviews/give-review", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar("Review Submitted", isError: false);

      _rideController.clear();
      Get.offAll(() => const MainDriver());
    } else {
      debugPrint(response.body);
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLaoding(false);
  }

  Future<void> fetchDriverProfile() async {
    isLoading(true);

    final response = await ApiClient.getData("/profile");

    if (response.statusCode == 200 || response.statusCode == 201) {
      driverProfileModel.value = DriverProfileModel.fromJson(response.body);
    } else {
      debugPrint("soemthing we want wrong ======> ${response.statusText}");
    }
    isLoading(false);
  }

  Future<void> updateProfile({
    required String imagePath,
    required String name,
  }) async {
    uploadProfileLoading(true);
    List<MultipartBody> multipartBody = [];

    if (imagePath.isNotEmpty) {
      multipartBody.add(MultipartBody('avatar', File(imagePath)));
    }

    Map<String, String> fromData = {"name": name};

    final response = await ApiClient.patchMultipartData(
      "/profile/edit",
      fromData,
      multipartBody: multipartBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      fetchDriverProfile();
      Get.back();
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    uploadProfileLoading(false);
  }

  Future<void> connectStripeAccount() async {
    isConnectLoading(true);

    final response = await ApiClient.getData("/profile/connect-stripe");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final stripeUrl = response.body['url'];

      if (stripeUrl != null && stripeUrl.isNotEmpty) {
        // Launch the URL in the browser
        await _openPayementUrl(stripeUrl);
        fetchDriverProfile();
      } else {
        showCustomSnackBar("Stripe URL not found", isError: true);
      }
    } else {
      showCustomSnackBar("Try Again", isError: true);
    }
    isConnectLoading(false);
  }

  Future<void> _openPayementUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      showCustomSnackBar("Could not launch payment URL", isError: true);
    }
  }

  Future<void> withdrawFunds({required String amount}) async {
    isWithdrawLoading(true);

    final body = {"amount": amount};

    final response = await ApiClient.postData("/payments/withdraw", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      fetchDriverProfile();
      Get.back();
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isWithdrawLoading(false);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    changePasswordLoading(true);

    final body = {"oldPassword": oldPassword, "newPassword": newPassword};

    final response = await ApiClient.postData("/profile/change-password", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      Get.back();
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    changePasswordLoading(false);
  }

  Future<void> fetchTermsInfo() async {
    isLaoding(true);

    final response = await ApiClient.getData("/context-pages/terms");
    if (response.statusCode == 200) {
      termModel.value = TermsModel.fromJson(response.body);
    } else {
      debugPrint("soemting we want wrong ======> ${response.statusText}");
    }
    isLaoding(false);
  }

  Future<void> fetchPrivacyInfo() async {
    isLaoding(true);

    final response = await ApiClient.getData("/context-pages/privacy-policy");
    if (response.statusCode == 200) {
      privacyModel.value = PrivacyPolicyModel.fromJson(response.body);
    } else {
      debugPrint("soemting we want wrong ======> ${response.statusText}");
    }
    isLaoding(false);
  }
}
