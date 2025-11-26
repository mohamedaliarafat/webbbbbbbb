import 'dart:convert';
import 'dart:typed_data';

import 'package:customer/core/constants/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // تهيئة الإشعارات المحلية
  static Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onNotificationTap(response.payload);
      },
    );
  }

  // تهيئة FCM
  static Future<void> initializeFCM() async {
    // طلب الأذونات
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      announcement: false,
    );
    
    print('صلاحيات الإشعارات: ${settings.authorizationStatus}');

    // الحصول على token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
      print('FCM Token: $token');
    }

    // التعامل مع التحديثات
    _firebaseMessaging.onTokenRefresh.listen(_saveFCMToken);

    // إعداد معالج الإشعارات في الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // إعداد معالج الإشعارات في المقدمة
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // إعداد التنقل من الإشعارات
    await setupNotificationNavigation();
  }

  // 🔄 التصحيح: إعداد التنقل من الإشعارات (بدون getInitialNotification)
  static Future<void> setupNotificationNavigation() async {
    try {
      print('🎯 Setting up notification navigation...');

      // 1. معالج الإشعارات عند فتح التطبيق من إشعار (للتطبيق المقتول)
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          print('📱 App opened from terminated state: ${message.data}');
          _handleNotificationTap(message.data);
        }
      });

      // 2. معالج الإشعارات عند فتح التطبيق من الخلفية (background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('📱 App opened from background: ${message.data}');
        _handleNotificationTap(message.data);
      });

      // 3. معالج الإشعارات في المقدمة (foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📱 Notification received in foreground: ${message.data}');
        _handleForegroundNotification(message);
      });

      print('✅ Notification navigation setup completed');
    } catch (e) {
      print('❌ Error setting up notification navigation: $e');
    }
  }

  // معالج الإشعارات في الخلفية
  @pragma('vm:entry-point')
  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    await _showLocalNotification(message);
    await _handleNotificationData(message.data);
  }

  // معالج الإشعارات في المقدمة
  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    await _showLocalNotification(message);
    await _handleNotificationData(message.data);
  }

  // معالج الإشعارات في المقدمة (محدث)
  static Future<void> _handleForegroundNotification(RemoteMessage message) async {
    try {
      // عرض الإشعار محلياً
      await _showLocalNotification(message);
      
      // تحديث حالة التطبيق إذا كان مفتوحاً
      _updateAppState(message.data);
    } catch (e) {
      print('❌ Error handling foreground notification: $e');
    }
  }

  // معالجة بيانات الإشعار
  static Future<void> _handleNotificationData(Map<String, dynamic> data) async {
    try {
      print('معالجة بيانات الإشعار: $data');
      
      // حفظ الإشعار محلياً
      await _saveNotificationLocally(data);
      
      // تحديث حالة التطبيق
      _updateAppState(data);
      
      // إظهار تحديث في الواجهة
      _showInAppNotification(data);
    } catch (e) {
      print('خطأ في معالجة بيانات الإشعار: $e');
    }
  }

  // حفظ الإشعار محلياً
  static Future<void> _saveNotificationLocally(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('notifications') ?? [];
      
      final notificationData = {
        'id': data['notificationId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'title': data['title'] ?? 'إشعار جديد',
        'body': data['body'] ?? '',
        'type': data['type'] ?? 'system',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };
      
      notifications.insert(0, jsonEncode(notificationData));
      
      // حفظ فقط آخر 100 إشعار
      if (notifications.length > 100) {
        notifications.removeLast();
      }
      
      await prefs.setStringList('notifications', notifications);
      print('تم حفظ الإشعار محلياً');
    } catch (e) {
      print('خطأ في حفظ الإشعار محلياً: $e');
    }
  }

  // تحديث حالة التطبيق
  static void _updateAppState(Map<String, dynamic> data) {
    try {
      // يمكنك استخدام Provider أو BLoC هنا لتحديث الحالة
      // هذا مثال باستخدام EventBus أو أي نظام event آخر
      
      // مثال: إرسال event لتحديث العدادات
      // EventBus().fire(NotificationReceivedEvent(data));
      
      print('تم تحديث حالة التطبيق ببيانات الإشعار');
    } catch (e) {
      print('خطأ في تحديث حالة التطبيق: $e');
    }
  }

  // إظهار إشعار داخل التطبيق
  static void _showInAppNotification(Map<String, dynamic> data) {
    try {
      // يمكنك استخدام Overlay أو SnackBar لإظهار إشعار داخل التطبيق
      if (AppRouter.navigatorKey.currentContext != null) {
        final scaffoldMessenger = ScaffoldMessenger.of(AppRouter.navigatorKey.currentContext!);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(data['title'] ?? 'إشعار جديد'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'عرض',
              textColor: Colors.white,
              onPressed: () {
                _handleNotificationTap(data);
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('خطأ في إظهار الإشعار الداخلي: $e');
    }
  }

  // عرض الإشعار المحلي
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      
      if (notification != null) {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'your_channel_id',
          'الإشعارات',
          channelDescription: 'قناة الإشعارات الرئيسية',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('notification'),
          enableVibration: true,
          vibrationPattern: Int64List.fromList(const [0, 500, 1000, 500]),
        );

        const DarwinNotificationDetails iosPlatformChannelSpecifics =
            DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        final NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics,
        );

        await _flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          notification.title,
          notification.body,
          platformChannelSpecifics,
          payload: jsonEncode(message.data),
        );
      }
    } catch (e) {
      print('خطأ في عرض الإشعار المحلي: $e');
    }
  }

  // حفظ token في الخادم
  static Future<void> _saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      
      // إرسال Token للخادم
      await _sendTokenToServer(token);
    } catch (e) {
      print('خطأ في حفظ Token: $e');
    }
  }

  // إرسال Token للخادم
  static Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: استبدل بـ API الخاص بك
      final response = await http.post(
        Uri.parse('https://your-api.com/api/users/fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'fcmToken': token}),
      );

      if (response.statusCode == 200) {
        print('تم إرسال Token للخادم بنجاح');
      } else {
        print('فشل في إرسال Token: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في إرسال Token: $e');
    }
  }

  // التعامل مع نقر الإشعار
  static void _onNotificationTap(String? payload) {
    try {
      if (payload != null) {
        final data = jsonDecode(payload);
        _handleNotificationTap(data);
      }
    } catch (e) {
      print('خطأ في معالجة نقر الإشعار: $e');
    }
  }

  // 🔄 التصحيح: معالج النقر على الإشعارات
  static Future<void> _handleNotificationTap(Map<String, dynamic> data) async {
    try {
      print('🎯 Handling notification tap: $data');
      
      // إعطاء الوقت لـ Navigator ليكون جاهزاً
      await Future.delayed(Duration(milliseconds: 300));
      
      if (AppRouter.navigatorKey.currentContext != null) {
        if (_isValidNotificationData(data)) {
          await _navigateFromNotification(data);
        } else {
          // بيانات غير صالحة، الانتقال لشاشة الإشعارات
          await AppRouter.navigateTo('/notifications');
        }
        
        // تحديد الإشعار كمقروء
        _markNotificationAsRead(data['notificationId']);
      } else {
        print('⚠️ Navigator key not ready, saving notification for later');
        _savePendingNotification(data);
      }
    } catch (e) {
      print('❌ Error handling notification tap: $e');
      // الانتقال لشاشة الإشعارات كبديل آمن
      await AppRouter.navigateTo('/notifications');
    }
  }

  // التحقق من صحة بيانات الإشعار
  static bool _isValidNotificationData(Map<String, dynamic> data) {
    final screen = data['screen']?.toString() ?? '';
    final orderId = data['orderId']?.toString() ?? '';

    switch (screen) {
      case 'OrderDetails':
      case 'TrackOrder':
      case 'FuelOrderDetails':
      case 'PaymentReview':
        return orderId.isNotEmpty;
      
      case 'ChatScreen':
        return orderId.isNotEmpty && data['chatId']?.toString()?.isNotEmpty == true;
      
      case 'Notifications':
        return true;
      
      default:
        return false;
    }
  }

  // التنقل من الإشعارات
  static Future<void> _navigateFromNotification(Map<String, dynamic> data) async {
    final screen = data['screen']?.toString() ?? '';
    final orderId = data['orderId']?.toString() ?? '';
    final chatId = data['chatId']?.toString() ?? '';
    final orderType = data['orderType']?.toString() ?? 'fuel';

    print('🧭 Navigating from notification: $screen');

    switch (screen) {
      case 'OrderDetails':
        await AppRouter.navigateTo('/order-details', arguments: {
          'orderId': orderId,
          'orderType': orderType,
        });
        break;

      case 'TrackOrder':
        await AppRouter.navigateTo('/track-order', arguments: {
          'orderId': orderId,
          'orderType': orderType,
        });
        break;

      case 'ChatScreen':
        await AppRouter.navigateTo('/chat', arguments: {
          'orderId': orderId,
          'chatId': chatId,
        });
        break;

      case 'PaymentReview':
        await AppRouter.navigateTo('/order-details', arguments: {
          'orderId': orderId,
          'orderType': orderType,
        });
        break;

      case 'FuelOrderDetails':
        await AppRouter.navigateTo('/order-details', arguments: {
          'orderId': orderId,
          'orderType': 'fuel',
        });
        break;

      case 'Notifications':
        await AppRouter.navigateTo('/notifications');
        break;

      default:
        await AppRouter.navigateTo('/notifications');
        break;
    }
  }

  static void _savePendingNotification(Map<String, dynamic> data) {
    // حفظ الإشعار للمعالجة لاحقاً عندما يكون التطبيق جاهزاً
    print('💾 Saving pending notification: $data');
  }

  // تحديد الإشعار كمقروء
  static Future<void> _markNotificationAsRead(String? notificationId) async {
    if (notificationId != null && notificationId.isNotEmpty) {
      try {
        // TODO: استبدل بـ API الخاص بك
        final response = await http.patch(
          Uri.parse('https://your-api.com/api/notifications/$notificationId/read'),
          headers: {
            'Authorization': 'Bearer YOUR_TOKEN',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print('تم تحديد الإشعار كمقروء: $notificationId');
        } else {
          print('فشل في تحديد الإشعار كمقروء: ${response.statusCode}');
        }
      } catch (e) {
        print('خطأ في تحديد الإشعار كمقروء: $e');
      }
    }
  }

  // الحصول على الإشعارات المحفوظة
  static Future<List<Map<String, dynamic>>> getLocalNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('notifications') ?? [];
      
      return notifications.map((item) {
        try {
          return jsonDecode(item) as Map<String, dynamic>;
        } catch (e) {
          return <String, dynamic>{};
        }
      }).where((item) => item.isNotEmpty).toList();
    } catch (e) {
      print('خطأ في جلب الإشعارات المحلية: $e');
      return [];
    }
  }

  // حذف إشعار محلي
  static Future<void> deleteLocalNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('notifications') ?? [];
      
      final updatedNotifications = notifications.where((item) {
        try {
          final data = jsonDecode(item) as Map<String, dynamic>;
          return data['id'] != id;
        } catch (e) {
          return true;
        }
      }).toList();
      
      await prefs.setStringList('notifications', updatedNotifications);
    } catch (e) {
      print('خطأ في حذف الإشعار المحلي: $e');
    }
  }

  // تحديد كل الإشعارات كمقروءة محلياً
  static Future<void> markAllLocalNotificationsAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('notifications') ?? [];
      
      final updatedNotifications = notifications.map((item) {
        try {
          final data = jsonDecode(item) as Map<String, dynamic>;
          data['read'] = true;
          return jsonEncode(data);
        } catch (e) {
          return item;
        }
      }).toList();
      
      await prefs.setStringList('notifications', updatedNotifications);
    } catch (e) {
      print('خطأ في تحديد كل الإشعارات كمقروءة: $e');
    }
  }

  // إلغاء الاشتراك في الإشعارات
  static Future<void> unsubscribeFromNotifications() async {
    try {
      await _firebaseMessaging.deleteToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('fcm_token');
      print('تم إلغاء الاشتراك في الإشعارات');
    } catch (e) {
      print('خطأ في إلغاء الاشتراك: $e');
    }
  }

  // الحصول على عدد الإشعارات غير المقروءة
  static Future<int> getUnreadNotificationsCount() async {
    try {
      final notifications = await getLocalNotifications();
      return notifications.where((notification) => notification['read'] == false).length;
    } catch (e) {
      print('خطأ في حساب الإشعارات غير المقروءة: $e');
      return 0;
    }
  }

  // 🔄 دالة مساعدة لإعادة تهيئة الخدمة
  static Future<void> reinitialize() async {
    try {
      print('🔄 Reinitializing Firebase Notification Service...');
      await initializeLocalNotifications();
      await initializeFCM();
      print('✅ Firebase Notification Service reinitialized successfully');
    } catch (e) {
      print('❌ Error reinitializing Firebase Notification Service: $e');
    }
  }
}