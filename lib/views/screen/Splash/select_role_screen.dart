import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/splash_controller.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/Splash/location_enable_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  final _splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Center(child: SvgPicture.asset("assets/icons/ride.svg")),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Ride. Earn. Go Further",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Book quick rides or start earning on your own schedule - Assurance, Speed, and Precision",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF545454),
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              CustomButton(
                onTap: () {
                  _splashController.setRole("USER");

                  Get.to(() => const LocationEnableScreen(role: "USER"));
                },
                text: "User Account",
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {

                    _splashController.setRole("DRIVER");
                    
                  Get.to(() => const LocationEnableScreen(role: "DRIVER"));
                
                },
                child: Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EAF0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      "Drivers Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF545454),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
