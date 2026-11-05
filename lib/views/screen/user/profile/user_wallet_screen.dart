import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/user_profile_controller.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:get/get.dart';

class UserWalletScreen extends StatefulWidget {
  const UserWalletScreen({super.key});

  @override
  State<UserWalletScreen> createState() => _UserWalletScreenState();
}

class _UserWalletScreenState extends State<UserWalletScreen> {
  final _userProfileController = Get.put(UserProfileController());

  final amountController = TextEditingController();

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
      appBar: const CustomAppbar(title: "Wallet"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Container(
            width: double.infinity,
            height: 191,
            decoration: BoxDecoration(
              color: const Color(0xFFE6EAF0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Obx(
                () => Text(
                  " + ${_userProfileController.userProfileModel.value.wallet!.balance} £",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF012F64),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Amount",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF545454),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: amountController,

                  keyboardType: TextInputType.number,
                  filColor: Color(0xFFFFFFFF),
                  hintText: "Enter Amount",
                ),
              ],
            ),
          ),
          const SizedBox(height: 112),
          Obx(
            () => CustomButton(
              loading: _userProfileController.isTopUpLoading.value,
              onTap: () {
                _userProfileController.topUpWallet(
                  amount: amountController.text,
                );
              },
              text: "Top Up",
            ),
          ),
          const SizedBox(height: 16),

          _userProfileController.userProfileModel.value.isStripeConnected ==
                  false
              ? const SizedBox.shrink()
              : Obx(
                  () => CustomButton(
                    loading: _userProfileController.isWithdrawLoading.value,
                    onTap: () {
                      _userProfileController.withdrawFunds(
                        amount: amountController.text,
                      );
                    },
                    text: "Withdraw",
                  ),
                ),

          const SizedBox(height: 16),
          _userProfileController.userProfileModel.value.isStripeConnected ==
                  true
              ? const SizedBox.shrink()
              : Obx(
                  () => CustomButton(
                    loading: _userProfileController.isConnectLoading.value,
                    onTap: () {
                      _userProfileController.connectStripeAccount();
                    },
                    text: "Connect Stripe Account",
                  ),
                ),
        ],
      ),
    );
  }
}