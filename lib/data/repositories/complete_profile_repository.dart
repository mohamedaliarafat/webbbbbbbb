import 'dart:io';
import 'package:customer/core/constants/api_endpoints.dart';
import 'package:customer/core/constants/app_constants.dart';
import 'package:customer/core/services/api_service.dart';
import 'package:customer/data/datasources/local_datasource.dart';
import 'package:customer/data/datasources/remote_datasource.dart';
import 'package:customer/data/models/complete_profile_model.dart';
import 'package:customer/services/firebase_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class CompleteProfileRepository {
  final ApiService _apiService = ApiService();
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();



Future<CompleteProfileModel> getCompleteProfile() async {
  try {
    final token = await _localDataSource.getToken();
    print('🔗 Getting complete profile...');

    final dio = Dio();
    final response = await dio.get(
      '${ApiEndpoints.baseUrl}/completeProfile/profile',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    print('📥 Response received: ${response.statusCode}');

    if (response.statusCode == 200) {
      // ✅ مباشرة بدون متغيرات وسيطة
      if (response.data['data'] != null) {
        return CompleteProfileModel.fromJson(response.data['data']);
      } else {
        return CompleteProfileModel.fromJson(response.data);
      }
    } 
    else if (response.statusCode == 404) {
      throw Exception('لا يوجد ملف شخصي');
    }
    else {
      throw Exception('فشل في الاتصال: ${response.statusCode}');
    }

  } catch (e) {
    print('❌ ERROR: $e');
    rethrow;
  }
}

  // ✅ إنشاء أو تحديث الملف الشخصي مع الرفع المباشر لـ Firebase
 Future<CompleteProfileModel> createOrUpdateProfile(Map<String, dynamic> profileData) async {
  try {
    // 1️⃣ جلب التوكن فقط (لا نحتاج userId في Body)
    final token = await _localDataSource.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('يجب تسجيل الدخول - التوكن غير موجود');
      
    }

    // 2️⃣ رفع الملفات إلى Firebase (نحتاج userId للمسار فقط)
    final String? userIdForPath = await _localDataSource.getUserId();
    if (userIdForPath == null || userIdForPath.isEmpty) {
      throw Exception('معرف المستخدم غير موجود');
    }

    final uploadedDocuments = <String, dynamic>{};
    final documents = profileData['documents'] ?? {};

    for (final entry in documents.entries) {
      final docType = entry.key;
      final filePath = entry.value['file']?.toString() ?? '';
      final documentNumber = entry.value['number']?.toString();
      final expiryDate = entry.value['expiryDate'];

      if (filePath.isNotEmpty && await File(filePath).exists()) {
        try {
          print('📤 جاري رفع ملف $docType إلى Firebase...');
          
          final fileUrl = await FirebaseStorageService.uploadFileToFirebase(
            File(filePath),
            customPath: 'users/$userIdForPath/documents/$docType/${DateTime.now().millisecondsSinceEpoch}',
          );

          print('✅ تم رفع $docType بنجاح');
          

          uploadedDocuments[docType] = {
            'file': fileUrl,
            if (documentNumber != null && documentNumber.isNotEmpty)
              'number': documentNumber,
            if (expiryDate != null)
              'expiryDate': expiryDate is DateTime ? expiryDate.toIso8601String() : expiryDate.toString(),
          };
        } catch (e) {
          print('❌ فشل في رفع $docType: $e');
          throw Exception('فشل في رفع ملف $docType: $e');
        }
      } else {
        uploadedDocuments[docType] = {
          if (documentNumber != null && documentNumber.isNotEmpty)
            'number': documentNumber,
          if (expiryDate != null)
            'expiryDate': expiryDate is DateTime ? expiryDate.toIso8601String() : expiryDate.toString(),
        };
      }
    }

    // 3️⃣ إعداد البيانات النهائية بدون حقل "user"
    final requestData = {
      // ❌ إزالة حقل "user" تماماً لأن السيرفر يأخذه من JWT
      "companyName": profileData['companyName']?.toString() ?? '',
      "email": profileData['email']?.toString() ?? '',
      "contactPerson": profileData['contactPerson']?.toString() ?? '',
      "contactPhone": profileData['contactPhone']?.toString() ?? '',
      "contactPosition": profileData['contactPosition']?.toString() ?? '',
      "documents": uploadedDocuments,
      "profileStatus": "submitted",
      if (profileData['vehicleInfo'] != null) "vehicleInfo": profileData['vehicleInfo'],
      if (profileData['nationalAddress'] != null) "nationalAddress": profileData['nationalAddress'],
    };

    print('📦 Request Body النهائي (بدون userId): $requestData');

    // 4️⃣ إرسال البيانات بدون userId في Body
    final response = await _apiService.dio.post(
      '${ApiEndpoints.baseUrl}/completeProfile/profile-submit',
      data: requestData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    print('📥 API Response Code: ${response.statusCode}');
    print('📥 API Response Body: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CompleteProfileModel.fromJson(response.data['data'] ?? response.data);
    } else {
      final errorMsg = response.data['message'] ?? 'فشل في إرسال البيانات';
      print('❌ Server Error: $errorMsg');
      throw Exception(errorMsg);
    }
  } catch (e) {
    print('❌ Error in createOrUpdateProfile: $e');
    rethrow;
  }
}

  // ✅ رفع ملف منفرد إلى Firebase وإرجاع الرابط
  Future<String> uploadFileToFirebase(File file, {String? documentType, String? userId}) async {
    try {
      final currentUserId = userId ?? await _localDataSource.getUserId();
      final docType = documentType ?? 'general';
      
      return await FirebaseStorageService.uploadFileToFirebase(
        file,
        customPath: 'users/$currentUserId/documents/$docType/${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      throw Exception('فشل في رفع الملف إلى Firebase: $e');
    }
  }

  // ✅ رفع مستندات متعددة إلى Firebase
  Future<Map<String, dynamic>> uploadMultipleDocumentsToFirebase(Map<String, File> documents) async {
    try {
      final uploadedUrls = await FirebaseStorageService.uploadMultipleFiles(documents);
      
      // تحويل النتيجة إلى التنسيق المطلوب
      final result = <String, dynamic>{};
      for (var entry in uploadedUrls.entries) {
        result[entry.key] = {
          'file': entry.value,
          'uploadedAt': DateTime.now().toIso8601String(),
        };
      }
      
      return result;
    } catch (e) {
      throw Exception('فشل في رفع المستندات المتعددة إلى Firebase: $e');
    }
  }

  // ✅ تحديث مستند معين مع الرفع إلى Firebase
  Future<CompleteProfileModel> updateDocumentWithFirebase({
    required String documentType,
    required File file,
    String? documentNumber,
    DateTime? expiryDate,
  }) async {
    try {
      final token = await _localDataSource.getToken();
      if (token == null || token.isEmpty) throw Exception('يجب تسجيل الدخول');

      final userId = await _localDataSource.getUserId();
      if (userId == null) throw Exception('معرف المستخدم غير موجود');

      // رفع الملف إلى Firebase
      final fileUrl = await uploadFileToFirebase(file, documentType: documentType, userId: userId);

      // إعداد بيانات المستند للتحديث
      final documentData = {
        'file': fileUrl,
        if (documentNumber != null && documentNumber.isNotEmpty)
          'number': documentNumber,
        if (expiryDate != null)
          'expiryDate': expiryDate.toIso8601String(),
      };

      // إرسال التحديث إلى السيرفر
      final response = await _apiService.put(
        '${ApiEndpoints.completeProfile}/documents/$documentType',
        data: {'document': documentData},
      );

      return CompleteProfileModel.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('فشل في تحديث المستند: $e');
    }
  }

  // ✅ حذف ملف من Firebase
  Future<void> deleteFileFromFirebase(String fileUrl) async {
    try {
      await FirebaseStorageService.deleteFileFromFirebase(fileUrl);
    } catch (e) {
      throw Exception('فشل في حذف الملف من Firebase: $e');
    }
  }

  Future<void> submitProfileForReview(Map<String, dynamic> profileData) async {
    try {
      // 1️⃣ جلب معرف المستخدم من التخزين المحلي
      final userId = await LocalDataSource().getUserId();
      if (userId == null || userId.length != 24) {
        throw Exception('معرف المستخدم غير صالح');
      }

      // 2️⃣ جلب التوكن من التخزين المحلي
      final token = await _localDataSource.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }

      // 3️⃣ تجهيز البيانات للإرسال
      final requestData = {
        "user": userId,
        ...profileData, // باقي بيانات الملف الشخصي
      };

      print('البيانات النهائية للطلب: $requestData');

      // 4️⃣ إرسال الطلب باستخدام endpoint الصحيح
      final response = await _remoteDataSource.post(
        ApiEndpoints.completeProfile, // /profile-submit
        requestData,
      );

      print('Response from server: $response');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'فشل في إرسال الملف الشخصي للمراجعة');
      }

      print('تم إرسال الملف الشخصي للمراجعة بنجاح');

    } catch (e) {
      print("خطأ غير متوقع: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _uploadAllDocuments(Map<String, dynamic> documents) async {
    final uploadedDocs = <String, dynamic>{};

    for (final entry in documents.entries) {
      final docType = entry.key;
      final docData = entry.value;
      final filePath = docData['file']?.toString() ?? '';

      if (filePath.isNotEmpty && await File(filePath).exists()) {
        try {
          // ✅ استخدام الـ static method الجديدة
          final fileUrl = await FirebaseStorageService.uploadFileToFirebase(File(filePath));
          uploadedDocs[docType] = {
            'file': fileUrl,   // فقط الملف
          };
        } catch (e) {
          print('❌ Failed to upload $docType: $e');
          throw Exception('فشل في رفع ملف $docType: $e');
        }
      } else {
        // بدون number وبدون expiryDate
        uploadedDocs[docType] = {};
      }
    }

    return uploadedDocs;
  }

  // ✅ تحديث المستندات
  Future<CompleteProfileModel> updateDocuments(Map<String, dynamic> documentsData) async {
    try {
      final response = await _apiService.post(
        '/api/completeProfile/profile-submit',
        data: {
          'documents': documentsData['documents'] ?? {},
        },
      );
      return CompleteProfileModel.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('فشل في تحديث المستندات: $e');
    }
  }

  // ✅ رفع مستند واحد (الطريقة القديمة - للتوافق)
  Future<String> uploadDocument({
    required String documentType,
    required File file,
    String? documentNumber,
    DateTime? expiryDate,
  }) async {
    try {
      final formData = {
        'documentType': documentType,
        if (documentNumber != null && documentNumber.isNotEmpty)
          'documentNumber': documentNumber,
        if (expiryDate != null)
          'expiryDate': expiryDate.toIso8601String(),
      };

      final response = await _apiService.uploadFile(
        '${ApiEndpoints.completeProfile}/documents',
        file.path,
        formData: formData,
      );
      
      return response['fileUrl'] ?? response['url'] ?? response['documentUrl'] ?? '';
    } catch (e) {
      throw Exception('فشل في رفع المستند: $e');
    }
  }

  // ✅ رفع مستندات متعددة (الطريقة القديمة - للتوافق)
  Future<Map<String, dynamic>> uploadMultipleDocuments(Map<String, File> documents) async {
    try {
      final fileUrls = <String, dynamic>{};
      
      for (final entry in documents.entries) {
        final documentType = entry.key;
        final file = entry.value;
        
        final fileUrl = await uploadDocument(
          documentType: documentType,
          file: file,
        );
        fileUrls[documentType] = {
          'file': fileUrl,
          'uploadedAt': DateTime.now().toIso8601String(),
        };
      }

      return fileUrls;
    } catch (e) {
      throw Exception('فشل في رفع المستندات المتعددة: $e');
    }
  }

  // ✅ تحديث المعلومات الشخصية
  Future<CompleteProfileModel> updateProfileInfo(Map<String, dynamic> profileInfo) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.updateProfile,
        data: profileInfo,
      );
      return CompleteProfileModel.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('فشل في تحديث المعلومات الشخصية: $e');
    }
  }

  // ✅ تحديث معلومات المركبة
  Future<CompleteProfileModel> updateVehicleInfo(Map<String, dynamic> vehicleInfo) async {
    try {
      final response = await _apiService.put(
        '${ApiEndpoints.completeProfile}/vehicle',
        data: vehicleInfo,
      );
      return CompleteProfileModel.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('فشل في تحديث معلومات المركبة: $e');
    }
  }

  // ✅ حذف مستند
  Future<void> deleteDocument(String documentType) async {
    try {
      await _apiService.delete(
        '${ApiEndpoints.completeProfile}/documents/$documentType',
      );
    } catch (e) {
      throw Exception('فشل في حذف المستند: $e');
    }
  }

  // ✅ الحصول على حالة الملف الشخصي
  Future<String> getProfileStatus(String userId) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.completeProfile}/$userId/status');
      return response['profileStatus'] ?? 'not_found';
    } catch (e) {
      throw Exception('فشل في الحصول على حالة الملف الشخصي: $e');
    }
  }

  // ✅ التحقق من اكتمال الملف الشخصي
  Future<Map<String, dynamic>> checkProfileCompletion(String userId) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.completeProfile}/$userId/completion');
      return {
        'isComplete': response['isComplete'] ?? false,
        'missingFields': response['missingFields'] ?? [],
        'message': response['message'] ?? '',
      };
    } catch (e) {
      throw Exception('فشل في التحقق من اكتمال الملف الشخصي: $e');
    }
  }

  // ✅ الحصول على جميع الملفات الشخصية (للمسؤول)
  Future<List<CompleteProfileModel>> getAllProfiles({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };

      final response = await _apiService.get(
        '${ApiEndpoints.completeProfile}/admin/profiles',
        queryParameters: queryParams,
      );

      final List<dynamic> profilesData = response['data'] ?? [];
      return profilesData.map((data) => CompleteProfileModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception('فشل في جلب الملفات الشخصية: $e');
    }
  }

  // ✅ تحديث حالة توثيق مستند (للمسؤول)
  Future<CompleteProfileModel> updateDocumentVerification({
    required String profileId,
    required String documentType,
    required bool verified,
  }) async {
    try {
      final response = await _apiService.put(
        '${ApiEndpoints.completeProfile}/admin/$profileId/documents/$documentType/verify',
        data: {'verified': verified},
      );
      return CompleteProfileModel.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('فشل في تحديث حالة التوثيق: $e');
    }
  }

  // ✅ مراجعة الملف الشخصي (للمسؤول)
  Future<CompleteProfileModel> reviewProfile({
    required String profileId,
    required String status,
    String? rejectionReason,
    String? adminNotes,
  }) async {
    try {
      final response = await _apiService.put(
        '${ApiEndpoints.completeProfile}/admin/$profileId/review',
        data: {
          'status': status,
          if (rejectionReason != null) 'rejectionReason': rejectionReason,
          if (adminNotes != null) 'adminNotes': adminNotes,
        },
      );
      return CompleteProfileModel.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('فشل في مراجعة الملف الشخصي: $e');
    }
  }

  // ✅ الحصول على إحصائيات الملفات الشخصية (للمسؤول)
  Future<Map<String, dynamic>> getProfileStats() async {
    try {
      final response = await _apiService.get('${ApiEndpoints.completeProfile}/admin/stats');
      return response['data'] ?? {};
    } catch (e) {
      throw Exception('فشل في جلب إحصائيات الملفات الشخصية: $e');
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      print('📤 Uploading file: ${file.path}');
      
      // 🔍 تحقق من وجود التوكن - استخدام LocalDataSource
      final token = await _localDataSource.getToken();
      print('🔑 Token exists: ${token != null && token.isNotEmpty}');
      if (token != null) {
        print('🔑 Token length: ${token.length}');
      } else {
        print('❌ No token found in LocalDataSource');
      }
      
      final fullUrl = '${ApiEndpoints.baseUrl}/completeProfile/upload-document';
      print('🔗 Full URL: $fullUrl');

      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(
          file.path,
          filename: 'file_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}',
        ),
      });

      final response = await _apiService.dio.post(
        fullUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('📥 Upload response: ${response.data}');
      
      if (response.data['success'] == true) {
        return response.data['data']['filename'] ?? response.data['data']['path'] ?? '';
      } else {
        throw Exception('فشل في رفع الملف: ${response.data['message']}');
      }
    } catch (e) {
      print('❌ Upload file error: $e');
      throw Exception('فشل في رفع الملف: $e');
    }
  }

  // ✅ بديل: استخدم الـ uploadFile الموجود في ApiService مباشرة
  Future<String> uploadFileUsingApiService(File file) async {
    try {
      print('📤 Uploading file using ApiService: ${file.path}');

      // ✅ احصل على التوكن أولاً
      final token = await _localDataSource.getToken();
      
      final response = await _apiService.uploadFile(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.getUploadFileUrl()}',
        file.path,
        fieldName: 'file',
      );

      print('📥 Upload response: $response');

      if (response['success'] == true) {
        final fileData = response['data'] ?? response;
        return fileData['filename'] ?? fileData['path'] ?? fileData['fileUrl'] ?? '';
      } else {
        throw Exception('فشل في رفع الملف: ${response['message']}');
      }
    } catch (e) {
      print('❌ Upload file error: $e');
      throw Exception('فشل في رفع الملف: $e');
    }
  }

  // ✅ بديل: رفع ملف وتحديث الملف الشخصي مباشرة
  Future<String> uploadAndUpdateFile({
    required File file,
    required String documentType,
    String? licenseNumber,
    DateTime? expiryDate,
  }) async {
    try {
      print('📤 Uploading and updating file: ${file.path}');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: '${documentType}_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}',
        ),
        'documentType': documentType,
        if (licenseNumber != null && licenseNumber.isNotEmpty)
          'licenseNumber': licenseNumber,
        if (expiryDate != null)
          'expiryDate': expiryDate.toIso8601String(),
      });

      final response = await _apiService.dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.getUploadAndUpdateUrl()}', // ✅ استخدم /upload-and-update
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('📥 Upload and update response: ${response.data}');

      if (response.data['success'] == true) {
        return response.data['data']['file']['filename'] ?? 
               response.data['data']['file']['path'] ?? 
               'تم الرفع بنجاح';
      } else {
        throw Exception('فشل في رفع وتحديث الملف: ${response.data['message']}');
      }
    } catch (e) {
      print('❌ Upload and update file error: $e');
      throw Exception('فشل في رفع وتحديث الملف: $e');
    }
  }

  // ✅ دالة مساعدة لتحويل البيانات إلى التنسيق المطلوب للـ API
  Map<String, dynamic> formatProfileDataForApi({
    required Map<String, dynamic> profileData,
    required Map<String, dynamic> documentsData,
    required Map<String, dynamic> vehicleData,
  }) {
    return {
      // البيانات الشخصية
      'companyName': profileData['companyName'] ?? '',
      'email': profileData['email'] ?? '',
      'contactPerson': profileData['contactPerson'] ?? '',
      'contactPhone': profileData['contactPhone'] ?? '',
      'contactPosition': profileData['contactPosition'] ?? '',
      
      // العنوان الوطني (إذا كان موجوداً)
      if (profileData['nationalAddress'] != null)
        'nationalAddress': profileData['nationalAddress'],
      
      // المستندات
      'documents': _formatDocumentsForApi(documentsData['documents'] ?? {}),
      
      // معلومات المركبة (إذا كانت موجودة)
      if (vehicleData.isNotEmpty)
        'vehicleInfo': _formatVehicleInfoForApi(vehicleData),
    };
  }

  // ✅ تنسيق بيانات المستندات للـ API
  Map<String, dynamic> _formatDocumentsForApi(Map<String, dynamic> documents) {
    final formattedDocs = <String, dynamic>{};
    
    for (final entry in documents.entries) {
      final docType = entry.key;
      final docData = entry.value;
      
      formattedDocs[docType] = {
        'file': docData['file'] ?? '',
        'number': docData['number'] ?? '',
        if (docData['expiryDate'] != null)
          'expiryDate': _parseDate(docData['expiryDate']),
      };
    }
    
    return formattedDocs;
  }

  // ✅ تنسيق بيانات المركبة للـ API
  Map<String, dynamic> _formatVehicleInfoForApi(Map<String, dynamic> vehicleData) {
    return {
      'type': vehicleData['vehicleType'] ?? '',
      'model': vehicleData['vehicleModel'] ?? '',
      'licensePlate': vehicleData['licensePlate'] ?? '',
      'color': vehicleData['vehicleColor'] ?? '',
      if (vehicleData['vehicleYear'] != null)
        'year': int.tryParse(vehicleData['vehicleYear'].toString()),
      if (vehicleData['insurance'] != null)
        'insurance': {
          'file': vehicleData['insurance']['file'] ?? '',
          if (vehicleData['insurance']['expiryDate'] != null)
            'expiryDate': _parseDate(vehicleData['insurance']['expiryDate']),
        },
    };
  }

  // ✅ دالة مساعدة لتحويل التاريخ
  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }
}