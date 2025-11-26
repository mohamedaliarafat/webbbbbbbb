// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalDataSource {
//   static final LocalDataSource _instance = LocalDataSource._internal();
//   factory LocalDataSource() => _instance;
//   LocalDataSource._internal();
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//   static const String _tokenKey = 'auth_token';
//   static const String _userKey = 'user_data';
//   static const String _settingsKey = 'app_settings';

//   Future<String?> getUserId() async {
//   final userString = await _secureStorage.read(key: 'user');
//   if (userString == null) return null;

//   try {
//     final userMap = jsonDecode(userString) as Map<String, dynamic>;

//     // جرب كل الحقول اللي ممكن تكون فيها الـ ID
//     final id = userMap['_id'] ?? 
//                userMap['id'] ?? 
//                userMap['userId'] ?? 
//                userMap['user_id'] ?? 
//                userMap['uid'];

//     print('الـ ID المستخرج من اليوزر: "$id"');

//     return id?.toString();
//   } catch (e) {
//     print('خطأ في قراءة الـ userId: $e');
//     return null;
//   }
// }

  

//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenKey, token);
//   }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey);
//   }


//   Future<void> clearToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tokenKey);
//   }

//   Future<bool> hasToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.containsKey(_tokenKey);
//   }

//   Future<void> saveUser(Map<String, dynamic> user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userKey, jsonEncode(user));
//   }

//   Future<Map<String, dynamic>?> getUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userString = prefs.getString(_userKey);
//     if (userString != null) {
//       return jsonDecode(userString);
//     }
//     return null;
//   }

//   Future<void> clearUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_userKey);
//   }

//   Future<void> saveSettings(Map<String, dynamic> settings) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_settingsKey, jsonEncode(settings));
//   }

//   Future<Map<String, dynamic>?> getSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final settingsString = prefs.getString(_settingsKey);
//     if (settingsString != null) {
//       return jsonDecode(settingsString);
//     }
//     return null;
//   }

//   Future<void> clearAll() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }

//   // Address caching
//   Future<void> saveAddresses(List<Map<String, dynamic>> addresses) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_addresses', jsonEncode(addresses));
//   }

//   Future<List<Map<String, dynamic>>?> getAddresses() async {
//     final prefs = await SharedPreferences.getInstance();
//     final addressesString = prefs.getString('user_addresses');
//     if (addressesString != null) {
//       final List<dynamic> addressesList = jsonDecode(addressesString);
//       return addressesList.cast<Map<String, dynamic>>();
//     }
//     return null;
//   }

//   // Products caching
//   Future<void> saveProducts(List<Map<String, dynamic>> products) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('cached_products', jsonEncode(products));
//   }

//   Future<List<Map<String, dynamic>>?> getProducts() async {
//     final prefs = await SharedPreferences.getInstance();
//     final productsString = prefs.getString('cached_products');
//     if (productsString != null) {
//       final List<dynamic> productsList = jsonDecode(productsString);
//       return productsList.cast<Map<String, dynamic>>();
//     }
//     return null;
//   }

//   // Companies caching
//   Future<void> saveCompanies(List<Map<String, dynamic>> companies) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('cached_companies', jsonEncode(companies));
//   }

//   Future<List<Map<String, dynamic>>?> getCompanies() async {
//     final prefs = await SharedPreferences.getInstance();
//     final companiesString = prefs.getString('cached_companies');
//     if (companiesString != null) {
//       final List<dynamic> companiesList = jsonDecode(companiesString);
//       return companiesList.cast<Map<String, dynamic>>();
//     }
//     return null;
//   }

//   // Cache expiration
//   Future<bool> isCacheValid(String key, Duration maxAge) async {
//     final prefs = await SharedPreferences.getInstance();
//     final lastUpdate = prefs.getInt('${key}_last_update');
//     if (lastUpdate == null) return false;
    
//     final now = DateTime.now().millisecondsSinceEpoch;
//     return (now - lastUpdate) < maxAge.inMilliseconds;
//   }

//   Future<void> updateCacheTimestamp(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('${key}_last_update', DateTime.now().millisecondsSinceEpoch);
//   }



  
// }

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  // Singleton مضمون 100%
  static final LocalDataSource _instance = LocalDataSource._internal();
  factory LocalDataSource() => _instance;
  LocalDataSource._internal();

  // الحل السحري: lazy initialization بدون late ولا مشاكل
  SharedPreferences? _prefs;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _settingsKey = 'app_settings';

  // دالة داخلية تضمن تحميل SharedPreferences قبل أي استخدام
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // اختياري: لو عايز تستدعيها يدوي في main.dart
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('LocalDataSource: SharedPreferences تم تهيئته بنجاح');
  }

  // ====================== الدوال الأساسية ======================

  Future<void> saveUser(Map<String, dynamic> user) async {
    final p = await prefs;
    await p.setString(_userKey, jsonEncode(user));
    print('تم حفظ اليوزر بنجاح (id: ${user['id'] ?? user['_id']})');
  }

  Future<String?> getUserId() async {
  final p = await prefs;
  final userString = p.getString(_userKey);
  if (userString == null) return null;

  final userMap = jsonDecode(userString) as Map<String, dynamic>;

  // ID اسمه "id" في login response
  String? id = userMap['id']?.toString();

  if (id == null || id.isEmpty) return null;

  // تنظيف أي حروف غير hex
  id = id.replaceAll(RegExp(r'[^a-fA-F0-9]'), '');

  if (id.length != 24) {
    print('معرف المستخدم بعد التنظيف غير صالح: $id (طوله ${id.length})');
    return null;
  }

  print('تم جلب معرف المستخدم النهائي من الـ storage: $id');
  return id;
}


  Future<void> saveToken(String token) async {
    final p = await prefs;
    await p.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final p = await prefs;
    return p.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final p = await prefs;
    await p.remove(_tokenKey);
  }

  Future<bool> hasToken() async {
    final p = await prefs;
    return p.containsKey(_tokenKey);
  }

  // ====================== باقي الدوال (كلها شغالة بنفس الطريقة) ======================

  Future<void> clearUser() async {
    final p = await prefs;
    await p.remove(_userKey);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final p = await prefs;
    final str = p.getString(_userKey);
    return str != null ? jsonDecode(str) as Map<String, dynamic> : null;
  }

  Future<void> clearAll() async {
    final p = await prefs;
    await p.clear();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final p = await prefs;
    await p.setString(_settingsKey, jsonEncode(settings));
  }

  Future<Map<String, dynamic>?> getSettings() async {
    final p = await prefs;
    final str = p.getString(_settingsKey);
    return str != null ? jsonDecode(str) as Map<String, dynamic> : null;
  }

  Future<void> saveAddresses(List<Map<String, dynamic>> addresses) async {
    final p = await prefs;
    await p.setString('user_addresses', jsonEncode(addresses));
  }

  Future<List<Map<String, dynamic>>?> getAddresses() async {
    final p = await prefs;
    final str = p.getString('user_addresses');
    if (str == null) return null;
    final list = jsonDecode(str) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final p = await prefs;
    await p.setString('cached_products', jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>?> getProducts() async {
    final p = await prefs;
    final str = p.getString('cached_products');
    if (str == null) return null;
    final list = jsonDecode(str) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> saveCompanies(List<Map<String, dynamic>> companies) async {
    final p = await prefs;
    await p.setString('cached_companies', jsonEncode(companies));
  }

  Future<List<Map<String, dynamic>>?> getCompanies() async {
    final p = await prefs;
    final str = p.getString('cached_companies');
    if (str == null) return null;
    final list = jsonDecode(str) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<bool> isCacheValid(String key, Duration maxAge) async {
    final p = await prefs;
    final timestamp = p.getInt('${key}_last_update');
    if (timestamp == null) return false;
    return (DateTime.now().millisecondsSinceEpoch - timestamp) < maxAge.inMilliseconds;
  }

  Future<void> updateCacheTimestamp(String key) async {
    final p = await prefs;
    await p.setInt('${key}_last_update', DateTime.now().millisecondsSinceEpoch);
  }
}