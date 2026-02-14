import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_profile_controller.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class RatingForUserInParcel extends StatefulWidget {
  const RatingForUserInParcel({super.key});

  @override
  State<RatingForUserInParcel> createState() => _RatingForUserInParcelState();
}

class _RatingForUserInParcelState extends State<RatingForUserInParcel> {
  final _rideController = Get.find<DriverRideController>();
  final _driverProfileController = Get.put(DriverProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rate Your Passengers",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Get.offAll(() => const MainDriver());
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 33),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE6E6E6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),

                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Center(
                      child: CustomNetworkImage(
                        imageUrl:
                            "${ApiConstant.imageBaseUrl}${_rideController.parcelResponse.value.data!.user.avatar}",
                        boxShape: BoxShape.circle,
                        height: 96,
                        width: 96,
                      ),
                    ),

                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        _rideController.parcelResponse.value.data!.user.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Trips",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _rideController
                        .parcelResponse
                        .value
                        .data!
                        .user
                        .tripReceivedCount
                        .toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current Ratings",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.star, color: AppColors.textColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _rideController.parcelResponse.value.data!.user.rating
                        .toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "How was your trip with ${_rideController.parcelResponse.value.data!.user.name}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Obx(
                () => Center(
                  child: RatingBar.builder(
                    initialRating: _driverProfileController.rating.value,
                    minRating: 1,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Color(0xFF012F64)),
                    onRatingUpdate: (value) {
                      _driverProfileController.updateRating(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 200),
              Obx(
                () => CustomButton(
                  loading: _driverProfileController.isLaoding.value,
                  onTap: () {
                    _driverProfileController.driverSubmitParcelRating(
                      userId:
                          _rideController.parcelResponse.value.data!.user.id,
                      tripId: _rideController.parcelResponse.value.data!.id,
                    );
                  },
                  text: "Rate Now",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
