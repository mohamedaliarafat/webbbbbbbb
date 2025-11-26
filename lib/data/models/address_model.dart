import 'location_model.dart';

class AddressModel {
  final String id;
  final String userId;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String district;
  final String state;
  final String country;
  final String postalCode;
  final String addressType;
  final String contactName;
  final String contactPhone;
  final LocationModel coordinates;
  final String deliveryInstructions;
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.district,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.addressType,
    required this.contactName,
    required this.contactPhone,
    required this.coordinates,
    required this.deliveryInstructions,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ إضافة constructor createNew فقط
  factory AddressModel.createNew({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String district,
    required String state,
    required String country,
    required String postalCode,
    required String addressType,
    required String contactName,
    required String contactPhone,
    required LocationModel coordinates,
    required String deliveryInstructions,
    required bool isDefault,
  }) {
    return AddressModel(
      id: '',
      userId: '',
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      district: district,
      state: state,
      country: country,
      postalCode: postalCode,
      addressType: addressType,
      contactName: contactName,
      contactPhone: contactPhone,
      coordinates: coordinates,
      deliveryInstructions: deliveryInstructions,
      isDefault: isDefault,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? '',
      userId: json['userId']?.toString() ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? 'Saudi Arabia',
      postalCode: json['postalCode'] ?? '',
      addressType: json['addressType'] ?? 'home',
      contactName: json['contactName'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      coordinates: LocationModel.fromJson(json['coordinates'] ?? {}),
      deliveryInstructions: json['deliveryInstructions'] ?? '',
      isDefault: json['isDefault'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      if (userId.isNotEmpty) 'userId': userId,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'district': district,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'addressType': addressType,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'coordinates': coordinates.toJson(),
      'deliveryInstructions': deliveryInstructions,
      'isDefault': isDefault,
      'isActive': isActive,
      if (id.isNotEmpty) 'createdAt': createdAt.toIso8601String(),
      if (id.isNotEmpty) 'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ✅ إضافة دالة toMap لحل المشكلة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'district': district,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'addressType': addressType,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'coordinates': coordinates.toMap(),
      'deliveryInstructions': deliveryInstructions,
      'isDefault': isDefault,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? district,
    String? state,
    String? country,
    String? postalCode,
    String? addressType,
    String? contactName,
    String? contactPhone,
    LocationModel? coordinates,
    String? deliveryInstructions,
    bool? isDefault,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      addressType: addressType ?? this.addressType,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      coordinates: coordinates ?? this.coordinates,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ✅ إضافة method للتحويل إلى Map بشكل آمن
  static Map<String, dynamic>? safeToMap(AddressModel? address) {
    return address?.toMap();
  }

  // ✅ إضافة method للتحقق من النوع قبل التحويل
  static Map<String, dynamic>? convertToMap(dynamic address) {
    if (address == null) return null;
    if (address is AddressModel) {
      return address.toMap();
    } else if (address is Map<String, dynamic>) {
      return address;
    } else {
      throw ArgumentError('Cannot convert type ${address.runtimeType} to Map<String, dynamic>');
    }
  }
}