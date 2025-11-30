import 'dart:io';


import 'package:customer/data/datasources/local_datasource.dart';
import 'package:customer/data/models/complete_profile_model.dart';
import 'package:customer/data/repositories/complete_profile_repository.dart';

import 'package:flutter/foundation.dart';

class CompleteProfileProvider with ChangeNotifier {
  final CompleteProfileRepository _completeProfileRepository = CompleteProfileRepository();
  final LocalDataSource _localDataSource = LocalDataSource();
  
  CompleteProfileModel? _completeProfile;
  bool _isLoading = false;
  String _error = '';
  int _currentStep = 0;
  Map<String, dynamic> _profileData = {};
  Map<String, dynamic> _documentsData = {};
  Map<String, dynamic> _vehicleData = {};

  CompleteProfileModel? get completeProfile => _completeProfile;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get currentStep => _currentStep;
  Map<String, dynamic> get profileData => _profileData;
  Map<String, dynamic> get documentsData => _documentsData;
  Map<String, dynamic> get vehicleData => _vehicleData;

  // ✅ الحل: إضافة هذه الدوال الجديدة للمشكلة
  bool get isProfileComplete {
    return _completeProfile != null && _completeProfile!.profileStatus == 'approved';
  }
  
  String? get userProfileStatus {
    return _completeProfile?.profileStatus;
  }
  
  bool get hasProfile {
    return _completeProfile != null;
  }

  // ✅ دالة مساعدة للتحقق من التوكن
  Future<bool> _checkAuth() async {
    try {
      final token = await _localDataSource.getToken();
      final hasToken = token != null && token.isNotEmpty;
      
      print('🔑 Auth check in provider (LocalDataSource): ${hasToken ? "Token EXISTS (${token.length} chars)" : "NO token"}');
      print('🔑 Token key used: auth_token');
      
      return hasToken;
    } catch (e) {
      print('❌ Auth check error: $e');
      return false;
    }
  }

  // ✅ دالة جديدة: طباعة حالة التوكن
  Future<void> debugTokenStatus() async {
    try {
      final tokenFromLocalDS = await _localDataSource.getToken();
      print('🔍 Debug - LocalDataSource Token: ${tokenFromLocalDS != null ? "EXISTS (${tokenFromLocalDS.length} chars)" : "NULL"}');
    } catch (e) {
      print('❌ Debug token error: $e');
    }
  }

  // تحميل بيانات الملف الشخصي
  Future<void> loadCompleteProfile() async {
  if (!await _checkAuth()) {
    _error = 'يجب تسجيل الدخول أولاً';
    notifyListeners();
    return;
  }

  _isLoading = true;
  _error = '';
  notifyListeners();

  try {
    print('🔄 Loading complete profile...');
    
    try {
      _completeProfile = await _completeProfileRepository.getCompleteProfile();
      print('✅ Profile loaded: ${_completeProfile?.id}');
      _updateLocalDataFromProfile(_completeProfile!);
    } catch (e) {
      // ✅ لا نعرض خطأ إذا لم يكن هناك ملف شخصي (هذا طبيعي)
      if (e.toString().contains('لا يوجد ملف شخصي')) {
        print('ℹ️ No profile exists yet - this is normal');
        _completeProfile = null;
        _error = ''; // ❌ لا نعرض خطأ
      } else {
        rethrow; // ✅ نعيد throw الأخطاء الأخرى
      }
    }
    
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _isLoading = false;
    _error = 'فشل في تحميل الملف الشخصي: $e';
    print('❌ ERROR loading profile: $e');
    notifyListeners();
  }
}

  // تحديث البيانات الشخصية
  void updateProfileData(Map<String, dynamic> data) {
    _profileData.addAll(data);
    notifyListeners();
  }

  // تحديث بيانات المستندات
  void updateDocumentsData(Map<String, dynamic> data) {
    _documentsData.addAll(data);
    notifyListeners();
  }

  // تحديث بيانات المركبة
  void updateVehicleData(Map<String, dynamic> data) {
    _vehicleData.addAll(data);
    notifyListeners();
  }

  // الانتقال للخطوة التالية
  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  // الرجوع للخطوة السابقة
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // الانتقال لخطوة محددة
  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // ✅ رفع الملفات إلى Firebase مباشرة
  Future<Map<String, dynamic>> uploadDocumentsToFirebase(Map<String, dynamic> documents) async {
    if (!await _checkAuth()) {
      _error = 'يجب تسجيل الدخول أولاً';
      notifyListeners();
      return {};
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('📤 بدء رفع المستندات إلى Firebase...');
      
      final filesToUpload = <String, File>{};
      final documentsData = <String, dynamic>{};

      for (final entry in documents.entries) {
        final docType = entry.key;
        final docData = entry.value;
        final filePath = docData['file']?.toString() ?? '';

        documentsData[docType] = {
          if (docData['number'] != null) 'number': docData['number'],
          if (docData['expiryDate'] != null) 'expiryDate': docData['expiryDate'],
        };

        if (filePath.isNotEmpty && await File(filePath).exists()) {
          filesToUpload[docType] = File(filePath);
        }
      }

      if (filesToUpload.isNotEmpty) {
        final uploadResults = await _completeProfileRepository.uploadMultipleDocumentsToFirebase(filesToUpload);
        
        for (final entry in uploadResults.entries) {
          final docType = entry.key;
          final fileInfo = entry.value;
          
          documentsData[docType]['file'] = fileInfo['file'];
          documentsData[docType]['uploadedAt'] = fileInfo['uploadedAt'];
        }
      }

      _documentsData['documents'] = documentsData;
      
      _isLoading = false;
      notifyListeners();
      
      return documentsData;
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في رفع المستندات إلى Firebase: $e';
      notifyListeners();
      return {};
    }
  }

  // ✅ رفع ملف منفرد إلى Firebase
  Future<String?> uploadSingleFileToFirebase(String documentType, File file) async {
    if (!await _checkAuth()) {
      _error = 'يجب تسجيل الدخول أولاً';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('📤 رفع ملف $documentType إلى Firebase...');
      
      final fileUrl = await _completeProfileRepository.uploadFileToFirebase(
        file, 
        documentType: documentType
      );

      if (!_documentsData.containsKey('documents')) {
        _documentsData['documents'] = {};
      }
      
      if (_documentsData['documents'][documentType] == null) {
        _documentsData['documents'][documentType] = {};
      }
      
      _documentsData['documents'][documentType]['file'] = fileUrl;
      _documentsData['documents'][documentType]['uploadedAt'] = DateTime.now();

      _isLoading = false;
      notifyListeners();
      
      return fileUrl;
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في رفع الملف إلى Firebase: $e';
      notifyListeners();
      return null;
    }
  }

  // ✅ إرسال الملف الشخصي للمراجعة
  Future<bool> submitProfileForReview() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (!await _checkAuth()) {
        _error = 'يجب تسجيل الدخول أولاً. الرجاء تسجيل الدخول ثم إعادة المحاولة.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!_isPersonalInfoComplete()) {
        _error = 'يرجى إكمال المعلومات الشخصية أولاً';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!_isDocumentsComplete()) {
        _error = 'يرجى رفع جميع المستندات المطلوبة أولاً';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final completeData = {
        'companyName': _profileData['companyName'] ?? '',
        'email': _profileData['email'] ?? '',
        'contactPerson': _profileData['contactPerson'] ?? '',
        'contactPhone': _profileData['contactPhone'] ?? '',
        'contactPosition': _profileData['contactPosition'] ?? '',
        'documents': _documentsData['documents'] ?? {},
        'profileStatus': 'submitted',
        if (_vehicleData.isNotEmpty) 'vehicleInfo': _vehicleData,
        if (_profileData['nationalAddress'] != null) 
          'nationalAddress': _profileData['nationalAddress'],
      };

      print('🔄 إرسال الملف الشخصي مع روابط Firebase...');

      _completeProfile = await _completeProfileRepository.createOrUpdateProfile(completeData);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في إرسال الملف الشخصي للمراجعة: $e';
      print('❌ Provider Error: $_error');
      notifyListeners();
      return false;
    }
  }

  // ✅ حذف ملف من Firebase
  Future<bool> deleteFileFromFirebase(String fileUrl) async {
    try {
      await _completeProfileRepository.deleteFileFromFirebase(fileUrl);
      return true;
    } catch (e) {
      _error = 'فشل في حذف الملف: $e';
      notifyListeners();
      return false;
    }
  }

  // ✅ رفع المستندات
  Future<bool> uploadDocuments(Map<String, dynamic> documents) async {
    if (!await _checkAuth()) {
      _error = 'يجب تسجيل الدخول أولاً';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final uploadedDocuments = await uploadDocumentsToFirebase(documents);
      
      if (uploadedDocuments.isNotEmpty) {
        final response = await _completeProfileRepository.updateDocuments({
          'documents': uploadedDocuments,
        });
        
        _completeProfile = response;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('لم يتم رفع أي ملفات');
      }
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في رفع المستندات: $e';
      notifyListeners();
      return false;
    }
  }

  // ✅ الحصول على رابط ملف من Firebase
  String? getDocumentUrl(String documentType) {
    final docs = _documentsData['documents'] ?? {};
    final docData = docs[documentType];
    
    if (docData != null && docData['file'] != null) {
      final fileUrl = docData['file'].toString();
      if (fileUrl.contains('firebasestorage.googleapis.com')) {
        return fileUrl;
      }
    }
    return null;
  }

  // ✅ التحقق من أن الملف مرفوع على Firebase
  bool isDocumentUploadedToFirebase(String documentType) {
    final url = getDocumentUrl(documentType);
    return url != null && url.contains('firebasestorage.googleapis.com');
  }

  // حفظ البيانات الشخصية
  Future<bool> savePersonalInfo(Map<String, dynamic> personalInfo) async {
    if (!await _checkAuth()) {
      _error = 'يجب تسجيل الدخول أولاً';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _profileData.addAll(personalInfo);
      
      final formattedData = _completeProfileRepository.formatProfileDataForApi(
        profileData: _profileData,
        documentsData: _documentsData,
        vehicleData: _vehicleData,
      );
      
      _completeProfile = await _completeProfileRepository.createOrUpdateProfile(formattedData);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في حفظ المعلومات الشخصية: $e';
      notifyListeners();
      return false;
    }
  }

  // رفع وثيقة واحدة
  Future<bool> uploadSingleDocument({
    required String documentType,
    required String filePath,
    required String fileName,
    Map<String, dynamic>? additionalData,
  }) async {
    if (!await _checkAuth()) {
      _error = 'يجب تسجيل الدخول أولاً';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (!_documentsData.containsKey('documents')) {
        _documentsData['documents'] = {};
      }
      
      _documentsData['documents'][documentType] = {
        'file': filePath,
        'fileName': fileName,
        'uploadedAt': DateTime.now(),
        ...?additionalData,
      };
      
      final fileUrl = await _completeProfileRepository.uploadDocument(
        documentType: documentType,
        file: File(filePath),
        documentNumber: additionalData?['number'],
        expiryDate: additionalData?['expiryDate'] is String 
            ? DateTime.tryParse(additionalData!['expiryDate'])
            : additionalData?['expiryDate'],
      );
      
      _documentsData['documents'][documentType]['file'] = fileUrl;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في رفع الملف: $e';
      notifyListeners();
      return false;
    }
  }

  // حفظ معلومات المركبة
  Future<bool> saveVehicleInfo(Map<String, dynamic> vehicleInfo) async {
    if (!await _checkAuth()) {
      _error = 'يجب تسجيل الدخول أولاً';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _vehicleData.addAll(vehicleInfo);
      
      if (_vehicleData.isNotEmpty) {
        final response = await _completeProfileRepository.updateVehicleInfo(_vehicleData);
        _completeProfile = response;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في حفظ معلومات المركبة: $e';
      notifyListeners();
      return false;
    }
  }

  // التحقق من اكتمال الخطوة الحالية
  bool isCurrentStepComplete() {
    switch (_currentStep) {
      case 0:
        return _isPersonalInfoComplete();
      case 1:
        return _isDocumentsComplete();
      case 2:
        return true;
      default:
        return false;
    }
  }

  // التحقق من اكتمال المعلومات الشخصية
  bool _isPersonalInfoComplete() {
    return _profileData['companyName'] != null &&
        _profileData['companyName'].toString().isNotEmpty &&
        _profileData['email'] != null &&
        _profileData['email'].toString().isNotEmpty &&
        _profileData['contactPerson'] != null &&
        _profileData['contactPerson'].toString().isNotEmpty &&
        _profileData['contactPhone'] != null &&
        _profileData['contactPhone'].toString().isNotEmpty;
  }

  // التحقق من اكتمال المستندات
  bool _isDocumentsComplete() {
    final docs = _documentsData['documents'] ?? {};
    return docs['commercialLicense'] != null &&
        docs['energyLicense'] != null &&
        docs['commercialRecord'] != null &&
        docs['taxNumber'] != null &&
        docs['nationalAddressDocument'] != null &&
        docs['civilDefenseLicense'] != null;
  }

  // الحصول على حالة التقدم
  double getProgress() {
    int completedSteps = 0;
    
    if (_isPersonalInfoComplete()) completedSteps++;
    if (_isDocumentsComplete()) completedSteps++;
    
    return completedSteps / 2.0;
  }

  // الحصول على قائمة المستندات المطلوبة
  List<Map<String, dynamic>> getRequiredDocuments() {
    return [
      {
        'type': 'commercialLicense',
        'name': 'الرخصة التجارية',
        'description': 'رخصة مزاولة النشاط التجاري',
        'isRequired': true,
        'isUploaded': _isDocumentUploaded('commercialLicense'),
      },
      {
        'type': 'energyLicense',
        'name': 'رخصة الطاقة',
        'description': 'رخصة توزيع المواد البترولية',
        'isRequired': true,
        'isUploaded': _isDocumentUploaded('energyLicense'),
      },
      {
        'type': 'commercialRecord',
        'name': 'السجل التجاري',
        'description': 'شهادة السجل التجاري',
        'isRequired': true,
        'isUploaded': _isDocumentUploaded('commercialRecord'),
      },
      {
        'type': 'taxNumber',
        'name': 'الرقم الضريبي',
        'description': 'شهادة التسجيل الضريبي',
        'isRequired': true,
        'isUploaded': _isDocumentUploaded('taxNumber'),
      },
      {
        'type': 'nationalAddressDocument',
        'name': 'سجل العنوان الوطني',
        'description': 'وثيقة العنوان الوطني',
        'isRequired': true,
        'isUploaded': _isDocumentUploaded('nationalAddressDocument'),
      },
      {
        'type': 'civilDefenseLicense',
        'name': 'رخصة الدفاع المدني',
        'description': 'رخصة السلامة من الدفاع المدني',
        'isRequired': true,
        'isUploaded': _isDocumentUploaded('civilDefenseLicense'),
      },
    ];
  }

  // التحقق من رفع مستند معين
  bool _isDocumentUploaded(String documentType) {
    final docs = _documentsData['documents'] ?? {};
    return docs[documentType] != null && 
        docs[documentType]['file'] != null &&
        docs[documentType]['file'].toString().isNotEmpty;
  }

  // ✅ التحقق من حالة المصادقة
  Future<bool> isUserAuthenticated() async {
    return await _checkAuth();
  }

  // ✅ إعادة تحميل التوكن
  Future<void> reloadAuth() async {
    final isAuthenticated = await _checkAuth();
    if (!isAuthenticated) {
      _error = 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.';
      notifyListeners();
    }
  }

  // تحديث البيانات المحلية من الملف الشخصي
  void _updateLocalDataFromProfile(CompleteProfileModel profile) {
    _profileData = {
      'companyName': profile.companyName,
      'email': profile.email,
      'contactPerson': profile.contactPerson,
      'contactPhone': profile.contactPhone,
      'contactPosition': profile.contactPosition ?? '',
      'nationalAddress': profile.nationalAddress,
    };

    if (profile.documents != null) {
      _documentsData['documents'] = {
        'commercialLicense': {
          'file': profile.documents!.commercialLicense.file,
        },
        'energyLicense': {
          'file': profile.documents!.energyLicense.file,
        },
        'commercialRecord': {
          'file': profile.documents!.commercialRecord.file,
        },
        'taxNumber': {
          'file': profile.documents!.taxNumber.file,
        },
        'nationalAddressDocument': {
          'file': profile.documents!.nationalAddressDocument.file,
        },
        'civilDefenseLicense': {
          'file': profile.documents!.civilDefenseLicense.file,
        },
      };
    }

    if (profile.vehicleInfo != null) {
      _vehicleData = {
        'vehicleType': profile.vehicleInfo!.type,
        'vehicleModel': profile.vehicleInfo!.model,
        'licensePlate': profile.vehicleInfo!.licensePlate,
        'vehicleColor': profile.vehicleInfo!.color,
        'vehicleYear': profile.vehicleInfo!.year,
        'insurance': profile.vehicleInfo!.insurance != null ? {
          'file': profile.vehicleInfo!.insurance!.file,
        } : null,
      };
    }
  }

  // التحقق من وجود ملف شخصي مكتمل
  bool get hasCompleteProfile => _completeProfile != null;

  // الحصول على حالة الملف الشخصي
  String get profileStatus {
    if (_completeProfile == null) return 'not_started';
    return _completeProfile!.profileStatus;
  }

  // التحقق من الموافقة على الملف الشخصي
  bool get isProfileApproved {
    return _completeProfile?.profileStatus == 'approved';
  }

  // التحقق من رفض الملف الشخصي
  bool get isProfileRejected {
    return _completeProfile?.profileStatus == 'rejected';
  }

  // التحقق من أن الملف قيد المراجعة
  bool get isProfileUnderReview {
    return _completeProfile?.profileStatus == 'submitted' || 
           _completeProfile?.profileStatus == 'under_review';
  }

  // الحصول على سبب الرفض
  String get rejectionReason {
    return _completeProfile?.rejectionReason ?? '';
  }

  // الحصول على ملاحظات الإدارة
  String get adminNotes {
    return _completeProfile?.adminNotes ?? '';
  }

  // التحقق مما إذا كان المستخدم قد بدأ في إدخال بيانات المركبة
  bool get hasVehicleData {
    return _vehicleData.isNotEmpty && 
          (_vehicleData['vehicleType'] != null || 
           _vehicleData['vehicleModel'] != null || 
           _vehicleData['licensePlate'] != null);
  }

  // مسح بيانات المركبة
  void clearVehicleData() {
    _vehicleData = {};
    notifyListeners();
  }

  // مسح البيانات المؤقتة
  void clearTemporaryData() {
    _profileData = {};
    _documentsData = {};
    _vehicleData = {};
    _currentStep = 0;
    _error = '';
    notifyListeners();
  }

  // مسح الخطأ
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // إعادة تعيين الـ provider
  void reset() {
    _completeProfile = null;
    _isLoading = false;
    _error = '';
    _currentStep = 0;
    _profileData = {};
    _documentsData = {};
    _vehicleData = {};
    notifyListeners();
  }

  // تحديث بيانات الملف الشخصي من الـ API
  void updateFromApi(CompleteProfileModel profile) {
    _completeProfile = profile;
    _updateLocalDataFromProfile(profile);
    notifyListeners();
  }

  // التحقق من اكتمال الملف الشخصي للطلب
  bool get isProfileCompleteForOrder {
    return hasCompleteProfile && isProfileApproved;
  }

  // الحصول على رسالة حالة الملف الشخصي
  String get profileStatusMessage {
    if (_completeProfile == null) return 'لم يتم بدء الملف الشخصي';
    
    switch (_completeProfile!.profileStatus) {
      case 'draft':
        return 'الملف الشخصي قيد التعديل';
      case 'submitted':
        return 'الملف الشخصي مقدم للمراجعة';
      case 'under_review':
        return 'جاري مراجعة الملف الشخصي';
      case 'approved':
        return 'تمت الموافقة على الملف الشخصي';
      case 'rejected':
        return 'تم رفض الملف الشخصي';
      case 'needs_correction':
        return 'الملف الشخصي يحتاج إلى تصحيح';
      default:
        return 'حالة غير معروفة';
    }
  }

  // ✅ إعادة تعيين الخطوة بعد الإرسال بنجاح
  void resetStepAfterSubmission() {
    _currentStep = 0;
    notifyListeners();
  }

  // ✅ التحقق من صحة الخطوة الحالية
  bool get isCurrentStepValid {
    return _currentStep >= 0 && _currentStep <= 2;
  }
}