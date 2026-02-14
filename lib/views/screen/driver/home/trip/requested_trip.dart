import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/driver/home/custom_map_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RequestedTrip extends StatefulWidget {
  const RequestedTrip({super.key});

  @override
  State<RequestedTrip> createState() => _RequestedTripState();
}

class _RequestedTripState extends State<RequestedTrip> {
  final _driverRideController = Get.find<DriverRideController>();

  @override
  Widget build(BuildContext context) {
    var trip = _driverRideController.tripResponse.value.data;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 500,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CustomMapView(),

                
                  Positioned(
                    bottom: -60,
                    left: 20,
                    right: 20,
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
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "newRideRequest".tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              "Static (5 min ETA)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/pick.svg'),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        trip!.pickupAddress,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/location.svg',
                                      color: AppColors.textColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        trip.dropoffAddress,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/dollar.svg'),
                                    const SizedBox(width: 12),
                                    Text(
                                      "${trip.totalCost}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF012F64),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "(£)",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w200,
                                        color: AppColors.textColor,
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

            const SizedBox(height: 120),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        loading: _driverRideController.cancelLoading.value,
                        onTap: () {
                          _driverRideController.cancelTripRequest();
                        },
                        text: "Decline",
                        color: const Color(0xFFE6E6E6),
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 22),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        loading: _driverRideController.acceptedLoading.value,
                        onTap: () {
                          _driverRideController.acceptTripRequest();
                        },
                        text: "accept".tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  
  
  }
}
