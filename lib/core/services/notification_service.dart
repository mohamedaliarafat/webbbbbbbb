// core/services/notification_service.dart
import 'package:customer/data/models/notification_model.dart';
import 'package:customer/data/repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository _repository = NotificationRepository();

  // جلب إشعارات المستخدم
  Future<List<AppNotification >> getUserNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? read,
  }) async {
    return await _repository.getUserNotifications(
      page: page,
      limit: limit,
      type: type,
      read: read,
    );
  }

  // جلب إحصائيات الإشعارات
  Future<Map<String, dynamic>> getNotificationStats() async {
    return await _repository.getNotificationStats();
  }

  // تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
  }

  // تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
  }

  // حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    await _repository.deleteNotification(notificationId);
  }

  // إرسال إشعار (للمدراء)
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
    await _repository.sendNotification(
      title: title,
      body: body,
      userId: userId,
      targetGroup: targetGroup,
      type: type,
      data: data,
      routing: routing,
      priority: priority,
    );
  }

  // إرسال إشعار جماعي (للمدراء)
  Future<void> sendGroupNotification({
    required String title,
    required String body,
    required String targetGroup,
    String type = 'system',
    Map<String, dynamic> data = const {},
    Map<String, dynamic> routing = const {},
    String priority = 'normal',
  }) async {
    await _repository.sendGroupNotification(
      title: title,
      body: body,
      targetGroup: targetGroup,
      type: type,
      data: data,
      routing: routing,
      priority: priority,
    );
  }
}