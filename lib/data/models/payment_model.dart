import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String id;
  final String orderId;
  final String? userId;
  final String? userName;
  final double totalAmount;
  final String currency;
  final BankTransfer bankTransfer;
  final PaymentReceipt receipt;
  final String status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final String? adminNotes;
  final String? customerNotes;
  final DateTime? paymentInitiatedAt;
  final DateTime? proofSubmittedAt;
  final DateTime? verifiedAt;
  final String paymentMethod;
  final int attemptCount;
  final DateTime? lastAttemptAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentModel({
    required this.id,
    required this.orderId,
    this.userId,
    this.userName,
    required this.totalAmount,
    required this.currency,
    required this.bankTransfer,
    required this.receipt,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    this.adminNotes,
    this.customerNotes,
    this.paymentInitiatedAt,
    this.proofSubmittedAt,
    this.verifiedAt,
    required this.paymentMethod,
    required this.attemptCount,
    this.lastAttemptAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    // معالجة orderId - إذا كان String يحتوي على JSON، استخرج الـ id منه
    String orderIdString = _extractOrderId(json['orderId']);
    
    return PaymentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      orderId: orderIdString,
      userId: json['userId']?.toString(),
      userName: json['userName']?.toString(),
      totalAmount: _parseDouble(json['totalAmount']),
      currency: json['currency']?.toString() ?? 'SAR',
      bankTransfer: BankTransfer.fromJson(json['bankTransfer'] ?? {}),
      receipt: PaymentReceipt.fromJson(json['receipt'] ?? {}),
      status: json['status']?.toString() ?? 'pending',
      reviewedBy: json['reviewedBy']?.toString(),
      reviewedAt: _parseDateTime(json['reviewedAt']),
      rejectionReason: json['rejectionReason']?.toString(),
      adminNotes: json['adminNotes']?.toString(),
      customerNotes: json['customerNotes']?.toString(),
      paymentInitiatedAt: _parseDateTime(json['paymentInitiatedAt']),
      proofSubmittedAt: _parseDateTime(json['proofSubmittedAt']),
      verifiedAt: _parseDateTime(json['verifiedAt']),
      paymentMethod: json['paymentMethod']?.toString() ?? 'bank_transfer',
      attemptCount: _parseInt(json['attemptCount'] ?? 1),
      lastAttemptAt: _parseDateTime(json['lastAttemptAt']),
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  // دالة لاستخراج orderId من البيانات المعقدة
  static String _extractOrderId(dynamic orderIdValue) {
    if (orderIdValue == null) return '';
    
    // إذا كان نصاً عادياً
    if (orderIdValue is String) {
      // إذا كان النص يحتوي على JSON، حاول استخراج الـ id منه
      if (orderIdValue.contains('_id:')) {
        try {
          // استخراج الـ id من النص باستخدام regex
          final idMatch = RegExp(r"_id:\s*([a-f0-9]+)").firstMatch(orderIdValue);
          if (idMatch != null) return idMatch.group(1)!;
        } catch (e) {
          print('Error extracting id from string: $e');
        }
      }
      // إذا كان النص يحتوي على ObjectId مباشرة
      if (orderIdValue.length == 24 && RegExp(r'^[a-f0-9]+$').hasMatch(orderIdValue)) {
        return orderIdValue;
      }
      return orderIdValue;
    }
    
    // إذا كان كائن Map
    if (orderIdValue is Map) {
      return orderIdValue['_id']?.toString() ?? 
             orderIdValue['id']?.toString() ?? '';
    }
    
    return orderIdValue.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 1;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 1;
    return 1;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'totalAmount': totalAmount,
      'currency': currency,
      'bankTransfer': bankTransfer.toJson(),
      'receipt': receipt.toJson(),
      'status': status,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'adminNotes': adminNotes,
      'customerNotes': customerNotes,
      'paymentInitiatedAt': paymentInitiatedAt?.toIso8601String(),
      'proofSubmittedAt': proofSubmittedAt?.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'attemptCount': attemptCount,
      'lastAttemptAt': lastAttemptAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Getter للتوافق مع الكود القديم
  String get receiptUrl => receipt.file;

  // Getters للتحقق من وجود القيم
  bool get hasRejectionReason => rejectionReason != null && rejectionReason!.isNotEmpty;
  bool get hasAdminNotes => adminNotes != null && adminNotes!.isNotEmpty;
  bool get hasCustomerNotes => customerNotes != null && customerNotes!.isNotEmpty;
  bool get hasReviewedBy => reviewedBy != null && reviewedBy!.isNotEmpty;

  String get statusText {
    switch (status) {
      case 'pending':
        return 'قيد المراجعة';
      case 'verified':
        return 'تم التحقق';
      case 'rejected':
        return 'مرفوض';
      case 'under_review':
        return 'قيد المراجعة';
      default:
        return status;
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case 'bank_transfer':
        return 'تحويل بنكي';
      case 'mada':
        return 'مدى';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      default:
        return paymentMethod;
    }
  }

  bool get isPending => status == 'pending' || status == 'under_review';
  bool get isVerified => status == 'verified';
  bool get isRejected => status == 'rejected';
  bool get hasReceipt => receipt.file.isNotEmpty;

  String get formattedAmount {
    return '${totalAmount.toStringAsFixed(2)} $currency';
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        userId,
        userName,
        totalAmount,
        currency,
        bankTransfer,
        receipt,
        status,
        reviewedBy,
        reviewedAt,
        rejectionReason,
        adminNotes,
        customerNotes,
        paymentInitiatedAt,
        proofSubmittedAt,
        verifiedAt,
        paymentMethod,
        attemptCount,
        lastAttemptAt,
        createdAt,
        updatedAt,
      ];
}

class BankTransfer extends Equatable {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String iban;
  final DateTime? transferDate;
  final String referenceNumber;

  const BankTransfer({
    this.bankName = '',
    this.accountNumber = '',
    this.accountName = '',
    this.iban = '',
    this.transferDate,
    this.referenceNumber = '',
  });

  factory BankTransfer.fromJson(Map<String, dynamic> json) {
    return BankTransfer(
      bankName: json['bankName']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
      iban: json['iban']?.toString() ?? '',
      transferDate: PaymentModel._parseDateTime(json['transferDate']),
      referenceNumber: json['referenceNumber']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'iban': iban,
      'transferDate': transferDate?.toIso8601String(),
      'referenceNumber': referenceNumber,
    };
  }

  bool get hasBankInfo => bankName.isNotEmpty && accountNumber.isNotEmpty;

  @override
  List<Object?> get props => [
        bankName,
        accountNumber,
        accountName,
        iban,
        transferDate,
        referenceNumber,
      ];
}

class PaymentReceipt extends Equatable {
  final String file;
  final String fileName;
  final int fileSize;
  final DateTime? uploadedAt;

  const PaymentReceipt({
    this.file = '',
    this.fileName = '',
    this.fileSize = 0,
    this.uploadedAt,
  });

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) {
    return PaymentReceipt(
      file: json['file']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? '',
      fileSize: PaymentModel._parseInt(json['fileSize']),
      uploadedAt: PaymentModel._parseDateTime(json['uploadedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'fileName': fileName,
      'fileSize': fileSize,
      'uploadedAt': uploadedAt?.toIso8601String(),
    };
  }

  bool get hasFile => file.isNotEmpty;
  bool get isImageFile => file.toLowerCase().endsWith('.jpg') || 
                         file.toLowerCase().endsWith('.jpeg') || 
                         file.toLowerCase().endsWith('.png');

  @override
  List<Object?> get props => [file, fileName, fileSize, uploadedAt];
}