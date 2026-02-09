import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar2 extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar2({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,

      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF0D1C12),
          size: 18,
        ),
      ),

      title: Image.asset('assets/images/logo.png'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
