import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/controller/driver/parcel_end_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EndParcelConfirmationScreen extends StatefulWidget {
  const EndParcelConfirmationScreen({super.key});

  @override
  State<EndParcelConfirmationScreen> createState() =>
      _EndParcelConfirmationScreenState();
}

class _EndParcelConfirmationScreenState
    extends State<EndParcelConfirmationScreen> {
  final _parcelEndController = Get.put(ParcelEndController());
  final _driverRideController = Get.find<DriverRideController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomNetworkImage(
                      imageUrl:
                          "${ApiConstant.imageBaseUrl}${_driverRideController.parcelResponse.value.data!.user.avatar}",
                      boxShape: BoxShape.circle,
                      height: 48,
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
                                  "${_driverRideController.parcelResponse.value.data!.user.tripReceivedCount}",
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
                                  "${_driverRideController.parcelResponse.value.data!.user.rating}",
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

                const SizedBox(height: 34),

                InkWell(
                  onTap: () {
                    _parcelEndController.pickParcelImage(fromCamera: true);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Take a picture for end trip",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),

                        Obx(() {
                          final image = _parcelEndController.parcelImage.value;
                          return InkWell(
                            onTap: () {
                              _parcelEndController.pickParcelImage(
                                fromCamera: true,
                              );
                            },
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFF11DF7F),
                                  width: 0.5,
                                ),
                              ),
                              child: image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.file(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }),
                      ],
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
                          SvgPicture.asset(
                            'assets/icons/kg.svg',
                            color: AppColors.textColor,
                          ),
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

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          Obx(
            () => CustomButton(
              loading: _driverRideController.isLoading.value,
              onTap: () async {
                bool success = await _driverRideController.endParcel(
                  imagePath: _parcelEndController.parcelImage.value!.path,
                );

                if (success) {
                  Get.back();
                }
              },
              text: "Confirm",
            ),
          ),
        ],
      ),
    );
  }

  void onDeliveryCompleted(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delivery Complete 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          content: Text(
            'Parcel delivery has been completed successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [],
        );
      },
    );
  }
}
