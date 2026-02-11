class DriverInfoModel {
  final String accessToken;
  final String refreshToken;
  final DriverModel driver;

  DriverInfoModel({
    required this.accessToken,
    required this.refreshToken,
    required this.driver,
  });

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverInfoModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      driver: DriverModel.fromJson(json['user'] ?? {}),
    );
  }
}

class DriverModel {
  final String id;
  final String role;
  final String email;
  final String? phone;

  final bool isVerified;
  final bool isActive;
  final bool isAdmin;
  final bool isVerificationPending;

  final String? oneSignalId;

  final String avatar;
  final String name;
  final DateTime dateOfBirth;
  final String gender;

  final List<String> drivingLicensePhotos;

  final String vehicleType;
  final String vehicleBrand;
  final String vehicleModel;
  final String vehiclePlateNumber;

  final List<String> vehicleRegistrationPhotos;
  final List<String> vehiclePhotos;

  final int tripGivenCount;
  final bool isStripeConnected;

  final double rating;
  final int ratingCount;

  final double? locationLat;
  final double? locationLng;
  final String? locationAddress;

  final DateTime createdAt;
  final DateTime updatedAt;

  DriverModel({
    required this.id,
    required this.role,
    required this.email,
    this.phone,
    required this.isVerified,
    required this.isActive,
    required this.isAdmin,
    required this.isVerificationPending,
    this.oneSignalId,
    required this.avatar,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.drivingLicensePhotos,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehiclePlateNumber,
    required this.vehicleRegistrationPhotos,
    required this.vehiclePhotos,
    required this.tripGivenCount,
    required this.isStripeConnected,
    required this.rating,
    required this.ratingCount,
    this.locationLat,
    this.locationLng,
    this.locationAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      isAdmin: json['is_admin'] ?? false,
      isVerificationPending: json['is_verification_pending'] ?? false,
      oneSignalId: json['onesignal_id'],
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      gender: json['gender'] ?? '',
      drivingLicensePhotos:
          List<String>.from(json['driving_license_photos'] ?? []),
      vehicleType: json['vehicle_type'] ?? '',
      vehicleBrand: json['vehicle_brand'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',
      vehiclePlateNumber: json['vehicle_plate_number'] ?? '',
      vehicleRegistrationPhotos:
          List<String>.from(json['vehicle_registration_photos'] ?? []),
      vehiclePhotos: List<String>.from(json['vehicle_photos'] ?? []),
      tripGivenCount: json['trip_given_count'] ?? 0,
      isStripeConnected: json['is_stripe_connected'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      locationLat: json['location_lat']?.toDouble(),
      locationLng: json['location_lng']?.toDouble(),
      locationAddress: json['location_address'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
