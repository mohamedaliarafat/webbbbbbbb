// import 'package:customer/data/models/fuel_order_model.dart';
// import 'package:customer/data/repositories/order_repository.dart';
// import 'package:flutter/foundation.dart';

// class OrderProvider with ChangeNotifier {
//   final OrderRepository _orderRepository = OrderRepository();
  
//    List<FuelOrderModel> _fuelOrders = [];
//   FuelOrderModel? _selectedFuelOrder;
//   bool _isLoading = false;
//   String _error = '';
//   bool _isDisposed = false;
//   // 🔹 Getters
//   List<FuelOrderModel> get fuelOrders => _fuelOrders;
//   FuelOrderModel? get selectedFuelOrder => _selectedFuelOrder;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   OrderProvider();

//   // 🔹 تنظيف البيانات قبل الإرسال
//   Map<String, dynamic> _cleanOrderData(Map<String, dynamic> data) {
//     return _recursiveClean(data);
//   }

//   dynamic _recursiveClean(dynamic value) {
//     if (value is Map) {
//       final cleanedMap = <String, dynamic>{};
//       value.forEach((key, value) {
//         final cleanedValue = _recursiveClean(value);
//         if (cleanedValue != null) {
//           cleanedMap[key] = cleanedValue;
//         }
//       });
//       return cleanedMap.isEmpty ? null : cleanedMap;
//     } else if (value is List) {
//       final cleanedList = value.map(_recursiveClean).where((item) => item != null).toList();
//       return cleanedList.isEmpty ? null : cleanedList;
//     } else {
//       return value;
//     }
//   }

//   // ===================== جلب طلبات الوقود =====================
//   Future<void> loadFuelOrders({
//     String? status,
//     int page = 1,
//     int limit = 10,
//   }) async {
//     if (_isLoading) return;
    
//     _isLoading = true;
//     _error = '';
//     _safeNotifyListeners();

//     try {
//       _fuelOrders = await _orderRepository.getFuelOrders(
//         status: status,
//         page: page,
//         limit: limit,
//       );
//       print('✅ تم تحميل ${_fuelOrders.length} طلب وقود');
//     } catch (e) {
//       _error = 'فشل في تحميل طلبات الوقود: ${e.toString()}';
//       print('❌ خطأ في loadFuelOrders: $e');
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   // ===================== إنشاء طلب وقود جديد =====================
//   Future<FuelOrderModel> createFuelOrder(Map<String, dynamic> orderData) async {
//     _isLoading = true;
//     _error = '';
//     _safeNotifyListeners();

//     try {
//       print('🚀 بدء إنشاء طلب وقود جديد...');
      
//       // 🔹 تنظيف البيانات وإضافة serviceType
//       final cleanedData = _cleanOrderData({
//         ...orderData,
//         'serviceType': 'fuel', // تأكيد نوع الخدمة
//       }) ?? {};

//       print('📦 البيانات النظيفة المرسلة: $cleanedData');
      
//       final order = await _orderRepository.createFuelOrder(cleanedData);
      
//       // 🔹 إضافة الطلب الجديد للقائمة
//       _fuelOrders.insert(0, order);
      
//       print('✅ تم إنشاء طلب الوقود بنجاح: ${order.orderNumber}');
      
//       return order;
//     } catch (e) {
//       _error = 'فشل في إنشاء طلب الوقود: ${e.toString()}';
//       print('❌ خطأ في createFuelOrder: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   // ===================== تحميل طلب وقود محدد =====================
//   Future<void> loadFuelOrder(String orderId) async {
//     _isLoading = true;
//     _error = '';
//     _safeNotifyListeners();

//     try {
//       _selectedFuelOrder = await _orderRepository.getFuelOrder(orderId);
//       print('✅ تم تحميل طلب الوقود: ${_selectedFuelOrder?.orderNumber}');
//     } catch (e) {
//       _error = 'فشل في تحميل طلب الوقود: ${e.toString()}';
//       print('❌ خطأ في loadFuelOrder: $e');
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   // ===================== تحديث حالة طلب الوقود =====================
//   Future<void> updateFuelOrderStatus(String orderId, String status, {String? notes}) async {
//     _isLoading = true;
//     _error = '';
//     _safeNotifyListeners();

//     try {
//       await _orderRepository.updateFuelOrderStatus(orderId, status, notes: notes);

//       // 🔹 تحديث الحالة محلياً
//       final index = _fuelOrders.indexWhere((order) => order.id == orderId);
//       if (index != -1) {
//         _fuelOrders[index] = _fuelOrders[index].copyWith(status: status);
//       }
      
//       if (_selectedFuelOrder?.id == orderId) {
//         _selectedFuelOrder = _selectedFuelOrder!.copyWith(status: status);
//       }
      
//       print('✅ تم تحديث حالة طلب الوقود إلى: $status');
//     } catch (e) {
//       _error = 'فشل في تحديث حالة طلب الوقود: ${e.toString()}';
//       print('❌ خطأ في updateFuelOrderStatus: $e');
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   // ===================== تعيين سعر طلب الوقود =====================
//   Future<void> setFuelOrderPrice(String orderId, double finalPrice) async {
//     _isLoading = true;
//     _error = '';
//     _safeNotifyListeners();

//     try {
//       await _orderRepository.setFuelOrderPrice(orderId, finalPrice);
//       print('✅ تم تعيين سعر طلب الوقود: $finalPrice');
//     } catch (e) {
//       _error = 'فشل في تعيين سعر طلب الوقود: ${e.toString()}';
//       print('❌ خطأ في setFuelOrderPrice: $e');
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   // ===================== تعيين سائق لطلب الوقود =====================
//   Future<void> assignDriverToFuelOrder(String orderId, String driverId) async {
//     _isLoading = true;
//     _error = '';
//     _safeNotifyListeners();

//     try {
//       await _orderRepository.assignDriverToFuelOrder(orderId, driverId);
//       print('✅ تم تعيين السائق لطلب الوقود: $driverId');
//     } catch (e) {
//       _error = 'فشل في تعيين السائق: ${e.toString()}';
//       print('❌ خطأ في assignDriverToFuelOrder: $e');
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   // ===================== تحديد طلب وقود محدد =====================
//   void setSelectedFuelOrder(FuelOrderModel order) {
//     _selectedFuelOrder = order;
//     _safeNotifyListeners();
//   }

//   // ===================== دوال مساعدة =====================
//   void clearError() {
//     _error = '';
//     _safeNotifyListeners();
//   }

//   void clearFuelOrders() {
//     _fuelOrders = [];
//     _safeNotifyListeners();
//   }

//   void clearSelection() {
//     _selectedFuelOrder = null;
//     _safeNotifyListeners();
//   }

//   // 🔹 الحصول على طلبات الوقود حسب الحالة
//   List<FuelOrderModel> get pendingFuelOrders {
//     return _fuelOrders.where((order) => order.status == 'pending').toList();
//   }

//   List<FuelOrderModel> get approvedFuelOrders {
//     return _fuelOrders.where((order) => order.status == 'approved').toList();
//   }

//   List<FuelOrderModel> get completedFuelOrders {
//     return _fuelOrders.where((order) => order.status == 'completed').toList();
//   }

//   List<FuelOrderModel> get inProgressFuelOrders {
//     return _fuelOrders.where((order) => order.status == 'in_progress').toList();
//   }

//   // 🔹 الحصول على طلبات الوقود حسب نوع الوقود
//   List<FuelOrderModel> getFuelOrdersByType(String fuelType) {
//     return _fuelOrders.where((order) => order.fuelType == fuelType).toList();
//   }

//   // 🔹 إحصائيات
//   int get totalFuelOrdersCount => _fuelOrders.length;
//   int get pendingFuelOrdersCount => pendingFuelOrders.length;
//   int get completedFuelOrdersCount => completedFuelOrders.length;

//   // 🔹 الحصول على إحصائيات حسب نوع الوقود
//   Map<String, int> get fuelTypeStats {
//     final stats = <String, int>{};
//     for (final order in _fuelOrders) {
//       stats[order.fuelType] = (stats[order.fuelType] ?? 0) + 1;
//     }
//     return stats;
//   }

//   FuelOrderModel? get latestFuelOrder => _fuelOrders.isNotEmpty ? _fuelOrders.first : null;
  
//   bool get hasError => _error.isNotEmpty;

//   // 🔹 الحصول على إجمالي كمية الوقود
//   int get totalFuelLiters {
//     return _fuelOrders.fold(0, (sum, order) => sum + order.fuelLiters);
//   }

//   // 🔹 تحديث البيانات
//   Future<void> refreshFuelOrders() async {
//     await loadFuelOrders();
//   }

//   // 🔹 البحث في طلبات الوقود
//   List<FuelOrderModel> searchFuelOrders(String query) {
//     if (query.isEmpty) return _fuelOrders;
    
//     final lowerQuery = query.toLowerCase();
//     return _fuelOrders.where((order) =>
//       order.orderNumber.toLowerCase().contains(lowerQuery) ||
//       order.customerNotes.toLowerCase().contains(lowerQuery) ||
//       order.fuelType.toLowerCase().contains(lowerQuery) ||
//       order.status.toLowerCase().contains(lowerQuery)
//     ).toList();
//   }

//   // 🔹 إعادة تعيين الحالة
//   void reset() {
//     _fuelOrders = [];
//     _selectedFuelOrder = null;
//     _isLoading = false;
//     _error = '';
//     _safeNotifyListeners();
//   }

//   // ===================== Safe Notify Listeners =====================
//   void _safeNotifyListeners() {
//     if (_isDisposed) return;
    
//     Future.microtask(() {
//       if (!_isDisposed && hasListeners) {
//         notifyListeners();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _isDisposed = true;
//     super.dispose();
//   }
// }


import 'dart:async';

import 'package:customer/data/models/fuel_order_model.dart';
import 'package:customer/data/repositories/order_repository.dart';
import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  
  List<FuelOrderModel> _fuelOrders = [];
  FuelOrderModel? _selectedFuelOrder;
  bool _isLoading = false;
  String _error = '';
  bool _isDisposed = false;
  Timer? _trackingTimer;

  // 🔹 Getters
  List<FuelOrderModel> get fuelOrders => _fuelOrders;
  FuelOrderModel? get selectedFuelOrder => _selectedFuelOrder;
  bool get isLoading => _isLoading;
  String get error => _error;

  // 🔹 دوال التحقق من الحالة
  bool get isOrderWaitingPayment => _selectedFuelOrder?.status == 'waiting_payment';
  bool get isOrderInProgress => _selectedFuelOrder?.status == 'processing' || 
                               _selectedFuelOrder?.status == 'assigned_to_driver' || 
                               _selectedFuelOrder?.status == 'on_the_way' ||
                               _selectedFuelOrder?.status == 'arrived' ||
                               _selectedFuelOrder?.status == 'fueling';
  bool get canShowPaymentButton => isOrderWaitingPayment && 
                                  (_selectedFuelOrder?.pricing.finalPrice ?? 0) > 0;

  OrderProvider();

  // ===================== 🔥 دوال التتبع التلقائي =====================
  void startOrderTracking(String orderId) {
    // إيقاف التتبع السابق إذا كان موجوداً
    stopOrderTracking();
    
    // تحميل الطلب أولاً
    loadFuelOrder(orderId);
    
    // بدء التحديث التلقائي كل 15 ثانية
    _trackingTimer = Timer.periodic(Duration(seconds: 15), (timer) async {
      print('🔄 تحديث تلقائي لطلب الوقود: $orderId');
      await loadFuelOrder(orderId);
      
      // إيقاف التحديث إذا اكتمل الطلب أو ألغي
      final currentStatus = _selectedFuelOrder?.status;
      if (currentStatus == 'completed' || currentStatus == 'cancelled' || currentStatus == 'delivered') {
        print('⏹️ إيقاف التتبع - حالة الطلب: $currentStatus');
        stopOrderTracking();
      }
    });
  }

  void stopOrderTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = null;
    print('⏹️ توقف التتبع التلقائي');
  }

  // ===================== 🔥 جلب طلبات الوقود =====================
  Future<void> loadFuelOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _fuelOrders = await _orderRepository.getFuelOrders(
        status: status,
        page: page,
        limit: limit,
      );
      print('✅ تم تحميل ${_fuelOrders.length} طلب وقود');
    } catch (e) {
      _error = 'فشل في تحميل طلبات الوقود: ${e.toString()}';
      print('❌ خطأ في loadFuelOrders: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // ===================== 🔥 تحميل طلب وقود محدد (مُحسّن) =====================
  Future<void> loadFuelOrder(String orderId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      print('🔍 جلب طلب الوقود: $orderId');
      
      final order = await _orderRepository.getFuelOrderById(orderId);
      
      if (order != null) {
        _selectedFuelOrder = order;
        print('✅ تم جلب طلب الوقود بنجاح: ${order.orderNumber}');
        print('📊 الحالة: ${order.status}');
        print('💰 السعر النهائي: ${order.pricing.finalPrice} ر.س');
      } else {
        print('❌ طلب الوقود غير موجود: $orderId');
        _selectedFuelOrder = null;
        _error = 'طلب الوقود غير موجود';
      }
    } catch (e) {
      _error = 'فشل في تحميل طلب الوقود: ${e.toString()}';
      print('❌ خطأ في loadFuelOrder: $e');
      _selectedFuelOrder = null;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // ===================== 🔥 إنشاء طلب وقود جديد =====================
  Future<FuelOrderModel> createFuelOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      print('🚀 بدء إنشاء طلب وقود جديد...');
      
      // تنظيف البيانات وإضافة serviceType
      final cleanedData = _cleanOrderData({
        ...orderData,
        'serviceType': 'fuel',
      }) ?? {};

      print('📦 البيانات النظيفة المرسلة: $cleanedData');
      
      final order = await _orderRepository.createFuelOrder(cleanedData);
      
      // إضافة الطلب الجديد للقائمة
      _fuelOrders.insert(0, order);
      
      print('✅ تم إنشاء طلب الوقود بنجاح: ${order.orderNumber}');
      
      return order;
    } catch (e) {
      _error = 'فشل في إنشاء طلب الوقود: ${e.toString()}';
      print('❌ خطأ في createFuelOrder: $e');
      rethrow;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // ===================== 🔥 تحديث حالة طلب الوقود =====================
  Future<void> updateFuelOrderStatus(String orderId, String status, {String? notes}) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      await _orderRepository.updateFuelOrderStatus(orderId, status, notes: notes);

      // تحديث الحالة محلياً
      final index = _fuelOrders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _fuelOrders[index] = _fuelOrders[index].copyWith(status: status);
      }
      
      if (_selectedFuelOrder?.id == orderId) {
        _selectedFuelOrder = _selectedFuelOrder!.copyWith(status: status);
      }
      
      print('✅ تم تحديث حالة طلب الوقود إلى: $status');
    } catch (e) {
      _error = 'فشل في تحديث حالة طلب الوقود: ${e.toString()}';
      print('❌ خطأ في updateFuelOrderStatus: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // ===================== 🔥 تعيين سعر طلب الوقود =====================
  Future<void> setFuelOrderPrice(String orderId, double finalPrice) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      await _orderRepository.setFuelOrderPrice(orderId, finalPrice);
      
      // تحديث السعر محلياً
      final index = _fuelOrders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _fuelOrders[index] = _fuelOrders[index].copyWith(
          pricing: _fuelOrders[index].pricing.copyWith(finalPrice: finalPrice)
        );
      }
      
      if (_selectedFuelOrder?.id == orderId) {
        _selectedFuelOrder = _selectedFuelOrder!.copyWith(
          pricing: _selectedFuelOrder!.pricing.copyWith(finalPrice: finalPrice)
        );
      }
      
      print('✅ تم تعيين سعر طلب الوقود: $finalPrice');
    } catch (e) {
      _error = 'فشل في تعيين سعر طلب الوقود: ${e.toString()}';
      print('❌ خطأ في setFuelOrderPrice: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // ===================== 🔥 تعيين سائق لطلب الوقود =====================
  Future<void> assignDriverToFuelOrder(String orderId, String driverId) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      await _orderRepository.assignDriverToFuelOrder(orderId, driverId);
      
      // تحديث محلياً
      final index = _fuelOrders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _fuelOrders[index] = _fuelOrders[index].copyWith(driverId: driverId);
      }
      
      if (_selectedFuelOrder?.id == orderId) {
        _selectedFuelOrder = _selectedFuelOrder!.copyWith(driverId: driverId);
      }
      
      print('✅ تم تعيين السائق لطلب الوقود: $driverId');
    } catch (e) {
      _error = 'فشل في تعيين السائق: ${e.toString()}';
      print('❌ خطأ في assignDriverToFuelOrder: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // ===================== 🔥 عملية الدفع =====================
  Future<void> proceedToPayment(String orderId) async {
    try {
      _isLoading = true;
      _safeNotifyListeners();

      print('💰 بدء عملية الدفع للطلب: $orderId');
      
      // محاكاة عملية الدفع
      await Future.delayed(Duration(seconds: 2));
      
      // بعد الدفع الناجح، تحديث الحالة
      await updateFuelOrderStatus(orderId, 'processing');
      
      print('✅ تم إتمام الدفع بنجاح');
      
    } catch (e) {
      _error = 'فشل في عملية الدفع: ${e.toString()}';
      print('❌ خطأ في proceedToPayment: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // ===================== 🔥 دوال مساعدة =====================
  
  // تنظيف البيانات قبل الإرسال
  Map<String, dynamic> _cleanOrderData(Map<String, dynamic> data) {
    return _recursiveClean(data);
  }

  dynamic _recursiveClean(dynamic value) {
    if (value is Map) {
      final cleanedMap = <String, dynamic>{};
      value.forEach((key, value) {
        final cleanedValue = _recursiveClean(value);
        if (cleanedValue != null) {
          cleanedMap[key] = cleanedValue;
        }
      });
      return cleanedMap.isEmpty ? null : cleanedMap;
    } else if (value is List) {
      final cleanedList = value.map(_recursiveClean).where((item) => item != null).toList();
      return cleanedList.isEmpty ? null : cleanedList;
    } else {
      return value;
    }
  }

  void setSelectedFuelOrder(FuelOrderModel order) {
    _selectedFuelOrder = order;
    _safeNotifyListeners();
  }

  void clearError() {
    _error = '';
    _safeNotifyListeners();
  }

  void clearFuelOrders() {
    _fuelOrders = [];
    _safeNotifyListeners();
  }

  void clearSelection() {
    _selectedFuelOrder = null;
    _safeNotifyListeners();
  }

  // 🔹 الحصول على طلبات الوقود حسب الحالة
  List<FuelOrderModel> get pendingFuelOrders => _fuelOrders.where((order) => order.status == 'pending').toList();
  List<FuelOrderModel> get approvedFuelOrders => _fuelOrders.where((order) => order.status == 'approved').toList();
  List<FuelOrderModel> get waitingPaymentFuelOrders => _fuelOrders.where((order) => order.status == 'waiting_payment').toList();
  List<FuelOrderModel> get completedFuelOrders => _fuelOrders.where((order) => order.status == 'completed').toList();
  List<FuelOrderModel> get inProgressFuelOrders => _fuelOrders.where((order) => order.status == 'in_progress').toList();
  List<FuelOrderModel> get cancelledFuelOrders => _fuelOrders.where((order) => order.status == 'cancelled').toList();

  // 🔹 الحصول على طلبات الوقود حسب نوع الوقود
  List<FuelOrderModel> getFuelOrdersByType(String fuelType) {
    return _fuelOrders.where((order) => order.fuelType == fuelType).toList();
  }

  // 🔹 إحصائيات
  int get totalFuelOrdersCount => _fuelOrders.length;
  int get pendingFuelOrdersCount => pendingFuelOrders.length;
  int get approvedFuelOrdersCount => approvedFuelOrders.length;
  int get waitingPaymentFuelOrdersCount => waitingPaymentFuelOrders.length;
  int get completedFuelOrdersCount => completedFuelOrders.length;
  int get inProgressFuelOrdersCount => inProgressFuelOrders.length;
  int get cancelledFuelOrdersCount => cancelledFuelOrders.length;

  // 🔹 الحصول على إحصائيات حسب نوع الوقود
  Map<String, int> get fuelTypeStats {
    final stats = <String, int>{};
    for (final order in _fuelOrders) {
      stats[order.fuelType] = (stats[order.fuelType] ?? 0) + 1;
    }
    return stats;
  }

  FuelOrderModel? get latestFuelOrder => _fuelOrders.isNotEmpty ? _fuelOrders.first : null;
  
  bool get hasError => _error.isNotEmpty;

  // 🔹 الحصول على إجمالي كمية الوقود
  int get totalFuelLiters {
    return _fuelOrders.fold(0, (sum, order) => sum + order.fuelLiters);
  }

  // 🔹 تحديث البيانات
  Future<void> refreshFuelOrders() async {
    await loadFuelOrders();
  }

  // 🔹 البحث في طلبات الوقود
  List<FuelOrderModel> searchFuelOrders(String query) {
    if (query.isEmpty) return _fuelOrders;
    
    final lowerQuery = query.toLowerCase();
    return _fuelOrders.where((order) =>
      order.orderNumber.toLowerCase().contains(lowerQuery) ||
      order.customerNotes.toLowerCase().contains(lowerQuery) ||
      order.fuelType.toLowerCase().contains(lowerQuery) ||
      order.status.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // 🔹 إعادة تعيين الحالة
  void reset() {
    _fuelOrders = [];
    _selectedFuelOrder = null;
    _isLoading = false;
    _error = '';
    stopOrderTracking();
    _safeNotifyListeners();
  }

  // ===================== Safe Notify Listeners =====================
  void _safeNotifyListeners() {
    if (_isDisposed) return;
    
    Future.microtask(() {
      if (!_isDisposed && hasListeners) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    stopOrderTracking();
    super.dispose();
  }
}