import 'package:flutter_extension/views/screen/Splash/select_role_screen.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_login_screen.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_signup_screen.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:flutter_extension/views/screen/user/auth/user_login_screen.dart';
import 'package:flutter_extension/views/screen/user/auth/user_signup_screen.dart';
import 'package:get/get.dart';

import '../views/screen/splash/splash_screen.dart';

class AppRoutes {
  static String splashScreen = "/splash_screen";
  static String selectRoleScreen = "/select_role_screen";
  static String mainDriver = "/main_driver";
  static String driverLoginScreen = "/driver_login_screen";
  static String driverSignupScreen = "/driver_signup_screen";
  static String userLoginScreen = "/user_login_screen";
  static String userSignupScreen = "/user_signup_screen";

  static List<GetPage> page = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: selectRoleScreen, page: () => const SelectRoleScreen()),
    GetPage(name: driverLoginScreen, page: () => const DriverLoginScreen()),
    GetPage(name: driverSignupScreen, page: () => const DriverSignupScreen()),
    GetPage(name: userLoginScreen, page: () => const UserLoginScreen()),
    GetPage(name: userSignupScreen, page: () => const UserSignupScreen()),
    GetPage(name: mainDriver, page: () => const MainDriver()),
  ];
}
