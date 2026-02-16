import 'dart:convert';
import 'dart:io';

import 'package:flutter_extension/data/api/api_checker.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/data/model/user/parcel_response_model.dart';
import 'package:flutter_extension/data/model/user/user_trip_model.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/accepted_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/parcel_payment_overview.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/requested_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/started_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/payment_orver_view.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/accepted_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/requested_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/started_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/waiting_for_payment.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverRideController extends GetxController {
  var activeStatus = ActiveStatus.NONE.obs;
  var tripStatus = TripStatus.REQUESTED.obs;
  var parcelStatus = ParcelStatus.ACCEPTED.obs;
  Rx<TripResponseModel> tripResponse = TripResponseModel().obs;

  var isTripStarted = false.obs;

  Rx<ParcelResponseModel> parcelResponse = ParcelResponseModel().obs;
  var isLoading = false.obs;

  /// set trip status
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

  /// set parcel status
  void setParcelStatus(ParcelResponseModel parcelResponseModel) {
    if (parcelResponseModel.data!.status == ParcelStatus.CANCELLED) {
      clear();
      return;
    }
    activeStatus.value = parcelResponseModel.kind!;
    parcelStatus.value = parcelResponseModel.data!.status;
    parcelResponse.value = parcelResponseModel;
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
        Get.offAll(const MainDriver());
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
        return const ParcelPaymentOverview();
      default:
        Get.offAll(const MainDriver());
    }
  }

  void updateDriverLocation(double lat, double lng, String? address) {
    SocketService().emit(
      'driver:update_location',
      data: {
        "location_lat": lat,
        "location_lng": lng,
        "location_address": address,
      },
    );
  }

  void listenDriverLocation({
    required void Function(LatLng newLatLng) onLocationUpdate,
    required String id,
  }) {
    SocketService().on('location:$id', (data) async {
      final newLatLng = LatLng(data['location_lat'], data['location_lng']);
      onLocationUpdate(newLatLng);
    });
  }

  listenDriverRide() {
    SocketService().on("driver-trip", (data) {
      final response = data is String ? jsonDecode(data) : data;

      if (response['kind'] == "TRIP") {
        print("========> check response:$response");
        TripResponseModel responseModel = TripResponseModel.fromJson(response);
        print("========> check model:${responseModel.kind}");
        setTripStatus(responseModel);
      } else if (response['kind'] == "PARCEL") {
        ParcelResponseModel parcelResponseModel = ParcelResponseModel.fromJson(
          response,
        );
        setParcelStatus(parcelResponseModel);
        print("========> check model:${response['kind']}");

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
      isTripStarted.value = true;
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

  /// parcel

  acceptParcelRequest() async {
    acceptedLoading(true);

    final response = await ApiClient.postData(
      ApiConstant.acceptParcelRequestForDriver,
      {"parcel_id": parcelResponse.value.data!.id},
    );

    if (response.statusCode == 200) {
      var responseModel = ParcelResponseModel.fromJson(response.body);
      setParcelStatus(responseModel);
    } else {
      ApiChecker.checkApi(response);
    }
    acceptedLoading(false);
  }

  cancelParcelRequest() async {
    cancelLoading(true);
    var response = await ApiClient.postData(
      ApiConstant.cancelParcelRequestForDriver,
      {"parcel_id": parcelResponse.value.data!.id},
    );
    if (response.statusCode == 200) {
      clear();
    } else {
      ApiChecker.checkApi(response);
    }
    cancelLoading(false);
  }

  startParcel() async {
    isLoading(true);
    var response = await ApiClient.postData(
      ApiConstant.startedParcelForDriver,
      {"parcel_id": parcelResponse.value.data!.id},
    );
    if (response.statusCode == 200) {
      var responseModel = ParcelResponseModel.fromJson(response.body);
      setParcelStatus(responseModel);
        isTripStarted.value = true;
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  Future<bool> endParcel({required String imagePath}) async {
    try {
      isLoading(true);

      final multipartBody = [MultipartBody('files', File(imagePath))];

      final response = await ApiClient.postMultipartData(
        ApiConstant.endParcelForDriver,
        {"parcel_id": parcelResponse.value.data!.id},
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseModel = ParcelResponseModel.fromJson(response.body);
        setParcelStatus(responseModel);
        return true;
      } else {
        ApiChecker.checkApi(response);
        return false;
      }
    } catch (e) {
      print("End Parcel Error: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }
}
