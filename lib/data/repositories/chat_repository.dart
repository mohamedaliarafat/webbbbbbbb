import 'package:customer/data/datasources/remote_datasource.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';


class ChatRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  // 💬 جلب محادثات المستخدم
  Future<List<ChatModel>> getUserChats({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _remoteDataSource.get(
        '/chat',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response['success'] == true) {
        final List chats = response['chats'] ?? [];
        return chats.map((chat) => ChatModel.fromJson(chat)).toList();
      } else {
        throw Exception(response['error'] ?? 'فشل في جلب المحادثات');
      }
    } catch (e) {
      throw Exception('خطأ في جلب المحادثات: $e');
    }
  }

  // 📨 جلب رسائل المحادثة
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _remoteDataSource.get(
        '/chat/$chatId/messages',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response['success'] == true) {
        final List messages = response['messages'] ?? [];
        return messages.map((message) => MessageModel.fromJson(message)).toList();
      } else {
        throw Exception(response['error'] ?? 'فشل في جلب الرسائل');
      }
    } catch (e) {
      throw Exception('خطأ في جلب الرسائل: $e');
    }
  }

  // 🆕 إنشاء محادثة جديدة
  Future<ChatModel> createChat(String orderId, String orderType) async {
    try {
      final response = await _remoteDataSource.post(
        '/chat/$orderType/$orderId',
        {},
      );

      if (response['success'] == true) {
        return ChatModel.fromJson(response['chat']);
      } else {
        throw Exception(response['error'] ?? 'فشل في إنشاء المحادثة');
      }
    } catch (e) {
      throw Exception('خطأ في إنشاء المحادثة: $e');
    }
  }

  // ✉️ إرسال رسالة
  Future<MessageModel> sendMessage({
    required String chatId,
    required String receiverId,
    required dynamic content,
    required String type,
  }) async {
    try {
      Map<String, dynamic> messageData = {
        'receiverId': receiverId,
        'type': type,
      };

      // بناء محتوى الرسالة حسب النوع
      if (type == 'text') {
        messageData['content'] = content;
      } else if (type == 'image' || type == 'voice' || type == 'video' || type == 'file') {
        if (content is Map<String, dynamic>) {
          messageData['content'] = content;
        } else {
          messageData['content'] = {
            'mediaUrl': content,
            'text': '',
            'duration': 0,
            'fileSize': 0,
            'fileName': _getDefaultFileName(type),
          };
        }
      }

      final response = await _remoteDataSource.post(
        '/chat/$chatId/messages',
        messageData,
      );

      if (response['success'] == true) {
        return MessageModel.fromJson(response['message']);
      } else {
        throw Exception(response['error'] ?? 'فشل في إرسال الرسالة');
      }
    } catch (e) {
      throw Exception('خطأ في إرسال الرسالة: $e');
    }
  }

  // 📞 بدء مكالمة
  Future<Map<String, dynamic>> startCall({
    required String chatId,
    required String callType,
  }) async {
    try {
      final response = await _remoteDataSource.post(
        '/chat/$chatId/call',
        {
          'callType': callType,
        },
      );

      if (response['success'] == true) {
        return {
          'callId': response['call']?['callId'],
          'receiverId': response['call']?['receiverId'],
          'callType': response['call']?['callType'],
          'chatId': chatId,
        };
      } else {
        throw Exception(response['error'] ?? 'فشل في بدء المكالمة');
      }
    } catch (e) {
      throw Exception('خطأ في بدء المكالمة: $e');
    }
  }

  // 🗑️ حذف محادثة
  Future<void> deleteChat(String chatId) async {
    try {
      final response = await _remoteDataSource.delete('/chat/$chatId');

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'فشل في حذف المحادثة');
      }
    } catch (e) {
      throw Exception('خطأ في حذف المحادثة: $e');
    }
  }

  // 📤 رفع ملف للمحادثة
  Future<String> uploadChatFile({
    required List<int> fileBytes,
    required String fileName,
    required String fileType, // 'image', 'voice', 'video', 'file'
  }) async {
    try {
      final response = await _remoteDataSource.uploadFile(
        '/chat/upload',
        fileBytes,
        fileName,
        additionalData: {
          'fileType': fileType,
        },
      );

      if (response['success'] == true) {
        return response['fileUrl'] ?? response['url'] ?? '';
      } else {
        throw Exception(response['error'] ?? 'فشل في رفع الملف');
      }
    } catch (e) {
      throw Exception('خطأ في رفع الملف: $e');
    }
  }

  // 🔄 تحديث حالة الرسائل كمقروءة
  Future<void> markMessagesAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    try {
      final response = await _remoteDataSource.patch(
        '/chat/$chatId/mark-read',
        {
          'messageIds': messageIds,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'فشل في تحديث حالة القراءة');
      }
    } catch (e) {
      throw Exception('خطأ في تحديث حالة القراءة: $e');
    }
  }

  // 📊 جلب إحصائيات المحادثة
  Future<Map<String, dynamic>> getChatStats(String chatId) async {
    try {
      final response = await _remoteDataSource.get('/chat/$chatId/stats');

      if (response['success'] == true) {
        return response['stats'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'فشل في جلب إحصائيات المحادثة');
      }
    } catch (e) {
      throw Exception('خطأ في جلب إحصائيات المحادثة: $e');
    }
  }

  // 🔍 البحث في رسائل المحادثة
  Future<List<MessageModel>> searchInChat({
    required String chatId,
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _remoteDataSource.get(
        '/chat/$chatId/search',
        queryParams: {
          'query': query,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response['success'] == true) {
        final List messages = response['messages'] ?? [];
        return messages.map((message) => MessageModel.fromJson(message)).toList();
      } else {
        throw Exception(response['error'] ?? 'فشل في البحث في المحادثة');
      }
    } catch (e) {
      throw Exception('خطأ في البحث في المحادثة: $e');
    }
  }

  // 🏷️ إضافة رد على رسالة
  Future<MessageModel> replyToMessage({
    required String chatId,
    required String messageId,
    required String receiverId,
    required String replyText,
  }) async {
    try {
      final response = await _remoteDataSource.post(
        '/chat/$chatId/reply',
        {
          'messageId': messageId,
          'receiverId': receiverId,
          'content': replyText,
          'type': 'text',
        },
      );

      if (response['success'] == true) {
        return MessageModel.fromJson(response['message']);
      } else {
        throw Exception(response['error'] ?? 'فشل في إضافة الرد');
      }
    } catch (e) {
      throw Exception('خطأ في إضافة الرد: $e');
    }
  }

  // ⭐ تثبيت رسالة
  Future<void> pinMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await _remoteDataSource.patch(
        '/chat/$chatId/pin-message',
        {
          'messageId': messageId,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'فشل في تثبيت الرسالة');
      }
    } catch (e) {
      throw Exception('خطأ في تثبيت الرسالة: $e');
    }
  }

  // 🗑️ حذف رسالة
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await _remoteDataSource.delete(
        '/chat/$chatId/messages/$messageId',
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'فشل في حذف الرسالة');
      }
    } catch (e) {
      throw Exception('خطأ في حذف الرسالة: $e');
    }
  }

  // 🔔 تفعيل/تعطيل الإشعارات للمحادثة
  Future<void> toggleChatNotifications({
    required String chatId,
    required bool enabled,
  }) async {
    try {
      final response = await _remoteDataSource.patch(
        '/chat/$chatId/notifications',
        {
          'enabled': enabled,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'فشل في تحديث إعدادات الإشعارات');
      }
    } catch (e) {
      throw Exception('خطأ في تحديث إعدادات الإشعارات: $e');
    }
  }

  // 👥 جلب معلومات المشاركين في المحادثة
  Future<Map<String, dynamic>> getChatParticipants(String chatId) async {
    try {
      final response = await _remoteDataSource.get('/chat/$chatId/participants');

      if (response['success'] == true) {
        return {
          'customer': response['customer'],
          'driver': response['driver'],
        };
      } else {
        throw Exception(response['error'] ?? 'فشل في جلب معلومات المشاركين');
      }
    } catch (e) {
      throw Exception('خطأ في جلب معلومات المشاركين: $e');
    }
  }

  // 🕒 جلب آخر نشاط في المحادثة
  Future<Map<String, dynamic>> getChatLastSeen(String chatId) async {
    try {
      final response = await _remoteDataSource.get('/chat/$chatId/last-seen');

      if (response['success'] == true) {
        return response['lastSeen'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'فشل في جلب آخر نشاط');
      }
    } catch (e) {
      throw Exception('خطأ في جلب آخر نشاط: $e');
    }
  }

  // دالة مساعدة للحصول على اسم ملف افتراضي
  String _getDefaultFileName(String fileType) {
    switch (fileType) {
      case 'image':
        return 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      case 'voice':
        return 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      case 'video':
        return 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      case 'file':
        return 'file_${DateTime.now().millisecondsSinceEpoch}.pdf';
      default:
        return 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // التحقق من وجود محادثة للطلب
  Future<bool> checkOrderChatExists(String orderId, String orderType) async {
    try {
      final response = await _remoteDataSource.get('/chat/check/$orderType/$orderId');

      if (response['success'] == true) {
        return response['exists'] ?? false;
      } else {
        throw Exception(response['error'] ?? 'فشل في التحقق من وجود المحادثة');
      }
    } catch (e) {
      throw Exception('خطأ في التحقق من وجود المحادثة: $e');
    }
  }

  // تجديد بيانات المحادثة
  Future<ChatModel> refreshChat(String chatId) async {
    try {
      final response = await _remoteDataSource.get('/chat/$chatId/refresh');

      if (response['success'] == true) {
        return ChatModel.fromJson(response['chat']);
      } else {
        throw Exception(response['error'] ?? 'فشل في تجديد بيانات المحادثة');
      }
    } catch (e) {
      throw Exception('خطأ في تجديد بيانات المحادثة: $e');
    }
  }
}