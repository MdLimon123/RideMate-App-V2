import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/parcel_end_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_extension/views/screen/driver/rides/driver_ride_history_details.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DriverRideHistoryScreen extends StatefulWidget {
  const DriverRideHistoryScreen({super.key});

  @override
  State<DriverRideHistoryScreen> createState() =>
      _DriverRideHistoryScreenState();
}

class _DriverRideHistoryScreenState extends State<DriverRideHistoryScreen> {
  final _parcelController = Get.put(ParcelEndController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _parcelController.fetchRiderHistory(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ride History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),

                  Obx(
                    () => DropdownButton<String>(
                      value: _parcelController.selectedOption.value.isEmpty
                          ? null
                          : _parcelController.selectedOption.value,

                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textColor,
                      ),
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFFFEF7F6),
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        _parcelController.changeOption(newValue);
                      },
                      items: _parcelController.optionsMap.keys
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Obx(() {
                if (_parcelController.isLoading.value) {
                  return Center(
                    child: CustomLoading(color: AppColors.primaryColor),
                  );
                }

                if (_parcelController.riderHistoryList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No ride history available",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF87878A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final item = _parcelController.riderHistoryList[index];

                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => DriverRideHistoryDetails(
                              isParcel: item.isParcel,
                              riderHistoryItem: item,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.completedAt != null
                                        ? DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(item.completedAt!)
                                        : item.date ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "From : ${item.pickupAddress}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF87878A),
                                    ),
                                  ),
                                  Text(
                                    "To : ${item.dropoffAddress}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF87878A),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                "${item.totalCost} £",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF012F64),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(height: 8),
                    itemCount: _parcelController.riderHistoryList.length,
                  ),
                );
              }),

              // Expanded(
              //   child: ListView.separated(
              //     itemBuilder: (context, index) {
              //       return InkWell(
              //         onTap: () {
              //           Get.to(() => const DriverRideHistoryDetails());
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 12,
              //             vertical: 13,
              //           ),
              //           decoration: BoxDecoration(
              //             color: const Color(0xFFE6E6E6),
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           child: const Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     "Monday",
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                       color: Color(0xFF333333),
              //                     ),
              //                   ),
              //                   SizedBox(height: 4),

              //                   Text(
              //                     "8 trips • 6.5h",
              //                     style: TextStyle(
              //                       fontSize: 14,
              //                       color: Color(0xFF87878A),
              //                       fontWeight: FontWeight.w400,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Spacer(),
              //               Text(
              //                 "\$20.00",
              //                 style: TextStyle(
              //                   color: Color(0xFF012F64),
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w400,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //     separatorBuilder: (_, _) => const SizedBox(height: 8),
              //     itemCount: 10,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
