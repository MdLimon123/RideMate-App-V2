import 'package:flutter/material.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Notification"),
      body: ListView.separated(
        itemCount: 10,

        separatorBuilder: (_, __) => const SizedBox(height: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemBuilder: (context, index) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment confirm",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF012F64),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Lorem ipsum dolor sit amet consectetur. Ultrici es tincidunt eleifend vitae",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF676769),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "10 min ago",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF676769),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
