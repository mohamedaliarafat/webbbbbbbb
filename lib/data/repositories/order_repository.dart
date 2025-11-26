import 'package:customer/data/datasources/remote_datasource.dart';
import '../models/fuel_order_model.dart';

class OrderRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  // ===================== طلبات الوقود فقط =====================
  
  // إنشاء طلب وقود جديد
  Future<FuelOrderModel> createFuelOrder(Map<String, dynamic> orderData) async {
    try {
      print('🔄 إرسال طلب وقود إلى الـ API...');
      print('📦 البيانات المرسلة: $orderData');
      
      final response = await _remoteDataSource.post('/orders', orderData);

      print('📡 استجابة الـ API: $response');

      if (response['success'] == true) {
        print('✅ تم إنشاء طلب الوقود بنجاح في قاعدة البيانات');
        return FuelOrderModel.fromJson(response['order']);
      } else {
        final error = response['error'] ?? response['message'] ?? 'Create fuel order failed';
        print('❌ خطأ من الـ API: $error');
        throw Exception(error);
      }
    } catch (e) {
      print('❌ خطأ في الاتصال: $e');
      throw Exception('Create fuel order error: $e');
    }
  }

  Future<FuelOrderModel> getFuelOrderById(String orderId) async {
  try {
    final response = await _remoteDataSource.get('/orders/$orderId');

    if (response['success'] == true) {
      final List orders = response['orders'] ?? [];
      if (orders.isNotEmpty) {
        return FuelOrderModel.fromJson(orders.first);
      } else {
        throw Exception('Order not found');
      }
    } else {
      throw Exception(response['error'] ?? 'Get fuel order failed');
    }
  } catch (e) {
    throw Exception('Get fuel order error: $e');
  }
}


  

  // الحصول على جميع طلبات الوقود
  Future<List<FuelOrderModel>> getFuelOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'serviceType': 'fuel', // تصفية طلبات الوقود فقط
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) queryParams['status'] = status;

      final response = await _remoteDataSource.get(
        '/orders',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final List orders = response['orders'] ?? [];
        return orders.map((order) => FuelOrderModel.fromJson(order)).toList();
      } else {
        throw Exception(response['error'] ?? 'Get fuel orders failed');
      }
    } catch (e) {
      throw Exception('Get fuel orders error: $e');
    }
  }

  // الحصول على طلب وقود محدد
  Future<FuelOrderModel> getFuelOrder(String orderId) async {
    try {
      final response = await _remoteDataSource.get('/orders/$orderId');

      if (response['success'] == true) {
        return FuelOrderModel.fromJson(response['order']);
      } else {
        throw Exception(response['error'] ?? 'Get fuel order failed');
      }
    } catch (e) {
      throw Exception('Get fuel order error: $e');
    }
  }

  // تحديث حالة طلب الوقود
  Future<void> updateFuelOrderStatus(String orderId, String status, {String? notes}) async {
    try {
      final response = await _remoteDataSource.patch(
        '/orders/$orderId/status',
        {
          'status': status,
          if (notes != null) 'notes': notes,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update fuel order status failed');
      }
    } catch (e) {
      throw Exception('Update fuel order status error: $e');
    }
  }

  // تعيين سعر طلب الوقود
  Future<void> setFuelOrderPrice(String orderId, double finalPrice) async {
    try {
      final response = await _remoteDataSource.patch(
        '/orders/$orderId/price',
        {'finalPrice': finalPrice},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Set fuel order price failed');
      }
    } catch (e) {
      throw Exception('Set fuel order price error: $e');
    }
  }

  // تعيين سائق لطلب الوقود
  Future<void> assignDriverToFuelOrder(String orderId, String driverId) async {
    try {
      final response = await _remoteDataSource.patch(
        '/orders/$orderId/assign-driver',
        {'driverId': driverId},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Assign driver failed');
      }
    } catch (e) {
      throw Exception('Assign driver error: $e');
    }
  }

  // تحديث تتبع طلب الوقود
  Future<void> updateFuelOrderTracking(String orderId, Map<String, dynamic> trackingData) async {
    try {
      final response = await _remoteDataSource.patch(
        '/orders/$orderId/tracking',
        trackingData,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update fuel order tracking failed');
      }
    } catch (e) {
      throw Exception('Update fuel order tracking error: $e');
    }
  }

  // الحصول على إحصائيات طلبات الوقود
  Future<Map<String, dynamic>> getFuelOrdersStats() async {
    try {
      final response = await _remoteDataSource.get(
        '/orders/stats',
        queryParams: {'serviceType': 'fuel'},
      );

      if (response['success'] == true) {
        return response['stats'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'Get fuel orders stats failed');
      }
    } catch (e) {
      throw Exception('Get fuel orders stats error: $e');
    }
  }
}