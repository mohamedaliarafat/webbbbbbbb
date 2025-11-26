class LocationModel {
  final double lat;
  final double lng;
  final String address;
  final DateTime? lastUpdated;

  // دعم بيانات إضافية لو ظهرت في تفاصيل الأوردر
  final String? contactName;
  final String? contactPhone;
  final String? instructions;

  LocationModel({
    required this.lat,
    required this.lng,
    required this.address,
    this.lastUpdated,
    this.contactName,
    this.contactPhone,
    this.instructions,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // لو البيانات جاية داخل coordinates
    final data = json['coordinates'] ?? json;

    return LocationModel(
      lat: (data['lat'] ?? 0.0).toDouble(),
      lng: (data['lng'] ?? 0.0).toDouble(),
      address: data['address'] ?? '',
      lastUpdated: data['lastUpdated'] != null
          ? DateTime.parse(data['lastUpdated'])
          : null,

      // قيم إضافية محتمل وجودها داخل تفاصيل الأوردر
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      instructions: json['instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
      'lastUpdated': lastUpdated?.toIso8601String(),
      if (contactName != null) 'contactName': contactName,
      if (contactPhone != null) 'contactPhone': contactPhone,
      if (instructions != null) 'instructions': instructions,
    };
  }

  // ✅ إضافة دالة toMap
  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
      'lastUpdated': lastUpdated?.toIso8601String(),
      if (contactName != null) 'contactName': contactName,
      if (contactPhone != null) 'contactPhone': contactPhone,
      if (instructions != null) 'instructions': instructions,
    };
  }
}