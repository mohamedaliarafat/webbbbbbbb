import 'dart:async';
import 'dart:convert';
import 'package:customer/core/constants/api_endpoints.dart';
import 'package:customer/core/constants/app_constants.dart';
import 'package:customer/core/services/api_service.dart';
import 'package:customer/core/services/storage_service.dart';
import 'package:customer/data/models/chat_model.dart';
import 'package:customer/data/models/message_model.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final Logger _logger = Logger();

  IO.Socket? _socket;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // Stream controllers for real-time updates
  final StreamController<MessageModel> _messageStream = StreamController<MessageModel>.broadcast();
  final StreamController<ChatModel> _chatUpdateStream = StreamController<ChatModel>.broadcast();
  final StreamController<String> _typingStream = StreamController<String>.broadcast();
  final StreamController<Map<String, dynamic>> _callStream = StreamController<Map<String, dynamic>>.broadcast();

  // Stream getters
  Stream<MessageModel> get messageStream => _messageStream.stream;
  Stream<ChatModel> get chatUpdateStream => _chatUpdateStream.stream;
  Stream<String> get typingStream => _typingStream.stream;
  Stream<Map<String, dynamic>> get callStream => _callStream.stream;

  // Initialize chat service
  Future<void> init() async {
    try {
      await _connectSocket();
      _logger.i('✅ Chat service initialized');
    } catch (e) {
      _logger.e('❌ Error initializing chat service: $e');
    }
  }

  // Connect to socket server
  Future<void> _connectSocket() async {
    try {
      final token = await _storageService.getString(AppConstants.tokenKey);
      if (token == null) {
        throw 'No authentication token found';
      }

      _socket = IO.io(
        AppConstants.baseUrl.replaceFirst('/api', ''),
        IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
      );

      _setupSocketListeners();
      _socket!.connect();

      _logger.i('🔌 Socket connection initiated');
    } catch (e) {
      _logger.e('❌ Error connecting to socket: $e');
    }
  }

  // Setup socket listeners
  void _setupSocketListeners() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      _isConnected = true;
      _logger.i('✅ Socket connected');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      _logger.i('🔌 Socket disconnected');
    });

    _socket!.onError((error) {
      _logger.e('❌ Socket error: $error');
    });

    // Message events
    _socket!.on('new_message', (data) {
      _handleNewMessage(data);
    });

    _socket!.on('message_delivered', (data) {
      _handleMessageDelivered(data);
    });

    _socket!.on('message_read', (data) {
      _handleMessageRead(data);
    });

    // Chat events
    _socket!.on('chat_updated', (data) {
      _handleChatUpdated(data);
    });

    // Typing events
    _socket!.on('user_typing', (data) {
      _handleUserTyping(data);
    });

    _socket!.on('user_stop_typing', (data) {
      _handleUserStopTyping(data);
    });

    // Call events
    _socket!.on('incoming_call', (data) {
      _handleIncomingCall(data);
    });

    _socket!.on('call_accepted', (data) {
      _handleCallAccepted(data);
    });

    _socket!.on('call_rejected', (data) {
      _handleCallRejected(data);
    });

    _socket!.on('call_ended', (data) {
      _handleCallEnded(data);
    });
  }

  // Get user chats
  Future<List<ChatModel>> getUserChats({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.getUserChats,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final chatsData = response['chats'] as List;
      final chats = chatsData.map((chatData) => ChatModel.fromJson(chatData)).toList();

      _logger.i('📋 Retrieved ${chats.length} chats');
      return chats;
    } catch (e) {
      _logger.e('❌ Error getting user chats: $e');
      rethrow;
    }
  }

  // Create or get chat
  Future<ChatModel> createChat({
    required String orderId,
    required String orderType,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.buildUrlWithSuffix(
          ApiEndpoints.createChat,
          orderType,
          '/$orderId',
        ),
      );

      final chatData = response['chat'];
      final chat = ChatModel.fromJson(chatData);

      _logger.i('💬 Created/retrieved chat: ${chat.id}');
      return chat;
    } catch (e) {
      _logger.e('❌ Error creating chat: $e');
      rethrow;
    }
  }

  // Get chat messages
  Future<List<MessageModel>> getChatMessages({
    required String chatId,
    int page = 1,
    int limit = AppConstants.messagesPageSize,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.buildUrlWithSuffix(
          ApiEndpoints.getMessages,
          chatId,
          '/messages',
        ),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final messagesData = response['messages'] as List;
      final messages = messagesData.map((msgData) => MessageModel.fromJson(msgData)).toList();

      _logger.i('📨 Retrieved ${messages.length} messages for chat: $chatId');
      return messages.reversed.toList(); // Return in chronological order
    } catch (e) {
      _logger.e('❌ Error getting chat messages: $e');
      rethrow;
    }
  }

  // Send message
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String receiverId,
    String type = 'text',
    Map<String, dynamic>? additionalContent,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.buildUrlWithSuffix(
          ApiEndpoints.sendMessage,
          chatId,
          '/messages',
        ),
        data: {
          'content': content,
          'receiverId': receiverId,
          'type': type,
          if (additionalContent != null) ...additionalContent,
        },
      );

      final messageData = response['message'];
      final message = MessageModel.fromJson(messageData);

      // Emit socket event for real-time delivery
      _socket?.emit('send_message', {
        'chatId': chatId,
        'message': message.toJson(),
      });

      _logger.i('📤 Sent message: ${message.id}');
      return message;
    } catch (e) {
      _logger.e('❌ Error sending message: $e');
      rethrow;
    }
  }

  // Send file message
  Future<MessageModel> sendFileMessage({
    required String chatId,
    required String filePath,
    required String receiverId,
    String type = 'file',
    String? fileName,
  }) async {
    try {
      final response = await _apiService.uploadFile(
        ApiEndpoints.buildUrlWithSuffix(
          ApiEndpoints.sendMessage,
          chatId,
          '/messages',
        ),
        filePath,
        fieldName: 'file',
        formData: {
          'receiverId': receiverId,
          'type': type,
          'fileName': fileName,
        },
      );

      final messageData = response['message'];
      final message = MessageModel.fromJson(messageData);

      _logger.i('📎 Sent file message: ${message.id}');
      return message;
    } catch (e) {
      _logger.e('❌ Error sending file message: $e');
      rethrow;
    }
  }

  // Start a call
  Future<Map<String, dynamic>> startCall({
    required String chatId,
    required String callType, // 'audio' or 'video'
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.buildUrlWithSuffix(
          ApiEndpoints.startCall,
          chatId,
          '/call',
        ),
        data: {
          'callType': callType,
        },
      );

      final callData = response['call'];
      
      // Emit socket event for real-time call initiation
      _socket?.emit('start_call', {
        'chatId': chatId,
        'callType': callType,
        'callData': callData,
      });

      _logger.i('📞 Started $callType call in chat: $chatId');
      return callData;
    } catch (e) {
      _logger.e('❌ Error starting call: $e');
      rethrow;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    try {
      _socket?.emit('mark_messages_read', {
        'chatId': chatId,
        'messageIds': messageIds,
      });

      _logger.i('👁️ Marked ${messageIds.length} messages as read in chat: $chatId');
    } catch (e) {
      _logger.e('❌ Error marking messages as read: $e');
    }
  }

  // Send typing indicator
  void sendTypingIndicator({
    required String chatId,
    required bool isTyping,
  }) {
    try {
      if (isTyping) {
        _socket?.emit('typing_start', {'chatId': chatId});
      } else {
        _socket?.emit('typing_stop', {'chatId': chatId});
      }

      _logger.i('⌨️ Typing ${isTyping ? 'started' : 'stopped'} in chat: $chatId');
    } catch (e) {
      _logger.e('❌ Error sending typing indicator: $e');
    }
  }

  // Delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _apiService.delete(
        ApiEndpoints.buildUrl(ApiEndpoints.deleteChat, chatId),
      );

      _socket?.emit('delete_chat', {'chatId': chatId});

      _logger.i('🗑️ Deleted chat: $chatId');
    } catch (e) {
      _logger.e('❌ Error deleting chat: $e');
      rethrow;
    }
  }

  // Socket event handlers
  void _handleNewMessage(dynamic data) {
    try {
      final message = MessageModel.fromJson(data);
      _messageStream.add(message);
      _logger.i('📩 New message received: ${message.id}');
    } catch (e) {
      _logger.e('❌ Error handling new message: $e');
    }
  }

  void _handleMessageDelivered(dynamic data) {
    _logger.i('✅ Message delivered: $data');
    // Update message status in local storage
  }

  void _handleMessageRead(dynamic data) {
    _logger.i('👁️ Message read: $data');
    // Update message status in local storage
  }

  void _handleChatUpdated(dynamic data) {
    try {
      final chat = ChatModel.fromJson(data);
      _chatUpdateStream.add(chat);
      _logger.i('🔄 Chat updated: ${chat.id}');
    } catch (e) {
      _logger.e('❌ Error handling chat update: $e');
    }
  }

  void _handleUserTyping(dynamic data) {
    try {
      final userId = data['userId'] as String;
      _typingStream.add(userId);
      _logger.i('⌨️ User typing: $userId');
    } catch (e) {
      _logger.e('❌ Error handling user typing: $e');
    }
  }

  void _handleUserStopTyping(dynamic data) {
    try {
      final userId = data['userId'] as String;
      _typingStream.add(''); // Empty string indicates typing stopped
      _logger.i('⌨️ User stopped typing: $userId');
    } catch (e) {
      _logger.e('❌ Error handling user stop typing: $e');
    }
  }

  void _handleIncomingCall(dynamic data) {
    _callStream.add({
      'type': 'incoming',
      'data': data,
    });
    _logger.i('📞 Incoming call: $data');
  }

  void _handleCallAccepted(dynamic data) {
    _callStream.add({
      'type': 'accepted',
      'data': data,
    });
    _logger.i('✅ Call accepted: $data');
  }

  void _handleCallRejected(dynamic data) {
    _callStream.add({
      'type': 'rejected',
      'data': data,
    });
    _logger.i('❌ Call rejected: $data');
  }

  void _handleCallEnded(dynamic data) {
    _callStream.add({
      'type': 'ended',
      'data': data,
    });
    _logger.i('📞 Call ended: $data');
  }

  // Join chat room
  void joinChat(String chatId) {
    _socket?.emit('join_chat', {'chatId': chatId});
    _logger.i('🚪 Joined chat room: $chatId');
  }

  // Leave chat room
  void leaveChat(String chatId) {
    _socket?.emit('leave_chat', {'chatId': chatId});
    _logger.i('🚪 Left chat room: $chatId');
  }

  // Disconnect socket
  void disconnect() {
    _socket?.disconnect();
    _isConnected = false;
    _logger.i('🔌 Socket disconnected');
  }

  // Reconnect socket
  void reconnect() {
    _socket?.connect();
    _logger.i('🔌 Socket reconnection attempted');
  }

  // Dispose
  void dispose() {
    disconnect();
    _messageStream.close();
    _chatUpdateStream.close();
    _typingStream.close();
    _callStream.close();
    _logger.i('💬 Chat service disposed');
  }
}