// في ملف driver_service.dart
import 'package:customer/core/services/api_service.dart';

class DriverService {
  final ApiService _apiService = ApiService();
  final Map<String, Map<String, dynamic>> _driverCache = {};

  Future<Map<String, dynamic>?> getDriverById(String driverId) async {
    try {
      // التحقق من الكاش أولاً
      if (_driverCache.containsKey(driverId)) {
        return _driverCache[driverId];
      }

      final response = await _apiService.get('/drivers/$driverId');
      
      if (response['success'] == true && response['data'] != null) {
        _driverCache[driverId] = response['data'];
        return response['data'];
      }
      return null;
    } catch (e) {
      print('❌ Error fetching driver: $e');
      return null;
    }
  }

  Future<String?> getDriverName(String driverId) async {
    try {
      final driverData = await getDriverById(driverId);
      if (driverData != null) {
        return driverData['name']?.toString();
      }
      return null;
    } catch (e) {
      print('❌ Error getting driver name: $e');
      return null;
    }
  }

  // للحصول على صورة السائق أيضاً
  Future<String?> getDriverImage(String driverId) async {
    try {
      final driverData = await getDriverById(driverId);
      if (driverData != null) {
        return driverData['profileImage']?.toString();
      }
      return null;
    } catch (e) {
      print('❌ Error getting driver image: $e');
      return null;
    }
  }

  // لمسح الكاش إذا احتجت
  void clearCache() {
    _driverCache.clear();
  }
}