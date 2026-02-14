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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RatingForParcelDriver extends StatefulWidget {
  const RatingForParcelDriver({super.key});

  @override
  State<RatingForParcelDriver> createState() => _RatingForParcelDriverState();
}

class _RatingForParcelDriverState extends State<RatingForParcelDriver> {
  final _rideController = Get.find<RideController>();

  final _userProfileController = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Rate Driver"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                      child: CustomNetworkImage(
                        imageUrl:
                            "${ApiConstant.imageBaseUrl}${_rideController.parcelResponse.value.data!.driver!.avatar}",
                        height: 48,
                        boxShape: BoxShape.circle,
                        width: 48,
                      ),
                    ),

                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        _rideController.parcelResponse.value.data!.driver!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                              _rideController
                                  .parcelResponse
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
                            const SizedBox(width: 16),
                            const Icon(Icons.star, color: Color(0xFF012F64)),
                            const SizedBox(width: 4),
                            Text(
                              _rideController
                                  .parcelResponse
                                  .value
                                  .data!
                                  .driver!
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
                    const SizedBox(height: 34),
                    const Center(
                      child: Text(
                        "Rate the Driver",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFFFF),
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
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.white),
                          onRatingUpdate: (rating) {
                            _userProfileController.updateRating(rating);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const UserHome());
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
    );
  }
}
