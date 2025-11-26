// presentation/screens/notifications/notifications_screen.dart
import 'package:customer/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer/data/models/notification_model.dart';
import 'package:customer/presentation/widgets/notification/notification_item.dart';
import 'package:customer/presentation/screens/notifications/notification_details_screen.dart';


class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // تحميل الإشعارات عند بداية الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(LoadNotifications());
      context.read<NotificationBloc>().add(LoadNotificationStats());
    });

    // إعداد listener للتحميل التلقائي عند الوصول لنهاية القائمة
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<NotificationBloc>().add(LoadNotifications(
        page: _getCurrentPage() + 1,
      ));
    }
  }

  int _getCurrentPage() {
    final state = context.read<NotificationBloc>().state;
    if (state is NotificationLoaded) {
      return state.currentPage;
    }
    return 1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(right: 55),
          child: Text(
            'الإشعارات',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // زر تحديد الكل كمقروء
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              final unreadCount = _getUnreadCount(state);
              if (unreadCount > 0) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.mark_email_read, color: Colors.orange),
                    onPressed: () {
                      _showMarkAllReadConfirmation(context);
                    },
                    tooltip: 'تحديد الكل كمقروء',
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          
          // زر التحديث
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: () {
                context.read<NotificationBloc>().add(LoadNotifications());
              },
              tooltip: 'تحديث',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1a1a1a),
              Colors.black,
            ],
          ),
        ),
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationError) {
              // عرض رسالة الخطأ إذا لزم الأمر
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return _buildBodyContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildBodyContent(NotificationState state) {
    if (state is NotificationLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل الإشعارات...',
              style: GoogleFonts.cairo(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (state is NotificationError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.message,
                style: GoogleFonts.cairo(
                  color: Colors.white54,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationBloc>().add(LoadNotifications());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'إعادة المحاولة',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is NotificationLoaded && state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Icon(
                Icons.notifications_none,
                size: 60,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد إشعارات',
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيظهر هنا جميع إشعارات النظام والطلبات',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationBloc>().add(LoadNotifications());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تحديث',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is NotificationLoaded) {
      return RefreshIndicator(
        backgroundColor: Colors.black,
        color: Colors.white,
        onRefresh: () async {
          context.read<NotificationBloc>().add(LoadNotifications());
        },
        child: Column(
          children: [
            // شريط الإحصائيات
            if (_getUnreadCount(state) > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_active,
                      size: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'لديك ${_getUnreadCount(state)} إشعار غير مقروء',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            
            // قائمة الإشعارات
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  }
                  
                  final notification = state.notifications[index];
                  
                  return NotificationItem(
                    notification: notification,
                    isRead: notification.isRead,
                    onTap: () {
                      _handleNotificationTap(notification, context);
                    },
                    onDelete: () {
                      _showDeleteConfirmation(notification, context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // الحالة الابتدائية
    return Center(
      child: Text(
        'جاري التهيئة...',
        style: GoogleFonts.cairo(
          color: Colors.white54,
        ),
      ),
    );
  }

  int _getUnreadCount(NotificationState state) {
    if (state is NotificationLoaded) {
      return state.notifications.where((notification) => !notification.isRead).length;
    }
    return 0;
  }

  void _handleNotificationTap(AppNotification notification, BuildContext context) {
    // تحديد الإشعار كمقروء أولاً
    context.read<NotificationBloc>().add(MarkAsRead(notification.id));

    // التنقل بناءً على نوع الإشعار وبيانات التوجيه
    _navigateBasedOnNotification(notification, context);
  }

  void _navigateBasedOnNotification(AppNotification notification, BuildContext context) {
    final params = notification.routing.params;
    
    switch (notification.routing.screen) {
      case 'OrderDetails':
        Navigator.pushNamed(
          context,
          '/order-details',
          arguments: {
            'orderId': params['orderId'],
            'orderType': params['orderType'] ?? 'fuel',
          },
        );
        break;
        
      case 'TrackOrder':
        Navigator.pushNamed(
          context,
          '/track-order',
          arguments: {
            'orderId': params['orderId'],
          },
        );
        break;
        
      case 'ChatScreen':
        Navigator.pushNamed(
          context,
          '/chat',
          arguments: {
            'orderId': params['orderId'],
            'chatId': params['chatId'],
          },
        );
        break;
        
      case 'PaymentReview':
        Navigator.pushNamed(
          context,
          '/payment-proof',
          arguments: {
            'orderId': params['orderId'],
          },
        );
        break;
        
      case 'FuelOrderDetails':
        Navigator.pushNamed(
          context,
          '/fuel-order-details',
          arguments: {
            'orderId': params['orderId'],
          },
        );
        break;
        
      default:
        // إذا لم تكن هناك شاشة محددة، عرض تفاصيل الإشعار
        _showNotificationDetails(notification, context);
    }
  }

  void _showNotificationDetails(AppNotification notification, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailsScreen(notification: notification),
      ),
    );
  }

  void _showDeleteConfirmation(AppNotification notification, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'حذف الإشعار',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذا الإشعار؟',
            style: GoogleFonts.cairo(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<NotificationBloc>().add(DeleteNotification(notification.id));
                
                // عرض رسالة نجاح
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'تم حذف الإشعار بنجاح',
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                );
              },
              child: Text(
                'حذف',
                style: GoogleFonts.cairo(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMarkAllReadConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'تحديد الكل كمقروء',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل تريد تحديد جميع الإشعارات كمقروءة؟',
            style: GoogleFonts.cairo(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<NotificationBloc>().add(MarkAllAsRead());
                
                // عرض رسالة نجاح
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'تم تحديد جميع الإشعارات كمقروءة',
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                );
              },
              child: Text(
                'تأكيد',
                style: GoogleFonts.cairo(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}