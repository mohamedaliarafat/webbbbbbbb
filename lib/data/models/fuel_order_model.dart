import 'location_model.dart';

class FuelOrderModel {
  final String id;
  final String orderNumber;
  final String customerId;
  final String? driverId;
  final String serviceType; // سيكون دائماً 'fuel'
  final String description;
  final LocationModel deliveryLocation;
  final FuelOrderPricing pricing;
  final FuelOrderPayment payment;
  final String? approvedBy;
  final String? confirmedBy;
  final String? deliveryCode;
  final String status;
  final DateTime submittedAt;
  final DateTime? approvedAt;
  final DateTime? pricedAt;
  final DateTime? paymentSubmittedAt;
  final DateTime? paymentVerifiedAt;
  final DateTime? assignedToDriverAt;
  final DateTime? deliveredAt;
  final List<FuelOrderTracking> tracking;
  final String supervisorNotes;
  final String adminNotes;
  final String customerNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // 🔹 حقول خاصة بالوقود
  final String fuelType;
  final int fuelLiters;
  final String? fuelTypeName;
  final Map<String, dynamic>? vehicleInfo;

  FuelOrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    this.driverId,
    required this.serviceType,
    required this.description,
    required this.deliveryLocation,
    required this.pricing,
    required this.payment,
    this.approvedBy,
    this.confirmedBy,
    this.deliveryCode,
    required this.status,
    required this.submittedAt,
    this.approvedAt,
    this.pricedAt,
    this.paymentSubmittedAt,
    this.paymentVerifiedAt,
    this.assignedToDriverAt,
    this.deliveredAt,
    required this.tracking,
    required this.supervisorNotes,
    required this.adminNotes,
    required this.customerNotes,
    required this.createdAt,
    required this.updatedAt,
    // 🔹 حقول الوقود
    required this.fuelType,
    required this.fuelLiters,
    this.fuelTypeName,
    this.vehicleInfo,
  });

  factory FuelOrderModel.fromJson(Map<String, dynamic> json) {
    return FuelOrderModel(
      id: json['_id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      driverId: json['driverId']?.toString(),
      serviceType: json['serviceType']?.toString() ?? 'fuel',
      description: json['description']?.toString() ?? '',
      deliveryLocation: LocationModel.fromJson(json['deliveryLocation'] ?? {}),
      pricing: FuelOrderPricing.fromJson(json['pricing'] ?? {}),
      payment: FuelOrderPayment.fromJson(json['payment'] ?? {}),
      approvedBy: json['approvedBy']?.toString(),
      confirmedBy: json['confirmedBy']?.toString(),
      deliveryCode: json['deliveryCode']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      submittedAt: _parseDateTime(json['submittedAt']) ?? DateTime.now(),
      approvedAt: _parseDateTime(json['approvedAt']),
      pricedAt: _parseDateTime(json['pricedAt']),
      paymentSubmittedAt: _parseDateTime(json['paymentSubmittedAt']),
      paymentVerifiedAt: _parseDateTime(json['paymentVerifiedAt']),
      assignedToDriverAt: _parseDateTime(json['assignedToDriverAt']),
      deliveredAt: _parseDateTime(json['deliveredAt']),
      tracking: _parseTrackingList(json['tracking']),
      supervisorNotes: json['supervisorNotes']?.toString() ?? '',
      adminNotes: json['adminNotes']?.toString() ?? '',
      customerNotes: json['customerNotes']?.toString() ?? '',
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
      // 🔹 حقول الوقود
      fuelType: json['fuelType']?.toString() ?? json['fuelDetails']?['fuelType']?.toString() ?? '',
      fuelLiters: _parseInt(json['fuelLiters'] ?? json['fuelDetails']?['fuelLiters']),
      fuelTypeName: json['fuelTypeName']?.toString() ?? json['fuelDetails']?['fuelTypeName']?.toString(),
      vehicleInfo: json['vehicleInfo'] is Map ? Map<String, dynamic>.from(json['vehicleInfo']) : {},
    );
  }

  // 🔹 دالة لتحويل البيانات للإرسال للـ API
  Map<String, dynamic> toCreateJson() {
    return {
      'serviceType': 'fuel',
      'description': description,
      'deliveryLocation': deliveryLocation.toJson(),
      'customerNotes': customerNotes,
      'fuelType': fuelType,
      'fuelLiters': fuelLiters,
      'fuelTypeName': fuelTypeName,
      'vehicleInfo': vehicleInfo ?? {},
      'pricing': pricing.toJson(),
      'payment': payment.toJson(),
      'status': status,
    };
  }

  // دوال مساعدة لمعالجة القيم null
  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return null;
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.parse(value.toString());
    } catch (e) {
      return 0;
    }
  }

  static List<FuelOrderTracking> _parseTrackingList(dynamic tracking) {
    if (tracking is! List) return [];
    try {
      return List<FuelOrderTracking>.from(
        tracking.map((x) => FuelOrderTracking.fromJson(x ?? {})).where((x) => x != null),
      );
    } catch (e) {
      return [];
    }
  }

  FuelOrderModel copyWith({
    String? id,
    String? orderNumber,
    String? customerId,
    String? driverId,
    String? serviceType,
    String? description,
    LocationModel? deliveryLocation,
    FuelOrderPricing? pricing,
    FuelOrderPayment? payment,
    String? approvedBy,
    String? confirmedBy,
    String? deliveryCode,
    String? status,
    DateTime? submittedAt,
    DateTime? approvedAt,
    DateTime? pricedAt,
    DateTime? paymentSubmittedAt,
    DateTime? paymentVerifiedAt,
    DateTime? assignedToDriverAt,
    DateTime? deliveredAt,
    List<FuelOrderTracking>? tracking,
    String? supervisorNotes,
    String? adminNotes,
    String? customerNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    // 🔹 حقول الوقود
    String? fuelType,
    int? fuelLiters,
    String? fuelTypeName,
    Map<String, dynamic>? vehicleInfo,
  }) {
    return FuelOrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      driverId: driverId ?? this.driverId,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      pricing: pricing ?? this.pricing,
      payment: payment ?? this.payment,
      approvedBy: approvedBy ?? this.approvedBy,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      deliveryCode: deliveryCode ?? this.deliveryCode,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      pricedAt: pricedAt ?? this.pricedAt,
      paymentSubmittedAt: paymentSubmittedAt ?? this.paymentSubmittedAt,
      paymentVerifiedAt: paymentVerifiedAt ?? this.paymentVerifiedAt,
      assignedToDriverAt: assignedToDriverAt ?? this.assignedToDriverAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      tracking: tracking ?? this.tracking,
      supervisorNotes: supervisorNotes ?? this.supervisorNotes,
      adminNotes: adminNotes ?? this.adminNotes,
      customerNotes: customerNotes ?? this.customerNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // 🔹 حقول الوقود
      fuelType: fuelType ?? this.fuelType,
      fuelLiters: fuelLiters ?? this.fuelLiters,
      fuelTypeName: fuelTypeName ?? this.fuelTypeName,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
    );
  }
}

class FuelOrderPricing {
  final double estimatedPrice;
  final double finalPrice;
  final bool priceVisible;
  final String? priceSetBy;
  final DateTime? priceSetAt;
  final double fuelPricePerLiter; // 🔹 سعر اللتر
  final double serviceFee; // 🔹 رسوم الخدمة

  FuelOrderPricing({
    required this.estimatedPrice,
    required this.finalPrice,
    required this.priceVisible,
    this.priceSetBy,
    this.priceSetAt,
    required this.fuelPricePerLiter,
    required this.serviceFee,
  });

  factory FuelOrderPricing.fromJson(Map<String, dynamic> json) {
    return FuelOrderPricing(
      estimatedPrice: _parseDouble(json['estimatedPrice']),
      finalPrice: _parseDouble(json['finalPrice']),
      priceVisible: json['priceVisible'] ?? false,
      priceSetBy: json['priceSetBy']?.toString(),
      priceSetAt: _parseDateTime(json['priceSetAt']),
      fuelPricePerLiter: _parseDouble(json['fuelPricePerLiter']),
      serviceFee: _parseDouble(json['serviceFee']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estimatedPrice': estimatedPrice,
      'finalPrice': finalPrice,
      'priceVisible': priceVisible,
      if (priceSetBy != null) 'priceSetBy': priceSetBy,
      if (priceSetAt != null) 'priceSetAt': priceSetAt!.toIso8601String(),
      'fuelPricePerLiter': fuelPricePerLiter,
      'serviceFee': serviceFee,
    };
  }

  // دوال مساعدة
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return 0.0;
    }
  }

  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return null;
    }
  }

  FuelOrderPricing copyWith({
    double? estimatedPrice,
    double? finalPrice,
    bool? priceVisible,
    String? priceSetBy,
    DateTime? priceSetAt,
    double? fuelPricePerLiter,
    double? serviceFee,
  }) {
    return FuelOrderPricing(
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      priceVisible: priceVisible ?? this.priceVisible,
      priceSetBy: priceSetBy ?? this.priceSetBy,
      priceSetAt: priceSetAt ?? this.priceSetAt,
      fuelPricePerLiter: fuelPricePerLiter ?? this.fuelPricePerLiter,
      serviceFee: serviceFee ?? this.serviceFee,
    );
  }
}

class FuelOrderPayment {
  final String status;
  final FuelPaymentProof proof;
  final String? verifiedBy;
  final DateTime? verifiedAt;

  FuelOrderPayment({
    required this.status,
    required this.proof,
    this.verifiedBy,
    this.verifiedAt,
  });

  factory FuelOrderPayment.fromJson(Map<String, dynamic> json) {
    return FuelOrderPayment(
      status: json['status']?.toString() ?? 'pending',
      proof: FuelPaymentProof.fromJson(json['proof'] ?? {}),
      verifiedBy: json['verifiedBy']?.toString(),
      verifiedAt: _parseDateTime(json['verifiedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'proof': proof.toJson(),
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt!.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return null;
    }
  }

  FuelOrderPayment copyWith({
    String? status,
    FuelPaymentProof? proof,
    String? verifiedBy,
    DateTime? verifiedAt,
  }) {
    return FuelOrderPayment(
      status: status ?? this.status,
      proof: proof ?? this.proof,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }
}

class FuelPaymentProof {
  final String image;
  final String bankName;
  final String accountNumber;
  final DateTime? transferDate;
  final double amount;

  FuelPaymentProof({
    required this.image,
    required this.bankName,
    required this.accountNumber,
    this.transferDate,
    required this.amount,
  });

  factory FuelPaymentProof.fromJson(Map<String, dynamic> json) {
    return FuelPaymentProof(
      image: json['image']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      transferDate: _parseDateTime(json['transferDate']),
      amount: _parseDouble(json['amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'bankName': bankName,
      'accountNumber': accountNumber,
      if (transferDate != null) 'transferDate': transferDate!.toIso8601String(),
      'amount': amount,
    };
  }

  // دوال مساعدة
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return 0.0;
    }
  }

  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return null;
    }
  }

  FuelPaymentProof copyWith({
    String? image,
    String? bankName,
    String? accountNumber,
    DateTime? transferDate,
    double? amount,
  }) {
    return FuelPaymentProof(
      image: image ?? this.image,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      transferDate: transferDate ?? this.transferDate,
      amount: amount ?? this.amount,
    );
  }
}

class FuelOrderTracking {
  final String status;
  final LocationModel location;
  final DateTime timestamp;
  final String note;

  FuelOrderTracking({
    required this.status,
    required this.location,
    required this.timestamp,
    required this.note,
  });

  factory FuelOrderTracking.fromJson(Map<String, dynamic> json) {
    return FuelOrderTracking(
      status: json['status']?.toString() ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      timestamp: _parseDateTime(json['timestamp']) ?? DateTime.now(),
      note: json['note']?.toString() ?? '',
    );
  }

  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return null;
    }
  }

  FuelOrderTracking copyWith({
    String? status,
    LocationModel? location,
    DateTime? timestamp,
    String? note,
  }) {
    return FuelOrderTracking(
      status: status ?? this.status,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }
}