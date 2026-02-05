import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/home_controller.dart';
import 'package:get/get.dart';

class FindingRequest extends StatefulWidget {
  const FindingRequest({super.key});

  @override
  State<FindingRequest> createState() => _FindingRequestState();
}

class _FindingRequestState extends State<FindingRequest> {
  DriverHomeController _homeController = Get.put(DriverHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(child: Text('Finding Request Screen')),

          ElevatedButton(
            onPressed: () {
              _homeController.setActiveStatus(ActiveStatus.TRIP);
              _homeController.setTripStatus(TripStatus.REQUESTED);
            },
            child: Text(" Request Trip "),
          ),
        ],
      ),
    );
  }
}
