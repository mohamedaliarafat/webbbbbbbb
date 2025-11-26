// // import 'location_model.dart';

// // class PetrolOrderModel {
// //   final String id;
// //   final String orderNumber;
// //   final String user;
// //   final VehicleInfo vehicleInfo;
// //   final String fuelType;
// //   final int fuelLiters;
// //   final LocationModel deliveryLocation;
// //   final PetrolPricing pricing;
// //   final PetrolPayment payment;
// //   final String? driverId;
// //   final String? deliveryCode;
// //   final String status;
// //   final String notes;
// //   final String adminNotes;
// //   final String supervisorNotes;
// //   final String? approvedBy;
// //   final String? confirmedBy;
// //   final DateTime submittedAt;
// //   final DateTime? approvedAt;
// //   final DateTime? pricedAt;
// //   final DateTime? assignedToDriverAt;
// //   final DateTime? completedAt;
// //   final DateTime createdAt;
// //   final DateTime updatedAt;

// //   PetrolOrderModel({
// //     required this.id,
// //     required this.orderNumber,
// //     required this.user,
// //     required this.vehicleInfo,
// //     required this.fuelType,
// //     required this.fuelLiters,
// //     required this.deliveryLocation,
// //     required this.pricing,
// //     required this.payment,
// //     this.driverId,
// //     this.deliveryCode,
// //     required this.status,
// //     required this.notes,
// //     required this.adminNotes,
// //     required this.supervisorNotes,
// //     this.approvedBy,
// //     this.confirmedBy,
// //     required this.submittedAt,
// //     this.approvedAt,
// //     this.pricedAt,
// //     this.assignedToDriverAt,
// //     this.completedAt,
// //     required this.createdAt,
// //     required this.updatedAt,
// //   });

// //   factory PetrolOrderModel.fromJson(Map<String, dynamic> json) {
// //     return PetrolOrderModel(
// //       id: json['_id'] ?? '',
// //       orderNumber: json['orderNumber'] ?? '',
// //       user: json['user']?.toString() ?? '',
// //       vehicleInfo: VehicleInfo.fromJson(json['vehicleInfo'] ?? {}),
// //       fuelType: json['fuelType'] ?? '',
// //       fuelLiters: json['fuelLiters'] ?? 0,
// //       deliveryLocation: LocationModel.fromJson(json['deliveryLocation'] ?? {}),
// //       pricing: PetrolPricing.fromJson(json['pricing'] ?? {}),
// //       payment: PetrolPayment.fromJson(json['payment'] ?? {}),
// //       driverId: json['driverId']?.toString(),
// //       deliveryCode: json['deliveryCode'],
// //       status: json['status'] ?? 'pending',
// //       notes: json['notes'] ?? '',
// //       adminNotes: json['adminNotes'] ?? '',
// //       supervisorNotes: json['supervisorNotes'] ?? '',
// //       approvedBy: json['approvedBy']?.toString(),
// //       confirmedBy: json['confirmedBy']?.toString(),
// //       submittedAt: DateTime.parse(json['submittedAt'] ?? DateTime.now().toIso8601String()),
// //       approvedAt: json['approvedAt'] != null ? DateTime.parse(json['approvedAt']) : null,
// //       pricedAt: json['pricedAt'] != null ? DateTime.parse(json['pricedAt']) : null,
// //       assignedToDriverAt: json['assignedToDriverAt'] != null ? DateTime.parse(json['assignedToDriverAt']) : null,
// //       completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
// //       createdAt: DateTime.parse(json['createdAt']),
// //       updatedAt: DateTime.parse(json['updatedAt']),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'fuelType': fuelType,
// //       'fuelLiters': fuelLiters,
// //       'deliveryLocation': deliveryLocation.toJson(),
// //       'vehicleInfo': vehicleInfo.toJson(),
// //       'notes': notes,
// //     };
// //   }

// //   PetrolOrderModel copyWith({
// //     String? id,
// //     String? orderNumber,
// //     String? user,
// //     VehicleInfo? vehicleInfo,
// //     String? fuelType,
// //     int? fuelLiters,
// //     LocationModel? deliveryLocation,
// //     PetrolPricing? pricing,
// //     PetrolPayment? payment,
// //     String? driverId,
// //     String? deliveryCode,
// //     String? status,
// //     String? notes,
// //     String? adminNotes,
// //     String? supervisorNotes,
// //     String? approvedBy,
// //     String? confirmedBy,
// //     DateTime? submittedAt,
// //     DateTime? approvedAt,
// //     DateTime? pricedAt,
// //     DateTime? assignedToDriverAt,
// //     DateTime? completedAt,
// //     DateTime? createdAt,
// //     DateTime? updatedAt,
// //   }) {
// //     return PetrolOrderModel(
// //       id: id ?? this.id,
// //       orderNumber: orderNumber ?? this.orderNumber,
// //       user: user ?? this.user,
// //       vehicleInfo: vehicleInfo ?? this.vehicleInfo,
// //       fuelType: fuelType ?? this.fuelType,
// //       fuelLiters: fuelLiters ?? this.fuelLiters,
// //       deliveryLocation: deliveryLocation ?? this.deliveryLocation,
// //       pricing: pricing ?? this.pricing,
// //       payment: payment ?? this.payment,
// //       driverId: driverId ?? this.driverId,
// //       deliveryCode: deliveryCode ?? this.deliveryCode,
// //       status: status ?? this.status,
// //       notes: notes ?? this.notes,
// //       adminNotes: adminNotes ?? this.adminNotes,
// //       supervisorNotes: supervisorNotes ?? this.supervisorNotes,
// //       approvedBy: approvedBy ?? this.approvedBy,
// //       confirmedBy: confirmedBy ?? this.confirmedBy,
// //       submittedAt: submittedAt ?? this.submittedAt,
// //       approvedAt: approvedAt ?? this.approvedAt,
// //       pricedAt: pricedAt ?? this.pricedAt,
// //       assignedToDriverAt: assignedToDriverAt ?? this.assignedToDriverAt,
// //       completedAt: completedAt ?? this.completedAt,
// //       createdAt: createdAt ?? this.createdAt,
// //       updatedAt: updatedAt ?? this.updatedAt,
// //     );
// //   }
// // }

// // class PetrolPricing {
// //   final double estimatedPrice;
// //   final double finalPrice;
// //   final bool priceVisible;
// //   final String? priceSetBy;
// //   final DateTime? priceSetAt;
// //   final double fuelPricePerLiter;
// //   final double serviceFee;

// //   PetrolPricing({
// //     required this.estimatedPrice,
// //     required this.finalPrice,
// //     required this.priceVisible,
// //     this.priceSetBy,
// //     this.priceSetAt,
// //     required this.fuelPricePerLiter,
// //     required this.serviceFee,
// //   });

// //   factory PetrolPricing.fromJson(Map<String, dynamic> json) {
// //     return PetrolPricing(
// //       estimatedPrice: (json['estimatedPrice'] ?? 0).toDouble(),
// //       finalPrice: (json['finalPrice'] ?? 0).toDouble(),
// //       priceVisible: json['priceVisible'] ?? false,
// //       priceSetBy: json['priceSetBy']?.toString(),
// //       priceSetAt: json['priceSetAt'] != null ? DateTime.parse(json['priceSetAt']) : null,
// //       fuelPricePerLiter: (json['fuelPricePerLiter'] ?? 0).toDouble(),
// //       serviceFee: (json['serviceFee'] ?? 0).toDouble(),
// //     );
// //   }

// //   PetrolPricing copyWith({
// //     double? estimatedPrice,
// //     double? finalPrice,
// //     bool? priceVisible,
// //     String? priceSetBy,
// //     DateTime? priceSetAt,
// //     double? fuelPricePerLiter,
// //     double? serviceFee,
// //   }) {
// //     return PetrolPricing(
// //       estimatedPrice: estimatedPrice ?? this.estimatedPrice,
// //       finalPrice: finalPrice ?? this.finalPrice,
// //       priceVisible: priceVisible ?? this.priceVisible,
// //       priceSetBy: priceSetBy ?? this.priceSetBy,
// //       priceSetAt: priceSetAt ?? this.priceSetAt,
// //       fuelPricePerLiter: fuelPricePerLiter ?? this.fuelPricePerLiter,
// //       serviceFee: serviceFee ?? this.serviceFee,
// //     );
// //   }
// // }

// // class PetrolPayment {
// //   final String status;
// //   final PaymentProof proof;

// //   PetrolPayment({
// //     required this.status,
// //     required this.proof,
// //   });

// //   factory PetrolPayment.fromJson(Map<String, dynamic> json) {
// //     return PetrolPayment(
// //       status: json['status'] ?? 'hidden',
// //       proof: PaymentProof.fromJson(json['proof'] ?? {}),
// //     );
// //   }

// //   PetrolPayment copyWith({
// //     String? status,
// //     PaymentProof? proof,
// //   }) {
// //     return PetrolPayment(
// //       status: status ?? this.status,
// //       proof: proof ?? this.proof,
// //     );
// //   }
// // }

// // class VehicleInfo {
// //   final String type;
// //   final String model;
// //   final String licensePlate;
// //   final String color;

// //   VehicleInfo({
// //     required this.type,
// //     required this.model,
// //     required this.licensePlate,
// //     required this.color,
// //   });

// //   factory VehicleInfo.fromJson(Map<String, dynamic> json) {
// //     return VehicleInfo(
// //       type: json['type'] ?? '',
// //       model: json['model'] ?? '',
// //       licensePlate: json['licensePlate'] ?? '',
// //       color: json['color'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'type': type,
// //       'model': model,
// //       'licensePlate': licensePlate,
// //       'color': color,
// //     };
// //   }

// //   VehicleInfo copyWith({
// //     String? type,
// //     String? model,
// //     String? licensePlate,
// //     String? color,
// //   }) {
// //     return VehicleInfo(
// //       type: type ?? this.type,
// //       model: model ?? this.model,
// //       licensePlate: licensePlate ?? this.licensePlate,
// //       color: color ?? this.color,
// //     );
// //   }
// // }

// // class PaymentProof {
// //   final String image;
// //   final String bankName;
// //   final DateTime? transferDate;
// //   final double amount;

// //   PaymentProof({
// //     required this.image,
// //     required this.bankName,
// //     this.transferDate,
// //     required this.amount,
// //   });

// //   factory PaymentProof.fromJson(Map<String, dynamic> json) {
// //     return PaymentProof(
// //       image: json['image'] ?? '',
// //       bankName: json['bankName'] ?? '',
// //       transferDate: json['transferDate'] != null ? DateTime.parse(json['transferDate']) : null,
// //       amount: (json['amount'] ?? 0).toDouble(),
// //     );
// //   }

// //   PaymentProof copyWith({
// //     String? image,
// //     String? bankName,
// //     DateTime? transferDate,
// //     double? amount,
// //   }) {
// //     return PaymentProof(
// //       image: image ?? this.image,
// //       bankName: bankName ?? this.bankName,
// //       transferDate: transferDate ?? this.transferDate,
// //       amount: amount ?? this.amount,
// //     );
// //   }
// // }






// import 'location_model.dart';

// class PetrolOrderModel {
//   final String id;
//   final String orderNumber;
//   final String user;
//   final VehicleInfo vehicleInfo;
//   final String fuelType;
//   final int fuelLiters;
//   final DeliveryLocation deliveryLocation;
//   final PetrolPricing pricing;
//   final PetrolPayment payment;
//   final String? driverId;
//   final String? deliveryCode;
//   final String status;
//   final String notes;
//   final String adminNotes;
//   final String supervisorNotes;
//   final String? approvedBy;
//   final String? confirmedBy;
//   final DateTime submittedAt;
//   final DateTime? approvedAt;
//   final DateTime? pricedAt;
//   final DateTime? assignedToDriverAt;
//   final DateTime? completedAt;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   PetrolOrderModel({
//     required this.id,
//     required this.orderNumber,
//     required this.user,
//     required this.vehicleInfo,
//     required this.fuelType,
//     required this.fuelLiters,
//     required this.deliveryLocation,
//     required this.pricing,
//     required this.payment,
//     this.driverId,
//     this.deliveryCode,
//     required this.status,
//     required this.notes,
//     required this.adminNotes,
//     required this.supervisorNotes,
//     this.approvedBy,
//     this.confirmedBy,
//     required this.submittedAt,
//     this.approvedAt,
//     this.pricedAt,
//     this.assignedToDriverAt,
//     this.completedAt,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory PetrolOrderModel.fromJson(Map<String, dynamic> json) {
//     return PetrolOrderModel(
//       id: json['_id'] ?? json['id'] ?? '',
//       orderNumber: json['orderNumber'] ?? '',
//       user: _parseUser(json['user']),
//       vehicleInfo: VehicleInfo.fromJson(json['vehicleInfo'] ?? {}),
//       fuelType: json['fuelType'] ?? '',
//       fuelLiters: (json['fuelLiters'] ?? 0).toInt(),
//       deliveryLocation: DeliveryLocation.fromJson(json['deliveryLocation'] ?? {}),
//       pricing: PetrolPricing.fromJson(json['pricing'] ?? {}),
//       payment: PetrolPayment.fromJson(json['payment'] ?? {}),
//       driverId: _parseDriverId(json['driverId']),
//       deliveryCode: json['deliveryCode'],
//       status: json['status'] ?? 'pending',
//       notes: json['notes'] ?? '',
//       adminNotes: json['adminNotes'] ?? '',
//       supervisorNotes: json['supervisorNotes'] ?? '',
//       approvedBy: _parseApprovedBy(json['approvedBy']),
//       confirmedBy: _parseConfirmedBy(json['confirmedBy']),
//       submittedAt: _parseDateTime(json['submittedAt']),
//       approvedAt: _parseNullableDateTime(json['approvedAt']),
//       pricedAt: _parseNullableDateTime(json['pricedAt']),
//       assignedToDriverAt: _parseNullableDateTime(json['assignedToDriverAt']),
//       completedAt: _parseNullableDateTime(json['completedAt']),
//       createdAt: _parseDateTime(json['createdAt']),
//       updatedAt: _parseDateTime(json['updatedAt']),
//     );
//   }

//   // 🔹 دوال مساعدة لتحليل البيانات
//   static String _parseUser(dynamic user) {
//     if (user == null) return '';
//     if (user is String) return user;
//     if (user is Map) return user['_id']?.toString() ?? user['id']?.toString() ?? '';
//     return user.toString();
//   }

//   static String? _parseDriverId(dynamic driverId) {
//     if (driverId == null) return null;
//     if (driverId is String) return driverId;
//     if (driverId is Map) return driverId['_id']?.toString() ?? driverId['id']?.toString();
//     return driverId.toString();
//   }

//   static String? _parseApprovedBy(dynamic approvedBy) {
//     if (approvedBy == null) return null;
//     if (approvedBy is String) return approvedBy;
//     if (approvedBy is Map) return approvedBy['_id']?.toString() ?? approvedBy['id']?.toString();
//     return approvedBy.toString();
//   }

//   static String? _parseConfirmedBy(dynamic confirmedBy) {
//     if (confirmedBy == null) return null;
//     if (confirmedBy is String) return confirmedBy;
//     if (confirmedBy is Map) return confirmedBy['_id']?.toString() ?? confirmedBy['id']?.toString();
//     return confirmedBy.toString();
//   }

//   static DateTime _parseDateTime(dynamic date) {
//     if (date == null) return DateTime.now();
//     if (date is String) return DateTime.parse(date);
//     if (date is DateTime) return date;
//     return DateTime.now();
//   }

//   static DateTime? _parseNullableDateTime(dynamic date) {
//     if (date == null) return null;
//     if (date is String) return DateTime.tryParse(date);
//     if (date is DateTime) return date;
//     return null;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'fuelType': fuelType,
//       'fuelLiters': fuelLiters,
//       'deliveryLocation': deliveryLocation.toJson(),
//       'vehicleInfo': vehicleInfo.toJson(),
//       'notes': notes,
//       // 🔹 إضافة الحقول الاختيارية للبيانات المرسلة
//       if (pricing.finalPrice > 0) 'pricing': pricing.toJson(),
//       if (payment.status != 'hidden') 'payment': payment.toJson(),
//     };
//   }

//   PetrolOrderModel copyWith({
//     String? id,
//     String? orderNumber,
//     String? user,
//     VehicleInfo? vehicleInfo,
//     String? fuelType,
//     int? fuelLiters,
//     DeliveryLocation? deliveryLocation,
//     PetrolPricing? pricing,
//     PetrolPayment? payment,
//     String? driverId,
//     String? deliveryCode,
//     String? status,
//     String? notes,
//     String? adminNotes,
//     String? supervisorNotes,
//     String? approvedBy,
//     String? confirmedBy,
//     DateTime? submittedAt,
//     DateTime? approvedAt,
//     DateTime? pricedAt,
//     DateTime? assignedToDriverAt,
//     DateTime? completedAt,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return PetrolOrderModel(
//       id: id ?? this.id,
//       orderNumber: orderNumber ?? this.orderNumber,
//       user: user ?? this.user,
//       vehicleInfo: vehicleInfo ?? this.vehicleInfo,
//       fuelType: fuelType ?? this.fuelType,
//       fuelLiters: fuelLiters ?? this.fuelLiters,
//       deliveryLocation: deliveryLocation ?? this.deliveryLocation,
//       pricing: pricing ?? this.pricing,
//       payment: payment ?? this.payment,
//       driverId: driverId ?? this.driverId,
//       deliveryCode: deliveryCode ?? this.deliveryCode,
//       status: status ?? this.status,
//       notes: notes ?? this.notes,
//       adminNotes: adminNotes ?? this.adminNotes,
//       supervisorNotes: supervisorNotes ?? this.supervisorNotes,
//       approvedBy: approvedBy ?? this.approvedBy,
//       confirmedBy: confirmedBy ?? this.confirmedBy,
//       submittedAt: submittedAt ?? this.submittedAt,
//       approvedAt: approvedAt ?? this.approvedAt,
//       pricedAt: pricedAt ?? this.pricedAt,
//       assignedToDriverAt: assignedToDriverAt ?? this.assignedToDriverAt,
//       completedAt: completedAt ?? this.completedAt,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }

// class PetrolPricing {
//   final double estimatedPrice;
//   final double finalPrice;
//   final bool priceVisible;
//   final String? priceSetBy;
//   final DateTime? priceSetAt;
//   final double fuelPricePerLiter;
//   final double serviceFee;

//   PetrolPricing({
//     required this.estimatedPrice,
//     required this.finalPrice,
//     required this.priceVisible,
//     this.priceSetBy,
//     this.priceSetAt,
//     required this.fuelPricePerLiter,
//     required this.serviceFee,
//   });

//   factory PetrolPricing.fromJson(Map<String, dynamic> json) {
//     return PetrolPricing(
//       estimatedPrice: _toDouble(json['estimatedPrice']),
//       finalPrice: _toDouble(json['finalPrice']),
//       priceVisible: json['priceVisible'] ?? false,
//       priceSetBy: json['priceSetBy']?.toString(),
//       priceSetAt: _parseNullableDateTimeForPricing(json['priceSetAt']),
//       fuelPricePerLiter: _toDouble(json['fuelPricePerLiter']),
//       serviceFee: _toDouble(json['serviceFee']),
//     );
//   }

//   static double _toDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     return 0.0;
//   }

//   static DateTime? _parseNullableDateTimeForPricing(dynamic date) {
//     if (date == null) return null;
//     if (date is String) return DateTime.tryParse(date);
//     if (date is DateTime) return date;
//     return null;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'estimatedPrice': estimatedPrice,
//       'finalPrice': finalPrice,
//       'priceVisible': priceVisible,
//       if (priceSetBy != null) 'priceSetBy': priceSetBy,
//       if (priceSetAt != null) 'priceSetAt': priceSetAt!.toIso8601String(),
//       'fuelPricePerLiter': fuelPricePerLiter,
//       'serviceFee': serviceFee,
//     };
//   }

//   PetrolPricing copyWith({
//     double? estimatedPrice,
//     double? finalPrice,
//     bool? priceVisible,
//     String? priceSetBy,
//     DateTime? priceSetAt,
//     double? fuelPricePerLiter,
//     double? serviceFee,
//   }) {
//     return PetrolPricing(
//       estimatedPrice: estimatedPrice ?? this.estimatedPrice,
//       finalPrice: finalPrice ?? this.finalPrice,
//       priceVisible: priceVisible ?? this.priceVisible,
//       priceSetBy: priceSetBy ?? this.priceSetBy,
//       priceSetAt: priceSetAt ?? this.priceSetAt,
//       fuelPricePerLiter: fuelPricePerLiter ?? this.fuelPricePerLiter,
//       serviceFee: serviceFee ?? this.serviceFee,
//     );
//   }
// }

// class PetrolPayment {
//   final String status;
//   final PaymentProof proof;

//   PetrolPayment({
//     required this.status,
//     required this.proof,
//   });

//   factory PetrolPayment.fromJson(Map<String, dynamic> json) {
//     return PetrolPayment(
//       status: json['status'] ?? 'hidden',
//       proof: PaymentProof.fromJson(json['proof'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'proof': proof.toJson(),
//     };
//   }

//   PetrolPayment copyWith({
//     String? status,
//     PaymentProof? proof,
//   }) {
//     return PetrolPayment(
//       status: status ?? this.status,
//       proof: proof ?? this.proof,
//     );
//   }
// }

// // 🔹 تغيير من LocationModel إلى DeliveryLocation لتتوافق مع الباك اند
// class DeliveryLocation {
//   final String address;
//   final LocationCoordinates coordinates;
//   final String contactName;
//   final String contactPhone;
//   final String instructions;

//   DeliveryLocation({
//     required this.address,
//     required this.coordinates,
//     required this.contactName,
//     required this.contactPhone,
//     required this.instructions,
//   });

//   factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
//     return DeliveryLocation(
//       address: json['address'] ?? '',
//       coordinates: LocationCoordinates.fromJson(json['coordinates'] ?? {}),
//       contactName: json['contactName'] ?? '',
//       contactPhone: json['contactPhone'] ?? '',
//       instructions: json['instructions'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'address': address,
//       'coordinates': coordinates.toJson(),
//       'contactName': contactName,
//       'contactPhone': contactPhone,
//       'instructions': instructions,
//     };
//   }

//   DeliveryLocation copyWith({
//     String? address,
//     LocationCoordinates? coordinates,
//     String? contactName,
//     String? contactPhone,
//     String? instructions,
//   }) {
//     return DeliveryLocation(
//       address: address ?? this.address,
//       coordinates: coordinates ?? this.coordinates,
//       contactName: contactName ?? this.contactName,
//       contactPhone: contactPhone ?? this.contactPhone,
//       instructions: instructions ?? this.instructions,
//     );
//   }
// }

// class LocationCoordinates {
//   final double lat;
//   final double lng;

//   LocationCoordinates({
//     required this.lat,
//     required this.lng,
//   });

//   factory LocationCoordinates.fromJson(Map<String, dynamic> json) {
//     return LocationCoordinates(
//       lat: _toDouble(json['lat']),
//       lng: _toDouble(json['lng']),
//     );
//   }

//   static double _toDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     return 0.0;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'lat': lat,
//       'lng': lng,
//     };
//   }

//   LocationCoordinates copyWith({
//     double? lat,
//     double? lng,
//   }) {
//     return LocationCoordinates(
//       lat: lat ?? this.lat,
//       lng: lng ?? this.lng,
//     );
//   }
// }

// class VehicleInfo {
//   final String type;
//   final String model;
//   final String licensePlate;
//   final String color;

//   VehicleInfo({
//     required this.type,
//     required this.model,
//     required this.licensePlate,
//     required this.color,
//   });

//   factory VehicleInfo.fromJson(Map<String, dynamic> json) {
//     return VehicleInfo(
//       type: json['type'] ?? '',
//       model: json['model'] ?? '',
//       licensePlate: json['licensePlate'] ?? '',
//       color: json['color'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'model': model,
//       'licensePlate': licensePlate,
//       'color': color,
//     };
//   }

//   VehicleInfo copyWith({
//     String? type,
//     String? model,
//     String? licensePlate,
//     String? color,
//   }) {
//     return VehicleInfo(
//       type: type ?? this.type,
//       model: model ?? this.model,
//       licensePlate: licensePlate ?? this.licensePlate,
//       color: color ?? this.color,
//     );
//   }
// }

// class PaymentProof {
//   final String image;
//   final String bankName;
//   final DateTime? transferDate;
//   final double amount;

//   PaymentProof({
//     required this.image,
//     required this.bankName,
//     this.transferDate,
//     required this.amount,
//   });

//   factory PaymentProof.fromJson(Map<String, dynamic> json) {
//     return PaymentProof(
//       image: json['image'] ?? '',
//       bankName: json['bankName'] ?? '',
//       transferDate: _parseNullableDateTimeForProof(json['transferDate']),
//       amount: _toDouble(json['amount']),
//     );
//   }

//   static DateTime? _parseNullableDateTimeForProof(dynamic date) {
//     if (date == null) return null;
//     if (date is String) return DateTime.tryParse(date);
//     if (date is DateTime) return date;
//     return null;
//   }

//   static double _toDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     return 0.0;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'image': image,
//       'bankName': bankName,
//       if (transferDate != null) 'transferDate': transferDate!.toIso8601String(),
//       'amount': amount,
//     };
//   }

//   PaymentProof copyWith({
//     String? image,
//     String? bankName,
//     DateTime? transferDate,
//     double? amount,
//   }) {
//     return PaymentProof(
//       image: image ?? this.image,
//       bankName: bankName ?? this.bankName,
//       transferDate: transferDate ?? this.transferDate,
//       amount: amount ?? this.amount,
//     );
//   }
// }