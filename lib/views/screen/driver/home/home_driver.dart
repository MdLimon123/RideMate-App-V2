import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/home_controller.dart';
import 'package:flutter_extension/views/screen/driver/home/finding_request.dart';
import 'package:flutter_extension/views/screen/driver/home/payment_orver_view.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/waiting_for_payment.dart';
import 'package:get/get.dart';

import '../../../../util/app_constants.dart';

class HomeDriver extends StatefulWidget {
  const HomeDriver({super.key});

  @override
  State<HomeDriver> createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  final DriverHomeController _homeController = Get.put(DriverHomeController());

  @override
  Widget build(BuildContext context) {
    ever(_homeController.tripStatus, (TripStatus status) {
      switch (status) {
        case TripStatus.REQUESTED:
          Get.to(() => const WaitingForPayment());
          break;
        case TripStatus.COMPLETED:
          Get.to(() => const PaymentOrverView());
          break;
        default:
          break;
      }
    });

    return Scaffold(
      body: Obx(() => _route(_homeController.activeStatus.value)),
    );
  }

  _route(ActiveStatus activeStatus) {
    if (activeStatus == ActiveStatus.NONE) {
      return const FindingRequest();
    } else if (activeStatus == ActiveStatus.TRIP) {
      return _homeController.tripFlow();
    } else if (activeStatus == ActiveStatus.PARCEL) {
      return _homeController.parcelFlow();
    }
  }
}
