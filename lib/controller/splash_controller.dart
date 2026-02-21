import 'package:flutter_extension/controller/data_controller.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
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

  var isLoading = false.obs;

  final _dataController = Get.put(DataController());

  final _rideController = Get.put(RideController(), permanent: true);
  final DriverRideController _driverRideController = Get.put(
    DriverRideController(),
    permanent: true,
  );

  void setRole(String role) {
    selectRole.value = role;
  }

  @override
  void onInit() {
    super.onInit();
  }

  void checkLogin() async {
    await _dataController.getData();

    final token = await PrefsHelper.getString(AppConstants.bearerTokenKEN);

    final role = _dataController.role.value;
    final isActive = _dataController.isActive.value;

    print("token ====> $token");
    print("role ====> $role");
    print("isActive ====> $isActive");
    print("selectRole ====> ${_dataController.name.value}");

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
      await _rideController.recoverTrip();
      await _rideController.socketConntect();

      /// add new condition

      final isIdle =
          _rideController.tripStatus.value == TripStatus.idle &&
          _rideController.parcelStatus.value == ParcelStatus.idle;

      if (isIdle) {
        Get.offAll(() => const UserHome());
        return;
      }
    } else if (role == 'DRIVER') {
      await _driverRideController.socketConntect();
      Get.offAll(() => const MainDriver());
    }
  }

  Future<Position?> getLocationWithLoading() async {
    try {
      isLoading.value = true;

      Position? position = await getCurrentLocation();

      return position;
    } catch (e) {
      return null;
    } finally {
      isLoading.value = false;
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
