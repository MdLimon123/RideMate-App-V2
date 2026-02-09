import 'package:flutter/material.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/driver/profile/about_us_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/change_password_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/edit_profile_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/privacy_policy_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/support_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/terms_service_screen.dart';
import 'package:flutter_extension/views/screen/driver/profile/wallet_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                Row(
                  children: [
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
                        Get.to(() => const EditProfileScreen());
                      },
                      child: SvgPicture.asset("assets/icons/edit.svg"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Center(
                //   child: CustomNetworkImage(
                //     imageUrl:
                //         "${ApiConstant.imageBaseUrl}${_driverProfileController.driverProfileModel.value.avatar}",
                //     boxShape: BoxShape.circle,
                //     height: 80,
                //     width: 80,
                //   ),
                // ),
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/demo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Walid",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    "demo@gmail.com",
                    style: TextStyle(
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
                        const Text(
                          "100",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.star, color: Color(0xFF012F64)),
                        const SizedBox(width: 4),
                        const Text(
                          "4.5",
                          style: TextStyle(
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
                    Get.to(() => const WalletScreen());
                  },
                  image: 'assets/icons/wallet_icon.svg',
                  title: 'RADEEF Wallet',
                ),

                // _customTile(
                //     onTap: (){
                //       Get.to(()=> TripHistoryScreen());
                //     },
                //     image: "assets/icons/cycle.svg",
                //     title: "Trip History"),
                _customTile(
                  onTap: () {
                    Get.to(() => const ChangePasswordScreen());
                  },
                  image: "assets/icons/lock.svg",
                  title: "Change Password",
                ),

                _customTile(
                  onTap: () {
                    Get.to(() => const TermsServiceScreen());
                  },
                  image: "assets/icons/about.svg",
                  title: "Terms & Service",
                ),
                _customTile(
                  onTap: () {
                    Get.to(() => const PrivacyPolicyScreen());
                  },
                  image: "assets/icons/about.svg",
                  title: "Privacy & Policy",
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
                                    onTap: () {},
                                    child: Container(
                                      width: double.infinity,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6E6E6),
                                        borderRadius: BorderRadius.circular(24),
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
                                SizedBox(width: 33),
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
