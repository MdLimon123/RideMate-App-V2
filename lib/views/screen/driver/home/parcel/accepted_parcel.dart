import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_chat_controller.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/screen/driver/home/custom_map_view.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/live_parcel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AcceptedParcel extends StatefulWidget {
  const AcceptedParcel({super.key});

  @override
  State<AcceptedParcel> createState() => _AcceptedParcelState();
}

class _AcceptedParcelState extends State<AcceptedParcel> {
  final _driverRideController = Get.find<DriverRideController>();
  final _driverChatController = Get.put(DriverChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(

        child:SingleChildScrollView(
          child:  Column(
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
                                    "${ApiConstant.imageBaseUrl}${_driverRideController.parcelResponse.value.data!.user.avatar}",
                                height: 48,
                                boxShape: BoxShape.circle,
                                width: 48,
                              ),

                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      _driverRideController
                                          .parcelResponse
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

                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/cycle.svg",
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            "Trip",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _driverRideController
                                                .parcelResponse
                                                .value
                                                .data!
                                                .user
                                                .tripReceivedCount
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          const Icon(
                                            Icons.star,
                                            color: Color(0xFF012F64),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _driverRideController
                                                .parcelResponse
                                                .value
                                                .data!
                                                .user
                                                .rating
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                    SvgPicture.asset('assets/icons/pick.svg'),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _driverRideController
                                            .parcelResponse
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
                                            .parcelResponse
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
                                    SvgPicture.asset('assets/icons/kg.svg'),
                                    const SizedBox(width: 12),
                                    Text(
                                      _driverRideController
                                          .parcelResponse
                                          .value
                                          .data!
                                          .weight
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF012F64),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "(kg/pound)",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w200,
                                        color: AppColors.textColor,
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
                                          .parcelResponse
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await _driverChatController.createChatRoom(
                        userId: _driverRideController
                            .parcelResponse
                            .value
                            .data!
                            .userId
                            .toString(),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE6EAF0),
                      ),
                      child: SvgPicture.asset('assets/icons/message.svg'),
                    ),
                  ),
                  const SizedBox(width: 6),

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const LiveParcel());
                      },
                      child: Container(
                        height: 46,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFFE6EAF0),
                        ),
                        child: Center(
                          child: Text(
                            "View Map",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        loading: _driverRideController.isLoading.value,
                        onTap: () {
                          _driverRideController.startParcel();
                        },
                        text: "Pickup Parcel",
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
     
     
        )
      ),
    );
  }
}
