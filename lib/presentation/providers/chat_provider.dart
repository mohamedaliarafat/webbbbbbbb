import 'package:customer/data/models/chat_model.dart';
import 'package:customer/data/models/message_model.dart';
import 'package:customer/data/repositories/chat_repository.dart';
import 'package:flutter/foundation.dart';


class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  
  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  ChatModel? _selectedChat;
  bool _isLoading = false;
  String _error = '';
  bool _isTyping = false;
  Map<String, List<MessageModel>> _chatMessages = {};

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  ChatModel? get selectedChat => _selectedChat;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isTyping => _isTyping;

  // جلب جميع محادثات المستخدم
  Future<void> loadUserChats({
    int page = 1,
    int limit = 20,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _chats = await _chatRepository.getUserChats(
        page: page,
        limit: limit,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // جلب الرسائل لمحادثة محددة
  Future<void> loadMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _messages = await _chatRepository.getMessages(
        chatId: chatId,
        page: page,
        limit: limit,
      );
      
      // حفظ الرسائل في الـ cache
      _chatMessages[chatId] = _messages;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // إنشاء محادثة جديدة
  Future<ChatModel> createChat(String orderId, String orderType) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final chat = await _chatRepository.createChat(orderId, orderType);
      _chats.insert(0, chat);
      _isLoading = false;
      notifyListeners();
      return chat;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // إرسال رسالة نصية
  Future<MessageModel> sendTextMessage({
    required String chatId,
    required String receiverId,
    required String text,
  }) async {
    _isTyping = true;
    notifyListeners();

    try {
      final message = await _chatRepository.sendMessage(
        chatId: chatId,
        receiverId: receiverId,
        content: text,
        type: 'text',
      );
      
      // إضافة الرسالة للقائمة المحلية
      _addMessageToChat(chatId, message);
      
      _isTyping = false;
      notifyListeners();
      return message;
    } catch (e) {
      _isTyping = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // إرسال صورة
  Future<MessageModel> sendImageMessage({
    required String chatId,
    required String receiverId,
    required String imageUrl,
    String? caption,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final message = await _chatRepository.sendMessage(
        chatId: chatId,
        receiverId: receiverId,
        content: {
          'mediaUrl': imageUrl,
          'text': caption ?? '',
          'fileSize': 0,
          'fileName': 'image.jpg',
          'duration': 0,
        },
        type: 'image',
      );
      
      _addMessageToChat(chatId, message);
      _isLoading = false;
      notifyListeners();
      return message;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // إرسال رسالة صوتية
  Future<MessageModel> sendVoiceMessage({
    required String chatId,
    required String receiverId,
    required String audioUrl,
    required int duration,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final message = await _chatRepository.sendMessage(
        chatId: chatId,
        receiverId: receiverId,
        content: {
          'mediaUrl': audioUrl,
          'text': '',
          'fileSize': 0,
          'fileName': 'audio.m4a',
          'duration': duration,
        },
        type: 'voice',
      );
      
      _addMessageToChat(chatId, message);
      _isLoading = false;
      notifyListeners();
      return message;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // بدء مكالمة
  Future<Map<String, dynamic>> startCall({
    required String chatId,
    required String callType,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final callData = await _chatRepository.startCall(
        chatId: chatId,
        callType: callType,
      );
      
      // إنشاء رسالة للمكالمة
      final callMessage = MessageModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        chatId: chatId,
        senderId: 'current_user', // سيتم استبدالها بالـ ID الحقيقي
        receiverId: callData['receiverId'] ?? '',
        orderId: _selectedChat?.orderId ?? '',
        type: 'call',
        content: MessageContent(
          text: 'مكالمة ${callType == 'video' ? 'فيديو' : 'صوتية'}',
          mediaUrl: '',
          duration: 0,
          fileSize: 0,
          fileName: '',
        ),
        status: 'sent',
        callInfo: CallInfo(
          type: callType,
          duration: 0,
          status: 'initiated',
          callId: callData['callId'] ?? '',
        ),
        timestamp: DateTime.now(),
      );
      
      _addMessageToChat(chatId, callMessage);
      _isLoading = false;
      notifyListeners();
      return callData;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // تحديث حالة المكالمة
  void updateCallStatus({
    required String chatId,
    required String callId,
    required String status,
    int duration = 0,
  }) {
    final messages = _chatMessages[chatId];
    if (messages != null) {
      final callMessageIndex = messages.indexWhere(
        (msg) => msg.callInfo?.callId == callId,
      );
      
      if (callMessageIndex != -1) {
        final updatedMessage = MessageModel(
          id: messages[callMessageIndex].id,
          chatId: messages[callMessageIndex].chatId,
          senderId: messages[callMessageIndex].senderId,
          receiverId: messages[callMessageIndex].receiverId,
          orderId: messages[callMessageIndex].orderId,
          type: messages[callMessageIndex].type,
          content: messages[callMessageIndex].content,
          status: messages[callMessageIndex].status,
          callInfo: CallInfo(
            type: messages[callMessageIndex].callInfo?.type ?? 'audio',
            duration: duration,
            status: status,
            callId: messages[callMessageIndex].callInfo?.callId ?? callId,
          ),
          timestamp: messages[callMessageIndex].timestamp,
        );
        
        messages[callMessageIndex] = updatedMessage;
        
        if (_selectedChat?.id == chatId) {
          _messages = List.from(messages);
        }
        
        notifyListeners();
      }
    }
  }

  // حذف محادثة
  Future<void> deleteChat(String chatId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _chatRepository.deleteChat(chatId);
      _chats.removeWhere((chat) => chat.id == chatId);
      
      // حذف الـ cache الخاص بالرسائل
      _chatMessages.remove(chatId);
      
      if (_selectedChat?.id == chatId) {
        _selectedChat = null;
        _messages = [];
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // إضافة رسالة للمحادثة (محلياً)
  void addMessageToChat(String chatId, MessageModel message) {
    _addMessageToChat(chatId, message);
  }

  // دالة مساعدة لإضافة رسالة
  void _addMessageToChat(String chatId, MessageModel message) {
    if (!_chatMessages.containsKey(chatId)) {
      _chatMessages[chatId] = [];
    }
    
    _chatMessages[chatId]!.add(message);
    
    // إذا كانت المحادثة المحددة هي نفسها، قم بتحديث القائمة
    if (_selectedChat?.id == chatId) {
      _messages = List.from(_chatMessages[chatId]!);
    }
    
    // تحديث آخر رسالة في قائمة المحادثات
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final updatedChat = ChatModel(
        id: _chats[chatIndex].id,
        orderId: _chats[chatIndex].orderId,
        customerId: _chats[chatIndex].customerId,
        driverId: _chats[chatIndex].driverId,
        isActive: _chats[chatIndex].isActive,
        lastMessage: {
          'messageId': message.id,
          'content': message.type == 'text' 
              ? {'text': message.content.text}
              : {'text': _getMessageTypeText(message.type)},
          'type': message.type,
          'timestamp': message.timestamp.toIso8601String(),
          'senderId': message.senderId,
        },
        unreadCount: _chats[chatIndex].unreadCount,
        callsEnabled: _chats[chatIndex].callsEnabled,
        videoCallsEnabled: _chats[chatIndex].videoCallsEnabled,
        createdAt: _chats[chatIndex].createdAt,
        updatedAt: DateTime.now(),
      );
      
      _chats[chatIndex] = updatedChat;
      
      // نقل المحادثة للأعلى
      final chat = _chats.removeAt(chatIndex);
      _chats.insert(0, chat);
    }
    
    notifyListeners();
  }

  // تعيين محادثة محددة
  void setSelectedChat(ChatModel chat) {
    _selectedChat = chat;
    
    // تحميل الرسائل من الـ cache إذا كانت موجودة
    if (_chatMessages.containsKey(chat.id)) {
      _messages = List.from(_chatMessages[chat.id]!);
    } else {
      _messages = [];
    }
    
    notifyListeners();
  }

  // مسح الرسائل
  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  // مسح الخطأ
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // تعيين حالة الكتابة
  void setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  // الحصول على رسائل محادثة محددة من الـ cache
  List<MessageModel> getCachedMessages(String chatId) {
    return _chatMessages[chatId] ?? [];
  }

  // تحديث حالة الرسائل كمقروءة
  void markMessagesAsRead(String chatId) {
    if (_chatMessages.containsKey(chatId)) {
      // في التطبيق الحقيقي، ستقوم بإرسال طلب للخادم لتحديث حالة القراءة
    }
    
    // تحديث العداد المحلي
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = ChatModel(
        id: _chats[chatIndex].id,
        orderId: _chats[chatIndex].orderId,
        customerId: _chats[chatIndex].customerId,
        driverId: _chats[chatIndex].driverId,
        isActive: _chats[chatIndex].isActive,
        lastMessage: _chats[chatIndex].lastMessage,
        unreadCount: {
          'customer': 0,
          'driver': _chats[chatIndex].unreadCount['driver'] ?? 0,
        },
        callsEnabled: _chats[chatIndex].callsEnabled,
        videoCallsEnabled: _chats[chatIndex].videoCallsEnabled,
        createdAt: _chats[chatIndex].createdAt,
        updatedAt: _chats[chatIndex].updatedAt,
      );
    }
    
    notifyListeners();
  }

  // دالة مساعدة للحصول على نص نوع الرسالة
  String _getMessageTypeText(String type) {
    switch (type) {
      case 'image':
        return '📷 صورة';
      case 'voice':
        return '🎤 رسالة صوتية';
      case 'video':
        return '🎥 فيديو';
      case 'file':
        return '📄 ملف';
      case 'call':
        return '📞 مكالمة';
      default:
        return 'رسالة';
    }
  }

  // إعادة تعيين الـ provider
  void reset() {
    _chats = [];
    _messages = [];
    _selectedChat = null;
    _chatMessages = {};
    _error = '';
    _isLoading = false;
    _isTyping = false;
    notifyListeners();
  }

  void sendMessage({required String chatId, required String receiverId, required String content}) {}
}