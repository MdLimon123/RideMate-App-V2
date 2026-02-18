import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_home_controller.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_dropdown.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParcleInputDetails extends StatefulWidget {
  const ParcleInputDetails({super.key});

  @override
  State<ParcleInputDetails> createState() => _ParcleInputDetailsState();
}

class _ParcleInputDetailsState extends State<ParcleInputDetails> {
  final _userHomeController = Get.put(UserHomeController());

  @override
  void dispose() {
    _userHomeController.pickController.clear();
    _userHomeController.dropController.clear();
    _userHomeController.suggestions.clear();
    _userHomeController.pickAddress.value = '';
    _userHomeController.dropAddress.value = '';
    _userHomeController.dropCoordinates.clear();
    _userHomeController.parcelWeightController.clear();
    _userHomeController.parcelAmount.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Send Parcel"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    // --- Pick-up Field ---
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _userHomeController.pickController,
                            onChanged: (value) {
                              _userHomeController.fetchSuggestions(
                                value,
                                LocationField.pick,
                              );
                            },
                            decoration: InputDecoration(
                              hintText: "Pick-up Location",
                              prefixIcon: InkWell(
                                onTap: () {
                                  _userHomeController.getCurrentLocation(
                                    setToTextField: true,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/pick.svg',
                                  ),
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(
                                0xFFE6E6E6,
                              ).withOpacity(0.24),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          if (_userHomeController.isLoading.value &&
                              _userHomeController.activeField.value ==
                                  LocationField.pick)
                            const CustomLoading(),

                          if (_userHomeController.suggestions.isNotEmpty &&
                              _userHomeController.activeField.value ==
                                  LocationField.pick)
                            suggestionList(
                              onTap: _userHomeController.selectPick,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- Drop-off Field ---
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _userHomeController.dropController,
                            onChanged: (value) {
                              _userHomeController.fetchSuggestions(
                                value,
                                LocationField.drop,
                              );
                            },
                            decoration: InputDecoration(
                              hintText: "Drop-off Location",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                  'assets/icons/location.svg',
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(
                                0xFFE6E6E6,
                              ).withOpacity(0.24),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          if (_userHomeController.isLoading.value &&
                              _userHomeController.activeField.value ==
                                  LocationField.drop)
                            const CustomLoading(),

                          if (_userHomeController.suggestions.isNotEmpty &&
                              _userHomeController.activeField.value ==
                                  LocationField.drop)
                            suggestionList(
                              onTap: _userHomeController.selectDrop,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Parcels Info",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Color(0xFF545454),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Recent Destinations ---
                    // Text(
                    //   "recentDestination".tr,
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 24,
                    //     color: Color(0xFF545454),
                    //   ),
                    // ),
                    // const SizedBox(height: 12),
                    Obx(
                      () => CustomDropdown(
                        title: "Parcel Type",
                        options: _userHomeController.parcelType.toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _userHomeController.selectedParcelType.value =
                                value;
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _userHomeController.parcelWeightController,
                      hintText: "Parcels Weight",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _userHomeController.parcelAmount,
                      hintText: "Parcels Amount",
                      keyboardType: TextInputType.number,
                    ),

                    // ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: 5,
                    //   separatorBuilder: (_, __) => const SizedBox(height: 6),
                    //   itemBuilder: (context, index) {
                    //     return InkWell(
                    //       onTap: () {},
                    //       child: Container(
                    //         width: double.infinity,
                    //         padding: const EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //           color: const Color(0xFFE6E6E6).withOpacity(0.24),
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Row(
                    //           children: [
                    //             SvgPicture.asset('assets/icons/location.svg'),
                    //             const SizedBox(width: 12),
                    //             const Expanded(
                    //               child: Text(
                    //                 "2972 Westheimer Rd. Santa ",
                    //                 style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                   color: Color(0xFF8A8A8A),
                    //                 ),
                    //                 overflow: TextOverflow.ellipsis,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 157),
                    Obx(
                      () => CustomButton(
                        loading: _userHomeController.isShowAnountLoading.value,
                        onTap: () {
                          _userHomeController.calculateParcelAmount();
                        },
                        text: "Continue",
                      ),
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

  Widget suggestionList({required Function(String) onTap}) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        itemCount: _userHomeController.suggestions.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(
            _userHomeController.suggestions[index],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          onTap: () => onTap(_userHomeController.suggestions[index]),
        ),
      ),
    );
  }
}
