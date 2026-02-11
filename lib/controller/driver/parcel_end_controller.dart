import 'dart:io';

import 'package:flutter_extension/util/image_utils.dart';
import 'package:get/get.dart';

class ParcelEndController extends GetxController {
  Rx<File?> parcelImage = Rx<File?>(null);

  final RxString selectedOption = 'All'.obs;
    final RxString selectedTab = 'trip'.obs;

  final Map<String, String> optionsMap = {
    'All': 'all_time',
    'This Week': 'this_week',
    'This Month': 'this_month',
  };

  void changeOption(String newValue) {
    selectedOption.value = newValue;
    // page = 1;
    // hasMore = true;
    // riderHistoryList.clear();
    // fetchRiderHistory();
  }

 void changeTab(String tab) {
    selectedTab.value = tab;
    
  }

  Future<void> pickParcelImage({bool fromCamera = true}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      parcelImage.value = pickedFile;
    }
  }
}
