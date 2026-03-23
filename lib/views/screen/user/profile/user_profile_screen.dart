import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/screen/Splash/select_role_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/about_us_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/change_password_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/support_screen.dart';
import 'package:flutter_extension/views/screen/user/profile/trip_history_screen.dart';
import 'package:flutter_extension/views/screen/user/profile/user_edit_profile_screen.dart';
import 'package:flutter_extension/views/screen/user/profile/user_wallet_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _userProfileController = Get.put(UserProfileController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProfileController.fetchUserInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _userProfileController.isLaoding.value
            ? const Center(child: CustomLoading())
            : SafeArea(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xFF676769),
                              ),
                            ),
                            const Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Get.to(() => const UserEditProfileScreen());
                              },
                              child: SvgPicture.asset("assets/icons/edit.svg"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: CustomNetworkImage(
                            imageUrl:
                                "${ApiConstant.imageBaseUrl}${_userProfileController.userProfileModel.value.avatar ?? ""}",
                            boxShape: BoxShape.circle,
                            height: 80,
                            width: 80,
                          ),
                        ),

                        // Container(
                        //   height: 80,
                        //   width: 80,
                        //   decoration: const BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     image: DecorationImage(
                        //       image: AssetImage('assets/images/demo.png'),
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            _userProfileController
                                    .userProfileModel
                                    .value
                                    .name ??
                                "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            _userProfileController
                                    .userProfileModel
                                    .value
                                    .email ??
                                "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF87878A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6EAF0),
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
                                  _userProfileController
                                      .userProfileModel
                                      .value
                                      .tripReceivedCount
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFF012F64),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _userProfileController
                                      .userProfileModel
                                      .value
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
                        const SizedBox(height: 20),
                        _customTile(
                          onTap: () {
                            Get.to(() => const UserWalletScreen());
                          },
                          image: 'assets/icons/wallet_icon.svg',
                          title: 'RADEEF Wallet',
                        ),

                        _customTile(
                          onTap: () {
                            Get.to(() => const TripHistoryScreen());
                          },
                          image: "assets/icons/cycle.svg",
                          title: "Trip History",
                        ),
                        _customTile(
                          onTap: () {
                            Get.to(() => const ChangePasswordScreen());
                          },
                          image: "assets/icons/lock.svg",
                          title: "Change Password",
                        ),

                        _customTile(
                          onTap: () {
                            Get.to(() => const AboutUsScreen());
                          },
                          image: "assets/icons/about.svg",
                          title: "About Us",
                        ),

                        _customTile(
                          onTap: () {
                            Get.to(() => const SupportScreen());
                          },
                          image: "assets/icons/support.svg",
                          title: "Support",
                        ),

                        _customTile(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 32,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset("assets/icons/delete.svg", height: 48, width: 48),
                                    const SizedBox(height: 16),
                                    const Center(
                                      child: Text(
                                        "Delete Account",
                                        style:  TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                   const  Center(
                                      child: Text(
                                        "Are you sure you want to delete your account? This action cannot be undone.",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF87878A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              Get.back();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 52,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE6E6E6),
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "cancel".tr,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF333333),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 33),
                                        Expanded(
                                          child: CustomButton(
                                            onTap: () async {
                                              final isDeleted = await _userProfileController.deleteUserAccount();
                                              if (isDeleted) {
                                                Get.back();
                                                SocketService().disconnect();
                                                await PrefsHelper.remove(
                                                  AppConstants.bearerTokenKEN,
                                                );
                                                await PrefsHelper.remove("id");
                                                await PrefsHelper.remove("role");
                                                await PrefsHelper.remove("user");
                                                await PrefsHelper.remove("is_active");
                                                await PrefsHelper.remove("name");
                                                await ApiClient.refreshToken();
                                                Get.offAll(
                                                  () => const SelectRoleScreen(),
                                                );
                                              }
                                            },
                                            text: "Delete",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          image: "assets/icons/delete.svg",
                          title: "Delete Account",
                        ),



                        _customTile(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 32,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Text(
                                        "doYouHaveLogOut".tr,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              SocketService().disconnect();
                                              await PrefsHelper.remove(
                                                AppConstants.bearerTokenKEN,
                                              );
                                              await PrefsHelper.remove("id");
                                              await PrefsHelper.remove("role");
                                              await PrefsHelper.remove("user");
                                              await PrefsHelper.remove("is_active");
                                              await PrefsHelper.remove("name");
                                              await ApiClient.refreshToken();
                                              Get.offAll(
                                                () => const SelectRoleScreen(),
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 52,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE6E6E6),
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "logOut".tr,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF333333),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 33),
                                        Expanded(
                                          child: CustomButton(
                                            onTap: () {
                                              Get.back();
                                            },
                                            text: "cancel".tr,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          image: "assets/icons/logout.svg",
                          title: "Log Out",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  ListTile _customTile({
    required String image,
    required String title,
    required Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(image),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF545454),
        ),
      ),
    );
  }
}
