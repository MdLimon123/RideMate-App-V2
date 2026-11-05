import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserEditProfileScreen extends StatefulWidget {
  const UserEditProfileScreen({super.key});

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  final _userProfileController = Get.put(UserProfileController());

  final nameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProfileController.fetchUserInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text =
        _userProfileController.userProfileModel.value.name ?? "";
    return Scaffold(
      appBar: const CustomAppbar(title: "Edit Profile"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Obx(
                () => _userProfileController.userProfileImage.value != null
                    ? Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(
                              _userProfileController.userProfileImage.value!,
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
                            "${ApiConstant.imageBaseUrl}${_userProfileController.userProfileModel.value.avatar}",
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
                    _userProfileController.pickUserProfileImage();
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
          CustomTextField(controller: nameController),
          const SizedBox(height: 62),
          Obx(
            () => CustomButton(
              loading: _userProfileController.uploadProfileLoading.value,
              onTap: () {
                if (nameController.text.isEmpty) {
                  nameController.text =
                      _userProfileController.userProfileModel.value.name ?? "";
                }

                _userProfileController.updateProfile(
                  imagePath:
                      _userProfileController.userProfileImage.value != null
                      ? _userProfileController.userProfileImage.value!.path
                      : "",
                  name: nameController.text.trim(),
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
