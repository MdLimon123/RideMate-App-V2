import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/home_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/driver/home/rating_for_user.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PaymentOrverView extends StatefulWidget {
  const PaymentOrverView({super.key});

  @override
  State<PaymentOrverView> createState() => _PaymentOrverViewState();
}

class _PaymentOrverViewState extends State<PaymentOrverView> {
  final _homeController = Get.put(DriverHomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 500,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Obx(
                    () => GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target:
                            _homeController.currentPosition.value ??
                            const LatLng(23.8103, 90.4125),
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      // onMapCreated: _homeController.setMapController,
                    ),
                  ),

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
                          Center(
                            child: Text(
                              "Your earn of this trip",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Center(
                            child: Container(
                              width: 187,
                              height: 57,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6EAF0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "100 (£)",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Radeef ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              SvgPicture.asset(
                                "assets/icons/percentige.svg",
                                color: AppColors.textColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "10",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                "(£)",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                onTap: () {
                  Get.to(() => const RatingForUser());
                },
                text: "Close",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
