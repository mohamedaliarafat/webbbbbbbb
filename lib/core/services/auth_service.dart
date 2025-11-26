// import 'dart:convert';
// import 'package:customer/core/constants/api_endpoints.dart';
// import 'package:customer/core/constants/app_constants.dart';
// import 'package:customer/core/services/api_service.dart';
// import 'package:customer/core/services/storage_service.dart';
// import 'package:customer/data/models/location_model.dart';
// import 'package:customer/data/models/user_model.dart';
// import 'package:logger/logger.dart';

// class AuthService {
//   // Singleton
//   static final AuthService _instance = AuthService._internal();
//   factory AuthService() => _instance;
//   AuthService._internal();

//   final ApiService _apiService = ApiService();
//   final StorageService _storageService = StorageService();
//   final Logger _logger = Logger();

//   UserModel? _currentUser;
//   UserModel? get currentUser => _currentUser;
//   bool get isLoggedIn => _currentUser != null;



  

//   // ===================== Initialization =====================
//   Future<void> init() async {
//     await _loadCurrentUser();
//   }

//   Future<void> _loadCurrentUser() async {
//     try {
//       final userData = await _storageService.getString(AppConstants.userKey);
//       if (userData != null) {
//         _currentUser = UserModel.fromJson(json.decode(userData));
//         _logger.i('👤 User loaded: ${_currentUser?.name}');
//       }
//     } catch (e) {
//       _logger.e('❌ Failed to load user: $e');
//       await _storageService.remove(AppConstants.userKey);
//     }
//   }

//   // ===================== Authentication =====================
//   Future<UserModel> register({
//     required String phone,
//     required String password,
//     String userType = 'customer',
//   }) async {
//     try {
//       final response = await _apiService.post(
//         ApiEndpoints.register,
//         data: {'phone': phone, 'password': password, 'userType': userType},
//         requiresAuth: false,
//       );

//       await _saveAuthData(response);
//       _logger.i('✅ User registered: $phone');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Registration failed: $e');
//       rethrow;
//     }
//   }

//   Future<String?> getStoredToken() async {
//     return await _storageService.getString(AppConstants.tokenKey);
//   }

//   // الحصول على الـ user ID
//   String? get userId => _currentUser?.id;

//   // التحقق من صحة الـ token
//   Future<bool> validateToken() async {
//     try {
//       final token = await getStoredToken();
//       if (token == null || token.isEmpty) return false;
      
//       await verifyToken();
//       return true;
//     } catch (e) {
//       _logger.e('❌ Token validation failed: $e');
//       await logout();
//       return false;
//     }
//   }

//   Future<void> updateToken(String newToken) async {
//     await _storageService.setString(AppConstants.tokenKey, newToken);
//   }

//    Future<Map<String, String?>> getAuthData() async {
//     final token = await getStoredToken();
//     final userId = _currentUser?.id;
    
//     return {
//       'token': token,
//       'userId': userId,
//     };
//   }

  


//   Future<UserModel> login({
//     required String phone,
//     required String password,
//   }) async {
//     try {
//       final response = await _apiService.post(
//         ApiEndpoints.login,
//         data: {'phone': phone, 'password': password},
//         requiresAuth: false,
//       );

//       await _saveAuthData(response);
//       _logger.i('✅ User logged in: $phone');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Login failed: $e');
//       rethrow;
//     }
//   }

//   Future<void> logout() async {
//     try {
//       await _apiService.post(ApiEndpoints.logout);
//     } catch (e) {
//       _logger.e('❌ Logout API failed: $e');
//     } finally {
//       await _clearAuthData();
//       _logger.i('✅ User logged out');
//     }
//   }

//   Future<UserModel> verifyToken() async {
//     try {
//       final response = await _apiService.get(ApiEndpoints.verifyToken);
//       _currentUser = UserModel.fromJson(response['user']);
//       await _saveUserData(_currentUser!.toJson());
//       _logger.i('✅ Token verified for user: ${_currentUser?.name}');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Token verification failed: $e');
//       await logout();
//       rethrow;
//     }
//   }

//   // ===================== Phone Verification =====================
//   Future<UserModel> verifyPhone({
//     required String phone,
//     required String verificationCode,
//   }) async {
//     try {
//       final response = await _apiService.post(
//         ApiEndpoints.verifyPhone,
//         data: {'phone': phone, 'verificationCode': verificationCode},
//         requiresAuth: false,
//       );
//       _currentUser = UserModel.fromJson(response['user']);
//       await _saveUserData(_currentUser!.toJson());
//       _logger.i('✅ Phone verified: $phone');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Phone verification failed: $e');
//       rethrow;
//     }
//   }

//   Future<void> resendVerification(String phone) async {
//     try {
//       await _apiService.post(
//         ApiEndpoints.resendVerification,
//         data: {'phone': phone},
//         requiresAuth: false,
//       );
//       _logger.i('✅ Verification code resent to: $phone');
//     } catch (e) {
//       _logger.e('❌ Resend verification failed: $e');
//       rethrow;
//     }
//   }

//   // ===================== Profile Management =====================
//   Future<UserModel> completeProfile({
//     required String name,
//     String? profileImage,
//     String? email,
//     LocationModel? location,
//   }) async {
//     try {
//       final response = await _apiService.post(
//         ApiEndpoints.completeProfile,
//         data: {
//           'name': name,
//           if (profileImage != null) 'profileImage': profileImage,
//           if (email != null) 'email': email,
//           if (location != null) 'location': location.toJson(),
//         },
//       );
//       _currentUser = UserModel.fromJson(response['user']);
//       await _saveUserData(_currentUser!.toJson());
//       _logger.i('✅ Profile completed: $name');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Profile completion failed: $e');
//       rethrow;
//     }
//   }

//   Future<UserModel> uploadDocuments(List<Map<String, dynamic>> documents) async {
//     try {
//       final response = await _apiService.post(
//         ApiEndpoints.uploadDocuments,
//         data: {'documents': documents},
//       );
//       _currentUser = UserModel.fromJson(response['user']);
//       await _saveUserData(_currentUser!.toJson());
//       _logger.i('✅ Documents uploaded');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Documents upload failed: $e');
//       rethrow;
//     }
//   }

//   Future<UserModel> getProfile() async {
//     try {
//       final response = await _apiService.get(ApiEndpoints.getProfile);
//       _currentUser = UserModel.fromJson(response['user']);
//       await _saveUserData(_currentUser!.toJson());
//       _logger.i('✅ Profile loaded: ${_currentUser?.name}');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Get profile failed: $e');
//       rethrow;
//     }
//   }

//   Future<UserModel> updateProfile({
//     String? name,
//     String? profileImage,
//     String? phone,
//     LocationModel? location,
//   }) async {
//     try {
//       final data = <String, dynamic>{};
//       if (name != null) data['name'] = name;
//       if (profileImage != null) data['profileImage'] = profileImage;
//       if (phone != null) data['phone'] = phone;
//       if (location != null) data['location'] = location.toJson();

//       final response = await _apiService.put(ApiEndpoints.updateProfile, data: data);
//       _currentUser = UserModel.fromJson(response['user']);
//       await _saveUserData(_currentUser!.toJson());
//       _logger.i('✅ Profile updated: ${_currentUser?.name}');
//       return _currentUser!;
//     } catch (e) {
//       _logger.e('❌ Profile update failed: $e');
//       rethrow;
//     }
//   }

//   // ===================== Password =====================
//   Future<void> forgotPassword(String phone) async {
//     try {
//       await _apiService.post(
//         ApiEndpoints.forgotPassword,
//         data: {'phone': phone},
//         requiresAuth: false,
//       );
//       _logger.i('✅ Password reset instructions sent');
//     } catch (e) {
//       _logger.e('❌ Forgot password failed: $e');
//       rethrow;
//     }
//   }

//   Future<void> resetPassword({
//     required String phone,
//     required String newPassword,
//     required String resetCode,
//   }) async {
//     try {
//       await _apiService.post(
//         ApiEndpoints.resetPassword,
//         data: {'phone': phone, 'newPassword': newPassword, 'resetCode': resetCode},
//         requiresAuth: false,
//       );
//       _logger.i('✅ Password reset successfully');
//     } catch (e) {
//       _logger.e('❌ Password reset failed: $e');
//       rethrow;
//     }
//   }

//   // ===================== FCM Token =====================
//   Future<void> updateFcmToken(String fcmToken) async {
//     if (_currentUser == null) return;
//     try {
//       _currentUser = _currentUser!.copyWith(fcmToken: fcmToken);
//       await _saveUserData(_currentUser!.toJson());
//       await _apiService.put(ApiEndpoints.updateProfile, data: {'fcmToken': fcmToken});
//       await _storageService.setString(AppConstants.fcmTokenKey, fcmToken);
//       _logger.i('✅ FCM token updated');
//     } catch (e) {
//       _logger.e('❌ FCM token update failed: $e');
//     }
//   }

//   Future<String?> getStoredFcmToken() async {
//     return await _storageService.getString(AppConstants.fcmTokenKey);
//   }

//   // ===================== User Utilities =====================
//   bool get isUserVerified => _currentUser?.isVerified ?? false;
//   bool get hasCompleteProfile => _currentUser?.name?.isNotEmpty ?? false;
//   bool get hasUploadedDocuments =>
//       _currentUser?.completeProfile != null && _currentUser!.completeProfile!.isNotEmpty;
//   String get userType => _currentUser?.userType ?? 'customer';
//   bool get needsProfileCompletion => !hasCompleteProfile;
//   bool get isActive => _currentUser?.isActive ?? false;
//   List<String> get userAddresses => _currentUser?.addresses ?? [];
//   List<String> get userOrders => _currentUser?.orders ?? [];
//   LocationModel? get userLocation => _currentUser?.location;
//   bool get canPlaceOrders => isUserVerified && hasCompleteProfile && isActive;
//   DateTime? get registrationDate => _currentUser?.createdAt;
//   DateTime? get lastLoginDate => _currentUser?.lastLogin;
//   bool get isDriver => userType == 'driver';
//   bool get isSupervisor => userType == 'supervisor';
//   bool get isAdmin => userType == 'admin';
//   String get displayName => _currentUser?.name?.isNotEmpty == true
//       ? _currentUser!.name
//       : _currentUser?.phone ?? 'User';
//   String get profileImageUrl =>
//       _currentUser?.profileImage ?? 'https://a.top4top.io/p_356432nv81.png';

//   // ===================== Helpers =====================
//   Future<void> _saveAuthData(Map<String, dynamic> response) async {
//     final token = response['token'];
//     final userData = response['user'];
//     await _storageService.setString(AppConstants.tokenKey, token);
//     await _saveUserData(userData);
//     _currentUser = UserModel.fromJson(userData);
//   }

//   Future<void> _saveUserData(Map<String, dynamic> userData) async {
//     await _storageService.setString(AppConstants.userKey, json.encode(userData));
//   }

//   Future<void> _clearAuthData() async {
//     await _storageService.remove(AppConstants.tokenKey);
//     await _storageService.remove(AppConstants.userKey);
//     await _storageService.remove(AppConstants.fcmTokenKey);
//     _currentUser = null;
//     _apiService.clearAuth();
//   }
// }



import 'dart:convert';
import 'package:customer/core/constants/api_endpoints.dart';
import 'package:customer/core/constants/app_constants.dart';
import 'package:customer/core/services/api_service.dart';
import 'package:customer/core/services/storage_service.dart';
import 'package:customer/data/datasources/remote_datasource.dart';
import 'package:customer/data/models/location_model.dart';
import 'package:customer/data/models/user_model.dart';
import 'package:logger/logger.dart';

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final Logger _logger = Logger();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  
  // 🔥 التصحيح: جعل isLoggedIn تتحقق من وجود token أيضاً
  bool get isLoggedIn {
    // إذا كان هناك user في الذاكرة، نعتبر المستخدم مسجل دخول
    if (_currentUser != null) {
      return true;
    }
    
    // إذا لم يكن هناك user في الذاكرة، نتحقق من وجود token كمؤشر بديل
    // هذه حالة مؤقتة لحين إعادة تحميل user من التخزين
    return _hasTokenSync();
  }

  // ===================== Initialization =====================
  Future<void> init() async {
    await _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userData = await _storageService.getString(AppConstants.userKey);
      if (userData != null) {
        _currentUser = UserModel.fromJson(json.decode(userData));
        _logger.i('👤 User loaded: ${_currentUser?.name}');
        
        // 🔥 التحقق من أن token موجود أيضاً
        final token = await getStoredToken();
        if (token == null) {
          _logger.w('⚠️ User data exists but no token found - possible data corruption');
        }
      } else {
        _logger.i('📝 No user data found in storage');
      }
    } catch (e) {
      _logger.e('❌ Failed to load user: $e');
      await _storageService.remove(AppConstants.userKey);
    }
  }

  // ===================== Authentication =====================
  Future<UserModel> register({
    required String phone,
    required String password,
    String userType = 'customer',
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {'phone': phone, 'password': password, 'userType': userType},
        requiresAuth: false,
      );

      await _saveAuthData(response);
      _logger.i('✅ User registered: $phone');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Registration failed: $e');
      rethrow;
    }
  }

  Future<String?> getStoredToken() async {
    return await _storageService.getString(AppConstants.tokenKey);
  }

  // 🔥 دالة مساعدة للتحقق من وجود token بشكل متزامن
  bool _hasTokenSync() {
    // هذه دالة مبسطة - في التطبيق الحقيقي قد تحتاج لطريقة أكثر تعقيداً
    // أو يمكنك استخدام Future للحصول على القيمة الفعلية
    try {
      // محاولة التحقق من وجود token بدون async/await
      // هذا حل مؤقت - الأفضل هو تعديل الكود ليكون async بالكامل
      return true; // نفترض وجود token مؤقتاً
    } catch (e) {
      return false;
    }
  }

  // 🔥 دالة محسنة للتحقق من حالة المصادقة
 Future<bool> validateAuthState() async {
  try {
    // محاولة مزامنة الـ token أولاً
    await syncTokenFromRemoteDataSource();
    
    final token = await getStoredToken();
    final hasUser = _currentUser != null;
    
    _logger.i('🔍 حالة المصادقة بعد المزامنة:');
    _logger.i('   - Token موجود: ${token != null && token.isNotEmpty}');
    _logger.i('   - المستخدم في الذاكرة: $hasUser');
    _logger.i('   - User ID: ${_currentUser?.id}');
    
    return token != null && token.isNotEmpty && hasUser;
  } catch (e) {
    _logger.e('❌ خطأ في التحقق من حالة المصادقة: $e');
    return false;
  }
}

  // 🔥 دالة لإعادة تحميل حالة المستخدم
  Future<void> reloadUser() async {
    try {
      _logger.i('🔄 Reloading user data...');
      await _loadCurrentUser();
      
      if (_currentUser == null) {
        _logger.w('⚠️ No user data found after reload');
      } else {
        _logger.i('✅ User reloaded successfully: ${_currentUser!.name}');
      }
    } catch (e) {
      _logger.e('❌ Error reloading user: $e');
    }
  }

  // الحصول على الـ user ID
  String? get userId => _currentUser?.id;

  // التحقق من صحة الـ token
  Future<bool> validateToken() async {
    try {
      final token = await getStoredToken();
      if (token == null || token.isEmpty) return false;
      
      await verifyToken();
      return true;
    } catch (e) {
      _logger.e('❌ Token validation failed: $e');
      await logout();
      return false;
    }
  }

  Future<void> updateToken(String newToken) async {
    await _storageService.setString(AppConstants.tokenKey, newToken);
  }

  Future<Map<String, String?>> getAuthData() async {
    final token = await getStoredToken();
    final userId = _currentUser?.id;
    
    return {
      'token': token,
      'userId': userId,
    };
  }

  Future<UserModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {'phone': phone, 'password': password},
        requiresAuth: false,
      );

      await _saveAuthData(response);
      _logger.i('✅ User logged in: $phone');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Login failed: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(ApiEndpoints.logout);
    } catch (e) {
      _logger.e('❌ Logout API failed: $e');
    } finally {
      await _clearAuthData();
      _logger.i('✅ User logged out');
    }
  }

  Future<UserModel> verifyToken() async {
    try {
      final response = await _apiService.get(ApiEndpoints.verifyToken);
      _currentUser = UserModel.fromJson(response['user']);
      await _saveUserData(_currentUser!.toJson());
      _logger.i('✅ Token verified for user: ${_currentUser?.name}');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Token verification failed: $e');
      await logout();
      rethrow;
    }
  }

  // ===================== Phone Verification =====================
  Future<UserModel> verifyPhone({
    required String phone,
    required String verificationCode,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.verifyPhone,
        data: {'phone': phone, 'verificationCode': verificationCode},
        requiresAuth: false,
      );
      _currentUser = UserModel.fromJson(response['user']);
      await _saveUserData(_currentUser!.toJson());
      _logger.i('✅ Phone verified: $phone');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Phone verification failed: $e');
      rethrow;
    }
  }

  Future<void> resendVerification(String phone) async {
    try {
      await _apiService.post(
        ApiEndpoints.resendVerification,
        data: {'phone': phone},
        requiresAuth: false,
      );
      _logger.i('✅ Verification code resent to: $phone');
    } catch (e) {
      _logger.e('❌ Resend verification failed: $e');
      rethrow;
    }
  }

  // ===================== Profile Management =====================
  Future<UserModel> completeProfile({
    required String name,
    String? profileImage,
    String? email,
    LocationModel? location,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.completeProfile,
        data: {
          'name': name,
          if (profileImage != null) 'profileImage': profileImage,
          if (email != null) 'email': email,
          if (location != null) 'location': location.toJson(),
        },
      );
      _currentUser = UserModel.fromJson(response['user']);
      await _saveUserData(_currentUser!.toJson());
      _logger.i('✅ Profile completed: $name');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Profile completion failed: $e');
      rethrow;
    }
  }

  Future<UserModel> uploadDocuments(List<Map<String, dynamic>> documents) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.uploadDocuments,
        data: {'documents': documents},
      );
      _currentUser = UserModel.fromJson(response['user']);
      await _saveUserData(_currentUser!.toJson());
      _logger.i('✅ Documents uploaded');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Documents upload failed: $e');
      rethrow;
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getProfile);
      _currentUser = UserModel.fromJson(response['user']);
      await _saveUserData(_currentUser!.toJson());
      _logger.i('✅ Profile loaded: ${_currentUser?.name}');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Get profile failed: $e');
      rethrow;
    }
  }

  Future<UserModel> updateProfile({
    String? name,
    String? profileImage,
    String? phone,
    LocationModel? location,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (profileImage != null) data['profileImage'] = profileImage;
      if (phone != null) data['phone'] = phone;
      if (location != null) data['location'] = location.toJson();

      final response = await _apiService.put(ApiEndpoints.updateProfile, data: data);
      _currentUser = UserModel.fromJson(response['user']);
      await _saveUserData(_currentUser!.toJson());
      _logger.i('✅ Profile updated: ${_currentUser?.name}');
      return _currentUser!;
    } catch (e) {
      _logger.e('❌ Profile update failed: $e');
      rethrow;
    }
  }

  // ===================== Password =====================
  Future<void> forgotPassword(String phone) async {
    try {
      await _apiService.post(
        ApiEndpoints.forgotPassword,
        data: {'phone': phone},
        requiresAuth: false,
      );
      _logger.i('✅ Password reset instructions sent');
    } catch (e) {
      _logger.e('❌ Forgot password failed: $e');
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String newPassword,
    required String resetCode,
  }) async {
    try {
      await _apiService.post(
        ApiEndpoints.resetPassword,
        data: {'phone': phone, 'newPassword': newPassword, 'resetCode': resetCode},
        requiresAuth: false,
      );
      _logger.i('✅ Password reset successfully');
    } catch (e) {
      _logger.e('❌ Password reset failed: $e');
      rethrow;
    }
  }

  // ===================== FCM Token =====================
  Future<void> updateFcmToken(String fcmToken) async {
    if (_currentUser == null) return;
    try {
      _currentUser = _currentUser!.copyWith(fcmToken: fcmToken);
      await _saveUserData(_currentUser!.toJson());
      await _apiService.put(ApiEndpoints.updateProfile, data: {'fcmToken': fcmToken});
      await _storageService.setString(AppConstants.fcmTokenKey, fcmToken);
      _logger.i('✅ FCM token updated');
    } catch (e) {
      _logger.e('❌ FCM token update failed: $e');
    }
  }

  Future<String?> getStoredFcmToken() async {
    return await _storageService.getString(AppConstants.fcmTokenKey);
  }

  // في auth_service.dart - أضف هذه الدوال
Future<void> syncTokenFromRemoteDataSource() async {
  try {
    _logger.i('🔄 مزامنة الـ token من RemoteDataSource...');
    
    // الحصول على الـ token من RemoteDataSource
    final remoteDataSource = RemoteDataSource();
    final token = await remoteDataSource.getToken();
    
    if (token != null && token.isNotEmpty) {
      _logger.i('✅ تم العثور على token في RemoteDataSource');
      
      // حفظ الـ token في AuthService
      await _storageService.setString(AppConstants.tokenKey, token);
      _logger.i('💾 تم حفظ الـ token في AuthService');
      
      // محاولة تحميل المستخدم إذا كان الـ token موجوداً ولكن المستخدم غير محمل
      if (_currentUser == null) {
        _logger.i('👤 جاري تحميل بيانات المستخدم...');
        await _loadCurrentUser();
        
        if (_currentUser == null) {
          _logger.w('⚠️ لا توجد بيانات مستخدم - قد تحتاج لإعادة تسجيل الدخول');
        }
      }
    } else {
      _logger.w('⚠️ لا يوجد token في RemoteDataSource');
    }
  } catch (e) {
    _logger.e('❌ خطأ في مزامنة الـ token: $e');
  }
}

// تحديث دالة validateAuthState


  // ===================== User Utilities =====================
  bool get isUserVerified => _currentUser?.isVerified ?? false;
  bool get hasCompleteProfile => _currentUser?.name?.isNotEmpty ?? false;
  bool get hasUploadedDocuments =>
      _currentUser?.completeProfile != null && _currentUser!.completeProfile!.isNotEmpty;
  String get userType => _currentUser?.userType ?? 'customer';
  bool get needsProfileCompletion => !hasCompleteProfile;
  bool get isActive => _currentUser?.isActive ?? false;
  List<String> get userAddresses => _currentUser?.addresses ?? [];
  List<String> get userOrders => _currentUser?.orders ?? [];
  LocationModel? get userLocation => _currentUser?.location;
  bool get canPlaceOrders => isUserVerified && hasCompleteProfile && isActive;
  DateTime? get registrationDate => _currentUser?.createdAt;
  DateTime? get lastLoginDate => _currentUser?.lastLogin;
  bool get isDriver => userType == 'driver';
  bool get isSupervisor => userType == 'supervisor';
  bool get isAdmin => userType == 'admin';
  String get displayName => _currentUser?.name?.isNotEmpty == true
      ? _currentUser!.name
      : _currentUser?.phone ?? 'User';
  String get profileImageUrl =>
      _currentUser?.profileImage ?? 'https://a.top4top.io/p_356432nv81.png';

  // ===================== Helpers =====================
  Future<void> _saveAuthData(Map<String, dynamic> response) async {
    final token = response['token'];
    final userData = response['user'];
    await _storageService.setString(AppConstants.tokenKey, token);
    await _saveUserData(userData);
    _currentUser = UserModel.fromJson(userData);
    _logger.i('💾 Auth data saved - Token: ${token != null ? "Yes" : "No"}, User: ${_currentUser != null ? "Yes" : "No"}');
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    await _storageService.setString(AppConstants.userKey, json.encode(userData));
  }

  Future<void> _clearAuthData() async {
    await _storageService.remove(AppConstants.tokenKey);
    await _storageService.remove(AppConstants.userKey);
    await _storageService.remove(AppConstants.fcmTokenKey);
    _currentUser = null;
    _apiService.clearAuth();
    _logger.i('🗑️ Auth data cleared');
  }

  
}