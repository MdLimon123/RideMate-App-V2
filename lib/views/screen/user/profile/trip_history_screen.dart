import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/parcel_end_controller.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {

  final _driverRiderController = Get.put(ParcelEndController());

  @override
  void initState() {
    _driverRiderController.fetchRiderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Trip History"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ride History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),

                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _driverRiderController.selectedOption.value.isEmpty
                          ? null
                          : _driverRiderController.selectedOption.value,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF333333),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                      ),
                      items: _driverRiderController.optionsMap.keys.map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue == null) return;
                        _driverRiderController.changeOption(newValue);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(
              () => _driverRiderController.isLoading.value
                  ? Center(child: CustomLoading(color: AppColors.primaryColor))
                  : _driverRiderController.riderHistoryList.isEmpty
                  ? const Center(
                      child: Text(
                        "No ride history available.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final item =
                              _driverRiderController.riderHistoryList[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 13,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6EAF0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/pick.svg'),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "From: ${item.pickupAddress} ",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8A8A8A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "${item.totalCost} £",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF012F64),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/location.svg',
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "${item.dropoffAddress}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8A8A8A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },

                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount:
                            _driverRiderController.riderHistoryList.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
