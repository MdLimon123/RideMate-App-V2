import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/home_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_switch.dart';
import 'package:flutter_extension/views/base/formate_min_to_hours.dart';
import 'package:flutter_extension/views/base/home_state_shimmer.dart';
import 'package:flutter_extension/views/screen/driver/home/custom_map_view.dart';
import 'package:flutter_extension/views/screen/notification/notification_screen.dart';
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

  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;



  @override
  void initState() {
    setupAnimation();
    super.initState();
  }

  void setupAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _opacityAnim = Tween<double>(
      begin: 0.4,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();

    //SocketService().socket?.disconnect();
    super.dispose();
  }

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
                        onTap: () {
                          Get.to(() => const NotificationScreen());
                        },
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
                      top: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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

                         
                            
                              Obx(() {
                                if (_homeController.isLocationEnabled.value) {
                                  return Center(
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedBuilder(
                                            animation: _pulseController,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: _scaleAnim.value * 1.2,
                                                child: Container(
                                                  width: 72,
                                                  height: 72,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white
                                                        .withValues(
                                                          alpha:
                                                              _opacityAnim
                                                                  .value *
                                                              0.5,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          AnimatedBuilder(
                                            animation: _pulseController,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: _scaleAnim.value,
                                                child: Container(
                                                  width: 72,
                                                  height: 72,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white
                                                        .withOpacity(
                                                          _opacityAnim.value,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          AnimatedBuilder(
                                            animation: _rotateController,
                                            builder: (context, child) {
                                              return Transform.rotate(
                                                angle:
                                                    _rotateController.value *
                                                    2 *
                                                    3.14159,
                                                child: child,
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              'assets/icons/search_fill.svg',
                                              colorFilter: ColorFilter.mode(
                                                Colors.white.withOpacity(0.9),
                                                BlendMode.srcIn,
                                              ),
                                              width: 72,
                                              height: 72,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                child: Column(
                                  children: [
                                    const Row(
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
                                    const SizedBox(height: 8),

                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Text(
                                    //         "10",
                                    //         textAlign: TextAlign.center,
                                    //         style: TextStyle(
                                    //           fontSize: 20,
                                    //           fontWeight: FontWeight.w500,
                                    //           color: Color(0xFF333333),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Expanded(
                                    //       child: Text(
                                    //         "10h 30m",
                                    //         textAlign: TextAlign.center,
                                    //         style: TextStyle(
                                    //           fontSize: 20,
                                    //           fontWeight: FontWeight.w500,
                                    //           color: Color(0xFF333333),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Expanded(
                                    //       child: Text(
                                    //         "£ 1000",
                                    //         textAlign: TextAlign.center,
                                    //         style: TextStyle(
                                    //           fontSize: 20,
                                    //           fontWeight: FontWeight.w500,
                                    //           color: Color(0xFF333333),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Obx(() {
                                      if (_homeController.isLoading.value) {
                                        return const HomeStatsShimmer();
                                      }

                                      final home =
                                          _homeController.homeModel.value;

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              home.totalCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              formatMinutesToHour(
                                                home.totalTime,
                                              ),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "£ ${home.totalEarnings}",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
