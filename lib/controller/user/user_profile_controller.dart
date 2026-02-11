import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/model/user/user_profile_model.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {

 var userProfileModel = UserProfileModel().obs;

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


}
