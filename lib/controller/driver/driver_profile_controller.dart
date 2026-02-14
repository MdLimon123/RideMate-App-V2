import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:get/get.dart';

class DriverProfileController extends GetxController {
  final RxDouble rating = 0.0.obs;

  var isLaoding = false.obs;

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
}
