import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_profile_controller.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _driverProfileController = Get.put(DriverProfileController());

  final amountController = TextEditingController();

  @override
  void initState() {
    _driverProfileController.fetchDriverProfile();
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
                  "  + ${_driverProfileController.driverProfileModel.value.wallet!.balance} £",
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
                  filColor: const Color(0xFFFFFFFF),
                  controller: amountController,
                  hintText: "Enter amount",
                ),
                // SizedBox(height: 16),
                // Text(
                //   "A/C",
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.w400,
                //     color: Color(0xFF545454),
                //   ),
                // ),
                // SizedBox(height: 10),
                // CustomTextField(
                //   filColor: Color(0xFFFFFFFF),
                //   hintText: 'Enter A/C',
                // ),
              ],
            ),
          ),
          const SizedBox(height: 112),
          _driverProfileController.driverProfileModel.value.isStripeConnected ==
                  true
              ? const SizedBox.shrink()
              : Obx(
                  () => CustomButton(
                    loading: _driverProfileController.isConnectLoading.value,
                    onTap: () {
                      _driverProfileController.connectStripeAccount();
                    },
                    text: "Connect Stripe Account",
                  ),
                ),

          const SizedBox(height: 16),

          _driverProfileController.driverProfileModel.value.isStripeConnected ==
                  false
              ? const SizedBox.shrink()
              : Obx(
                  () => CustomButton(
                    loading: _driverProfileController.isWithdrawLoading.value,
                    onTap: () {
                      _driverProfileController.withdrawFunds(
                        amount: amountController.text,
                      );
                    },
                    text: "Withdraw Now",
                  ),
                ),
        ],
      ),
    );
  }
}
