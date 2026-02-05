import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:get/get.dart';

import '../views/screen/splash/splash_screen.dart';

class AppRoutes {
  static String splashScreen = "/splash_screen";
  static String mainDriver = "/main_driver";

  static List<GetPage> page = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: mainDriver, page: () => const MainDriver()),
  ];
}
