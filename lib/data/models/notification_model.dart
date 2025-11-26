class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? userId;
  final bool broadcast;
  final String? targetGroup;
  final String type;
  final NotificationData data;
  final NotificationRouting routing;
  final List<String> readBy;
  final bool sentViaFcm;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String priority;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.userId,
    this.broadcast = false,
    this.targetGroup,
    required this.type,
    required this.data,
    required this.routing,
    required this.readBy,
    required this.sentViaFcm,
    required this.createdAt,
    this.expiresAt,
    required this.priority,
    this.isRead = false, String? user,  sentViaEmail,  sentViaSms,  scheduledFor,  isScheduled,  updatedAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['user'],
      broadcast: json['broadcast'] ?? false,
      targetGroup: json['targetGroup'],
      type: json['type'] ?? 'system',
      data: NotificationData.fromJson(json['data'] ?? {}),
      routing: NotificationRouting.fromJson(json['routing'] ?? {}),
      readBy: List<String>.from(json['readBy'] ?? []),
      sentViaFcm: json['sentViaFcm'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      priority: json['priority'] ?? 'normal',
      isRead: (json['readBy'] as List).contains('current-user-id'), // ستستبدل هذا
    );
  }

  get sentViaSms => null;

  get sentViaEmail => null;

  get scheduledFor => null;

  get isScheduled => null;

  get updatedAt => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'user': userId,
      'broadcast': broadcast,
      'targetGroup': targetGroup,
      'type': type,
      'data': data.toJson(),
      'routing': routing.toJson(),
      'readBy': readBy,
      'sentViaFcm': sentViaFcm,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'priority': priority,
    };
  }

  AppNotification copyWith({
    bool? isRead,
    List<String>? readBy,
  }) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      userId: userId,
      broadcast: broadcast,
      targetGroup: targetGroup,
      type: type,
      data: data,
      routing: routing,
      readBy: readBy ?? this.readBy,
      sentViaFcm: sentViaFcm,
      createdAt: createdAt,
      expiresAt: expiresAt,
      priority: priority,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationData {
  final String? orderId;
  final String? driverId;
  final String? customerId;
  final String? chatId;
  final String? callId;
  final double? amount;
  final Location? location;
  final String? code;

  NotificationData({
    this.orderId,
    this.driverId,
    this.customerId,
    this.chatId,
    this.callId,
    this.amount,
    this.location,
    this.code,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      orderId: json['orderId'],
      driverId: json['driverId'],
      customerId: json['customerId'],
      chatId: json['chatId'],
      callId: json['callId'],
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'driverId': driverId,
      'customerId': customerId,
      'chatId': chatId,
      'callId': callId,
      'amount': amount,
      'location': location?.toJson(),
      'code': code,
    };
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'] != null ? double.parse(json['lat'].toString()) : 0.0,
      lng: json['lng'] != null ? double.parse(json['lng'].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class NotificationRouting {
  final String screen;
  final Map<String, dynamic> params;
  final String action;

  NotificationRouting({
    required this.screen,
    required this.params,
    required this.action,
  });

  factory NotificationRouting.fromJson(Map<String, dynamic> json) {
    return NotificationRouting(
      screen: json['screen'] ?? '',
      params: Map<String, dynamic>.from(json['params'] ?? {}),
      action: json['action'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screen': screen,
      'params': params,
      'action': action,
    };
  }
}