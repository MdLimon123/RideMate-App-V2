import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_checker.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/data/model/user/parcel_response_model.dart';
import 'package:flutter_extension/data/model/user/user_trip_model.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';

import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/screen/user/home/parcel/accepted_parcel_for_driver.dart';
import 'package:flutter_extension/views/screen/user/home/parcel/finding_for_parcel_request.dart';
import 'package:flutter_extension/views/screen/user/home/parcel/pay_for_parcel_screen.dart';
import 'package:flutter_extension/views/screen/user/home/parcel/rating_for_parcel_driver.dart';
import 'package:flutter_extension/views/screen/user/home/trip/accepted_trip_for_driver.dart';
import 'package:flutter_extension/views/screen/user/home/trip/finding_driver.dart';
import 'package:flutter_extension/views/screen/user/home/trip/pay_for_trip_screen.dart';
import 'package:flutter_extension/views/screen/user/home/trip/rating_for_trip_driver.dart';
import 'package:flutter_extension/views/screen/user/home/user_home.dart';
import 'package:get/get.dart';

class RideController extends GetxController {
  var activeStatus = ActiveStatus.NONE.obs;
  var tripStatus = TripStatus.idle.obs;
  var parcelStatus = ParcelStatus.idle.obs;
  Rx<TripResponseModel> tripResponse = TripResponseModel().obs;

  Rx<ParcelResponseModel> parcelResponse = ParcelResponseModel().obs;

  var isLoading = false.obs;

  void setTripStatus(TripResponseModel tripResponseModel) {
    activeStatus.value = tripResponseModel.kind!;
    tripStatus.value = tripResponseModel.data!.status;
    tripResponse.value = tripResponseModel;
    tripFlow(tripStatus.value);
    update();
  }

  void setParcelStatus(ParcelResponseModel parcelResponseModel) {
    activeStatus.value = parcelResponseModel.kind!;
    parcelStatus.value = parcelResponseModel.data!.status;
    parcelResponse.value = parcelResponseModel;
    parcelFlow(parcelStatus.value);
    update();
  }

  // ========== CLEAR TRIP =================

  void clearStates() {
    tripStatus.value = TripStatus.idle;
    parcelStatus.value = ParcelStatus.idle;
    activeStatus.value = ActiveStatus.NONE;
  }

  // ================= ROUTING CORE =================

  tripFlow(TripStatus tripStatus) {
    switch (tripStatus) {
      case TripStatus.REQUESTED:
        Get.off(
          () => FindingDriver(
            pickLocation: tripResponse.value.data!.pickupAddress,
            dropLocation: tripResponse.value.data!.dropoffAddress,
          ),
        );
        break;
      case TripStatus.ACCEPTED:
        Get.off(() => const AcceptedTripForDriver());
        break;
      case TripStatus.STARTED:
        Get.off(() => const AcceptedTripForDriver());
        break;
      case TripStatus.ARRIVED:
        Get.off(() => const PayForTripScreen());
        break;
      case TripStatus.COMPLETED:
        Get.off(() => const RatingForTripDriver());
      default:
        Get.offAll(() => const UserHome());
    }
  }

  parcelFlow(ParcelStatus parcelStatus) {
    switch (parcelStatus) {
      case ParcelStatus.REQUESTED:
        Get.off(
          () => FindingForParcelRewuest(
            pickLocation: parcelResponse.value.data!.pickupAddress,
            dropLocation: parcelResponse.value.data!.dropoffAddress,
          ),
        );
        break;
      case ParcelStatus.ACCEPTED:
        Get.off(() => const AcceptedParcelForDriver());
        break;
      case ParcelStatus.STARTED:
        Get.off(() => const AcceptedParcelForDriver());
        break;
      case ParcelStatus.DELIVERED:
        Get.off(() => const PayForParcelScreen());

        break;
      case ParcelStatus.COMPLETED:
        Get.off(() => const RatingForParcelDriver());
        break;
      default:
        Get.offAll(() => const UserHome());
    }
  }

  socketConntect() async {
    var token = await PrefsHelper.getString(AppConstants.bearerTokenKEN);
    await SocketService().connect(token);
    listenTripAndParcel();
  }

  /// ============= listen trip/parcel ==================
  listenTripAndParcel() {
    SocketService().on("user-trip", (data) {
      debugPrint("test Data : $data");
      final response = data is String ? jsonDecode(data) : data;
      if (response["kind"] == "TRIP") {
        setTripStatus(TripResponseModel.fromJson(data));
      } else if (response["kind"] == "PARCEL") {
        setParcelStatus(ParcelResponseModel.fromJson(data));
      }
    });
  }

  /// ================= REQUEST TRIP =================

  requestTrip(Map<String, dynamic> body) async {
    isLoading(true);
    var response = await ApiClient.postData(ApiConstant.requestTripUrl, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("test Response : $body");
      setTripStatus(TripResponseModel.fromJson(response.body));
      isLoading(false);
    } else {
      isLoading(false);
      ApiChecker.checkApi(response);
    }
  }

  /// ================= CANCEL TRIP =================
  cancelTrip(String tripId) async {
    isLoading(true);
    var body = {"trip_id": tripId};
    var response = await ApiClient.postData(ApiConstant.cancelTripUrl, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.offAll(const UserHome());
      clearStates();
    } else {
      isLoading(false);
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  payForTrip() async {
    isLoading(true);
    var body = {"trip_id": tripResponse.value.data!.id};
    var response = await ApiClient.postData(ApiConstant.payForTrip, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setTripStatus(TripResponseModel.fromJson(response.body));
    } else {
      isLoading(false);
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  /// =================== REQUEST PARCEL ==================
  requestParcel(Map<String, dynamic> body) async {
    isLoading(true);
    var response = await ApiClient.postData(ApiConstant.requestParcelUrl, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("test Response : $body");
      setParcelStatus(ParcelResponseModel.fromJson(response.body));
      isLoading(false);
    } else {
      isLoading(false);
      //ApiChecker.checkApi(response);
    }
    isLoading(false);
    //ApiChecker.checkApi(response);
  }

  /// =================== CANCEL PARCEL ==================
  cancelParcel(String parcelId) async {
    isLoading(true);
    var body = {"parcel_id": parcelId};
    var response = await ApiClient.postData(ApiConstant.cancelParcelUrl, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.offAll(const UserHome());
      clearStates();
    } else {
      isLoading(false);
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  payForParcel() async {
    isLoading(true);
    var body = {"parcel_id": parcelResponse.value.data!.id};
    var response = await ApiClient.postData(ApiConstant.payForParcel, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setParcelStatus(ParcelResponseModel.fromJson(response.body));
    } else {
      isLoading(false);
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  recoverTrip() async {
    isLoading(true);

    final response = await ApiClient.getData(ApiConstant.recoverTripUrl);

    debugPrint("test Response==========> : ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body["kind"] == "TRIP") {
        setTripStatus(TripResponseModel.fromJson(response.body));
      } else if (response.body["kind"] == "PARCEL") {
        setParcelStatus(ParcelResponseModel.fromJson(response.body));
      } else {
        clearStates();
      }
    } else {
      isLoading(false);
      // ApiChecker.checkApi(response);
    }
    isLoading(false);
  }
}
