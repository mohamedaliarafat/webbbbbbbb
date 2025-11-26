class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String orderId;
  final String type;
  final MessageContent content;
  final String status;
  final CallInfo? callInfo;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.orderId,
    required this.type,
    required this.content,
    required this.status,
    this.callInfo,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      chatId: json['chatId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      type: json['type'] ?? 'text',
      content: MessageContent.fromJson(json['content'] ?? {}),
      status: json['status'] ?? 'sent',
      callInfo: json['callInfo'] != null ? CallInfo.fromJson(json['callInfo']) : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'receiverId': receiverId,
      'content': content.toJson(),
      'type': type,
    };
  }
}

class MessageContent {
  final String text;
  final String mediaUrl;
  final int duration;
  final int fileSize;
  final String fileName;

  MessageContent({
    required this.text,
    required this.mediaUrl,
    required this.duration,
    required this.fileSize,
    required this.fileName,
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      text: json['text'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      duration: json['duration'] ?? 0,
      fileSize: json['fileSize'] ?? 0,
      fileName: json['fileName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'mediaUrl': mediaUrl,
      'duration': duration,
      'fileSize': fileSize,
      'fileName': fileName,
    };
  }
}

class CallInfo {
  final String type;
  final int duration;
  final String status;
  final String callId;

  CallInfo({
    required this.type,
    required this.duration,
    required this.status,
    required this.callId,
  });

  factory CallInfo.fromJson(Map<String, dynamic> json) {
    return CallInfo(
      type: json['type'] ?? 'audio',
      duration: json['duration'] ?? 0,
      status: json['status'] ?? 'answered',
      callId: json['callId'] ?? '',
    );
  }
}