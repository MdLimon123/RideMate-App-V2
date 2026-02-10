import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_extension/views/screen/driver/home/finding_request.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/accepted_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/requested_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/started_trip.dart';
import 'package:get/get.dart';

enum ActiveStatus { NONE, TRIP, PARCEL }

enum TripStatus { REQUESTED, ACCEPTED, ARRIVED, STARTED, COMPLETED }

enum ParcelStatus { REQUESTED, ACCEPTED, ARRIVED, STARTED, COMPLETED }

class DriverHomeController extends GetxController {
  var activeStatus = ActiveStatus.TRIP.obs;
  var tripStatus = TripStatus.REQUESTED.obs;
  var parcelStatus = ParcelStatus.REQUESTED.obs;

  void setActiveStatus(ActiveStatus status) {
    activeStatus.value = status;
    update();
  }

  void setTripStatus(TripStatus status) {
    tripStatus.value = status;
    update();
  }

  void setParcelStatus(ParcelStatus status) {
    parcelStatus.value = status;
    update();
  }

  clear() {
    activeStatus.value = ActiveStatus.NONE;
    tripStatus.value = TripStatus.REQUESTED;
    parcelStatus.value = ParcelStatus.REQUESTED;
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
        break;
      case TripStatus.COMPLETED:
        return const CustomLoading();
      //go to completed screen
      //
    }
  }

  parcelFlow() {
    switch (parcelStatus.value) {
      case ParcelStatus.REQUESTED:
        //go to accepted screen
        break;
      case ParcelStatus.ACCEPTED:
        //go to arrived screen
        break;
      case ParcelStatus.STARTED:
        //go to completed screen
        break;
      case ParcelStatus.ARRIVED:
        //go to started screen
        break;

      case ParcelStatus.COMPLETED:

      //go to completed screen
    }
  }
}
