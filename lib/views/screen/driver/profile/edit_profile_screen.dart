import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_profile_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final _driverProfileController = Get.put(DriverProfileController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _driverProfileController.fetchDriverProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text =
        _driverProfileController.driverProfileModel.value.name ?? "";
    return Scaffold(
      appBar: const CustomAppbar(title: "Edit Profile"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Obx(
                () => _driverProfileController.driverProfileImage.value != null
                    ? Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(
                              _driverProfileController
                                  .driverProfileImage
                                  .value!,
                            ),

                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withValues(alpha: 0.30),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      )
                    : CustomNetworkImage(
                        imageUrl:
                            "${ApiConstant.imageBaseUrl}${_driverProfileController.driverProfileModel.value.avatar}",
                        height: 110,
                        boxShape: BoxShape.circle,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.30),
                          BlendMode.darken,
                        ),
                        width: 110,
                      ),
              ),
              Positioned(
                bottom: 5,
                right: 120,
                child: InkWell(
                  onTap: () {
                    _driverProfileController.pickDriverProfileImage();
                  },
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF012F64),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset('assets/icons/camera.svg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: nameController,
            hintText: "Enter full name",
          ),
          const SizedBox(height: 62),
          Obx(
            () => CustomButton(
              loading: _driverProfileController.uploadProfileLoading.value,
              onTap: () {
                _driverProfileController.updateProfile(
                  imagePath:
                      _driverProfileController.driverProfileImage.value!.path,
                  name: nameController.text,
                );
              },
              text: "save".tr,
            ),
          ),
        ],
      ),
    );
  }
}
