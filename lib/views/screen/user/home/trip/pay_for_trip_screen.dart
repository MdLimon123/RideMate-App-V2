import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/controller/user/chat_controller.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/controller/user/user_home_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PayForTripScreen extends StatefulWidget {
  const PayForTripScreen({super.key});

  @override
  State<PayForTripScreen> createState() => _PayForTripScreenState();
}

class _PayForTripScreenState extends State<PayForTripScreen> {
  final RideController rideController = Get.put(RideController());
  final codeController = TextEditingController(text: "");
  final _chatController = Get.put(ChatController());

  final _homeController = Get.put(UserHomeController());

  @override
  void initState() {
    final driverLat =
        rideController.tripResponse.value.data!.driver!.locationLat;
    final driverLng =
        rideController.tripResponse.value.data!.driver!.locationLng;

    final userLat = rideController.tripResponse.value.data!.user.locationLat;
    final userLng = rideController.tripResponse.value.data!.user.locationLng;

    _homeController.calculateDriverETA(
      driverLat: driverLat!,
      driverLng: driverLng!,
      userLat: userLat!,
      userLng: userLng!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    codeController.text = rideController.tripResponse.value.data!.slug;
    return Scaffold(
      appBar: const CustomAppbar(title: "Driver Assigned"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFF345983),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CustomNetworkImage(
                                imageUrl:
                                    "${ApiConstant.imageBaseUrl}${rideController.tripResponse.value.data!.driver!.avatar}",
                                boxShape: BoxShape.circle,
                                height: 48,
                                width: 48,
                              ),
                            ),

                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                rideController
                                    .tripResponse
                                    .value
                                    .data!
                                    .driver!
                                    .name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${rideController.tripResponse.value.data!.driver!.vehicleModel} ${rideController.tripResponse.value.data!.driver!.vehicleModel}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  " ${_homeController.driverEta.value} away",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/icons/cycle.svg"),
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
                                      rideController
                                          .tripResponse
                                          .value
                                          .data!
                                          .driver!
                                          .tripGivenCount
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
                                      "${rideController.tripResponse.value.data!.driver!.rating}",
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
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
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
                                          rideController
                                              .tripResponse
                                              .value
                                              .data!
                                              .pickupAddress,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF333333),
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
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          rideController
                                              .tripResponse
                                              .value
                                              .data!
                                              .dropoffAddress,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF333333),
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
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        rideController
                                            .tripResponse
                                            .value
                                            .data!
                                            .totalCost
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        "(£)",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                          color: Color(0xFF333333),
                                          fontStyle: FontStyle.italic,
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
                      const SizedBox(height: 17),
                      TextFormField(
                        controller: codeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: codeController.text),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard!'),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset('assets/icons/copy.svg'),
                            ),
                          ),

                          fillColor: const Color(0xFFE6EAF0),
                          filled: true,
                          hint: Text(
                            rideController.tripResponse.value.data!.slug,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 98),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              await _chatController.createChatRoom(
                                userId: rideController
                                    .tripResponse
                                    .value
                                    .data!
                                    .driver!
                                    .id
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
                              child: SvgPicture.asset(
                                'assets/icons/message.svg',
                              ),
                            ),
                          ),
                          const SizedBox(width: 22),
                          Expanded(
                            child: Obx(
                              () => CustomButton(
                                loading: rideController.isLoading.value,
                                onTap: () {
                                  rideController.payForTrip();
                                },
                                text: "Pay Now",
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                color: const Color(0xFFE6EAF0),
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
      ),
    );
  }
}
