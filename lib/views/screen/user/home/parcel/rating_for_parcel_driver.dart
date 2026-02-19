import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/screen/user/home/user_home.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class RatingForParcelDriver extends StatefulWidget {
  const RatingForParcelDriver({super.key});

  @override
  State<RatingForParcelDriver> createState() => _RatingForParcelDriverState();
}

class _RatingForParcelDriverState extends State<RatingForParcelDriver> {
  final RideController _rideController = Get.put(RideController());

  final _userProfileController = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    print(
      "Driver rating: ${_rideController.parcelResponse.value.data?.driver?.rating}",
    );
    return Scaffold(
      appBar: const CustomAppbar(title: "Rate Driver"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Obx(() {
                          final driver =
                              _rideController.parcelResponse.value.data?.driver;

                          if (driver == null || driver.avatar == null) {
                            return const CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.person),
                            );
                          }

                          return CustomNetworkImage(
                            imageUrl:
                                "${ApiConstant.imageBaseUrl}${driver.avatar}",
                            height: 96,
                            width: 96,
                            boxShape: BoxShape.circle,
                          );
                        }),
                      ),

                      const SizedBox(height: 12),
                      Center(
                        child: Obx(() {
                          final driver =
                              _rideController.parcelResponse.value.data?.driver;

                          return Text(
                            driver?.name ?? "Driver not assigned",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }),
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
                    const SizedBox(width: 4),
                    Text(
                      _rideController
                              .parcelResponse
                              .value
                              .data
                              ?.driver
                              ?.tripGivenCount
                              .toString() ??
                          "0",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
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
                    const Icon(Icons.star, color: Color(0xFF012F64)),
                    const SizedBox(width: 4),
                    Text(
                      _rideController.parcelResponse.value.data?.driver?.rating
                              .toString() ??
                          "0",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 34),
                Center(
                  child: Text(
                    "How was your trip with ${_rideController.parcelResponse.value.data!.driver!.name}",
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
                      initialRating: _userProfileController.rating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: AppColors.primaryColor),
                      onRatingUpdate: (rating) {
                        _userProfileController.updateRating(rating);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 150),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.offAll(() => const UserHome());
                        },
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              "Later",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: Obx(
                        () => CustomButton(
                          loading: _userProfileController.isLaoding.value,
                          onTap: () {
                            _userProfileController.submitRatingParcel(
                              userId: _rideController
                                  .parcelResponse
                                  .value
                                  .data!
                                  .driver!
                                  .id,
                              parcelId:
                                  _rideController.parcelResponse.value.data!.id,
                            );
                          },
                          text: "Rate Now",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
