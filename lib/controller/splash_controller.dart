import 'package:flutter_extension/controller/data_controller.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_login_screen.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:flutter_extension/views/screen/user/auth/user_login_screen.dart';
import 'package:flutter_extension/views/screen/user/home/user_home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  var selectRole = "".obs;

  bool isLoggedIn = false;

  final _dataController = Get.put(DataController());

  void setRole(String role) {
    selectRole.value = role;
  }

  // jumpNextScreen() {
  //   if (isLoggedIn) {
  //     Get.offNamed(AppRoutes.mainDriver);
  //   } else {
  //     Get.offNamed(AppRoutes.selectRoleScreen);
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
  }

  void checkLogin() async {
    await _dataController.getData();
    final token = await PrefsHelper.getString(AppConstants.bearerTokenKEN);

    final role = _dataController.role.value;
    final isActive = _dataController.isActive.value;

    print("token ======> $token");
    print("role ======> $role");
    print("isverified ====> $isActive");

    if (token.isEmpty) {
      Get.offAllNamed(AppRoutes.selectRoleScreen);
      return;
    } else {}

    if (!isActive) {
      if (role == 'USER') {
        Get.offAll(() => const UserLoginScreen());
      } else if (role == 'DRIVER') {
        Get.offAll(() => const DriverLoginScreen());
      } else {
        Get.offAllNamed(AppRoutes.selectRoleScreen);
      }
      return;
    }
    if (role == 'USER') {
      Get.offAll(() => const UserHome());
    } else if (role == 'DRIVER') {
      Get.offAll(() => const MainDriver());
    } else {
      Get.offAllNamed(AppRoutes.selectRoleScreen);
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
