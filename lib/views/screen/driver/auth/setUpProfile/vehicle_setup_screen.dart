import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_setu_profile_controller.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/driver/auth/setUpProfile/driver_capture_image_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class VehicleSetupScreen extends StatefulWidget {
  const VehicleSetupScreen({super.key});

  @override
  State<VehicleSetupScreen> createState() => _VehicleSetupScreenState();
}

class _VehicleSetupScreenState extends State<VehicleSetupScreen> {
  final _driverSetupController = Get.put(DriverProfileSetupController());
  final _fromKey = GlobalKey<FormState>();

  final typeController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final licenseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.arrow_back_ios, color: Color(0xFF676769)),
            Image.asset('assets/images/logo.png'),
            const Spacer(),
            const Text(
              "3 Of 4",
              style: TextStyle(
                color: Color(0xFF012F64),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      body: Form(
        key: _fromKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            const Text(
              "Vehicle ",
              style: TextStyle(
                color: Color(0xFF012F64),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: typeController,
              hintText: "Vehicle Type",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your Vehicle Type";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: brandController,
              hintText: "Vehicle Brand",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your Vehicle Brand";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: modelController,
              hintText: "Model",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your Vehicle Model";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: licenseController,
              keyboardType: TextInputType.number,
              hintText: "License Plate Number",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your License Plate Number";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vehicle Registration",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF545454),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Upload ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF545454),
                              ),
                            ),

                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Obx(() {
                                  final image =
                                      _driverSetupController.vehicleImage.value;
                                  return InkWell(
                                    onTap: () {
                                      _driverSetupController.pickVehicleImage();
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: image != null
                                              ? const Color(0xFF11DF7F)
                                              : const Color(0xFF012F64),
                                          width: 0.5,
                                        ),
                                        color: image == null
                                            ? const Color(0xFFE6E6E6)
                                            : null,
                                      ),
                                      child: image != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.file(
                                                image,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                }),

                                Obx(() {
                                  return _driverSetupController
                                              .vehicleImage
                                              .value ==
                                          null
                                      ? Positioned(
                                          child: InkWell(
                                            onTap: () {
                                              _driverSetupController
                                                  .pickVehicleImage();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/camera.svg',
                                                color: const Color(0xFF012F64),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vehicle Photo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF545454),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Upload (Front Side)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF545454),
                              ),
                            ),

                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Obx(() {
                                  final image =
                                      _driverSetupController.vfrontImage.value;
                                  return InkWell(
                                    onTap: () {
                                      _driverSetupController.pickVFrontImage();
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: image != null
                                              ? const Color(0xFF11DF7F)
                                              : const Color(0xFF012F64),
                                          width: 0.5,
                                        ),
                                        color: image == null
                                            ? const Color(0xFFE6E6E6)
                                            : null,
                                      ),
                                      child: image != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.file(
                                                image,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                }),

                                Obx(() {
                                  return _driverSetupController
                                              .vfrontImage
                                              .value ==
                                          null
                                      ? Positioned(
                                          child: InkWell(
                                            onTap: () {
                                              _driverSetupController
                                                  .pickVFrontImage();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/camera.svg',
                                                color: const Color(0xFF012F64),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Upload (Back Side)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF545454),
                              ),
                            ),

                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Obx(() {
                                  final image =
                                      _driverSetupController.vbackImage.value;
                                  return InkWell(
                                    onTap: () {
                                      _driverSetupController.pickVBackImage();
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: image != null
                                              ? const Color(0xFF11DF7F)
                                              : const Color(0xFF012F64),
                                          width: 0.5,
                                        ),
                                        color: image == null
                                            ? const Color(0xFFE6E6E6)
                                            : null,
                                      ),
                                      child: image != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.file(
                                                image,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                }),

                                Obx(() {
                                  return _driverSetupController
                                              .vbackImage
                                              .value ==
                                          null
                                      ? Positioned(
                                          child: InkWell(
                                            onTap: () {
                                              _driverSetupController
                                                  .pickVBackImage();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/camera.svg',
                                                color: const Color(0xFF012F64),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Obx(
              () => CustomButton(
                loading: _driverSetupController.isLoading.value,
                onTap: () {
                  if (_fromKey.currentState!.validate()) {
                    _driverSetupController.uploadVehicleInfo(
                      vType: typeController.text,
                      vBrand: brandController.text,
                      vModel: modelController.text,
                      licenseNumber: licenseController.text,
                      vImage: _driverSetupController.vehicleImage.value!.path,
                      vFrontImage:
                          _driverSetupController.vfrontImage.value!.path,
                      vBackImage: _driverSetupController.vbackImage.value!.path,
                    );
                  }
                },
                text: "Save Now",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
