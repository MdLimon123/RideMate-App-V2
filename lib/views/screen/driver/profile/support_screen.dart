import 'package:flutter/material.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_svg/svg.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Support"),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/icons/support.svg",
              height: 95,
              width: 96,
              color: const Color(0xFF345983),
            ),
            const SizedBox(height: 20),
            const Text(
              "Shoot us your complain through email",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text("Contact@radeefs.com", style: TextStyle(fontSize: 20)),

            const Spacer(), 

            Row(
              children: [
                SvgPicture.asset("assets/icons/what.svg"),
                const SizedBox(width: 8),
                const Text("Need Help?"),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/chat.svg"),
                    const SizedBox(width: 8),
                    const Text("Live Chat"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
