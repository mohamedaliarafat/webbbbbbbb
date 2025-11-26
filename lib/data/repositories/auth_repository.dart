import 'package:customer/data/datasources/local_datasource.dart';
import 'package:customer/data/datasources/remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../models/complete_profile_model.dart';

class AuthRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final FlutterSecureStorage _localDataSource = const FlutterSecureStorage();

  Future<UserModel> login(String phone, String password) async {
  try {
    final response = await _remoteDataSource.post(
      '/auth/login',
      {
        'phone': phone,
        'password': password,
      },
    );

    // طباعة الاستجابة كاملة للتأكد
    print('استجابة الـ login من السيرفر: $response');

    if (response['success'] == true) {
      final userData = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String;

      // حفظ التوكن
      await _remoteDataSource.saveToken(token);
      print('تم حفظ التوكن بنجاح: $token');

      // استخراج معرف المستخدم
      final String? userId = userData['_id']?.toString() ??
          userData['id']?.toString() ??
          userData['userId']?.toString() ??
          userData['user_id']?.toString() ??
          userData['uid']?.toString();

      if (userId == null || userId.isEmpty) {
        throw Exception('معرف المستخدم غير موجود في الاستجابة!');
      }

      print('تم استخراج معرف المستخدم: "$userId"');

      // حفظ اليوزر كامل في الـ LocalDataSource
      await LocalDataSource().saveUser(userData);
      print('تم حفظ بيانات اليوزر في LocalDataSource بنجاح');

      // إعادة بناء UserModel من البيانات المستلمة
      final user = UserModel.fromJson(userData);
      return user;
    } else {
      throw Exception(response['error'] ?? 'فشل تسجيل الدخول');
    }
  } catch (e) {
    print('خطأ في تسجيل الدخول: $e');
    if (e is DioException) {
      print('📌 Dio Error Response: ${e.response?.data}');
      print('📌 Dio Error Status: ${e.response?.statusCode}');
    }
    rethrow;
  }
}

  Future<UserModel> register(String phone, String password, String userType) async {
  try {
    final response = await _remoteDataSource.post(
      '/auth/register',
      {
        'phone': phone,
        'password': password,
        'userType': userType,
      },
    );

    if (response['success'] == true) {
      final userData = response['user'];
      final token = response['token'] as String;

      // 1. حفظ التوكن
      await _remoteDataSource.saveToken(token);

      // 2. طباعة كل البيانات اللي رجعت من السيرفر (مهم جدًا للتشخيص)
      print('استجابة التسجيل - كل بيانات اليوزر: $userData');

      // 3. استخراج الـ ID مهما كان اسمه في الاستجابة
      final String? extractedId = userData['_id']?.toString() ??
          userData['id']?.toString() ??
          userData['userId']?.toString() ??
          userData['user_id']?.toString() ??
          userData['uid']?.toString();

      print('تم استخراج الـ ID بنجاح: $extractedId');

      // 4. لو مفيش ID خالص → نوقف العملية ونعرف المشكلة
      if (extractedId == null || extractedId.isEmpty || extractedId == 'null') {
        print('تحذير: السيرفر لم يرسل معرف المستخدم!');
        // لسه هنحفظ اليوزر عادي، بس هنحذر
      }

      // 5. حفظ اليوزر كامل في الـ storage
      await LocalDataSource().saveUser(userData);

      // 6. إرجاع اليوزر
      final user = UserModel.fromJson(userData);
      return user;
    } else {
      throw Exception(response['error'] ?? 'فشل في التسجيل');
    }
  } catch (e) {
    print('خطأ في التسجيل: $e');
    throw Exception('فشل في التسجيل: $e');
  }
}

  Future<void> verifyPhone(String phone, String verificationCode) async {
    try {
      final response = await _remoteDataSource.post(
        '/auth/verify-phone',
        {
          'phone': phone,
          'verificationCode': verificationCode,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Verification failed');
      }
    } catch (e) {
      throw Exception('Phone verification error: $e');
    }
  }

  Future<void> resendVerification(String phone) async {
    try {
      final response = await _remoteDataSource.post(
        '/auth/resend-verification',
        {'phone': phone},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Resend failed');
      }
    } catch (e) {
      throw Exception('Resend verification error: $e');
    }
  }

  Future<void> completeProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _remoteDataSource.post(
        '/auth/complete-profile',
        profileData,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Complete profile failed');
      }
    } catch (e) {
      throw Exception('Complete profile error: $e');
    }
  }

  Future<void> uploadDocuments(Map<String, dynamic> documents) async {
    try {
      final response = await _remoteDataSource.post(
        '/auth/upload-documents',
        {'documents': documents},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Upload documents failed');
      }
    } catch (e) {
      throw Exception('Upload documents error: $e');
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _remoteDataSource.get('/auth/profile');

      if (response['success'] == true) {
        return UserModel.fromJson(response['user']);
      } else {
        throw Exception(response['error'] ?? 'Get profile failed');
      }
    } catch (e) {
      throw Exception('Get profile error: $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _remoteDataSource.put(
        '/auth/update-profile',
        updateData,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update profile failed');
      }
    } catch (e) {
      throw Exception('Update profile error: $e');
    }
  }

  Future<void> forgotPassword(String phone) async {
    try {
      final response = await _remoteDataSource.post(
        '/auth/forgot-password',
        {'phone': phone},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Forgot password failed');
      }
    } catch (e) {
      throw Exception('Forgot password error: $e');
    }
  }

  Future<void> resetPassword(String phone, String newPassword, String resetCode) async {
    try {
      final response = await _remoteDataSource.post(
        '/auth/reset-password',
        {
          'phone': phone,
          'newPassword': newPassword,
          'resetCode': resetCode,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Reset password failed');
      }
    } catch (e) {
      throw Exception('Reset password error: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _remoteDataSource.post('/auth/logout', {});
      await _remoteDataSource.clearToken();
    } catch (e) {
      await _remoteDataSource.clearToken();
      throw Exception('Logout error: $e');
    }
  }

  Future<UserModel> verifyToken() async {
    try {
      final response = await _remoteDataSource.get('/auth/verify-token');

      if (response['success'] == true) {
        return UserModel.fromJson(response['user']);
      } else {
        throw Exception(response['error'] ?? 'Token verification failed');
      }
    } catch (e) {
      throw Exception('Token verification error: $e');
    }
  }

  // ✅ دوال جديدة مضافة للتكامل مع CompleteProfileProvider

  // جلب الملف الشخصي المكتمل
  Future<CompleteProfileModel?> getCompleteProfile(String userId) async {
    try {
      final response = await _remoteDataSource.get('/users/$userId/complete-profile');

      if (response['success'] == true && response['completeProfile'] != null) {
        return CompleteProfileModel.fromJson(response['completeProfile']);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Get complete profile error: $e');
    }
  }

  // رفع ملف واحد
  Future<Map<String, dynamic>> uploadSingleDocument({
    required String documentType,
    required List<int> fileBytes,
    required String fileName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final response = await _remoteDataSource.uploadFile(
        '/auth/upload-single-document',
        fileBytes,
        fileName,
        additionalData: {
          'documentType': documentType,
          ...?additionalData,
        },
      );

      if (response['success'] == true) {
        return response['document'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'Upload document failed');
      }
    } catch (e) {
      throw Exception('Upload document error: $e');
    }
  }

  // تحديث حالة الملف الشخصي
  Future<void> updateProfileStatus(String status, {String? notes}) async {
    try {
      final response = await _remoteDataSource.patch(
        '/auth/update-profile-status',
        {
          'status': status,
          if (notes != null) 'notes': notes,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update profile status failed');
      }
    } catch (e) {
      throw Exception('Update profile status error: $e');
    }
  }

  // التحقق من حالة الملف الشخصي
  Future<Map<String, dynamic>> checkProfileStatus() async {
    try {
      final response = await _remoteDataSource.get('/auth/profile-status');

      if (response['success'] == true) {
        return response['status'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'Check profile status failed');
      }
    } catch (e) {
      throw Exception('Check profile status error: $e');
    }
  }

  // إرسال الملف الشخصي للمراجعة النهائية
  Future<void> submitProfileForReview() async {
    try {
      final response = await _remoteDataSource.post(
        '/auth/submit-profile-review',
        {},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Submit profile for review failed');
      }
    } catch (e) {
      throw Exception('Submit profile for review error: $e');
    }
  }

  // جلب قائمة المستندات المطلوبة
  Future<List<dynamic>> getRequiredDocuments() async {
    try {
      final response = await _remoteDataSource.get('/auth/required-documents');

      if (response['success'] == true) {
        return response['documents'] ?? [];
      } else {
        throw Exception(response['error'] ?? 'Get required documents failed');
      }
    } catch (e) {
      throw Exception('Get required documents error: $e');
    }
  }

  // تحديث بيانات المركبة
  Future<void> updateVehicleInfo(Map<String, dynamic> vehicleData) async {
    try {
      final response = await _remoteDataSource.put(
        '/auth/update-vehicle-info',
        vehicleData,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update vehicle info failed');
      }
    } catch (e) {
      throw Exception('Update vehicle info error: $e');
    }
  }

  // تحديث العنوان الوطني
  Future<void> updateNationalAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await _remoteDataSource.put(
        '/auth/update-national-address',
        addressData,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update national address failed');
      }
    } catch (e) {
      throw Exception('Update national address error: $e');
    }
  }

  // ✅ الدوال المساعدة للإدارة

  Future<bool> isLoggedIn() {
    return _remoteDataSource.hasToken();
  }

  Future<String?> getToken() {
    return _remoteDataSource.getToken();
  }

  Future<void> clearAuthData() async {
    await _remoteDataSource.clearToken();
    // await _remoteDataSource.clearUser();
  }

  // التحقق من اكتمال الملف الشخصي
  Future<bool> isProfileComplete() async {
    try {
      final response = await _remoteDataSource.get('/auth/profile-complete');

      if (response['success'] == true) {
        return response['isComplete'] ?? false;
      } else {
        throw Exception(response['error'] ?? 'Check profile complete failed');
      }
    } catch (e) {
      throw Exception('Check profile complete error: $e');
    }
  }

  // جلب تقدم إكمال الملف الشخصي
  Future<Map<String, dynamic>> getProfileProgress() async {
    try {
      final response = await _remoteDataSource.get('/auth/profile-progress');

      if (response['success'] == true) {
        return response['progress'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'Get profile progress failed');
      }
    } catch (e) {
      throw Exception('Get profile progress error: $e');
    }
  }
}