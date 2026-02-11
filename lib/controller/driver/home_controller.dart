import 'package:flutter_extension/views/screen/driver/home/parcel/accepted_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/requested_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/started_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/payment_orver_view.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/accepted_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/requested_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/started_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/waiting_for_payment.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../util/app_constants.dart';


class DriverHomeController extends GetxController {
  var activeStatus = ActiveStatus.NONE.obs;
  var tripStatus = TripStatus.REQUESTED.obs;
  var parcelStatus = ParcelStatus.ACCEPTED.obs;

  var currentLatLng = Rxn<LatLng>();
  GoogleMapController? mapController;

  @override
  void onInit() {
    getCurrentLocation();
    super.onInit();
  }

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
        return const WaitingForPayment();

      case TripStatus.COMPLETED:
        return const PaymentOrverView();
      //go to completed screen
      //
      case TripStatus.idle:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TripStatus.CANCELLED:
        // TODO: Handle this case.
        throw UnimplementedError();
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
      case ParcelStatus.idle:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ParcelStatus.CANCELLED:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLatLng.value = LatLng(position.latitude, position.longitude);

    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLatLng.value!),
      );
    }
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;

    if (currentLatLng.value != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLatLng.value!),
      );
    }
  }
}
