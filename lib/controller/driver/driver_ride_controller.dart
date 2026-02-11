import 'dart:convert';

import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/data/model/user/user_trip_model.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/accepted_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/requested_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/started_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/payment_orver_view.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/accepted_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/requested_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/started_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/waiting_for_payment.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:get/get.dart';

class DriverRideController extends GetxController {
  var activeStatus = ActiveStatus.NONE.obs;
  var tripStatus = TripStatus.REQUESTED.obs;
  var parcelStatus = ParcelStatus.ACCEPTED.obs;
  Rx<TripResponseModel> tripResponse = TripResponseModel().obs;

  void setTripStatus(TripResponseModel tripResponseModel) {
    activeStatus.value = tripResponseModel.kind!;
    tripStatus.value = tripResponseModel.data!.status;
    tripResponse.value = tripResponseModel;
    update();
  }

  clear() {
    activeStatus.value = ActiveStatus.NONE;
    tripStatus.value = TripStatus.idle;
    parcelStatus.value = ParcelStatus.idle;
    update();
  }

  tripFlow() {
    switch (tripStatus.value) {
      case TripStatus.REQUESTED:
        return const RequestedTrip();
      case TripStatus.ACCEPTED:
        //go to accepted screen
        return const AcceptedTrip();
      case TripStatus.STARTED:
        return const StartedTrip();
      case TripStatus.ARRIVED:
        // go to waiting for payment screen
        return const WaitingForPayment();

      case TripStatus.COMPLETED:
        return const PaymentOrverView();
      //go to completed screen
      //
      default:
        Get.offAll(MainDriver());
    }
  }

  parcelFlow() {
    switch (parcelStatus.value) {
      case ParcelStatus.REQUESTED:
        //go to accepted screen
        return const RequestedParcel();
      case ParcelStatus.ACCEPTED:
        //go to arrived screen
        return const AcceptedParcel();

      case ParcelStatus.STARTED:
        //go to completed screen
        return const StartedParcel();
      case ParcelStatus.DELIVERED:
        //go to started screen
        return const WaitingForPayment();

      case ParcelStatus.COMPLETED:
        //go to completed screen
        return const PaymentOrverView();
      default:
        Get.offAll(MainDriver());
    }
  }

  listenDriverRide() {
    SocketService().on("driver:trip", (data) {
      var response = jsonDecode(data);
      print("========> response listen driver: $data");
      if (data['kind'] == ActiveStatus.TRIP) {
        TripResponseModel responseModel = TripResponseModel.fromJson(response);
        activeStatus.value = responseModel.kind!;
        tripStatus.value = responseModel.data!.status;
        tripFlow();
      } else {
        parcelFlow();
      }
    });
  }
}
