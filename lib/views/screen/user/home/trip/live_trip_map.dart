import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LiveTripMap extends StatefulWidget {
  const LiveTripMap({super.key});

  @override
  State<LiveTripMap> createState() => _LiveTripMapState();
}

class _LiveTripMapState extends State<LiveTripMap> {

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final RideController _rideController = Get.find<RideController>();
  final _driverRideController = Get.put(DriverRideController());
  late LatLng _driverLatLng;

 
  final Completer<GoogleMapController> _mapController = Completer();



  @override
  void initState() {
    _driverLatLng = LatLng(
      _rideController.tripResponse.value.data!.driver!.locationLat!,
      _rideController.tripResponse.value.data!.driver!.locationLng!,
    );

    _setupMarkers();
    _drawPickupToDestination();
    _listenDriverLocation();

    if (_rideController.tripResponse.value.data!.status != TripStatus.STARTED) {
      _drawDriverToPickup();
    }
    handleTripStart();
    super.initState();
  }

  /// ================= MARKERS =================
  void _setupMarkers() {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: _driverLatLng!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          _rideController.tripResponse.value.data!.pickupLat,
          _rideController.tripResponse.value.data!.pickupLng,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          _rideController.tripResponse.value.data!.dropoffLat,
          _rideController.tripResponse.value.data!.dropoffLng,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  // /// ================= SOCKET =================
  void _listenDriverLocation() async {
    _driverRideController.listenDriverLocation(
      id: _rideController.tripResponse.value.data!.driver!.id,
      onLocationUpdate: (newLatLng) async {
        setState(() {
          _driverLatLng = newLatLng;
          // 🔴 ONLY update driver marker
          _markers.removeWhere((m) => m.markerId.value == 'driver');

          _markers.add(
            Marker(
              markerId: const MarkerId('driver'),
              position: _driverLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
          );
        });

        if (!_driverRideController.isTripStarted.value) {
          await _drawDriverToPickup();
        }
      },
    );


  }

  void handleTripStart() async {
    _driverRideController.isLoading(true);

    await _driverRideController.startTrip();

    _driverRideController.isLoading(false);

    // Update UI if trip started
    if (_driverRideController.isTripStarted.value) {
      setState(() {
        print(
          "====== TRIP STARTED ${_driverRideController.isTripStarted.value}",
        );

        _polylines.removeWhere((p) => p.polylineId.value == 'driver_to_pickup');
      });
    }
  }



  // /// ================= ROUTE =================

  Future<RouteData?> _fetchRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$startLat,$startLng&'
        'destination=$endLat,$endLng&'
        'key=${ApiConstant.googleApiKey}';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['routes'].isEmpty) return null;

    final route = data['routes'][0];
    final leg = route['legs'][0];

    final encoded = route['overview_polyline']['points'];
    final decoded = PolylinePoints.decodePolyline(encoded);

    return RouteData(
      points: decoded.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      duration: leg['duration']['text'],
      distance: leg['distance']['text'],
    );
  }

  /// ================= POLYLINES =================
  Future<void> _drawDriverToPickup() async {
    if (_driverRideController.isTripStarted.value) return;

    // 🔴 REMOVE FIRST
    _polylines.removeWhere((p) => p.polylineId.value == 'driver_to_pickup');

    final route = await _fetchRoute(
      _driverLatLng.latitude,
      _driverLatLng.longitude,
      _rideController.tripResponse.value.data!.pickupLat,
      _rideController.tripResponse.value.data!.pickupLng,
    );

    // 🔴 CHECK AGAIN AFTER AWAIT
    if (route == null || _driverRideController.isTripStarted.value) return;

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('driver_to_pickup'),
        points: route.points,
        color: Colors.blue,
        width: 5,
      ),
    );

    setState(() {});
  }

  // /// ================= POLYLINES =================

  Future<void> _drawPickupToDestination() async {
    final route = await _fetchRoute(
      _rideController.tripResponse.value.data!.pickupLat,
      _rideController.tripResponse.value.data!.pickupLng,
      _rideController.tripResponse.value.data!.dropoffLat,
      _rideController.tripResponse.value.data!.dropoffLng,
    );

    if (route == null) return;

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('pickup_to_destination'),
        points: route.points,
        color: Colors.red,
        width: 5,
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {

    super.dispose();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.8103, 90.4125),

              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 10,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: Get.back,
              ),
            ),
          ),

          // Positioned(
          //   bottom: 30, left: 20, right: 20,
          //   child: CustomButton(onTap: (){}
          //   , text: "Trip End"),
          // ),
        ],
      ),
    );
  }
}

class RouteData {
  final List<LatLng> points;
  final String duration;
  final String distance;

  RouteData({
    required this.points,
    required this.duration,
    required this.distance,
  });
}
