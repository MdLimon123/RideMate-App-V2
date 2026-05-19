import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/chat_controller.dart';
import 'package:flutter_extension/controller/user/user_home_controller.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/api/one_signla_helper.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_extension/views/base/get_greeting.dart';
import 'package:flutter_extension/views/screen/notification/notification_screen.dart';
import 'package:flutter_extension/views/screen/user/home/parcel/parcle_input_details.dart';
import 'package:flutter_extension/views/screen/user/home/trip/book_ride_screen.dart';
import 'package:flutter_extension/views/screen/user/profile/user_profile_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _userHomeController = Get.put(UserHomeController());
  final _userProfileController = Get.put(UserProfileController());
  final _chatController = Get.put(ChatController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _userHomeController.subscribleId();
      OneSignalHelper.optIn();
      _userProfileController.fetchUserInfo();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF545454),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _userProfileController.userProfileModel.value.name ??
                              '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF545454),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(() => const NotificationScreen());
                      },
                      child: SvgPicture.asset('assets/icons/notification.svg'),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        Get.to(() => const UserProfileScreen());
                      },
                      child: CustomNetworkImage(
                        imageUrl:
                            "${ApiConstant.imageBaseUrl}${_userProfileController.userProfileModel.value.avatar}",
                        boxShape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1),
                        height: 32,
                        width: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        readOnly: true,
                        onTap: () {
                          _userHomeController.updateSelectedIndex(0);
                          Get.to(() => const BookRideScreen());
                        },
                        decoration: InputDecoration(
                          hint: const Text(
                            "Where do you want to go?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF545454),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset('assets/icons/search.svg'),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE6E6E6),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _userHomeController.updateSelectedIndex(0);
                                Get.to(() => const BookRideScreen());
                              },
                              child: Container(
                                width: double.infinity,
                                height: 64,
                                decoration: BoxDecoration(
                                  color:
                                      _userHomeController.selectedIndex.value ==
                                          0
                                      ? const Color(0xFF345983)
                                      : const Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/bike.svg',
                                      color:
                                          _userHomeController
                                                  .selectedIndex
                                                  .value ==
                                              0
                                          ? Colors.white
                                          : const Color(0xFF333333),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "bookRide".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            _userHomeController
                                                    .selectedIndex
                                                    .value ==
                                                0
                                            ? Colors.white
                                            : const Color(0xFF333333),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Send Parcel Button
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _userHomeController.updateSelectedIndex(1);
                                Get.to(() => const ParcleInputDetails());
                              },
                              child: Container(
                                width: double.infinity,
                                height: 64,
                                decoration: BoxDecoration(
                                  color:
                                      _userHomeController.selectedIndex.value ==
                                          1
                                      ? const Color(0xFF345983)
                                      : const Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/box.svg',
                                      color:
                                          _userHomeController
                                                  .selectedIndex
                                                  .value ==
                                              1
                                          ? Colors.white
                                          : const Color(0xFF333333),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "sendParcel".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            _userHomeController
                                                    .selectedIndex
                                                    .value ==
                                                1
                                            ? Colors.white
                                            : const Color(0xFF333333),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              _userHomeController.recentDestinations.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final dest =
                                _userHomeController.recentDestinations[index];

                            return InkWell(
                              onTap: () {
                                _userHomeController.dropController.text =
                                    dest.address;
                                _userHomeController.dropAddress.value =
                                    dest.address;
                                _userHomeController.dropCoordinates.value = [
                                  dest.lat,
                                  dest.lng,
                                ];
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFE6E6E6,
                                  ).withValues(alpha: 0.24),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/location.svg',
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        dest.address,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8A8A8A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 129),
                      InkWell(
                        onTap: () {
                          _chatController.createAdminChatRoom();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icons/what.svg'),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "needHelp".tr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "support".tr,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF333333),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
