import 'package:customer/data/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final AppNotification  notification;

  const NotificationDetailsScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الإشعار'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Header
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _getNotificationIcon(notification.type),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      notification.body,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          _formatDateTime(notification.createdAt),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Notification Details
            if (_hasDetails(notification))
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تفاصيل الإشعار',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      ..._buildDetailItems(notification),
                    ],
                  ),
                ),
              ),

            // Action Buttons
            if (_hasActions(notification))
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildActionButtons(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'order_new':
        icon = Icons.shopping_cart;
        color = Colors.orange;
        break;
      case 'order_status':
        icon = Icons.update;
        color = Colors.blue;
        break;
      case 'order_assigned':
        icon = Icons.directions_car;
        color = Colors.green;
        break;
      case 'payment_pending':
        icon = Icons.payment;
        color = Colors.amber;
        break;
      case 'payment_verified':
        icon = Icons.verified;
        color = Colors.green;
        break;
      case 'chat_message':
        icon = Icons.chat;
        color = Colors.purple;
        break;
      case 'incoming_call':
        icon = Icons.call;
        color = Colors.green;
        break;
      case 'profile_approved':
        icon = Icons.verified_user;
        color = Colors.green;
        break;
      case 'profile_rejected':
        icon = Icons.warning;
        color = Colors.red;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 24);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool _hasDetails(AppNotification  notification) {
    return notification.data.amount! > 0 ||
        notification.data.orderId != null ||
        notification.data.driverId != null ||
        notification.data.customerId != null ||
        notification.data.chatId != null ||
        notification.data.callId != null;
  }

  List<Widget> _buildDetailItems(AppNotification  notification) {
    final List<Widget> items = [];

    if (notification.data.orderId != null) {
      items.add(_buildDetailItem('رقم الطلب', notification.data.orderId!));
    }
    if (notification.data.driverId != null) {
      items.add(_buildDetailItem('معرف السائق', notification.data.driverId!));
    }
    if (notification.data.customerId != null) {
      items.add(_buildDetailItem('معرف العميل', notification.data.customerId!));
    }
    if (notification.data.chatId != null) {
      items.add(_buildDetailItem('معرف المحادثة', notification.data.chatId!));
    }
    if (notification.data.callId != null) {
      items.add(_buildDetailItem('معرف المكالمة', notification.data.callId!));
    }
    if (notification.data.amount! > 0) {
      items.add(_buildDetailItem('المبلغ', '${notification.data.amount} ر.س'));
    }
    if (notification.data.code != null) {
      items.add(_buildDetailItem('الكود', notification.data.code!));
    }

    return items;
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  bool _hasActions(AppNotification  notification) {
    return notification.routing.screen.isNotEmpty;
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final List<Widget> buttons = [];
    final params = notification.routing.params;

    switch (notification.routing.screen) {
      case 'OrderDetails':
        buttons.add(
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/order-details',
                arguments: {
                  'orderId': params['orderId'],
                  'orderType': params['orderType'] ?? 'normal',
                },
              );
            },
            child: Text('عرض تفاصيل الطلب'),
          ),
        );
        break;

      case 'TrackOrder':
        buttons.add(
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/track-order',
                arguments: {
                  'orderId': params['orderId'],
                  'orderType': params['orderType'] ?? 'normal',
                },
              );
            },
            child: Text('تتبع الطلب'),
          ),
        );
        break;

      case 'ChatScreen':
        buttons.addAll([
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: {
                  'orderId': params['orderId'],
                  'orderType': params['orderType'] ?? 'normal',
                },
              );
            },
            child: Text('فتح المحادثة'),
          ),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/call',
                arguments: {
                  'chatId': params['chatId'],
                  'callType': 'audio',
                },
              );
            },
            child: Text('الاتصال صوتياً'),
          ),
        ]);
        break;

      case 'PaymentReview':
        buttons.add(
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/payment-proof',
                arguments: {
                  'orderId': params['orderId'],
                  'orderType': params['orderType'] ?? 'normal',
                },
              );
            },
            child: Text('مراجعة الدفع'),
          ),
        );
        break;

      case 'CallScreen':
        buttons.add(
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/call',
                arguments: {
                  'callId': params['callId'],
                  'isIncoming': params['isIncoming'] ?? false,
                },
              );
            },
            child: Text('الاتصال الآن'),
          ),
        );
        break;
    }

    return buttons;
  }
}