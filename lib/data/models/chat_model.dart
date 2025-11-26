class ChatModel {
  final String id;
  final String orderId;
  final String customerId;
  final String driverId;
  final bool isActive;
  final Map<String, dynamic>? lastMessage;
  final Map<String, int> unreadCount;
  final bool callsEnabled;
  final bool videoCallsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.driverId,
    required this.isActive,
    this.lastMessage,
    required this.unreadCount,
    required this.callsEnabled,
    required this.videoCallsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      orderId: json['orderId']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      driverId: json['driverId']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
      lastMessage: json['lastMessage'],
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
      callsEnabled: json['callsEnabled'] ?? true,
      videoCallsEnabled: json['videoCallsEnabled'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}