import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/model/user/user_profile_model.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/user/home/user_home.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  var userProfileModel = UserProfileModel().obs;

  final RxDouble rating = 0.0.obs;

  final _rideController = Get.find<RideController>();

  var isLaoding = false.obs;

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
}
