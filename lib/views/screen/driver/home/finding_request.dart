import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/home_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_switch.dart';
import 'package:flutter_extension/views/screen/driver/home/custom_map_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FindingRequest extends StatefulWidget {
  const FindingRequest({super.key});

  @override
  State<FindingRequest> createState() => _FindingRequestState();
}

class _FindingRequestState extends State<FindingRequest>
    with TickerProviderStateMixin {
  final _homeController = Get.put(DriverHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Row(
                    children: [
                      Text(
                        _homeController.isLocationEnabled.value
                            ? "Online"
                            : "Offline",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      CustomSwitch(
                        value: _homeController.isLocationEnabled.value,
                        onChanged: _homeController.toggleLocation,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/icons/notification.svg',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Map + Bottom Panel
              SizedBox(
                height: 300,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // MAP (static, never rebuild)
                    const CustomMapView(
                      height: 300,
                      zoom: 15,
                      gesturesEnabled: false,
                      showMyLocation: true,
                      showMyLocationButton: false,
                    ),

                    // Bottom Panel
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 280,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 30,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF345983),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Obx(
                                () => Text(
                                  _homeController.isLocationEnabled.value
                                      ? "We're searching a request for you!"
                                      : 'You are Now Offline',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Animated Icon (self-contained, isolated)
                            Obx(() {
                              if (_homeController.isLocationEnabled.value) {
                                return Center(
                                  // child: AnimatedBuilder(
                                  //   animation: Listenable.merge([
                                  //     _xController,
                                  //     _yController,
                                  //     _rotationController,
                                  //   ]),
                                  //   builder: (context, child) {
                                  //     return Transform.scale(
                                  //       scaleX: _xScale.value,
                                  //       scaleY: _yScale.value,
                                  //       child: Transform.rotate(
                                  //         angle: _rotation.value * 6.28319,
                                  //         child: child,
                                  //       ),
                                  //     );
                                  //   },
                                  child: SvgPicture.asset(
                                    'assets/icons/search_fill.svg',
                                    color: Colors.white,
                                    width: 72,
                                    height: 72,
                                  ),
                                );
                              } else {
                                return Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/happy.svg',
                                  ),
                                );
                              }
                            }),
                            const SizedBox(height: 20),

                            // Tips / Earnings Row
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Tips",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Online",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Earnings",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "10",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "10h 30m",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "£ 1000",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
