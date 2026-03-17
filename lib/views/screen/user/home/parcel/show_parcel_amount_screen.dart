import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ShowParcelAmountScreen extends StatefulWidget {
  final double showAmount;
  final double pickLat;
  final double pickLng;
  final double dropLat;
  final double dropLan;

  final String pickLocation;
  final String dropLocation;

  final int? weight;
  final double? amount;

  const ShowParcelAmountScreen({
    super.key,
    required this.showAmount,
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLan,
    required this.pickLocation,
    required this.dropLocation,
    required this.amount,
    required this.weight,
  });

  @override
  State<ShowParcelAmountScreen> createState() => _ShowParcelAmountScreenState();
}

class _ShowParcelAmountScreenState extends State<ShowParcelAmountScreen> {
  final pickLocationController = TextEditingController();
  final dropLocationController = TextEditingController();

  final RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pickLocationController.text = widget.pickLocation;
    dropLocationController.text = widget.dropLocation;
    return Scaffold(
      appBar: const CustomAppbar(title: "Parcels  Request"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      readOnly: true,
                      controller: pickLocationController,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset('assets/icons/pick.svg'),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5F5D7),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5F5D7),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5F5D7),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(
                          0xFFE6E6E6,
                        ).withValues(alpha: 0.24),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      readOnly: true,
                      controller: dropLocationController,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset('assets/icons/location.svg'),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5F5D7),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5F5D7),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5F5D7),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(
                          0xFFE6E6E6,
                        ).withValues(alpha: 0.24),
                      ),
                    ),

                    const SizedBox(height: 120),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 75,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF345983),
                        borderRadius: BorderRadius.circular(24),
                      ),

                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              "Estimate Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              " ${widget.showAmount} £",
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E6E6),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => CustomButton(
                              loading: rideController.isLoading.value,
                              onTap: () {
                                var body = {
                                  "weight": widget.weight,
                                  "amount": widget.showAmount,
                                  "pickup_lat": widget.pickLat,
                                  "pickup_lng": widget.pickLng,
                                  "pickup_address": widget.pickLocation,
                                  "dropoff_lat": widget.dropLat,
                                  "dropoff_lng": widget.dropLan,
                                  "dropoff_address": widget.dropLocation,
                                };
                                rideController.requestParcel(body);
                              },
                              text: "confirm".tr,
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
    );
  }
}
