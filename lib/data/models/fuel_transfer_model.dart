// data/models/fuel_transfer_model.dart
import 'package:customer/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

enum TransferStatus {
  pending,
  under_review,
  approved,
  rejected,
  driver_assigned,
  fueling_from_aramco,
  out_for_delivery,
  arrived_at_location,
  unloading,
  completed,
  cancelled
}

class FuelTransferRequest {
  final String id;
  final String? orderNumber;
  final String company;
  final double quantity;
  final double totalAmount;
  final String paymentMethod;
  final String deliveryLocation;
  final TransferStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? customerId;
  final String? driverId;
  final String? aramcoInvoiceUrl;
  final double? finalPrice;
  final String? rejectionReason;
  final Map<String, dynamic>? pricing;
  final Map<String, dynamic>? coordinates;

  FuelTransferRequest({
    required this.id,
    this.orderNumber,
    required this.company,
    required this.quantity,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryLocation,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.customerId,
    this.driverId,
    this.aramcoInvoiceUrl,
    this.finalPrice,
    this.rejectionReason,
    this.pricing,
    this.coordinates,
  });

  // Constructor لإنشاء كائن فارغ
  FuelTransferRequest.empty()
      : id = '',
        orderNumber = '',
        company = '',
        quantity = 0,
        totalAmount = 0,
        paymentMethod = '',
        deliveryLocation = '',
        status = TransferStatus.pending,
        createdAt = DateTime.now(),
        updatedAt = null,
        customerId = null,
        driverId = null,
        aramcoInvoiceUrl = null,
        finalPrice = null,
        rejectionReason = null,
        pricing = null,
        coordinates = null;

  factory FuelTransferRequest.fromJson(Map<String, dynamic> json) {
    try {
      // معالجة الحالة
      final statusString = json['status']?.toString() ?? 'pending';
      
      // معالجة التاريخ
      DateTime parseDate(dynamic date) {
        if (date == null) return DateTime.now();
        if (date is DateTime) return date;
        if (date is String) {
          try {
            return DateTime.parse(date);
          } catch (e) {
            return DateTime.now();
          }
        }
        return DateTime.now();
      }

      // معالجة المبلغ الإجمالي
      double parseTotalAmount() {
        if (json['pricing'] != null) {
          if (json['pricing'] is Map) {
            return (json['pricing']['totalAmount'] ?? 
                   json['pricing']['finalPrice'] ?? 
                   json['totalAmount'] ?? 0).toDouble();
          }
        }
        return (json['totalAmount'] ?? 0).toDouble();
      }

      // معالجة طريقة الدفع
      String parsePaymentMethod() {
        if (json['payment'] != null) {
          if (json['payment'] is Map) {
            return json['payment']['method'] ?? '';
          }
          if (json['payment'] is String) {
            return json['payment'];
          }
        }
        return json['paymentMethod'] ?? '';
      }

      // معالجة موقع التسليم
      String parseDeliveryLocation() {
        if (json['deliveryLocation'] != null) {
          if (json['deliveryLocation'] is Map) {
            return json['deliveryLocation']['address'] ?? '';
          }
          if (json['deliveryLocation'] is String) {
            return json['deliveryLocation'];
          }
        }
        return json['deliveryLocation'] ?? '';
      }

      return FuelTransferRequest(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        orderNumber: json['orderNumber']?.toString(),
        company: json['company']?.toString() ?? '',
        quantity: (json['quantity'] ?? 0).toDouble(),
        totalAmount: parseTotalAmount(),
        paymentMethod: parsePaymentMethod(),
        deliveryLocation: parseDeliveryLocation(),
        status: _parseStatus(statusString),
        createdAt: parseDate(json['createdAt']),
        updatedAt: json['updatedAt'] != null ? parseDate(json['updatedAt']) : null,
        customerId: _parseUserId(json['customer']),
        driverId: _parseUserId(json['driver']),
        aramcoInvoiceUrl: _parseInvoiceUrl(json),
        finalPrice: json['pricing']?['finalPrice']?.toDouble(),
        rejectionReason: json['review']?['rejectionReason']?.toString(),
        pricing: json['pricing'] is Map ? Map<String, dynamic>.from(json['pricing']) : null,
        coordinates: json['coordinates'] is Map ? Map<String, dynamic>.from(json['coordinates']) : null,
      );
    } catch (e) {
      print('❌ خطأ في تحويل JSON إلى FuelTransferRequest: $e');
      print('📦 JSON المدخل: $json');
      return FuelTransferRequest.empty();
    }
  }

  // دالة مساعدة لمعالجة معرف المستخدم
  static String? _parseUserId(dynamic userData) {
    if (userData == null) return null;
    if (userData is String) return userData;
    if (userData is Map) return userData['_id']?.toString();
    return null;
  }

  // دالة مساعدة لمعالجة رابط الفاتورة
  static String? _parseInvoiceUrl(Map<String, dynamic> json) {
    if (json['documents'] != null && json['documents'] is Map) {
      return json['documents']['aramcoInvoice']?['url']?.toString();
    }
    if (json['aramcoInvoiceUrl'] != null) {
      return json['aramcoInvoiceUrl']?.toString();
    }
    return null;
  }

  static TransferStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return TransferStatus.pending;
      case 'under_review': return TransferStatus.under_review;
      case 'approved': return TransferStatus.approved;
      case 'rejected': return TransferStatus.rejected;
      case 'driver_assigned': return TransferStatus.driver_assigned;
      case 'fueling_from_aramco': return TransferStatus.fueling_from_aramco;
      case 'out_for_delivery': return TransferStatus.out_for_delivery;
      case 'arrived_at_location': return TransferStatus.arrived_at_location;
      case 'unloading': return TransferStatus.unloading;
      case 'completed': return TransferStatus.completed;
      case 'cancelled': return TransferStatus.cancelled;
      default: 
        print('⚠️ حالة غير معروفة: $status, استخدام pending كافتراضي');
        return TransferStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (orderNumber != null) 'orderNumber': orderNumber,
      'company': company,
      'quantity': quantity,
      'paymentMethod': paymentMethod,
      'deliveryLocation': deliveryLocation,
      'status': _statusToString(status),
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (customerId != null) 'customerId': customerId,
      if (driverId != null) 'driverId': driverId,
      if (aramcoInvoiceUrl != null) 'aramcoInvoiceUrl': aramcoInvoiceUrl,
      if (finalPrice != null) 'finalPrice': finalPrice,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (pricing != null) 'pricing': pricing,
      if (coordinates != null) 'coordinates': coordinates,
    };
  }

  String _statusToString(TransferStatus status) {
    switch (status) {
      case TransferStatus.pending: return 'pending';
      case TransferStatus.under_review: return 'under_review';
      case TransferStatus.approved: return 'approved';
      case TransferStatus.rejected: return 'rejected';
      case TransferStatus.driver_assigned: return 'driver_assigned';
      case TransferStatus.fueling_from_aramco: return 'fueling_from_aramco';
      case TransferStatus.out_for_delivery: return 'out_for_delivery';
      case TransferStatus.arrived_at_location: return 'arrived_at_location';
      case TransferStatus.unloading: return 'unloading';
      case TransferStatus.completed: return 'completed';
      case TransferStatus.cancelled: return 'cancelled';
    }
  }

  String get statusText {
    switch (status) {
      case TransferStatus.pending: return 'قيد الانتظار';
      case TransferStatus.under_review: return 'قيد المراجعة';
      case TransferStatus.approved: return 'تم الموافقة';
      case TransferStatus.rejected: return 'مرفوض';
      case TransferStatus.driver_assigned: return 'تم تعيين سائق';
      case TransferStatus.fueling_from_aramco: return 'تعبئة من أرامكو';
      case TransferStatus.out_for_delivery: return 'خرج للتوصيل';
      case TransferStatus.arrived_at_location: return 'وصل الموقع';
      case TransferStatus.unloading: return 'قيد التفريغ';
      case TransferStatus.completed: return 'مكتمل';
      case TransferStatus.cancelled: return 'ملغي';
    }
  }

  Color get statusColor {
    switch (status) {
      case TransferStatus.pending: return Colors.orange;
      case TransferStatus.under_review: return Colors.blue;
      case TransferStatus.approved: return Colors.green;
      case TransferStatus.rejected: return Colors.red;
      case TransferStatus.driver_assigned: return Colors.purple;
      case TransferStatus.fueling_from_aramco: return Colors.teal;
      case TransferStatus.out_for_delivery: return Colors.amber;
      case TransferStatus.arrived_at_location: return Colors.lightBlue;
      case TransferStatus.unloading: return Colors.deepOrange;
      case TransferStatus.completed: return Colors.green;
      case TransferStatus.cancelled: return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case TransferStatus.pending: return Icons.access_time;
      case TransferStatus.under_review: return Icons.visibility;
      case TransferStatus.approved: return Icons.check_circle;
      case TransferStatus.rejected: return Icons.cancel;
      case TransferStatus.driver_assigned: return Icons.person;
      case TransferStatus.fueling_from_aramco: return Icons.local_gas_station;
      case TransferStatus.out_for_delivery: return Icons.directions_car;
      case TransferStatus.arrived_at_location: return Icons.location_on;
      case TransferStatus.unloading: return Icons.unarchive;
      case TransferStatus.completed: return Icons.verified;
      case TransferStatus.cancelled: return Icons.block;
    }
  }

  bool get canBeCancelled {
    return status == TransferStatus.pending || status == TransferStatus.under_review;
  }

  bool get canUploadInvoice {
    return status == TransferStatus.pending || status == TransferStatus.under_review;
  }

  bool get isCompleted {
    return status == TransferStatus.completed;
  }

  bool get isRejected {
    return status == TransferStatus.rejected;
  }

  bool get isCancelled {
    return status == TransferStatus.cancelled;
  }

  // دالة للمساواة بين الكائنات
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelTransferRequest &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // دالة لنسخ الكائن مع تحديث بعض الخصائص
  FuelTransferRequest copyWith({
    String? id,
    String? orderNumber,
    String? company,
    double? quantity,
    double? totalAmount,
    String? paymentMethod,
    String? deliveryLocation,
    TransferStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? customerId,
    String? driverId,
    String? aramcoInvoiceUrl,
    double? finalPrice,
    String? rejectionReason,
    Map<String, dynamic>? pricing,
    Map<String, dynamic>? coordinates,
  }) {
    return FuelTransferRequest(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      company: company ?? this.company,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customerId: customerId ?? this.customerId,
      driverId: driverId ?? this.driverId,
      aramcoInvoiceUrl: aramcoInvoiceUrl ?? this.aramcoInvoiceUrl,
      finalPrice: finalPrice ?? this.finalPrice,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      pricing: pricing ?? this.pricing,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  @override
  String toString() {
    return 'FuelTransferRequest(id: $id, orderNumber: $orderNumber, company: $company, quantity: $quantity, status: $status)';
  }
}