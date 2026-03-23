import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/model/about_us_model.dart';
import 'package:flutter_extension/data/model/user/user_profile_model.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/user/home/user_home.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileController extends GetxController {
  var userProfileModel = UserProfileModel().obs;

  var aboutUsModel = AboutUsModel().obs;

  final RxDouble rating = 0.0.obs;

  var changePasswordLoading = false.obs;

  final _rideController = Get.find<RideController>();
  var uploadProfileLoading = false.obs;

  var isLaoding = false.obs;

  var isTopUpLoading = false.obs;

  var isConnectLoading = false.obs;

  var isWithdrawLoading = false.obs;

  Rx<File?> userProfileImage = Rx<File?>(null);

  final RxString selectedOption = 'All'.obs;
  final Map<String, String> optionsMap = {
    'All': 'all_time',
    'This Week': 'this_week',
    'This Month': 'this_month',
  };

  void changeOption(String newValue) {
    selectedOption.value = newValue;
  }

  void updateRating(double value) {
    rating.value = value;
  }

  Future<void> pickUserProfileImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );

    if (pickedFile != null) {
      userProfileImage.value = pickedFile;
    }
  }

  Future<void> fetchUserInfo() async {
    isLaoding(true);

    final response = await ApiClient.getData("/profile");
    if (response.statusCode == 200) {
      userProfileModel.value = UserProfileModel.fromJson(response.body);
    } else {
      debugPrint("soemting we want wrong ======> ${response.statusText}");
    }
    isLaoding(false);
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

  Future<void> fetchAboutUsInfo() async {
    isLaoding(true);

    final response = await ApiClient.getData("/context-pages/about-us");
    if (response.statusCode == 200) {
      aboutUsModel.value = AboutUsModel.fromJson(response.body);
    } else {
      debugPrint("soemting we want wrong ======> ${response.statusText}");
    }
    isLaoding(false);
  }

  Future<void> topUpWallet({required String amount}) async {
    isTopUpLoading(true);

    final body = {"amount": amount};

    final response = await ApiClient.postData("/payments/topup", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final paymentUrl = response.body['url'];

      if (paymentUrl != null && paymentUrl.isNotEmpty) {
        await _openPayementUrl(paymentUrl);
        fetchUserInfo();
      } else {
        showCustomSnackBar("Payment URL not found", isError: true);
      }
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isTopUpLoading(false);
  }

  Future<void> _openPayementUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      showCustomSnackBar("Could not launch payment URL", isError: true);
    }
  }

  Future<void> connectStripeAccount() async {
    isConnectLoading(true);

    final response = await ApiClient.getData("/profile/connect-stripe");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final stripeUrl = response.body['url'];

      if (stripeUrl != null && stripeUrl.isNotEmpty) {
        await _openPayementUrl(stripeUrl);
        fetchUserInfo();
      } else {
        showCustomSnackBar("Stripe URL not found", isError: true);
      }
    } else {
      showCustomSnackBar("Try Again", isError: true);
    }
    isConnectLoading(false);
  }

  Future<void> withdrawFunds({required String amount}) async {
    isWithdrawLoading(true);

    final body = {"amount": amount};

    final response = await ApiClient.postData("/payments/withdraw", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      fetchUserInfo();
      Get.back();
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isWithdrawLoading(false);
  }

  Future<void> submitTripRating({
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

      _rideController.clearStates();
      Get.offAll(() => const UserHome());
    } else {
      debugPrint(response.body);
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLaoding(false);
  }

  Future<void> updateProfile({
    required String imagePath,
    required String name,
  }) async {
    uploadProfileLoading(true);

    try {
      List<MultipartBody> multipartBody = [];
      if (imagePath.isNotEmpty) {
        multipartBody.add(MultipartBody('avatar', File(imagePath)));
      }

      Map<String, String> formData = {"name": name};

      final response = await ApiClient.patchMultipartData(
        "/profile/edit",
        formData,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(response.statusText, isError: false);
        fetchUserInfo();
        Get.back();
      } else {
        showCustomSnackBar(response.statusText, isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Failed to update profile: $e", isError: true);
    } finally {
      uploadProfileLoading(false);
    }
  }

  Future<void> submitRatingParcel({
    required String userId,
    required String parcelId,
    String? tripId,
  }) async {
    isLaoding(true);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "rating": rating.value.toInt(),
      "comment": "Good",
      "ref_parcel_id": parcelId,
    };

    final response = await ApiClient.postData("/reviews/give-review", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar("Review Submitted", isError: false);
      _rideController.clearStates();
      Get.offAll(() => const UserHome());
    } else {
      debugPrint(response.body);
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLaoding(false);
  }

  Future<bool> deleteUserAccount() async {
    isLaoding(true);

    final response = await ApiClient.deleteData("/profile/delete");
    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      isLaoding(false);
      return true;
    } else {
      showCustomSnackBar(response.statusText, isError: true);
      isLaoding(false);
      return false;
    }
  }
}
