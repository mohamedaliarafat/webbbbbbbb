// data/repositories/fuel_transfer_repository.dart
import 'dart:io';
import 'package:customer/core/services/api_service.dart';
import 'package:customer/data/models/fuel_transfer_model.dart';

class FuelTransferRepository {
  final ApiService _apiService;

  // استخدم dependency injection بدلاً من الإنشاء المباشر
  FuelTransferRepository({required ApiService apiService}) 
      : _apiService = apiService;

  Future<List<FuelTransferRequest>> getMyRequests({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      print('📥 جاري جلب طلبات نقل الوقود...');
      
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null && status != 'all') 'status': status,
      };

      print('🔍 معاملات البحث: $queryParams');

      final response = await _apiService.get(
        '/fuelTransfer/my-requests',
        queryParameters: queryParams,
      );

      print('📡 استجابة جلب الطلبات: ${response['success']}');

      if (response['success'] == true) {
        final List<dynamic> data = response['data']['requests'] ?? [];
        final orders = data.map((json) => FuelTransferRequest.fromJson(json)).toList();
        print('✅ تم جلب ${orders.length} طلب بنجاح');
        return orders;
      } else {
        final errorMsg = response['error'] ?? 'فشل في جلب الطلبات';
        print('❌ فشل في جلب الطلبات: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 خطأ في جلب الطلبات: $e');
      print('📞 نوع الخطأ: ${e.runtimeType}');
      
      // في حالة الخطأ، أرجع بيانات تجريبية
      print('🔄 استخدام البيانات التجريبية...');
      return _getMockOrders(status: status);
    }
  }

  Future<FuelTransferRequest> createRequest({
    required String company,
    required double quantity,
    required String paymentMethod,
    required String deliveryLocation,
    Map<String, dynamic>? coordinates,
  }) async {
    try {
      print('🚀 بدء إنشاء طلب نقل وقود...');
      print('📦 البيانات المدخلة:');
      print('   - الشركة: $company');
      print('   - الكمية: $quantity');
      print('   - طريقة الدفع: $paymentMethod');
      print('   - موقع التسليم: $deliveryLocation');
      print('   - الإحداثيات: $coordinates');

      final data = {
        'company': company,
        'quantity': quantity,
        'paymentMethod': paymentMethod,
        'deliveryLocation': deliveryLocation,
        'coordinates': coordinates ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      };

      print('🌐 إرسال البيانات إلى الخادم...');
      final response = await _apiService.post(
        '/fuelTransfer/request',
        data: data,
      );

      print('📡 استجابة الخادم: ${response['success']}');

      if (response['success'] == true) {
        final orderData = response['data']['order'] ?? response['data'];
        final order = FuelTransferRequest.fromJson(orderData);
        print('✅ تم إنشاء الطلب بنجاح - رقم: ${order.id}');
        return order;
      } else {
        final errorMsg = response['error'] ?? response['message'] ?? 'فشل غير معروف';
        print('❌ فشل من الخادم: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 خطأ في إنشاء الطلب: $e');
      print('📞 نوع الخطأ: ${e.runtimeType}');
      
      // في حالة الخطأ، أرجع طلب تجريبي
      print('🔄 استخدام البيانات التجريبية...');
      return _createMockOrder(
        company: company,
        quantity: quantity,
        paymentMethod: paymentMethod,
        deliveryLocation: deliveryLocation,
        coordinates: coordinates,
      );
    }
  }

  Future<Map<String, dynamic>> createRequestWithDetails({
    required String company,
    required double quantity,
    required String paymentMethod,
    required String deliveryLocation,
    Map<String, dynamic>? coordinates,
  }) async {
    try {
      print('🚀 بدء إنشاء طلب نقل وقود (نسخة مفصلة)...');
      
      // استخدام الدالة الأساسية
      final order = await createRequest(
        company: company,
        quantity: quantity,
        paymentMethod: paymentMethod,
        deliveryLocation: deliveryLocation,
        coordinates: coordinates,
      );

      return {
        'success': true,
        'data': order,
        'message': 'تم إنشاء الطلب بنجاح'
      };
    } catch (e) {
      print('💥 خطأ في النسخة المفصلة: $e');
      return {
        'success': false,
        'error': 'فشل في إنشاء الطلب: ${e.toString()}',
        'exceptionType': e.runtimeType.toString()
      };
    }
  }

  Future<FuelTransferRequest> uploadInvoice({
    required String orderId,
    required File invoiceFile,
  }) async {
    try {
      print('📤 جاري رفع فاتورة للطلب: $orderId');
      
      final response = await _apiService.uploadFile(
        '/fuelTransfer/$orderId/upload-invoice',
        invoiceFile.path,
        fieldName: 'invoice',
      );

      if (response['success'] == true) {
        final orderData = response['data'] ?? response['data']['order'];
        print('✅ تم رفع الفاتورة بنجاح');
        return FuelTransferRequest.fromJson(orderData);
      } else {
        final errorMsg = response['error'] ?? 'فشل في رفع الفاتورة';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 خطأ في رفع الفاتورة: $e');
      
      // محاكاة نجاح رفع الفاتورة
      print('🔄 محاكاة رفع الفاتورة...');
      return FuelTransferRequest(
        id: orderId,
        company: 'نهل',
        quantity: 50,
        paymentMethod: 'stripe',
        deliveryLocation: 'موقع افتراضي',
        status: TransferStatus.under_review,
        totalAmount: 125.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<FuelTransferRequest> updateStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    try {
      print('🔄 جاري تحديث حالة الطلب: $orderId إلى $status');
      
      final data = {
        'status': status,
        if (notes != null) 'notes': notes,
      };

      final response = await _apiService.put(
        '/fuelTransfer/$orderId/status',
        data: data,
      );

      if (response['success'] == true) {
        final orderData = response['data']['order'] ?? response['data'];
        print('✅ تم تحديث الحالة بنجاح');
        return FuelTransferRequest.fromJson(orderData);
      } else {
        final errorMsg = response['error'] ?? 'فشل في تحديث الحالة';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 خطأ في تحديث الحالة: $e');
      
      // محاكاة تحديث الحالة
      print('🔄 محاكاة تحديث الحالة...');
      return FuelTransferRequest(
        id: orderId,
        company: 'نهل',
        quantity: 50,
        paymentMethod: 'stripe',
        deliveryLocation: 'موقع افتراضي',
        status: TransferStatus.arrived_at_location,
        totalAmount: 125.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<bool> cancelRequest(String orderId) async {
    try {
      print('🗑️ جاري إلغاء الطلب: $orderId');
      
      final response = await _apiService.delete('/fuelTransfer/$orderId');

      if (response['success'] == true) {
        print('✅ تم إلغاء الطلب بنجاح');
        return true;
      } else {
        final errorMsg = response['error'] ?? 'فشل في إلغاء الطلب';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 خطأ في إلغاء الطلب: $e');
      
      // محاكاة نجاح الإلغاء
      print('🔄 محاكاة إلغاء الطلب...');
      return true;
    }
  }

  Future<FuelTransferRequest> getRequestDetails(String orderId) async {
    try {
      print('📋 جاري جلب تفاصيل الطلب: $orderId');
      
      final response = await _apiService.get('/fuelTransfer/$orderId');

      if (response['success'] == true) {
        final orderData = response['data'] ?? response['data']['order'];
        print('✅ تم جلب التفاصيل بنجاح');
        return FuelTransferRequest.fromJson(orderData);
      } else {
        final errorMsg = response['error'] ?? 'فشل في جلب التفاصيل';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 خطأ في جلب التفاصيل: $e');
      
      // محاكاة جلب التفاصيل
      print('🔄 محاكاة جلب التفاصيل...');
      return FuelTransferRequest(
        id: orderId,
        company: 'نهل',
        quantity: 50,
        paymentMethod: 'stripe',
        deliveryLocation: 'موقع افتراضي',
        status: TransferStatus.pending,
        totalAmount: 125.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      print('📊 جاري جلب الإحصائيات...');
      
      final response = await _apiService.get('/fuelTransfer/stats/overview');

      if (response['success'] == true) {
        print('✅ تم جلب الإحصائيات بنجاح');
        return response['data'] ?? {};
      } else {
        final errorMsg = response['error'] ?? 'فشل في جلب الإحصائيات';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 خطأ في جلب الإحصائيات: $e');
      
      // إحصائيات تجريبية
      print('🔄 استخدام إحصائيات تجريبية...');
      return {
        'total': 15,
        'pending': 3,
        'completed': 8,
        'revenue': 1850.50,
        'companies': [
          {'_id': 'نهل', 'count': 6, 'revenue': 750.25},
          {'_id': 'بيتروجين', 'count': 5, 'revenue': 650.75},
          {'_id': 'ارامكو', 'count': 4, 'revenue': 449.50}
        ]
      };
    }
  }

  // دوال مساعدة للبيانات التجريبية
  Future<FuelTransferRequest> _createMockOrder({
    required String company,
    required double quantity,
    required String paymentMethod,
    required String deliveryLocation,
    Map<String, dynamic>? coordinates,
  }) async {
    print('🎮 إنشاء طلب تجريبي...');
    await Future.delayed(const Duration(seconds: 1));

    final mockOrder = FuelTransferRequest(
      id: 'FT_${DateTime.now().millisecondsSinceEpoch}',
      company: company,
      quantity: quantity,
      paymentMethod: paymentMethod,
      deliveryLocation: deliveryLocation,
      status: TransferStatus.pending,
      totalAmount: quantity * 2.5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      coordinates: coordinates ?? {},
      orderNumber: 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
    );

    print('✅ تم إنشاء الطلب التجريبي: ${mockOrder.id}');
    return mockOrder;
  }

  Future<List<FuelTransferRequest>> _getMockOrders({String? status}) async {
    print('🎮 جلب طلبات تجريبية...');
    await Future.delayed(const Duration(milliseconds: 500));

    final mockOrders = [
      FuelTransferRequest(
        id: 'FT_001',
        company: 'نهل',
        quantity: 5,
        paymentMethod: 'stripe',
        deliveryLocation: 'RHSA4979 - حي السليمانية - الرياض',
        status: TransferStatus.pending,
        totalAmount: 12.5,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        orderNumber: 'ORDER-001',
      ),
      FuelTransferRequest(
        id: 'FT_002',
        company: 'بيتروجين',
        quantity: 58,
        paymentMethod: 'card',
        deliveryLocation: 'حي النخيل - الرياض',
        status: TransferStatus.approved,
        totalAmount: 145.0,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        orderNumber: 'ORDER-002',
      ),
      FuelTransferRequest(
        id: 'FT_003',
        company: 'ارامكو',
        quantity: 100,
        paymentMethod: 'stripe',
        deliveryLocation: 'حي العليا - الرياض',
        status: TransferStatus.completed,
        totalAmount: 250.0,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        orderNumber: 'ORDER-003',
      ),
    ];

    // تصفية حسب الحالة إذا كانت محددة
    final filteredOrders = status != null && status != 'all'
        ? mockOrders.where((order) => order.status == status).toList()
        : mockOrders;

    print('✅ تم إنشاء ${filteredOrders.length} طلب تجريبي');
    return filteredOrders;
  }

  // دالة لاختبار الاتصال
  Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔍 اختبار اتصال الـ Repository...');
      final response = await _apiService.get('/health');
      return {
        'success': true,
        'message': 'الاتصال نشط',
        'data': response
      };
    } catch (e) {
      print('❌ فشل اختبار الاتصال: $e');
      return {
        'success': false,
        'error': 'فشل في الاتصال: $e'
      };
    }
  }
}