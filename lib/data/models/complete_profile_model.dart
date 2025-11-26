import 'location_model.dart';

class CompleteProfileModel {
  final String id;
  final String user;
  final String companyName;
  final String email;
  final String contactPerson;
  final String contactPhone;
  final String contactPosition;
  final NationalAddress? nationalAddress;
  final ProfileDocuments? documents;
  final VehicleInfo? vehicleInfo;
  final String profileStatus;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String rejectionReason;
  final String adminNotes;
  final String userNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompleteProfileModel({
    required this.id,
    required this.user,
    required this.companyName,
    required this.email,
    required this.contactPerson,
    required this.contactPhone,
    this.contactPosition = '',
    this.nationalAddress,
    this.documents,
    this.vehicleInfo,
    this.profileStatus = 'draft',
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason = '',
    this.adminNotes = '',
    this.userNotes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompleteProfileModel.fromJson(Map<String, dynamic> json) {
    return CompleteProfileModel(
      id: json['_id'] ?? json['id'] ?? '',
      user: json['user']?.toString() ?? '',
      companyName: json['companyName'] ?? '',
      email: json['email'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      contactPosition: json['contactPosition'] ?? '',
      nationalAddress: json['nationalAddress'] != null
          ? NationalAddress.fromJson(json['nationalAddress'])
          : null,
      documents: json['documents'] != null
          ? ProfileDocuments.fromJson(json['documents'])
          : null,
      vehicleInfo: json['vehicleInfo'] != null
          ? VehicleInfo.fromJson(json['vehicleInfo'])
          : null,
      // ✅ تحديث قيم profileStatus لتتوافق مع Backend
      profileStatus: json['profileStatus'] ?? 'draft',
      reviewedBy: json['reviewedBy']?.toString(),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
      rejectionReason: json['rejectionReason'] ?? '',
      adminNotes: json['adminNotes'] ?? '',
      userNotes: json['userNotes'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      if (user.isNotEmpty) 'user': user,
      'companyName': companyName,
      'email': email,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      if (contactPosition.isNotEmpty) 'contactPosition': contactPosition,
      if (nationalAddress != null) 'nationalAddress': nationalAddress!.toJson(),
      if (documents != null) 'documents': documents!.toJson(),
      if (vehicleInfo != null) 'vehicleInfo': vehicleInfo!.toJson(),
      'profileStatus': profileStatus,
      if (reviewedBy != null) 'reviewedBy': reviewedBy,
      if (reviewedAt != null) 'reviewedAt': reviewedAt!.toIso8601String(),
      if (rejectionReason.isNotEmpty) 'rejectionReason': rejectionReason,
      if (adminNotes.isNotEmpty) 'adminNotes': adminNotes,
      if (userNotes.isNotEmpty) 'userNotes': userNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'companyName': companyName,
      'email': email,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      if (contactPosition.isNotEmpty) 'contactPosition': contactPosition,
      if (nationalAddress != null && nationalAddress!.address.isNotEmpty)
        'nationalAddress': {
          'address': nationalAddress!.address,
          'city': nationalAddress!.city,
          'district': nationalAddress!.district,
          'postalCode': nationalAddress!.postalCode,
          if (nationalAddress!.coordinates != null)
            'coordinates': {
              'lat': nationalAddress!.coordinates!.lat,
              'lng': nationalAddress!.coordinates!.lng,
              'address': nationalAddress!.coordinates!.address,
            },
        },
      'documents': _documentsToApiJson(),
      if (vehicleInfo != null && vehicleInfo!.type.isNotEmpty)
        'vehicleInfo': _vehicleInfoToApiJson(),
      // ✅ تحديث حالة الملف الشخصي للإرسال
      'profileStatus': 'submitted',
    };
  }

  Map<String, dynamic> _documentsToApiJson() {
    return {
      'commercialLicense': {
        'file': documents?.commercialLicense.file ?? '',
        'verified': documents?.commercialLicense.verified ?? false,
      },
      'energyLicense': {
        'file': documents?.energyLicense.file ?? '',
        'verified': documents?.energyLicense.verified ?? false,
      },
      'commercialRecord': {
        'file': documents?.commercialRecord.file ?? '',
        'verified': documents?.commercialRecord.verified ?? false,
      },
      'taxNumber': {
        'file': documents?.taxNumber.file ?? '',
        'verified': documents?.taxNumber.verified ?? false,
      },
      'nationalAddressDocument': {
        'file': documents?.nationalAddressDocument.file ?? '',
        'verified': documents?.nationalAddressDocument.verified ?? false,
      },
      'civilDefenseLicense': {
        'file': documents?.civilDefenseLicense.file ?? '',
        'verified': documents?.civilDefenseLicense.verified ?? false,
      },
    };
  }

  Map<String, dynamic> _vehicleInfoToApiJson() {
    return {
      'type': vehicleInfo!.type,
      'model': vehicleInfo!.model,
      if (vehicleInfo!.year != null) 'year': vehicleInfo!.year,
      'licensePlate': vehicleInfo!.licensePlate,
      'color': vehicleInfo!.color,
      if (vehicleInfo!.insurance != null &&
          vehicleInfo!.insurance!.file.isNotEmpty)
        'insurance': {
          'file': vehicleInfo!.insurance!.file,
          'verified': vehicleInfo!.insurance!.verified ?? false,
        },
    };
  }

  // ✅ دالة للتحقق من أن الملف الشخصي معتمد
  bool get isApproved => profileStatus == 'approved';
  
  // ✅ دالة للتحقق من أن الملف الشخصي مكتمل
  bool get isComplete => profileStatus == 'approved' || profileStatus == 'submitted';
  
  // ✅ دالة للتحقق من أن الملف الشخصي مرفوض
  bool get isRejected => profileStatus == 'rejected';
  
  // ✅ دالة للتحقق من أن الملف الشخصي قيد المراجعة
  bool get isUnderReview => profileStatus == 'under_review';
  
  // ✅ دالة للتحقق من أن الملف الشخصي يحتاج تصحيح
  bool get needsCorrection => profileStatus == 'needs_correction';

  List<String> validateForSubmission() {
    final errors = <String>[];
    if (companyName.isEmpty) errors.add('اسم الشركة مطلوب');
    if (email.isEmpty) errors.add('البريد الإلكتروني مطلوب');
    if (contactPerson.isEmpty) errors.add('اسم الشخص المسؤول مطلوب');
    if (contactPhone.isEmpty) errors.add('رقم الهاتف مطلوب');

    if (documents?.commercialLicense.file.isEmpty ?? true)
      errors.add('رخصة تجارية مطلوبة');
    if (documents?.energyLicense.file.isEmpty ?? true)
      errors.add('رخصة الطاقة مطلوبة');
    if (documents?.commercialRecord.file.isEmpty ?? true)
      errors.add('السجل التجاري مطلوب');
    if (documents?.taxNumber.file.isEmpty ?? true)
      errors.add('الرقم الضريبي مطلوب');
    if (documents?.nationalAddressDocument.file.isEmpty ?? true)
      errors.add('وثيقة العنوان الوطني مطلوبة');
    if (documents?.civilDefenseLicense.file.isEmpty ?? true)
      errors.add('رخصة الدفاع المدني مطلوبة');

    return errors;
  }
}

class NationalAddress {
  final String address;
  final String city;
  final String district;
  final String postalCode;
  final LocationModel? coordinates;

  NationalAddress({
    this.address = '',
    this.city = '',
    this.district = '',
    this.postalCode = '',
    this.coordinates,
  });

  factory NationalAddress.fromJson(Map<String, dynamic> json) {
    return NationalAddress(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      postalCode: json['postalCode'] ?? '',
      coordinates: json['coordinates'] != null
          ? LocationModel.fromJson(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'district': district,
      'postalCode': postalCode,
      if (coordinates != null) 'coordinates': coordinates!.toJson(),
    };
  }
}

class ProfileDocuments {
  final DocumentInfo commercialLicense;
  final DocumentInfo energyLicense;
  final DocumentInfo commercialRecord;
  final DocumentInfo taxNumber;
  final DocumentInfo nationalAddressDocument;
  final DocumentInfo civilDefenseLicense;

  ProfileDocuments({
    required this.commercialLicense,
    required this.energyLicense,
    required this.commercialRecord,
    required this.taxNumber,
    required this.nationalAddressDocument,
    required this.civilDefenseLicense,
  });

  factory ProfileDocuments.fromJson(Map<String, dynamic> json) {
    return ProfileDocuments(
      commercialLicense:
          DocumentInfo.fromJson(json['commercialLicense'] ?? {}),
      energyLicense: DocumentInfo.fromJson(json['energyLicense'] ?? {}),
      commercialRecord: DocumentInfo.fromJson(json['commercialRecord'] ?? {}),
      taxNumber: DocumentInfo.fromJson(json['taxNumber'] ?? {}),
      nationalAddressDocument:
          DocumentInfo.fromJson(json['nationalAddressDocument'] ?? {}),
      civilDefenseLicense:
          DocumentInfo.fromJson(json['civilDefenseLicense'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commercialLicense': commercialLicense.toJson(),
      'energyLicense': energyLicense.toJson(),
      'commercialRecord': commercialRecord.toJson(),
      'taxNumber': taxNumber.toJson(),
      'nationalAddressDocument': nationalAddressDocument.toJson(),
      'civilDefenseLicense': civilDefenseLicense.toJson(),
    };
  }
}

class DocumentInfo {
  final String file;
  final bool verified;

  DocumentInfo({
    this.file = '',
    this.verified = false,
  });

  factory DocumentInfo.fromJson(Map<String, dynamic> json) {
    return DocumentInfo(
      file: json['file'] ?? '',
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'verified': verified,
    };
  }
}

class VehicleInfo {
  final String type;
  final String model;
  final int? year;
  final String licensePlate;
  final String color;
  final VehicleInsurance? insurance;

  VehicleInfo({
    this.type = '',
    this.model = '',
    this.year,
    this.licensePlate = '',
    this.color = '',
    this.insurance,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      type: json['type'] ?? '',
      model: json['model'] ?? '',
      year: json['year'],
      licensePlate: json['licensePlate'] ?? '',
      color: json['color'] ?? '',
      insurance: json['insurance'] != null
          ? VehicleInsurance.fromJson(json['insurance'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'model': model,
      if (year != null) 'year': year,
      'licensePlate': licensePlate,
      'color': color,
      if (insurance != null) 'insurance': insurance!.toJson(),
    };
  }
}

class VehicleInsurance {
  final String file;
  final bool verified;

  VehicleInsurance({
    this.file = '',
    this.verified = false,
  });

  factory VehicleInsurance.fromJson(Map<String, dynamic> json) {
    return VehicleInsurance(
      file: json['file'] ?? '',
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'verified': verified,
    };
  }
}

CompleteProfileModel createNewCompleteProfile({
  required String userId,
  String companyName = '',
  String email = '',
  String contactPerson = '',
  String contactPhone = '',
  String contactPosition = '',
}) {
  return CompleteProfileModel(
    id: '',
    user: userId,
    companyName: companyName,
    email: email,
    contactPerson: contactPerson,
    contactPhone: contactPhone,
    contactPosition: contactPosition,
    nationalAddress: NationalAddress(),
    documents: ProfileDocuments(
      commercialLicense: DocumentInfo(),
      energyLicense: DocumentInfo(),
      commercialRecord: DocumentInfo(),
      taxNumber: DocumentInfo(),
      nationalAddressDocument: DocumentInfo(),
      civilDefenseLicense: DocumentInfo(),
    ),
    vehicleInfo: VehicleInfo(),
    profileStatus: 'draft',
    rejectionReason: '',
    adminNotes: '',
    userNotes: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}