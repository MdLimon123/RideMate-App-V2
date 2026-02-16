import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';

import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/data/model/driver/home_model.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeController extends GetxController {
  var isLoading = false.obs;
  var homeModel = HomeModel().obs;

  final RxBool isLocationEnabled = false.obs;
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxString statusMessage = 'Location disabled'.obs;
  StreamSubscription<Position>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();
    debugPrint('📍 LocationController INITIALIZED (Permanent Service)');
    _requestLocationPermission();
    fetchHomeData();
  }

  @override
  void onClose() {
    debugPrint('📍 LocationController CLOSED');
    super.onClose();
  }

  Future<void> fetchHomeData() async {
    isLoading(true);
    final response = await ApiClient.getData("/drivers");

    if (response.statusCode == 200 || response.statusCode == 201) {
      homeModel.value = HomeModel.fromJson(response.body);
    } else {
      debugPrint("soemthing we want wrong ======> ${response.statusText}");
    }
    isLoading(false);
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
        updateActiveStatus(value);
        _startLocationUpdates();
      }
    } else {
      updateActiveStatus(value);
      _stopLocationUpdates();
    }
  }

  updateActiveStatus(bool value) {
    print("======> action : toggle : $value");
    SocketService().emit(
      "driver:toggle_online",
      data: {"online": value},
      ack: (response) {
        print("====>res: $response");
      },
    );
    // SocketService().socket?.emit("driver:toggle_online", {"online": value});
  }

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
    SocketService().socket?.emitWithAck(
      "driver:update_location",
      body,
      ack: (response) {
        debugPrint('Driver location updated: $response');
      },
    );
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
