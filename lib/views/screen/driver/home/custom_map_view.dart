

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_extension/controller/driver/home_controller.dart';

class CustomMapView extends StatefulWidget {
  final double height;
  final double zoom;
  final bool showMyLocation;
  final bool showMyLocationButton;
  final bool gesturesEnabled;

  const CustomMapView({
    super.key,
    this.height = 300,
    this.zoom = 15,
    this.showMyLocation = true,
    this.showMyLocationButton = false,
    this.gesturesEnabled = false,
  });

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> {
  final _homeController = Get.find<DriverHomeController>();
  GoogleMapController? _mapController;

  LatLng? _lastPosition;

  @override
  void initState() {
    super.initState();

    // Listen to position changes
    ever(_homeController.currentPosition, (LatLng? position) {
      if (position != null &&
          _mapController != null &&
          position != _lastPosition) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(position));
        _lastPosition = position;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition =
        _homeController.currentPosition.value ?? const LatLng(23.8103, 90.4125);

    return SizedBox(
      height: widget.height,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: widget.zoom,
        ),
        scrollGesturesEnabled: widget.gesturesEnabled,
        zoomGesturesEnabled: widget.gesturesEnabled,
        rotateGesturesEnabled: widget.gesturesEnabled,
        tiltGesturesEnabled: widget.gesturesEnabled,
        myLocationEnabled: widget.showMyLocation,
        myLocationButtonEnabled: widget.showMyLocationButton,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
