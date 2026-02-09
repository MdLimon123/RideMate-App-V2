import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar2.dart';

class DriverVerifyScreen extends StatefulWidget {
  const DriverVerifyScreen({super.key});

  @override
  State<DriverVerifyScreen> createState() => _DriverVerifyScreenState();
}

class _DriverVerifyScreenState extends State<DriverVerifyScreen> with SingleTickerProviderStateMixin{


  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar2(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 50,),
          Center(
            child: RotationTransition(
              turns: _controller,
              child: Image.asset(
                'assets/images/load_image.png',
                width: 200,
                height: 200,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              "Under the review your account, When admin approve then to the Home",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
          ),
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}