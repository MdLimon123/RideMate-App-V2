import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/user/home/trip/show_trip_amount_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

enum LocationField { pick, drop, none }

class UserHomeController extends GetxController {
  var selectedIndex = 0.obs;

  RxList<String> parcelType = ["SMALL", "MEDIUM", "LARGE"].obs;

  var isShowAnountLoading = false.obs;

  RxString selectedParcelType = "".obs;

  var currentLatLng = Rxn<LatLng>();
  GoogleMapController? mapController;

  var activeField = LocationField.none.obs;

  final pickController = TextEditingController();
  final dropController = TextEditingController();

  var pickCoordinates = <double>[].obs;
  var dropCoordinates = <double>[].obs;

  var pickAddress = ''.obs;
  var dropAddress = ''.obs;

  var isLoading = false.obs;
  var suggestions = <String>[].obs;

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> selectPick(String location) async {
    pickController.text = location;
    pickAddress.value = location;
    suggestions.clear();
    activeField.value = LocationField.none;
    pickCoordinates.value = await _fetchLatLng(location);
  }

  Future<void> selectDrop(String location) async {
    dropController.text = location;
    dropAddress.value = location;
    suggestions.clear();
    activeField.value = LocationField.none;
    final coords = await _fetchLatLng(location);
    if (coords.length < 2) return;

    dropCoordinates.value = coords;

    // saveRecentDestination(
    //   RecentDestination(address: location, lat: coords[0], lng: coords[1]),
    // );
  }

  Future<void> getCurrentLocation({bool setToTextField = false}) async {
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

    if (setToTextField) {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        pickController.text =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
      }
    }
  }

  Future<List<double>> _fetchLatLng(String place) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstant.findPlaceApiUrl}?input=$place&inputtype=textquery&fields=geometry&key=${ApiConstant.googleApiKey}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final loc = data['candidates'][0]['geometry']['location'];
      return [loc['lat'], loc['lng']];
    }
    return [];
  }

  Future<void> fetchSuggestions(String input, LocationField field) async {
    activeField.value = field;

    if (input.isEmpty) {
      suggestions.clear();
      return;
    }

    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstant.googleBaseUrl}?input=$input&key=${ApiConstant.googleApiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        suggestions.value = (data['predictions'] as List)
            .map((e) => e['description'] as String)
            .toList();
      } else {
        suggestions.clear();
      }
    } catch (e) {
      suggestions.clear();
    } finally {
      isLoading(false);
    }
  }

  Future<void> calculateAccount() async {
    if (pickCoordinates.length < 2 || dropCoordinates.length < 2) {
      showCustomSnackBar(
        "Please select pickup and drop location",
        isError: true,
      );
      return;
    }

    isShowAnountLoading(true);

    final body = {
      "pickup_lat": pickCoordinates[0],
      "pickup_lng": pickCoordinates[1],
      "dropoff_lat": dropCoordinates[0],
      "dropoff_lng": dropCoordinates[1],
      "pickup_address": pickAddress.value,
      "dropoff_address": dropAddress.value,
    };

    final response = await ApiClient.postData("/trips/estimate-fare", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      Get.to(
        () => ShowTripAmountScreen(
          showAmount: response.body['estimated_fare'].toDouble(),
          pickLat: pickCoordinates[0],
          pickLng: pickCoordinates[1],
          dropLat: dropCoordinates[0],
          dropLan: dropCoordinates[1],
          pickLocation: pickAddress.value,
          dropLocation: dropAddress.value,
        ),
      );
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isShowAnountLoading(false);
  }
}
