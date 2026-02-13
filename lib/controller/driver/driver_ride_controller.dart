import 'dart:convert';

import 'package:flutter_extension/data/api/api_checker.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
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
  var isLoading = false.obs;

  void setTripStatus(TripResponseModel tripResponseModel) {
    if (tripResponseModel.data!.status == TripStatus.CANCELLED) {
      clear();
      return;
    }
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
    print("trip flow : ${tripStatus.value}");
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
    SocketService().on("driver-trip", (data) {
      final response = data is String ? jsonDecode(data) : data;
      if (response['kind'] == "TRIP") {
        print("========> check response:$response");
        TripResponseModel responseModel = TripResponseModel.fromJson(response);
        print("========> check model:${responseModel.kind}");
        setTripStatus(responseModel);
      } else {
        print("========> cancel");
      }
    });
  }

  var acceptedLoading = false.obs;
  acceptTripRequest() async {
    acceptedLoading(true);
    var response = await ApiClient.postData(
      ApiConstant.acceptTripRequestForDriver,
      {"trip_id": tripResponse.value.data!.id},
    );
    if (response.statusCode == 200) {
      var responseModel = TripResponseModel.fromJson(response.body);
      setTripStatus(responseModel);
    } else {
      ApiChecker.checkApi(response);
    }
    acceptedLoading(false);
  }

  var cancelLoading = false.obs;
  cancelTripRequest() async {
    cancelLoading(true);
    var response = await ApiClient.postData(
      ApiConstant.cancelTripRequestForDriver,
      {"trip_id": tripResponse.value.data!.id},
    );
    if (response.statusCode == 200) {
      clear();
    } else {
      ApiChecker.checkApi(response);
    }
    cancelLoading(false);
  }

  startTrip() async {
    isLoading(true);
    var response = await ApiClient.postData(ApiConstant.startedTripForDriver, {
      "trip_id": tripResponse.value.data!.id,
    });
    if (response.statusCode == 200) {
      var responseModel = TripResponseModel.fromJson(response.body);
      setTripStatus(responseModel);
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  endTrip() async {
    isLoading(true);
    var response = await ApiClient.postData(ApiConstant.endTripForDriver, {
      "trip_id": tripResponse.value.data!.id,
    });
    if (response.statusCode == 200) {
      var responseModel = TripResponseModel.fromJson(response.body);
      setTripStatus(responseModel);
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }
}
