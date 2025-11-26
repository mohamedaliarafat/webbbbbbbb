import 'location_model.dart';

class UserModel {
  final String id;
  final String userType;
  final String phone;
  final String password;
  final bool isVerified;
  final String profileImage;
  final String name;
  final LocationModel? location;
  final List<String> addresses;
  final List<String> orders;
  final String? addedBy;
  final bool isActive;
  final DateTime? lastLogin;
  final String fcmToken;
  final String? completeProfile;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.userType,
    required this.phone,
    required this.password,
    required this.isVerified,
    required this.profileImage,
    required this.name,
    this.location,
    required this.addresses,
    required this.orders,
    this.addedBy,
    required this.isActive,
    this.lastLogin,
    required this.fcmToken,
    this.completeProfile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      userType: json['userType']?.toString() ?? 'customer',
      phone: json['phone']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      isVerified: json['isVerified'] ?? false,
      profileImage: json['profileImage']?.toString() ?? 'https://c.top4top.io/p_3613ezehd1.png',
      name: json['name']?.toString() ?? '',
      location: json['location'] != null ? LocationModel.fromJson(json['location']) : null,
      addresses: json['addresses'] != null
          ? List<String>.from(json['addresses'].map((x) => x.toString()))
          : [],
      orders: json['orders'] != null
          ? List<String>.from(json['orders'].map((x) => x.toString()))
          : [],
      addedBy: json['addedBy']?.toString(),
      isActive: json['isActive'] ?? true,
      lastLogin: json['lastLogin'] != null ? DateTime.tryParse(json['lastLogin']) : null,
      fcmToken: json['fcmToken']?.toString() ?? '',
      completeProfile: json['completeProfile']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userType': userType,
      'phone': phone,
      'password': password,
      'isVerified': isVerified,
      'profileImage': profileImage,
      'name': name,
      'location': location?.toJson(),
      'addresses': addresses,
      'orders': orders,
      'addedBy': addedBy,
      'isActive': isActive,
      'lastLogin': lastLogin?.toIso8601String(),
      'fcmToken': fcmToken,
      'completeProfile': completeProfile,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? userType,
    String? phone,
    String? password,
    bool? isVerified,
    String? profileImage,
    String? name,
    LocationModel? location,
    List<String>? addresses,
    List<String>? orders,
    String? addedBy,
    bool? isActive,
    DateTime? lastLogin,
    String? fcmToken,
    String? completeProfile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified,
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      location: location ?? this.location,
      addresses: addresses ?? this.addresses,
      orders: orders ?? this.orders,
      addedBy: addedBy ?? this.addedBy,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      fcmToken: fcmToken ?? this.fcmToken,
      completeProfile: completeProfile ?? this.completeProfile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
