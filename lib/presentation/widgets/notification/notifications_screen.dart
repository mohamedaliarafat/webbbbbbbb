import 'package:customer/bloc/notification_bloc.dart';
import 'package:customer/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = context.read<NotificationBloc>();
    _notificationBloc.add(LoadNotifications());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreNotifications();
    }
  }

  void _loadMoreNotifications() {
    final state = _notificationBloc.state;
    if (state is NotificationLoaded && !state.hasReachedMax) {
      _notificationBloc.add(LoadNotifications(page: state.currentPage + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () {
              _notificationBloc.add(MarkAllAsRead());
            },
            tooltip: 'تحديد الكل كمقروء',
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _notificationBloc.add(LoadNotifications());
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (state is NotificationLoaded) {
            return _buildNotificationsList(state);
          } else {
            return const Center(child: Text('لا توجد إشعارات'));
          }
        },
      ),
    );
  }

  Widget _buildNotificationsList(NotificationLoaded state) {
    if (state.notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد إشعارات'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _notificationBloc.add(LoadNotifications());
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.notifications.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.notifications.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildNotificationItem(state.notifications[index]);
        },
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<NotificationBloc>().add(DeleteNotification(notification.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الإشعار')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: notification.isRead ? Colors.white : Colors.blue[50],
        child: ListTile(
          leading: _getNotificationIcon(notification.type),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.body),
              const SizedBox(height: 4),
              Text(
                _formatDate(notification.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: notification.isRead
              ? null
              : const Icon(Icons.circle, color: Colors.blue, size: 12),
          onTap: () {
            if (!notification.isRead) {
              context.read<NotificationBloc>().add(MarkAsRead(notification.id));
            }
            _handleNotificationTap(notification);
          },
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
        color = Colors.green;
        break;
      case 'order_status':
        icon = Icons.update;
        color = Colors.orange;
        break;
      case 'payment_verified':
        icon = Icons.payment;
        color = Colors.green;
        break;
      case 'chat_message':
        icon = Icons.chat;
        color = Colors.blue;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'قبل ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'قبل ${difference.inHours} ساعة';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    // التنقل للشاشة المناسبة بناءً على routing data
    if (notification.routing.screen.isNotEmpty) {
      Navigator.of(context).pushNamed(
        notification.routing.screen,
        arguments: notification.routing.params,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}