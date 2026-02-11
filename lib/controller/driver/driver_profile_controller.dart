import 'dart:io';

import 'package:flutter_extension/util/image_utils.dart';
import 'package:get/get.dart';

class DriverProfileController extends GetxController {
  Rx<File?> driverProfileImage = Rx<File?>(null);

  Future<void> pickDriverProfileImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      driverProfileImage.value = pickedFile;
    }
  }
}
