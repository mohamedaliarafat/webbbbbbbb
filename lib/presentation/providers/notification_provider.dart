// presentation/providers/notification_provider.dart
import 'dart:convert';
import 'package:customer/core/services/notification_service.dart';
import 'package:customer/core/services/storage_service.dart';
import 'package:customer/data/models/notification_model.dart';
import 'package:customer/data/models/user_model.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final StorageService _storageService = StorageService();

  List<AppNotification> _notifications = [];
  List<AppNotification> _unreadNotifications = [];
  AppNotification? _selectedNotification;
  bool _isLoading = false;
  String _error = '';
  int _unreadCount = 0;
  String? _currentUserId;
  UserModel? _currentUser;

  List<AppNotification> get notifications => _notifications;
  List<AppNotification> get unreadNotifications => _unreadNotifications;
  AppNotification? get selectedNotification => _selectedNotification;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get unreadCount => _unreadCount;
  String? get currentUserId => _currentUserId;

  NotificationProvider() {
    _initializeUserData();
  }

  // تهيئة بيانات المستخدم
  Future<void> _initializeUserData() async {
    await _loadCurrentUserId();
    await _loadCurrentUser();
  }

  // جلب ID المستخدم من التخزين المحلي
  Future<void> _loadCurrentUserId() async {
    try {
      _currentUserId = await _storageService.getString('user_id');
      if (_currentUserId == null) {
        // محاولة جلب ID من بيانات المستخدم المخزنة
        final userJson = await _storageService.getString('current_user');
        if (userJson != null) {
          final userData = json.decode(userJson);
          _currentUserId = userData['_id'] ?? userData['id'];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في جلب user_id: $e');
      }
    }
  }

  // جلب بيانات المستخدم الكاملة
  Future<void> _loadCurrentUser() async {
    try {
      final userJson = await _storageService.getString('current_user');
      if (userJson != null) {
        final userData = json.decode(userJson);
        _currentUser = UserModel.fromJson(userData);
        // تأكيد وجود _currentUserId
        _currentUserId ??= _currentUser?.id;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في جلب current_user: $e');
      }
    }
  }

  // تحديث بيانات المستخدم الحالي
  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    _currentUserId = user.id;
    _updateUnreadCount(); // إعادة حساب الإشعارات غير المقروءة
    notifyListeners();
  }

  // جلب إشعارات المستخدم من الخادم
  Future<void> loadNotifications() async {
    // التحقق من وجود user_id قبل جلب الإشعارات
    if (_currentUserId == null) {
      await _initializeUserData();
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _notifications = await _notificationService.getUserNotifications();
      _updateUnreadCount();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'فشل في جلب الإشعارات: ${e.toString()}';
      notifyListeners();
    }
  }

  // جلب إحصائيات الإشعارات
  Future<void> loadNotificationStats() async {
    if (_currentUserId == null) {
      await _initializeUserData();
    }

    try {
      final stats = await _notificationService.getNotificationStats();
      _unreadCount = stats['unread'] ?? 0;
      notifyListeners();
    } catch (e) {
      _error = 'فشل في جلب الإحصائيات: ${e.toString()}';
      notifyListeners();
    }
  }

  // التحقق من وجود ID المستخدم
  bool get _hasValidUserId {
    return _currentUserId != null && _currentUserId!.isNotEmpty;
  }

  // تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    if (!_hasValidUserId) {
      _error = 'لا يمكن تحديد الإشعار كمقروء - المستخدم غير معروف';
      notifyListeners();
      return;
    }

    try {
      await _notificationService.markAsRead(notificationId);
      
      // تحديث القائمة المحلية
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = _notifications[index];
        if (!notification.readBy.contains(_currentUserId)) {
          _notifications[index] = notification.copyWith(
            readBy: [...notification.readBy, _currentUserId!],
          );
        }
        _updateUnreadCount();
        notifyListeners();
      }
    } catch (e) {
      _error = 'فشل في تحديد الإشعار كمقروء: ${e.toString()}';
      notifyListeners();
    }
  }

  // تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    if (!_hasValidUserId) {
      _error = 'لا يمكن تحديد الإشعارات كمقروءة - المستخدم غير معروف';
      notifyListeners();
      return;
    }

    try {
      await _notificationService.markAllAsRead();
      
      // تحديث القائمة المحلية
      _notifications = _notifications.map((notification) {
        if (!notification.readBy.contains(_currentUserId)) {
          return notification.copyWith(
            readBy: [...notification.readBy, _currentUserId!],
          );
        }
        return notification;
      }).toList();
      
      _updateUnreadCount();
      notifyListeners();
    } catch (e) {
      _error = 'فشل في تحديد جميع الإشعارات كمقروءة: ${e.toString()}';
      notifyListeners();
    }
  }

  // حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      
      // تحديث القائمة المحلية
      _notifications.removeWhere((n) => n.id == notificationId);
      if (_selectedNotification?.id == notificationId) {
        _selectedNotification = null;
      }
      _updateUnreadCount();
      notifyListeners();
    } catch (e) {
      _error = 'فشل في حذف الإشعار: ${e.toString()}';
      notifyListeners();
    }
  }

  // إرسال إشعار جديد (للمدراء)
  Future<void> sendNotification({
    required String title,
    required String body,
    String? userId,
    String? targetGroup,
    String type = 'system',
    Map<String, dynamic> data = const {},
    Map<String, dynamic> routing = const {},
    String priority = 'normal',
  }) async {
    try {
      await _notificationService.sendNotification(
        title: title,
        body: body,
        userId: userId,
        targetGroup: targetGroup,
        type: type,
        data: data,
        routing: routing,
        priority: priority,
      );
      
      // إعادة تحميل الإشعارات لعرض الجديد
      await loadNotifications();
    } catch (e) {
      _error = 'فشل في إرسال الإشعار: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  // تحديث عدد الإشعارات غير المقروءة
  void _updateUnreadCount() {
    if (!_hasValidUserId) {
      _unreadCount = 0;
      _unreadNotifications = [];
      return;
    }

    _unreadNotifications = _notifications.where((notification) {
      return !notification.readBy.contains(_currentUserId);
    }).toList();
    
    _unreadCount = _unreadNotifications.length;
  }

  // دالة مساعدة للتحقق من قراءة إشعار
  bool isNotificationRead(AppNotification notification) {
    if (!_hasValidUserId) return false;
    return notification.readBy.contains(_currentUserId);
  }

  // دالة مساعدة للحصول على قائمة الإشعارات غير المقروءة فقط
  List<AppNotification> getUnreadNotifications() {
    if (!_hasValidUserId) return [];
    return _notifications.where((n) => !n.readBy.contains(_currentUserId)).toList();
  }

  // دالة مساعدة للحصول على قائمة الإشعارات المقروءة فقط
  List<AppNotification> getReadNotifications() {
    if (!_hasValidUserId) return _notifications;
    return _notifications.where((n) => n.readBy.contains(_currentUserId)).toList();
  }

  // إضافة إشعار جديد (للاستخدام مع FCM)
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _updateUnreadCount();
    notifyListeners();
  }

  // إضافة إشعارات متعددة
  void addNotifications(List<AppNotification> notifications) {
    _notifications.insertAll(0, notifications);
    _updateUnreadCount();
    notifyListeners();
  }

  // تحديد إشعار محدد
  void setSelectedNotification(AppNotification notification) {
    _selectedNotification = notification;
    notifyListeners();
  }

  // تحديث إشعار محدد
  void updateNotification(String notificationId, AppNotification updatedNotification) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = updatedNotification;
      _updateUnreadCount();
      notifyListeners();
    }
  }

  // مسح الخطأ
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // مسح جميع الإشعارات
  void clearNotifications() {
    _notifications = [];
    _unreadNotifications = [];
    _unreadCount = 0;
    notifyListeners();
  }

  // تصفية الإشعارات حسب النوع
  List<AppNotification> filterNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // تصفية الإشعارات حسب الأولوية
  List<AppNotification> filterNotificationsByPriority(String priority) {
    return _notifications.where((n) => n.priority == priority).toList();
  }

  // البحث في الإشعارات
  List<AppNotification> searchNotifications(String query) {
    if (query.isEmpty) return _notifications;
    
    final lowercaseQuery = query.toLowerCase();
    return _notifications.where((notification) {
      return notification.title.toLowerCase().contains(lowercaseQuery) ||
             notification.body.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // تحديث الإشعارات تلقائياً
  Future<void> refreshNotifications() async {
    await loadNotifications();
    await loadNotificationStats();
  }

  // إعادة تعيين البيانات (للتسجيل الخروج)
  void reset() {
    _notifications = [];
    _unreadNotifications = [];
    _selectedNotification = null;
    _isLoading = false;
    _error = '';
    _unreadCount = 0;
    _currentUserId = null;
    _currentUser = null;
    notifyListeners();
  }

  // تحميل البيانات عند تسجيل الدخول
  Future<void> initializeForUser(String userId, UserModel? user) async {
    _currentUserId = userId;
    _currentUser = user;
    await loadNotifications();
    await loadNotificationStats();
  }
}

// إضافة دالة copyWith لـ NotificationModel إذا لم تكن موجودة
extension NotificationModelExtension on AppNotification {
  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? user,
    bool? broadcast,
    String? targetGroup,
    String? type,
    NotificationData? data,
    NotificationRouting? routing,
    List<String>? readBy,
    bool? sentViaFcm,
    bool? sentViaSms,
    bool? sentViaEmail,
    DateTime? scheduledFor,
    bool? isScheduled,
    String? priority,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      user: user ?? this.userId,
      broadcast: broadcast ?? this.broadcast,
      targetGroup: targetGroup ?? this.targetGroup,
      type: type ?? this.type,
      data: data ?? this.data,
      routing: routing ?? this.routing,
      readBy: readBy ?? this.readBy,
      sentViaFcm: sentViaFcm ?? this.sentViaFcm,
      sentViaSms: sentViaSms ?? this.sentViaSms,
      sentViaEmail: sentViaEmail ?? this.sentViaEmail,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isScheduled: isScheduled ?? this.isScheduled,
      priority: priority ?? this.priority,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}