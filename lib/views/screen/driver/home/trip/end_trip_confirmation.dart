import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/screen/driver/home/custom_map_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EndTripConfirmation extends StatefulWidget {
  const EndTripConfirmation({super.key});

  @override
  State<EndTripConfirmation> createState() => _EndTripConfirmationState();
}

class _EndTripConfirmationState extends State<EndTripConfirmation> {
  final _driverRideController = Get.find<DriverRideController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
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
                            color: const Color(0xFFFFFFFF),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomNetworkImage(
                                    imageUrl:
                                        "${ApiConstant.imageBaseUrl}${_driverRideController.tripResponse.value.data!.user.avatar}",
                                    boxShape: BoxShape.circle,
                                    height: 48,
                                    width: 48,
                                  ),

                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          _driverRideController
                                              .tripResponse
                                              .value
                                              .data!
                                              .user
                                              .name,
                                          style: TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                                        SvgPicture.asset(
                                          'assets/icons/pick.svg',
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _driverRideController
                                                .tripResponse
                                                .value
                                                .data!
                                                .pickupAddress,
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
                                            _driverRideController
                                                .tripResponse
                                                .value
                                                .data!
                                                .dropoffAddress,
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
                                          'assets/icons/dollar.svg',
                                          color: AppColors.textColor,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          _driverRideController
                                              .tripResponse
                                              .value
                                              .data!
                                              .totalCost
                                              .toString(),
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
                const SizedBox(height: 100),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => CustomButton(
                      loading: _driverRideController.isLoading.value,
                      onTap: () {
                        _driverRideController.endTrip();
                      },
                      text: "Confirm",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
