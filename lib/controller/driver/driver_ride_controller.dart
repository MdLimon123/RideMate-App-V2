import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_extension/data/api/api_checker.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/data/model/user/parcel_response_model.dart';
import 'package:flutter_extension/data/model/user/user_trip_model.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
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
  //var tripStatus = TripStatus.REQUESTED.obs;
  //var parcelStatus = ParcelStatus.ACCEPTED.obs;

  var tripStatus = TripStatus.idle.obs;
  var parcelStatus = ParcelStatus.idle.obs;

  Rx<TripResponseModel> tripResponse = TripResponseModel().obs;

  @override
  void onInit() {
    listenDriverRide();
    super.onInit();
  }

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
    isLoading.value = false;
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
          return const StartedTrip(); /// todo: add this
        /// return const WaitingForPayment(); //// todo: remove this

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
          return const StartedParcel(); /// todo: add this
       /// return const WaitingForPayment(); /// todo: remove this

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

  socketConntect() async {
    var token = await PrefsHelper.getString(AppConstants.bearerTokenKEN);
    print("token ====> $token");
    await SocketService().connect(token);
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

  Future<void> listenDriverRide() async {
    print("listenDriverRide");

    // Ensure socket connected first
    await socketConntect();

    // Attach listener safely
    SocketService().on("driver-trip", (data) {
      print("driver-trip received: $data");
      final response = data is String ? jsonDecode(data) : data;

      if (response['kind'] == "TRIP") {
        TripResponseModel responseModel = TripResponseModel.fromJson(response);
        setTripStatus(responseModel);
      } else if (response['kind'] == "PARCEL") {
        ParcelResponseModel parcelResponseModel = ParcelResponseModel.fromJson(
          response,
        );
        setParcelStatus(parcelResponseModel);
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
      isLoading(false);
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
        clear();
      }
      Get.off(() => const MainDriver());
      isLoading(false);
    } else {
      isLoading(false);
      //   ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  Future<void> driverSubmitRating({
    required String userId,
    required String tripId,
    required dynamic rating,
    required bool isTrip,
  }) async {
    try {
      isLoading(true);

      if (rating.value <= 0) {
        showCustomSnackBar("Please give a rating first", isError: true);
        return;
      }

      final Map<String, dynamic> body = isTrip
          ? {
              "user_id": userId,
              "rating": rating.value.toInt(),
              "comment": "Good",
              "ref_trip_id": tripId,
            }
          : {
              "user_id": userId,
              "rating": rating.value.toInt(),
              "comment": "Good",
              "ref_parcel_id": tripId,
            };

      final response = await ApiClient.postData("/reviews/give-review", body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        clear();
        Get.back();
        Get.back();
        Get.back();
      } else {
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint("Review Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
