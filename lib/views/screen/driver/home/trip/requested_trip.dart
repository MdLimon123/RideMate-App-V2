import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/home_controller.dart';
import 'package:get/get.dart';

class RequestedTrip extends StatefulWidget {
  const RequestedTrip({super.key});

  @override
  State<RequestedTrip> createState() => _RequestedTripState();
}

class _RequestedTripState extends State<RequestedTrip> {
  DriverHomeController _homeController = Get.put(DriverHomeController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(child: Text('Requested Trip Screen')),

            ElevatedButton(
              onPressed: () {
                _homeController.setTripStatus(TripStatus.COMPLETED);
              },
              child: Text("Accept Trip"),
            ),
          ],
        ),
      ),
    );
  }
}
