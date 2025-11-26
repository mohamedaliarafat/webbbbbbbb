// presentation/widgets/notification_item.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer/data/models/notification_model.dart';
import 'package:provider/provider.dart';
import 'package:customer/presentation/providers/notification_provider.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final bool isRead;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool showDeleteOption;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.isRead,
    required this.onTap,
    required this.onDelete,
    this.showDeleteOption = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    
    return showDeleteOption 
        ? _buildDismissibleNotification(context, notificationProvider)
        : _buildRegularNotification(context, notificationProvider);
  }

  Widget _buildDismissibleNotification(BuildContext context, NotificationProvider provider) {
    return Dismissible(
      key: Key('${notification.id}_${DateTime.now().millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      background: _buildDismissibleBackground(),
      secondaryBackground: _buildDismissibleBackground(),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) => onDelete(),
      child: _buildNotificationContent(context, provider),
    );
  }

  Widget _buildRegularNotification(BuildContext context, NotificationProvider provider) {
    return _buildNotificationContent(context, provider);
  }

  Widget _buildNotificationContent(BuildContext context, NotificationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _buildNotificationDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showNotificationOptions(context, provider),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الإشعار
                _buildNotificationIcon(),
                const SizedBox(width: 16),
                
                // محتوى الإشعار
                Expanded(
                  child: _buildNotificationContentDetails(),
                ),
                
                // مؤشر القراءة والوقت
                _buildNotificationSideInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // خلفية السحب للحذف
  Widget _buildDismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.4),
            Colors.red.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.delete_forever, color: Colors.white, size: 28),
          SizedBox(width: 8),
          Text(
            'حذف',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // تزيين خلفية الإشعار
  BoxDecoration _buildNotificationDecoration() {
    final color = _getNotificationColor(notification.type);
    
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isRead
            ? [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
              ]
            : [
                color.withOpacity(0.15),
                color.withOpacity(0.08),
                Colors.black.withOpacity(0.6),
              ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isRead 
            ? Colors.white.withOpacity(0.05) 
            : color.withOpacity(0.25),
        width: 1.5,
      ),
      boxShadow: [
        if (!isRead)
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        BoxShadow(
          color: Colors.black.withOpacity(0.6),
          blurRadius: 25,
          spreadRadius: 3,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // أيقونة الإشعار
  Widget _buildNotificationIcon() {
    final color = _getNotificationColor(notification.type);
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        _getNotificationIcon(notification.type),
        color: color,
        size: 26,
      ),
    );
  }

  // محتوى الإشعار التفصيلي
  Widget _buildNotificationContentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان والبادئة
        Row(
          children: [
            // بادئة النوع
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getNotificationColor(notification.type).withOpacity(0.4),
                ),
              ),
              child: Text(
                _getNotificationPrefix(notification.type),
                style: GoogleFonts.cairo(
                  fontSize: 10,
                  color: _getNotificationColor(notification.type),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            
            // الأولوية إذا كانت عالية
            if (notification.priority == 'high' || notification.priority == 'urgent')
              _buildPriorityIndicator(),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // العنوان الرئيسي
        Text(
          notification.title,
          style: GoogleFonts.cairo(
            fontSize: 17,
            fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
            color: Colors.white,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // نص الإشعار
        Text(
          notification.body,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: Colors.white.withOpacity(0.85),
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 12),
        
        // المعلومات الإضافية
        _buildAdditionalInfo(),
      ],
    );
  }

  // معلومات جانبية (الوقت ومؤشر القراءة)
  Widget _buildNotificationSideInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // مؤشر عدم القراءة
        if (!isRead)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 12),
        
        const SizedBox(height: 8),
        
        // الوقت
        Text(
          _formatTime(notification.createdAt),
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // مؤشر الأولوية
  Widget _buildPriorityIndicator() {
    final isUrgent = notification.priority == 'urgent';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUrgent
              ? [Colors.red, Colors.orange]
              : [Colors.orange, Colors.amber],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: (isUrgent ? Colors.red : Colors.orange).withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUrgent ? Icons.warning_amber_rounded : Icons.priority_high_rounded,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            isUrgent ? 'عاجل' : 'مهم',
            style: GoogleFonts.cairo(
              fontSize: 9,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // المعلومات الإضافية
  Widget _buildAdditionalInfo() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        // نوع الإشعار
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getNotificationColor(notification.type).withOpacity(0.3),
            ),
          ),
          child: Text(
            _getNotificationTypeText(notification.type),
            style: GoogleFonts.cairo(
              fontSize: 10,
              color: _getNotificationColor(notification.type),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // طريقة الإرسال
        if (notification.sentViaFcm)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications, size: 10, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'تطبيق',
                  style: GoogleFonts.cairo(
                    fontSize: 9,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // عرض خيارات الإشعار
  void _showNotificationOptions(BuildContext context, NotificationProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // العنوان
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getNotificationIcon(notification.type),
                      color: _getNotificationColor(notification.type),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              // الخيارات
              _buildOptionItem(
                context,
                icon: isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                title: isRead ? 'تحديد كمقروء' : 'تحديد كمقروء',
                color: isRead ? Colors.blue : Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  if (!isRead) {
                    provider.markAsRead(notification.id);
                  }
                },
              ),
              
              _buildOptionItem(
                context,
                icon: Icons.delete,
                title: 'حذف الإشعار',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(context).then((confirmed) {
                    if (confirmed == true) {
                      onDelete();
                    }
                  });
                },
              ),
              
              _buildOptionItem(
                context,
                icon: Icons.share,
                title: 'مشاركة الإشعار',
                color: Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                  _shareNotification(context);
                },
              ),
              
              // إغلاق
              _buildOptionItem(
                context,
                icon: Icons.close,
                title: 'إغلاق',
                color: Colors.grey,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  // تأكيد الحذف
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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

  // مشاركة الإشعار
  void _shareNotification(BuildContext context) {
    // يمكنك استخدام package مثل share_plus لمشاركة الإشعار
    final shareText = '${notification.title}\n\n${notification.body}';
    
    // مثال باستخدام share_plus:
    // Share.share(shareText);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'تم نسخ الإشعار للمشاركة',
          style: GoogleFonts.cairo(),
        ),
      ),
    );
  }

  // الحصول على بادئة النوع
  String _getNotificationPrefix(String type) {
    switch (type) {
      case 'system': return '⚙️';
      case 'order_new': return '🛒';
      case 'fuel_order_new': return '⛽';
      case 'order_assigned': return '🚗';
      case 'payment_pending': return '💳';
      case 'chat_message': return '💬';
      case 'profile_approved': return '✅';
      case 'profile_rejected': return '❌';
      case 'admin_alert': return '👑';
      case 'fuel_delivery_started': return '🚚';
      default: return '🔔';
    }
  }

  // الحصول على أيقونة حسب نوع الإشعار
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'system': return Icons.settings;
      case 'auth': return Icons.security;
      case 'order_new': return Icons.shopping_cart;
      case 'fuel_order_new': return Icons.local_gas_station;
      case 'order_status': return Icons.update;
      case 'fuel_order_status': return Icons.update;
      case 'order_price': return Icons.attach_money;
      case 'order_assigned': return Icons.directions_car;
      case 'driver_assignment': return Icons.directions_car;
      case 'order_delivered': return Icons.done_all;
      case 'fuel_delivery_completed': return Icons.done_all;
      case 'payment_pending': return Icons.payment;
      case 'payment_verified': return Icons.verified;
      case 'payment_failed': return Icons.error;
      case 'chat_message': return Icons.chat;
      case 'incoming_call': return Icons.call;
      case 'profile_approved': return Icons.verified_user;
      case 'profile_rejected': return Icons.warning;
      case 'admin_alert': return Icons.admin_panel_settings;
      case 'supervisor_alert': return Icons.supervisor_account;
      case 'fuel_delivery_started': return Icons.local_shipping;
      case 'driver_location': return Icons.location_on;
      default: return Icons.notifications;
    }
  }

  // الحصول على لون حسب نوع الإشعار
  Color _getNotificationColor(String type) {
    switch (type) {
      case 'system': return Colors.blue;
      case 'auth': return Colors.blue;
      case 'order_new': return Colors.orange;
      case 'fuel_order_new': return Colors.orange;
      case 'order_status': return Colors.orange;
      case 'fuel_order_status': return Colors.orange;
      case 'fuel_delivery_started': return Colors.orange;
      case 'fuel_delivery_completed': return Colors.orange;
      case 'order_assigned': return Colors.green;
      case 'driver_assignment': return Colors.green;
      case 'order_price': return Colors.purple;
      case 'payment_pending': return Colors.purple;
      case 'payment_verified': return Colors.purple;
      case 'payment_failed': return Colors.red;
      case 'profile_rejected': return Colors.red;
      case 'chat_message': return Colors.lightBlue;
      case 'incoming_call': return Colors.lightBlue;
      case 'profile_approved': return Colors.green;
      case 'admin_alert': return Colors.amber;
      case 'supervisor_alert': return Colors.amber;
      case 'driver_location': return Colors.indigo;
      default: return Colors.grey;
    }
  }

  // الحصول على نص نوع الإشعار بالعربية
  String _getNotificationTypeText(String type) {
    switch (type) {
      case 'system': return 'النظام';
      case 'auth': return 'الأمان';
      case 'order_new': return 'طلب جديد';
      case 'fuel_order_new': return 'طلب وقود';
      case 'order_status': return 'حالة الطلب';
      case 'fuel_order_status': return 'حالة الطلب';
      case 'order_price': return 'تحديد السعر';
      case 'order_assigned': return 'تعيين سائق';
      case 'driver_assignment': return 'تعيين سائق';
      case 'order_delivered': return 'تم التسليم';
      case 'fuel_delivery_completed': return 'تم التسليم';
      case 'payment_pending': return 'انتظار الدفع';
      case 'payment_verified': return 'تم التحقق';
      case 'payment_failed': return 'فشل الدفع';
      case 'chat_message': return 'محادثة';
      case 'incoming_call': return 'مكالمة';
      case 'profile_approved': return 'موافقة';
      case 'profile_rejected': return 'رفض';
      case 'admin_alert': return 'تنبيه إداري';
      case 'supervisor_alert': return 'تنبيه مشرف';
      case 'fuel_delivery_started': return 'بدء التوصيل';
      case 'driver_location': return 'موقع السائق';
      default: return 'إشعار';
    }
  }

  // تنسيق الوقت
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} د';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ي';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}