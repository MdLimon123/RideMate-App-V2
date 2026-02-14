import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/screen/driver/earn/driver_earn_screen.dart';
import 'package:flutter_extension/views/screen/driver/home/home_driver.dart';
import 'package:flutter_extension/views/screen/driver/profile/driver_profile_screen.dart';
import 'package:flutter_extension/views/screen/driver/rides/driver_ride_history_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainDriver extends StatefulWidget {
  const MainDriver({super.key});

  @override
  State<MainDriver> createState() => _MainDriverState();
}

class _MainDriverState extends State<MainDriver> {
  final DriverRideController _driverRideController = Get.put(
    DriverRideController(),
    permanent: true,
  );

  @override
  void initState() {
    socketConntect();

    super.initState();
  }

  var selectedIndex = 0;
  var pages = [
    const HomeDriver(),
    const DriverRideHistoryScreen(),
    const DriverEarnScreen(),
    const DriverProfileScreen(),
  ];

  socketConntect() async {
    var token = await PrefsHelper.getString(AppConstants.bearerTokenKEN);
    SocketService().connect(token);
    // _driverRideController.listenDriverRide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        selectedItemColor: const Color(0xff345983),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        iconSize: 28,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/home_2.svg",
              // color: const Color(0xff345983),
              height: 28,
              width: 28,
            ),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/cycle.svg",
              height: 28,
              width: 28,
            ),
            label: "Rides",
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/earn.svg",
              height: 28,
              width: 28,
            ),
            label: "Earn",
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/profile.svg",
              height: 28,
              width: 28,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
