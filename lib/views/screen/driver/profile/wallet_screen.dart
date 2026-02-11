import 'package:flutter/material.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final amountController = TextEditingController();

  @override
  void initState() {
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
            child: const Center(
              child: Text(
                " + 100000 £",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF012F64),
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

          CustomButton(onTap: () {}, text: "Connect Stripe Account"),

          const SizedBox(height: 16),

          CustomButton(onTap: () {}, text: "Withdraw Now"),
        ],
      ),
    );
  }
}
