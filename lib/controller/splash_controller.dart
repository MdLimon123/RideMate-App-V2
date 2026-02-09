import 'package:flutter_extension/helper/route_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  var selectRole = "".obs;

  bool isLoggedIn = false;

  void setRole(String role) {
    selectRole.value = role;
  }

  jumpNextScreen() {
    if (isLoggedIn) {
      Get.offNamed(AppRoutes.mainDriver);
    } else {
      Get.offNamed(AppRoutes.selectRoleScreen);
    }
  }

Future<Position?> getCurrentLocation() async {

  PermissionStatus permission = await Permission.location.status;

  if (permission.isDenied || permission.isPermanentlyDenied) {
    permission = await Permission.location.request();
    if (!permission.isGranted) {
      return null;
    }
  }

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return null;
  }


  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

}
