class UserProfileModel {
  String? id;
  String? role;
  String? email;
  String? phone;
  bool? isVerified;
  bool? isActive;
  bool? isAdmin;
  bool? isVerificationPending;
  String? oneSignalId;
  String? avatar;
  String? name;
  DateTime? dateOfBirth;
  String? gender;
  int? tripReceivedCount;
  bool? isStripeConnected;
  double? rating;
  int? ratingCount;
  double? locationLat;
  double? locationLng;
  String? locationAddress;
  WalletModel? wallet;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserProfileModel({
    this.id,
    this.role,
    this.email,
    this.phone,
    this.isVerified,
    this.isActive,
    this.isAdmin,
    this.isVerificationPending,
    this.oneSignalId,
    this.avatar,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.tripReceivedCount,
    this.isStripeConnected,
    this.rating,
    this.ratingCount,
    this.locationLat,
    this.locationLng,
    this.locationAddress,
    this.wallet,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return null;
      }
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return UserProfileModel(
      id: json['id'],
      role: json['role'],
      email: json['email'],
      phone: json['phone'],
      isVerified: json['is_verified'],
      isActive: json['is_active'],
      isAdmin: json['is_admin'],
      isVerificationPending: json['is_verification_pending'],
      oneSignalId: json['onesignal_id'],
      avatar: json['avatar'],
      name: json['name'],
      dateOfBirth: parseDate(json['date_of_birth']),
      gender: json['gender'],
      tripReceivedCount: parseInt(json['trip_received_count']),
      isStripeConnected: json['is_stripe_connected'],
      rating: parseDouble(json['rating']),
      ratingCount: parseInt(json['rating_count']),
      locationLat: parseDouble(json['location_lat']),
      locationLng: parseDouble(json['location_lng']),
      locationAddress: json['location_address'],
      wallet: json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "role": role,
      "email": email,
      "phone": phone,
      "is_verified": isVerified,
      "is_active": isActive,
      "is_admin": isAdmin,
      "is_verification_pending": isVerificationPending,
      "onesignal_id": oneSignalId,
      "avatar": avatar,
      "name": name,
      "date_of_birth": dateOfBirth?.toIso8601String(),
      "gender": gender,
      "trip_received_count": tripReceivedCount,
      "is_stripe_connected": isStripeConnected,
      "rating": rating,
      "rating_count": ratingCount,
      "location_lat": locationLat,
      "location_lng": locationLng,
      "location_address": locationAddress,
      "wallet": wallet?.toJson(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}

class WalletModel {
  double? balance;
  double? totalExpend;
  double? totalIncome;

  WalletModel({this.balance, this.totalExpend, this.totalIncome});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value);
      return null;
    }

    return WalletModel(
      balance: parseDouble(json['balance']),
      totalExpend: parseDouble(json['total_expend']),
      totalIncome: parseDouble(json['total_income']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "balance": balance,
      "total_expend": totalExpend,
      "total_income": totalIncome,
    };
  }
}
