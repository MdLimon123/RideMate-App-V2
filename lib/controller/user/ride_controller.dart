import 'package:flutter_extension/data/api/api_checker.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/model/user/user_trip_model.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/screen/user/home/trip/accepted_trip_for_driver.dart';
import 'package:flutter_extension/views/screen/user/home/trip/finding_driver.dart';
import 'package:flutter_extension/views/screen/user/home/trip/pay_for_trip_screen.dart';
import 'package:flutter_extension/views/screen/user/home/user_home.dart';
import 'package:get/get.dart';

class RideController extends GetxController {
  var activeStatus = ActiveStatus.NONE.obs;
  var tripStatus = TripStatus.idle.obs;
  var parcelStatus = ParcelStatus.idle.obs;
  TripResponseModel? tripResponse;

  var isLoading = false.obs;

  void setTripStatus(TripResponseModel tripResponseModel) {
    activeStatus.value = tripResponseModel.kind!;
    tripStatus.value = tripResponseModel.data!.status;
    tripResponse = tripResponseModel;
    tripFlow(tripStatus.value);
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
        Get.offAll(() => const FindingDriver());
        break;
      case TripStatus.ACCEPTED:
        Get.offAll(() => const AcceptedTripForDriver());
        break;
      case TripStatus.STARTED:
        Get.offAll(() => const AcceptedTripForDriver());
        break;
      case TripStatus.ARRIVED:
        Get.offAll(() => const PayForTripScreen());
        break;
      default:
        Get.offAll(() => const UserHome());
    }
  }

  parcelFlow(ParcelStatus parcelStatus) {
    switch (parcelStatus) {
      case ParcelStatus.REQUESTED:
        break;
      case ParcelStatus.ACCEPTED:
        break;
      case ParcelStatus.STARTED:
        break;
      case ParcelStatus.DELIVERED:
        break;
      case ParcelStatus.COMPLETED:
        break;
      case ParcelStatus.CANCELLED:
        break;
      case ParcelStatus.idle:
        throw UnimplementedError();
    }
  }

  /// ================= REQUEST TRIP =================

  requestTrip(Map<String, dynamic> body) async {
    isLoading(true);
    var response = await ApiClient.postData(ApiConstant.requestTripUrl, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setTripStatus(TripResponseModel.fromJson(response.body));
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
  }

  payForTrip() async {
    isLoading(true);
    var response = await ApiClient.postData(ApiConstant.payForTrip, {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      setTripStatus(TripResponseModel.fromJson(response.body));
    } else {
      isLoading(false);
      ApiChecker.checkApi(response);
    }
  }
}
