// data/repositories/notification_repository.dart
import 'dart:convert';
import 'package:customer/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:customer/data/models/notification_model.dart';
import 'package:customer/core/services/storage_service.dart';

class NotificationRepository {
  final StorageService _storageService = StorageService();
  final String _baseUrl = '${AppConstants.baseUrl}/notifications'; // تم التصحيح هنا

  Future<String> _getToken() async {
    return await _storageService.getString(AppConstants.tokenKey) ?? '';
  }

  // جلب جميع إشعارات المستخدم
  Future<List<AppNotification >> getUserNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? read,
  }) async {
    try {
      final token = await _getToken();
      
      // تحقق من وجود التوكن
      if (token.isEmpty) {
        throw Exception('لم يتم العثور على رمز المصادقة، يرجى تسجيل الدخول مرة أخرى');
      }

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type,
        if (read != null) 'read': read.toString(),
      };

      final uri = Uri.parse('$_baseUrl/my-notifications')
          .replace(queryParameters: queryParams);

      print('🌐 جلب الإشعارات من: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📡 استجابة السيرفر: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> notificationsJson = data['data'];
          print('✅ تم جلب ${notificationsJson.length} إشعار بنجاح');
          return notificationsJson
              .map((json) => AppNotification .fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'فشل في جلب الإشعارات');
        }
      } else if (response.statusCode == 401) {
        throw Exception('انتهت جلسة العمل، يرجى تسجيل الدخول مرة أخرى');
      } else if (response.statusCode == 404) {
        throw Exception('الرابط غير موجود: ${uri.toString()}');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في جلب الإشعارات: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في جلب الإشعارات: $e');
      throw Exception('خطأ في جلب الإشعارات: $e');
    }
  }

  // جلب عدد الإشعارات غير المقروءة
  Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      final token = await _getToken();
      
      // تحقق من وجود التوكن
      if (token.isEmpty) {
        throw Exception('لم يتم العثور على رمز المصادقة، يرجى تسجيل الدخول مرة أخرى');
      }

      final uri = Uri.parse('$_baseUrl/stats');
      print('🌐 جلب الإحصائيات من: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📡 استجابة السيرفر: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ تم جلب الإحصائيات بنجاح');
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'فشل في جلب الإحصائيات');
        }
      } else if (response.statusCode == 401) {
        throw Exception('انتهت جلسة العمل، يرجى تسجيل الدخول مرة أخرى');
      } else if (response.statusCode == 404) {
        throw Exception('الرابط غير موجود: ${uri.toString()}');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في جلب الإحصائيات: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في جلب الإحصائيات: $e');
      throw Exception('خطأ في جلب الإحصائيات: $e');
    }
  }

  // تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await _getToken();
      
      if (token.isEmpty) {
        throw Exception('لم يتم العثور على رمز المصادقة، يرجى تسجيل الدخول مرة أخرى');
      }

      final uri = Uri.parse('$_baseUrl/$notificationId/read');
      print('🌐 تحديث حالة الإشعار: $uri');

      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📡 استجابة السيرفر: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ تم تحديث حالة الإشعار بنجاح');
      } else if (response.statusCode == 401) {
        throw Exception('انتهت جلسة العمل، يرجى تسجيل الدخول مرة أخرى');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'فشل في تحديث حالة الإشعار: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في تحديد الإشعار كمقروء: $e');
      throw Exception('خطأ في تحديد الإشعار كمقروء: $e');
    }
  }

  // تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    try {
      final token = await _getToken();
      
      if (token.isEmpty) {
        throw Exception('لم يتم العثور على رمز المصادقة، يرجى تسجيل الدخول مرة أخرى');
      }

      final uri = Uri.parse('$_baseUrl/mark-all-read');
      print('🌐 تحديث جميع الإشعارات: $uri');

      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📡 استجابة السيرفر: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ تم تحديث جميع الإشعارات بنجاح');
      } else if (response.statusCode == 401) {
        throw Exception('انتهت جلسة العمل، يرجى تسجيل الدخول مرة أخرى');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'فشل في تحديث الإشعارات: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في تحديد جميع الإشعارات كمقروءة: $e');
      throw Exception('خطأ في تحديد جميع الإشعارات كمقروءة: $e');
    }
  }

  // حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    try {
      final token = await _getToken();
      
      if (token.isEmpty) {
        throw Exception('لم يتم العثور على رمز المصادقة، يرجى تسجيل الدخول مرة أخرى');
      }

      final uri = Uri.parse('$_baseUrl/$notificationId');
      print('🌐 حذف الإشعار: $uri');

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📡 استجابة السيرفر: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ تم حذف الإشعار بنجاح');
      } else if (response.statusCode == 401) {
        throw Exception('انتهت جلسة العمل، يرجى تسجيل الدخول مرة أخرى');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'فشل في حذف الإشعار: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في حذف الإشعار: $e');
      throw Exception('خطأ في حذف الإشعار: $e');
    }
  }

  // إرسال إشعار جديد (للمدراء فقط)
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
      final token = await _getToken();
      
      if (token.isEmpty) {
        throw Exception('لم يتم العثور على رمز المصادقة، يرجى تسجيل الدخول مرة أخرى');
      }

      final Map<String, dynamic> requestBody = {
        'title': title,
        'body': body,
        'type': type,
        'data': data,
        'routing': routing,
        'priority': priority,
      };

      if (userId != null) {
        requestBody['userId'] = userId;
      } else if (targetGroup != null) {
        requestBody['targetGroup'] = targetGroup;
      }

      final uri = Uri.parse('$_baseUrl/send-to-user');
      print('🌐 إرسال إشعار جديد: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📡 استجابة السيرفر: ${response.statusCode}');

      if (response.statusCode == 201) {
        print('✅ تم إرسال الإشعار بنجاح');
      } else if (response.statusCode == 401) {
        throw Exception('انتهت جلسة العمل، يرجى تسجيل الدخول مرة أخرى');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في إرسال الإشعار: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في إرسال الإشعار: $e');
      throw Exception('خطأ في إرسال الإشعار: $e');
    }
  }

  // إرسال إشعار جماعي (للمدراء فقط)
  Future<void> sendGroupNotification({
    required String title,
    required String body,
    required String targetGroup,
    String type = 'system',
    Map<String, dynamic> data = const {},
    Map<String, dynamic> routing = const {},
    String priority = 'normal',
  }) async {
    try {
      final token = await _getToken();
      
      if (token.isEmpty) {
        throw Exception('لم يتم العثور على رمز المصادقة، يرجى تسجيل الدخول مرة أخرى');
      }

      final uri = Uri.parse('$_baseUrl/send-to-group');
      print('🌐 إرسال إشعار جماعي: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'body': body,
          'targetGroup': targetGroup,
          'type': type,
          'data': data,
          'routing': routing,
          'priority': priority,
        }),
      );

      print('📡 استجابة السيرفر: ${response.statusCode}');

      if (response.statusCode == 201) {
        print('✅ تم إرسال الإشعار الجماعي بنجاح');
      } else if (response.statusCode == 401) {
        throw Exception('انتهت جلسة العمل، يرجى تسجيل الدخول مرة أخرى');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في إرسال الإشعار الجماعي: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في إرسال الإشعار الجماعي: $e');
      throw Exception('خطأ في إرسال الإشعار الجماعي: $e');
    }
  }

  // دالة مساعدة لفحص الاتصال
  Future<void> testConnection() async {
    try {
      final token = await _getToken();
      print('=== 🔍 فحص الاتصال ===');
      print('🔑 حالة التوكن: ${token.isNotEmpty ? "موجود" : "مفقود"}');
      print('🌐 الرابط الأساسي: $_baseUrl');
      
      if (token.isEmpty) {
        print('❌ خطأ: التوكن مفقود');
        return;
      }

      // اختبر جلب الإحصائيات
      print('📊 جرب جلب الإحصائيات...');
      final stats = await getNotificationStats();
      print('✅ فحص الاتصال ناجح: $stats');
      
    } catch (e) {
      print('❌ فحص الاتصال فشل: $e');
      rethrow;
    }
  }
}