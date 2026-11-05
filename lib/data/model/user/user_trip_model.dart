import 'package:flutter_extension/util/app_constants.dart';

class TripResponseModel {
  final ActiveStatus? kind;
  final TripModel? data;

  TripResponseModel({this.kind, this.data});

  factory TripResponseModel.fromJson(Map<String, dynamic> json) {
    return TripResponseModel(
      kind: ActiveStatus.values.firstWhere((e) => e.name == json['kind']),
      data: TripModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'kind': kind, 'data': data?.toJson()};
  }
}

class TripModel {
  final String id;
  final String slug;
  final DateTime? requestedAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? arrivedAt;
  final DateTime? paymentAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? time;
  final String date;
  final String userId;
  final String? driverId;

  final String pickupType;
  final double pickupLat;
  final double pickupLng;
  final String pickupAddress;

  final String dropoffType;
  final double dropoffLat;
  final double dropoffLng;
  final String dropoffAddress;

  final String locationType;
  final double? locationLat;
  final double? locationLng;
  final String? locationAddress;

  final TripStatus status;
  final double totalCost;
  final double driverEarning;
  final double adminEarning;

  final String? processingDriverId;
  final DateTime? processingAt;
  final bool isProcessing;

  final UserModel user;
  final DriverModel? driver;

  TripModel({
    required this.id,
    required this.slug,
    this.requestedAt,
    this.acceptedAt,
    this.startedAt,
    this.arrivedAt,
    this.paymentAt,
    this.completedAt,
    this.cancelledAt,
    this.time,
    required this.date,
    required this.userId,
    this.driverId,
    required this.pickupType,
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupAddress,
    required this.dropoffType,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.dropoffAddress,
    required this.locationType,
    this.locationLat,
    this.locationLng,
    this.locationAddress,
    required this.status,
    required this.totalCost,
    required this.driverEarning,
    required this.adminEarning,
    this.processingDriverId,
    this.processingAt,
    required this.isProcessing,
    required this.user,
    this.driver,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      requestedAt: json['requested_at'] != null
          ? DateTime.parse(json['requested_at'])
          : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      arrivedAt: json['arrived_at'] != null
          ? DateTime.parse(json['arrived_at'])
          : null,
      paymentAt: json['payment_at'] != null
          ? DateTime.parse(json['payment_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : null,
      time: json['time'].toString(),
      date: json['date'] ?? '',
      userId: json['user_id'] ?? '',
      driverId: json['driver_id'],
      pickupType: json['pickup_type'] ?? '',
      pickupLat: (json['pickup_lat'] ?? 0).toDouble(),
      pickupLng: (json['pickup_lng'] ?? 0).toDouble(),
      pickupAddress: json['pickup_address'] ?? '',
      dropoffType: json['dropoff_type'] ?? '',
      dropoffLat: (json['dropoff_lat'] ?? 0).toDouble(),
      dropoffLng: (json['dropoff_lng'] ?? 0).toDouble(),
      dropoffAddress: json['dropoff_address'] ?? '',
      locationType: json['location_type'] ?? '',
      locationLat: json['location_lat']?.toDouble(),
      locationLng: json['location_lng']?.toDouble(),
      locationAddress: json['location_address'],
      status: TripStatus.values.firstWhere((e) => e.name == json['status']),
      totalCost: (json['total_cost'] ?? 0).toDouble(),
      processingDriverId: json['processing_driver_id'],
      driverEarning: (json['driver_earning'] ?? 0).toDouble(),
      adminEarning: (json['admin_earning'] ?? 0).toDouble(),
      processingAt: json['processing_at'] != null
          ? DateTime.parse(json['processing_at'])
          : null,
      isProcessing: json['is_processing'] ?? false,
      user: UserModel.fromJson(json['user']),
      driver: json['driver'] != null
          ? DriverModel.fromJson(json['driver'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'requested_at': requestedAt?.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'arrived_at': arrivedAt?.toIso8601String(),
      'payment_at': paymentAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'time': time,
      'date': date,
      'user_id': userId,
      'driver_id': driverId,
      'pickup_type': pickupType,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'pickup_address': pickupAddress,
      'dropoff_type': dropoffType,
      'dropoff_lat': dropoffLat,
      'dropoff_lng': dropoffLng,
      'dropoff_address': dropoffAddress,
      'location_type': locationType,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'location_address': locationAddress,
      'status': status,
      'total_cost': totalCost,
      'processing_driver_id': processingDriverId,
      'processing_at': processingAt?.toIso8601String(),
      'is_processing': isProcessing,
      'user': user.toJson(),
      'driver': driver?.toJson(),
    };
  }
}

class UserModel {
  final String id;
  final String role;
  final String? oneSignalId;
  final String? avatar;
  final String name;
  final String? gender;
  final int tripReceivedCount;
  final bool isStripeConnected;
  final double rating;
  final int ratingCount;
  final double? locationLat;
  final double? locationLng;

  UserModel({
    required this.id,
    required this.role,
    this.oneSignalId,
    this.avatar,
    required this.name,
    this.gender,
    required this.tripReceivedCount,
    required this.isStripeConnected,
    required this.rating,
    required this.ratingCount,
    this.locationLat,
    this.locationLng,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      oneSignalId: json['onesignal_id'],
      avatar: json['avatar'],
      name: json['name'] ?? '',
      gender: json['gender'],
      tripReceivedCount: json['trip_received_count'] ?? 0,
      isStripeConnected: json['is_stripe_connected'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      locationLat: json['location_lat']?.toDouble(),
      locationLng: json['location_lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'onesignal_id': oneSignalId,
      'avatar': avatar,
      'name': name,
      'gender': gender,
      'trip_received_count': tripReceivedCount,
      'is_stripe_connected': isStripeConnected,
      'rating': rating,
      'rating_count': ratingCount,
      'location_lat': locationLat,
      'location_lng': locationLng,
    };
  }
}

class DriverModel {
  final String id;
  final String role;
  final String? oneSignalId;
  final String? avatar;
  final String name;
  final String? gender;

  final List<dynamic>? drivingLicensePhotos;
  final String? vehicleType;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehiclePlateNumber;
  final List<dynamic>? vehicleRegistrationPhotos;
  final List<dynamic>? vehiclePhotos;

  final int tripGivenCount;
  final bool isStripeConnected;
  final double rating;
  final int ratingCount;
  final double? locationLat;
  final double? locationLng;

  DriverModel({
    required this.id,
    required this.role,
    this.oneSignalId,
    this.avatar,
    required this.name,
    this.gender,
    this.drivingLicensePhotos,
    this.vehicleType,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehiclePlateNumber,
    this.vehicleRegistrationPhotos,
    this.vehiclePhotos,
    required this.tripGivenCount,
    required this.isStripeConnected,
    required this.rating,
    required this.ratingCount,
    this.locationLat,
    this.locationLng,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      oneSignalId: json['onesignal_id'],
      avatar: json['avatar'],
      name: json['name'] ?? '',
      gender: json['gender'],
      drivingLicensePhotos: json['driving_license_photos'],
      vehicleType: json['vehicle_type'],
      vehicleBrand: json['vehicle_brand'],
      vehicleModel: json['vehicle_model'],
      vehiclePlateNumber: json['vehicle_plate_number'],
      vehicleRegistrationPhotos: json['vehicle_registration_photos'],
      vehiclePhotos: json['vehicle_photos'],
      tripGivenCount: json['trip_given_count'] ?? 0,
      isStripeConnected: json['is_stripe_connected'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      locationLat: json['location_lat']?.toDouble(),
      locationLng: json['location_lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'onesignal_id': oneSignalId,
      'avatar': avatar,
      'name': name,
      'gender': gender,
      'driving_license_photos': drivingLicensePhotos,
      'vehicle_type': vehicleType,
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'vehicle_plate_number': vehiclePlateNumber,
      'vehicle_registration_photos': vehicleRegistrationPhotos,
      'vehicle_photos': vehiclePhotos,
      'trip_given_count': tripGivenCount,
      'is_stripe_connected': isStripeConnected,
      'rating': rating,
      'rating_count': ratingCount,
      'location_lat': locationLat,
      'location_lng': locationLng,
    };
  }
}
