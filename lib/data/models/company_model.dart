import 'location_model.dart';

class CompanyModel {
  final String id;
  final String name;
  final String commercialName;
  final ContactInfo contactInfo;
  final CompanyLocation location;
  final String companyType;
  final Map<String, BusinessHours> businessHours;
  final List<CompanyService> services;
  final FleetInfo fleetInfo;
  final CompanyDocuments documents;
  final CompanyImages images;
  final double rating;
  final int ratingCount;
  final CompanyPerformance performance;
  final String verification;
  final String verificationMessage;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String owner;
  final String code;
  final String description;
  final ServiceSettings serviceSettings;
  final bool isActive;
  final bool featured;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyModel({
    required this.id,
    required this.name,
    required this.commercialName,
    required this.contactInfo,
    required this.location,
    required this.companyType,
    required this.businessHours,
    required this.services,
    required this.fleetInfo,
    required this.documents,
    required this.images,
    required this.rating,
    required this.ratingCount,
    required this.performance,
    required this.verification,
    required this.verificationMessage,
    this.verifiedBy,
    this.verifiedAt,
    required this.owner,
    required this.code,
    required this.description,
    required this.serviceSettings,
    required this.isActive,
    required this.featured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      commercialName: json['commercialName'] ?? '',
      contactInfo: ContactInfo.fromJson(json['contactInfo'] ?? {}),
      location: CompanyLocation.fromJson(json['location'] ?? {}),
      companyType: json['companyType'] ?? 'fuel_supplier',
      businessHours: _parseBusinessHours(json['businessHours'] ?? {}),
      services: List<CompanyService>.from((json['services'] ?? []).map((x) => CompanyService.fromJson(x))),
      fleetInfo: FleetInfo.fromJson(json['fleetInfo'] ?? {}),
      documents: CompanyDocuments.fromJson(json['documents'] ?? {}),
      images: CompanyImages.fromJson(json['images'] ?? {}),
      rating: (json['rating'] ?? 3.0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      performance: CompanyPerformance.fromJson(json['performance'] ?? {}),
      verification: json['verification'] ?? 'Pending',
      verificationMessage: json['verificationMessage'] ?? 'شركتك قيد المراجعة. سنخطرك بمجرد التحقق منها.',
      verifiedBy: json['verifiedBy']?.toString(),
      verifiedAt: json['verifiedAt'] != null ? DateTime.parse(json['verifiedAt']) : null,
      owner: json['owner']?.toString() ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      serviceSettings: ServiceSettings.fromJson(json['serviceSettings'] ?? {}),
      isActive: json['isActive'] ?? true,
      featured: json['featured'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'commercialName': commercialName,
      'contactInfo': contactInfo.toJson(),
      'location': location.toJson(),
      'companyType': companyType,
      'businessHours': _businessHoursToJson(),
      'services': services.map((service) => service.toJson()).toList(),
      'fleetInfo': fleetInfo.toJson(),
      'documents': documents.toJson(),
      'images': images.toJson(),
      'description': description,
      'serviceSettings': serviceSettings.toJson(),
    };
  }

  static Map<String, BusinessHours> _parseBusinessHours(Map<String, dynamic> json) {
    final Map<String, BusinessHours> businessHours = {};
    final days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    
    for (final day in days) {
      if (json[day] != null) {
        businessHours[day] = BusinessHours.fromJson(json[day]);
      } else {
        businessHours[day] = BusinessHours(
          open: "08:00",
          close: "22:00",
          isOpen: true,
        );
      }
    }
    
    return businessHours;
  }

  Map<String, dynamic> _businessHoursToJson() {
    final Map<String, dynamic> hours = {};
    businessHours.forEach((key, value) {
      hours[key] = value.toJson();
    });
    return hours;
  }

  // دوال مساعدة
  String get displayName => commercialName.isNotEmpty ? commercialName : name;
  
  bool get isVerified => verification == 'Verified';
  
  bool get isOpenNow {
    final now = DateTime.now();
    final currentDay = now.weekday; // 1=Monday, 7=Sunday
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    final dayMap = {
      1: 'monday',
      2: 'tuesday', 
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };
    
    final today = dayMap[currentDay] ?? 'monday';
    final todayHours = businessHours[today];
    
    if (todayHours == null || !todayHours.isOpen) return false;
    
    return currentTime.compareTo(todayHours.open) >= 0 && 
           currentTime.compareTo(todayHours.close) <= 0;
  }

  double get completionRate {
    final totalOrders = performance.totalOrders;
    if (totalOrders == 0) return 0.0;
    return (performance.completedOrders / totalOrders) * 100;
  }

  CompanyModel copyWith({
    String? name,
    String? commercialName,
    ContactInfo? contactInfo,
    CompanyLocation? location,
    String? companyType,
    Map<String, BusinessHours>? businessHours,
    List<CompanyService>? services,
    FleetInfo? fleetInfo,
    CompanyDocuments? documents,
    CompanyImages? images,
    double? rating,
    int? ratingCount,
    CompanyPerformance? performance,
    String? verification,
    String? verificationMessage,
    String? verifiedBy,
    DateTime? verifiedAt,
    String? description,
    ServiceSettings? serviceSettings,
    bool? isActive,
    bool? featured,
  }) {
    return CompanyModel(
      id: id,
      name: name ?? this.name,
      commercialName: commercialName ?? this.commercialName,
      contactInfo: contactInfo ?? this.contactInfo,
      location: location ?? this.location,
      companyType: companyType ?? this.companyType,
      businessHours: businessHours ?? this.businessHours,
      services: services ?? this.services,
      fleetInfo: fleetInfo ?? this.fleetInfo,
      documents: documents ?? this.documents,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      performance: performance ?? this.performance,
      verification: verification ?? this.verification,
      verificationMessage: verificationMessage ?? this.verificationMessage,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      owner: owner,
      code: code,
      description: description ?? this.description,
      serviceSettings: serviceSettings ?? this.serviceSettings,
      isActive: isActive ?? this.isActive,
      featured: featured ?? this.featured,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class ContactInfo {
  final String phone;
  final String email;
  final String website;
  final String supportPhone;

  ContactInfo({
    required this.phone,
    required this.email,
    required this.website,
    required this.supportPhone,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      supportPhone: json['supportPhone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
      'supportPhone': supportPhone,
    };
  }
}

class CompanyLocation {
  final String address;
  final String city;
  final String district;
  final LocationModel coordinates;
  final List<String> workingArea;

  CompanyLocation({
    required this.address,
    required this.city,
    required this.district,
    required this.coordinates,
    required this.workingArea,
  });

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    return CompanyLocation(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      coordinates: LocationModel.fromJson(json['coordinates'] ?? {}),
      workingArea: List<String>.from(json['workingArea'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'district': district,
      'coordinates': coordinates.toJson(),
      'workingArea': workingArea,
    };
  }

  String get fullAddress {
    final parts = [address, district, city].where((part) => part.isNotEmpty);
    return parts.join(', ');
  }
}

class BusinessHours {
  final String open;
  final String close;
  final bool isOpen;

  BusinessHours({
    required this.open,
    required this.close,
    required this.isOpen,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    return BusinessHours(
      open: json['open'] ?? '08:00',
      close: json['close'] ?? '22:00',
      isOpen: json['isOpen'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'close': close,
      'isOpen': isOpen,
    };
  }

  String get displayHours => isOpen ? '$open - $close' : 'مغلق';
}

class CompanyService {
  final String name;
  final String description;
  final double price;
  final bool isAvailable;
  final String estimatedTime;

  CompanyService({
    required this.name,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.estimatedTime,
  });

  factory CompanyService.fromJson(Map<String, dynamic> json) {
    return CompanyService(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
      estimatedTime: json['estimatedTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'isAvailable': isAvailable,
      'estimatedTime': estimatedTime,
    };
  }

  String get displayPrice => price > 0 ? '$price ر.س' : 'مجاني';
}

class FleetInfo {
  final int totalVehicles;
  final List<VehicleType> vehicleTypes;
  final bool hasSpecialEquipment;

  FleetInfo({
    required this.totalVehicles,
    required this.vehicleTypes,
    required this.hasSpecialEquipment,
  });

  factory FleetInfo.fromJson(Map<String, dynamic> json) {
    return FleetInfo(
      totalVehicles: json['totalVehicles'] ?? 0,
      vehicleTypes: List<VehicleType>.from((json['vehicleTypes'] ?? []).map((x) => VehicleType.fromJson(x))),
      hasSpecialEquipment: json['hasSpecialEquipment'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalVehicles': totalVehicles,
      'vehicleTypes': vehicleTypes.map((type) => type.toJson()).toList(),
      'hasSpecialEquipment': hasSpecialEquipment,
    };
  }
}

class VehicleType {
  final String type;
  final int count;

  VehicleType({
    required this.type,
    required this.count,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'count': count,
    };
  }

  String get displayName {
    switch (type) {
      case 'tanker':
        return 'صهريج وقود';
      case 'truck':
        return 'شاحنة';
      case 'van':
        return 'فان';
      case 'car':
        return 'سيارة';
      default:
        return type;
    }
  }
}

class CompanyDocuments {
  final CompanyDocument commercialLicense;
  final CompanyDocument taxCertificate;
  final CompanyDocument chamberOfCommerce;

  CompanyDocuments({
    required this.commercialLicense,
    required this.taxCertificate,
    required this.chamberOfCommerce,
  });

  factory CompanyDocuments.fromJson(Map<String, dynamic> json) {
    return CompanyDocuments(
      commercialLicense: CompanyDocument.fromJson(json['commercialLicense'] ?? {}),
      taxCertificate: CompanyDocument.fromJson(json['taxCertificate'] ?? {}),
      chamberOfCommerce: CompanyDocument.fromJson(json['chamberOfCommerce'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commercialLicense': commercialLicense.toJson(),
      'taxCertificate': taxCertificate.toJson(),
      'chamberOfCommerce': chamberOfCommerce.toJson(),
    };
  }
}

class CompanyDocument {
  final String number;
  final String file;
  final DateTime? expiryDate;

  CompanyDocument({
    required this.number,
    required this.file,
    this.expiryDate,
  });

  factory CompanyDocument.fromJson(Map<String, dynamic> json) {
    return CompanyDocument(
      number: json['number'] ?? '',
      file: json['file'] ?? '',
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'file': file,
      if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
    };
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }
}

class CompanyImages {
  final String logo;
  final String cover;
  final List<String> gallery;

  CompanyImages({
    required this.logo,
    required this.cover,
    required this.gallery,
  });

  factory CompanyImages.fromJson(Map<String, dynamic> json) {
    return CompanyImages(
      logo: json['logo'] ?? '',
      cover: json['cover'] ?? '',
      gallery: List<String>.from(json['gallery'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'cover': cover,
      'gallery': gallery,
    };
  }
}

class CompanyPerformance {
  final int totalOrders;
  final int completedOrders;
  final double cancellationRate;
  final double averageResponseTime;

  CompanyPerformance({
    required this.totalOrders,
    required this.completedOrders,
    required this.cancellationRate,
    required this.averageResponseTime,
  });

  factory CompanyPerformance.fromJson(Map<String, dynamic> json) {
    return CompanyPerformance(
      totalOrders: json['totalOrders'] ?? 0,
      completedOrders: json['completedOrders'] ?? 0,
      cancellationRate: (json['cancellationRate'] ?? 0).toDouble(),
      averageResponseTime: (json['averageResponseTime'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'cancellationRate': cancellationRate,
      'averageResponseTime': averageResponseTime,
    };
  }
}

class ServiceSettings {
  final bool acceptsOnlineOrders;
  final bool hasDelivery;
  final bool hasPickup;
  final double minimumOrder;
  final double deliveryFee;

  ServiceSettings({
    required this.acceptsOnlineOrders,
    required this.hasDelivery,
    required this.hasPickup,
    required this.minimumOrder,
    required this.deliveryFee,
  });

  factory ServiceSettings.fromJson(Map<String, dynamic> json) {
    return ServiceSettings(
      acceptsOnlineOrders: json['acceptsOnlineOrders'] ?? true,
      hasDelivery: json['hasDelivery'] ?? true,
      hasPickup: json['hasPickup'] ?? false,
      minimumOrder: (json['minimumOrder'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acceptsOnlineOrders': acceptsOnlineOrders,
      'hasDelivery': hasDelivery,
      'hasPickup': hasPickup,
      'minimumOrder': minimumOrder,
      'deliveryFee': deliveryFee,
    };
  }
}