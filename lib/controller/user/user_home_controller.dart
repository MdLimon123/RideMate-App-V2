import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
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
}
