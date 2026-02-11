import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/accepted_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/requested_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/parcel/started_parcel.dart';
import 'package:flutter_extension/views/screen/driver/home/payment_orver_view.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/accepted_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/requested_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/started_trip.dart';
import 'package:flutter_extension/views/screen/driver/home/trip/waiting_for_payment.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../util/app_constants.dart';

class DriverHomeController extends GetxController {
  // var currentLatLng = Rxn<LatLng>();
  // GoogleMapController? mapController;

  // @override
  // void onInit() {
  //   getCurrentLocation();
  //   super.onInit();
  // }

  // Future<void> getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Get.snackbar('Error', 'Location services are disabled.');
  //     return;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) return;
  //   }

  //   if (permission == LocationPermission.deniedForever) return;

  //   final position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   currentLatLng.value = LatLng(position.latitude, position.longitude);

  //   if (mapController != null) {
  //     mapController!.animateCamera(
  //       CameraUpdate.newLatLng(currentLatLng.value!),
  //     );
  //   }
  // }

  // void setMapController(GoogleMapController controller) {
  //   mapController = controller;

  //   if (currentLatLng.value != null) {
  //     mapController!.animateCamera(
  //       CameraUpdate.newLatLng(currentLatLng.value!),
  //     );
  //   }
  // }
  // Public reactive variables (any screen can listen)
  final RxBool isLocationEnabled = false.obs;
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxString statusMessage = 'Location disabled'.obs;
  StreamSubscription<Position>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();
    debugPrint('📍 LocationController INITIALIZED (Permanent Service)');
    _requestLocationPermission();
  }

  @override
  void onClose() {
    // ⚠️ Get.offAll() করলেও এটা কল হবে না কারণ permanent: true
    // তাই manual cleanup দরকার নেই (service চালু রাখতে চাইলে)
    debugPrint('📍 LocationController CLOSED');
    super.onClose();
  }

  // Permission request
  Future<void> _requestLocationPermission() async {
    try {
      final status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied) {
        statusMessage.value = 'Permission denied';
      } else if (status == LocationPermission.whileInUse ||
          status == LocationPermission.always) {
        statusMessage.value = 'Permission granted';
        if (isLocationEnabled.value) {
          _startLocationUpdates();
        }
      }
    } catch (e) {
      statusMessage.value = 'Error: $e';
    }
  }

  // Toggle location ON/OFF globally
  void toggleLocation(bool value) async {
    isLocationEnabled.value = value;

    if (value) {
      final status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        await _requestLocationPermission();
      } else {
        _startLocationUpdates();
      }
    } else {
      _stopLocationUpdates();
    }
  }

  updateActiveSatus() {}

  // Start location stream (global tracking)
  void _startLocationUpdates() {
    if (_locationSubscription != null) return;
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );

    _locationSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) async {
            currentPosition.value = LatLng(
              position.latitude,
              position.longitude,
            );
            statusMessage.value =
                'Updated: ${DateTime.now().toLocal().toIso8601String().split('.')[0]}';

            String address = await getOptimizedAddress(
              position.latitude,
              position.longitude,
            );

            var body = {
              "location_lat": position.latitude,
              "location_lng": position.longitude,
              "location_address": address,
            };
            updateDriverLocation(body);
            debugPrint(
              '📍 New location: ${position.latitude}, ${position.longitude}',
            );
          },
          onError: (error) {
            statusMessage.value = 'Location error: $error';
            debugPrint('📍 Location stream error: $error');
          },
        );
  }

  String? _lastAddress;
  DateTime? _lastAddressTime;

  Future<String> getOptimizedAddress(double lat, double lng) async {
    if (_lastAddressTime != null &&
        DateTime.now().difference(_lastAddressTime!).inMinutes < 2) {
      return _lastAddress!;
    }

    final placemarks = await placemarkFromCoordinates(lat, lng);
    _lastAddress = placemarks.first.locality ?? 'Unknown';
    _lastAddressTime = DateTime.now();
    return _lastAddress!;
  }

  updateDriverLocation(Map<String, dynamic> body) async {
    var response = await ApiClient.postData(
      ApiConstant.updateDriverLocation,
      body,
    );
    if (response.statusCode == 200) {
      print("Update location in driver");
    }
  }

  // Stop location stream
  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    debugPrint('📍 Location tracking STOPPED globally');
  }

  // Manual refresh current location
  Future<void> refreshLocation() async {
    if (!isLocationEnabled.value) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      statusMessage.value = 'Refresh failed: $e';
    }
  }

  // Cleanup when app closes (optional but recommended)
  void disposeService() {
    _stopLocationUpdates();
    debugPrint('📍 LocationController FULLY DISPOSED');
  }
}
