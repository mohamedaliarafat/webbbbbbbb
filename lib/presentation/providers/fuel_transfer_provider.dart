// providers/fuel_transfer_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:customer/data/models/fuel_transfer_model.dart';
import 'package:customer/data/repositories/fuel_transfer_repository.dart';
import 'package:customer/core/services/api_service.dart';

class FuelTransferProvider with ChangeNotifier {
  final FuelTransferRepository _repository;
  final ApiService _apiService;
  
  FuelTransferProvider({
    required FuelTransferRepository repository,
    required ApiService apiService,
  }) : _repository = repository, _apiService = apiService;

  List<FuelTransferRequest> _orders = [];
  bool _isLoading = false;
  String? _error;
  FuelTransferRequest? _currentRequest;

  List<FuelTransferRequest> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  FuelTransferRequest? get currentRequest => _currentRequest;

  // جلب طلبات المستخدم
  Future<void> fetchMyRequests({String? status}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('📥 جاري جلب طلبات نقل الوقود...');
      _orders = await _repository.getMyRequests(status: status);
      
      print('✅ تم جلب ${_orders.length} طلب بنجاح');
    } catch (e) {
      _error = 'فشل في جلب الطلبات: ${e.toString()}';
      print('❌ خطأ في جلب الطلبات: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // إنشاء طلب جديد
  Future<bool> createRequest({
    required String company,
    required double quantity,
    required String paymentMethod,
    required String deliveryLocation,
    Map<String, dynamic>? coordinates,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('🎯 بدء إنشاء طلب نقل وقود...');
      print('📦 البيانات المدخلة:');
      print('   - الشركة: $company');
      print('   - الكمية: $quantity');
      print('   - طريقة الدفع: $paymentMethod');
      print('   - موقع التسليم: $deliveryLocation');
      
      final newOrder = await _repository.createRequest(
        company: company,
        quantity: quantity,
        paymentMethod: paymentMethod,
        deliveryLocation: deliveryLocation,
        coordinates: coordinates,
      );

      // إضافة الطلب الجديد للقائمة
      _orders.insert(0, newOrder);
      _currentRequest = newOrder;
      
      print('✅ تم إنشاء الطلب بنجاح - رقم الطلب: ${newOrder.id}');
      return true;
    } catch (e) {
      _error = 'فشل في إنشاء الطلب: ${e.toString()}';
      print('❌ خطأ في إنشاء الطلب: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // إنشاء طلب مع التحقق
  Future<bool> createRequestWithValidation({
    required String company,
    required double quantity,
    required String paymentMethod,
    required String deliveryLocation,
    Map<String, dynamic>? coordinates,
  }) async {
    // التحقق من البيانات أولاً
    if (!_validateRequestData(company, quantity, paymentMethod, deliveryLocation)) {
      return false;
    }

    // التحقق من الاتصال بالخادم
    final connection = await checkServerConnection();
    if (!connection['connected']) {
      _error = 'فشل في الاتصال بالخادم: ${connection['error']}';
      notifyListeners();
      return false;
    }

    // إنشاء الطلب
    return await createRequest(
      company: company,
      quantity: quantity,
      paymentMethod: paymentMethod,
      deliveryLocation: deliveryLocation,
      coordinates: coordinates,
    );
  }

  // التحقق من صحة البيانات
  bool _validateRequestData(
    String company,
    double quantity,
    String paymentMethod,
    String deliveryLocation,
  ) {
    if (company.isEmpty) {
      _error = 'يرجى اختيار الشركة';
      notifyListeners();
      return false;
    }

    if (quantity <= 0) {
      _error = 'الكمية يجب أن تكون أكبر من الصفر';
      notifyListeners();
      return false;
    }

    if (paymentMethod.isEmpty) {
      _error = 'يرجى اختيار طريقة الدفع';
      notifyListeners();
      return false;
    }

    if (deliveryLocation.isEmpty) {
      _error = 'يرجى إدخال موقع التوصيل';
      notifyListeners();
      return false;
    }

    return true;
  }

  // دالة التحقق من الاتصال
  Future<Map<String, dynamic>> checkServerConnection() async {
    try {
      print('🔍 التحقق من اتصال الخادم...');
      
      final connection = await _repository.testConnection();
      
      return {
        'connected': connection['success'] == true,
        'message': connection['message'] ?? 'الاتصال نشط',
        'timestamp': DateTime.now().toString()
      };
    } catch (e) {
      print('❌ فشل في التحقق: $e');
      return {
        'connected': false,
        'error': 'فشل في التحقق: ${e.toString()}',
        'timestamp': DateTime.now().toString()
      };
    }
  }

  // رفع فاتورة أرامكو
  Future<bool> uploadAramcoInvoice(String orderId, File invoiceFile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('📤 جاري رفع فاتورة أرامكو للطلب: $orderId');
      
      final updatedOrder = await _repository.uploadInvoice(
        orderId: orderId,
        invoiceFile: invoiceFile,
      );

      // تحديث الطلب في القائمة
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
        print('✅ تم تحديث الطلب بعد رفع الفاتورة');
      }
      
      _currentRequest = updatedOrder;

      return true;
    } catch (e) {
      _error = 'فشل في رفع الفاتورة: ${e.toString()}';
      print('❌ خطأ في رفع الفاتورة: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تحديث حالة الطلب
  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('🔄 جاري تحديث حالة الطلب $orderId إلى: $status');
      
      final updatedOrder = await _repository.updateStatus(
        orderId: orderId,
        status: status,
        notes: notes,
      );

      // تحديث الطلب في القائمة
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
        print('✅ تم تحديث حالة الطلب بنجاح');
      }
      
      _currentRequest = updatedOrder;

      return true;
    } catch (e) {
      _error = 'فشل في تحديث الحالة: ${e.toString()}';
      print('❌ خطأ في تحديث الحالة: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // إلغاء الطلب
  Future<bool> cancelOrder(String orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('🗑️ جاري إلغاء الطلب: $orderId');
      
      final success = await _repository.cancelRequest(orderId);
      
      if (success) {
        _orders.removeWhere((order) => order.id == orderId);
        if (_currentRequest?.id == orderId) {
          _currentRequest = null;
        }
        print('✅ تم إلغاء الطلب بنجاح');
      } else {
        print('❌ فشل في إلغاء الطلب من الخادم');
      }

      return success;
    } catch (e) {
      _error = 'فشل في إلغاء الطلب: ${e.toString()}';
      print('❌ خطأ في إلغاء الطلب: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // جلب تفاصيل طلب محدد
  Future<void> fetchOrderDetails(String orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('📋 جاري جلب تفاصيل الطلب: $orderId');
      
      _currentRequest = await _repository.getRequestDetails(orderId);
      
      print('✅ تم جلب تفاصيل الطلب بنجاح');
    } catch (e) {
      _error = 'فشل في جلب التفاصيل: ${e.toString()}';
      print('❌ خطأ في جلب التفاصيل: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // جلب الإحصائيات
  Future<Map<String, dynamic>?> fetchStats() async {
    try {
      print('📊 جاري جلب الإحصائيات...');
      
      final stats = await _repository.getStats();
      
      print('✅ تم جلب الإحصائيات بنجاح');
      return stats;
    } catch (e) {
      _error = 'فشل في جلب الإحصائيات: ${e.toString()}';
      print('❌ خطأ في جلب الإحصائيات: $e');
      return null;
    }
  }

  // جلب طلب محدد من القائمة المحلية
  FuelTransferRequest? getOrderById(String orderId) {
    try {
      return _orders.firstWhere(
        (order) => order.id == orderId,
      );
    } catch (e) {
      return null;
    }
  }

  // تحديث طلب محلي (للتحديثات الفورية)
  void updateOrderLocally(FuelTransferRequest updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      print('🔄 تم تحديث الطلب محلياً: ${updatedOrder.id}');
      notifyListeners();
    }
  }

  // إضافة طلب جديد محلياً
  void addOrderLocally(FuelTransferRequest newOrder) {
    _orders.insert(0, newOrder);
    print('➕ تم إضافة طلب جديد محلياً: ${newOrder.id}');
    notifyListeners();
  }

  // مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // مسح البيانات
  void clearData() {
    _orders.clear();
    _currentRequest = null;
    _error = null;
    notifyListeners();
  }

  // تحديث حالة التحميل
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // التحقق من وجود طلبات
  bool get hasOrders => _orders.isNotEmpty;

  // الحصول على عدد الطلبات حسب الحالة
  int getOrdersCountByStatus(String status) {
    return _orders.where((order) => order.status.name == status).length;
  }

  // الحصول على الطلبات حسب الحالة
  List<FuelTransferRequest> getOrdersByStatus(String status) {
    if (status == 'all') return _orders;
    return _orders.where((order) => order.status.name == status).toList();
  }

  // فحص حالة التطبيق
  Future<Map<String, dynamic>> checkAppStatus() async {
    print('🔍 فحص حالة التطبيق بالكامل...');
    
    final results = {
      'provider_initialized': _repository != null && _apiService != null,
      'has_orders': _orders.isNotEmpty,
      'last_error': _error,
      'is_loading': _isLoading,
      'current_request': _currentRequest != null,
      'orders_count': _orders.length,
      'timestamp': DateTime.now().toString(),
    };
    
    print('📊 نتائج الفحص: $results');
    return results;
  }
}