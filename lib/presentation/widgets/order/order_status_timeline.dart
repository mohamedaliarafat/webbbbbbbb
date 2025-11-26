import 'package:customer/data/models/fuel_order_model.dart';
import 'package:customer/data/models/petrol_order_model.dart';
import 'package:flutter/material.dart';

class OrderStatusTimeline extends StatelessWidget {
  final String status;
  final String orderType;
  final List<FuelOrderTracking>? tracking;

  const OrderStatusTimeline({
    Key? key,
    required this.status,
    required this.orderType,
    this.tracking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusSteps = _getStatusSteps();
    final currentStatusIndex = _getCurrentStatusIndex(statusSteps);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حالة الطلب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          _buildTimeline(statusSteps, currentStatusIndex),
          if (tracking != null && tracking!.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildTrackingHistory(tracking!),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeline(List<OrderStatusStep> steps, int currentIndex) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Line and Dot
            Column(
              children: [
                // Dot
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? Colors.green
                        : isCurrent
                            ? Colors.blue
                            : Colors.grey[300],
                    // border: Border.all(
                    //   color: isCompleted
                    //       ? Colors.green
                    //       : isCurrent
                    //           ? Colors.blue
                    //           : Colors.grey[400],
                    //   width: 2,
                    // ),
                  ),
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : isCurrent
                          ? Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.blue,
                            )
                          : null,
                ),
                // Line
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted ? Colors.green : Colors.grey[300],
                  ),
              ],
            ),
            SizedBox(width: 12),

            // Step Content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? Colors.green
                            : isCurrent
                                ? Colors.blue
                                : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      step.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (step.time != null) ...[
                      SizedBox(height: 4),
                      Text(
                        step.time!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTrackingHistory(List<FuelOrderTracking> tracking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سجل التتبع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        ...tracking.reversed.map((track) => _buildTrackingItem(track)).toList(),
      ],
    );
  }

  Widget _buildTrackingItem(FuelOrderTracking track) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getTrackingIcon(track.status),
            size: 20,
            color: _getStatusColor(track.status),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(track.status),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                if (track.note.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    track.note,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                SizedBox(height: 4),
                Text(
                  _formatDateTime(track.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<OrderStatusStep> _getStatusSteps() {
    if (orderType == 'fuel') {
      return _getFuelOrderStatusSteps();
    } else {
      return _getNormalOrderStatusSteps();
    }
  }

  List<OrderStatusStep> _getNormalOrderStatusSteps() {
    return [
      OrderStatusStep(
        title: 'تم الاستلام',
        description: 'تم استلام طلبك بنجاح',
        status: 'pending',
      ),
      OrderStatusStep(
        title: 'قيد المراجعة',
        description: 'جاري مراجعة الطلب من قبل المشرف',
        status: 'approved',
      ),
      OrderStatusStep(
        title: 'في انتظار الدفع',
        description: 'بانتظار تأكيد الدفع',
        status: 'waiting_payment',
      ),
      OrderStatusStep(
        title: 'قيد المعالجة',
        description: 'جاري تحضير طلبك',
        status: 'processing',
      ),
      OrderStatusStep(
        title: 'جاهز للتوصيل',
        description: 'الطلب جاهز للتسليم',
        status: 'ready_for_delivery',
      ),
      OrderStatusStep(
        title: 'تم تعيين سائق',
        description: 'تم تعيين سائق لتوصيل طلبك',
        status: 'assigned_to_driver',
      ),
      OrderStatusStep(
        title: 'تم الاستلام من السائق',
        description: 'استلم السائق الطلب',
        status: 'picked_up',
      ),
      OrderStatusStep(
        title: 'قيد التوصيل',
        description: 'الطلب في الطريق إليك',
        status: 'in_transit',
      ),
      OrderStatusStep(
        title: 'تم التسليم',
        description: 'تم تسليم الطلب بنجاح',
        status: 'delivered',
      ),
    ];
  }

  List<OrderStatusStep> _getFuelOrderStatusSteps() {
    return [
      OrderStatusStep(
        title: 'تم الاستلام',
        description: 'تم استلام طلب الوقود بنجاح',
        status: 'pending',
      ),
      OrderStatusStep(
        title: 'قيد المراجعة',
        description: 'جاري مراجعة الطلب من قبل المشرف',
        status: 'approved',
      ),
      OrderStatusStep(
        title: 'في انتظار الدفع',
        description: 'بانتظار تأكيد الدفع',
        status: 'waiting_payment',
      ),
      OrderStatusStep(
        title: 'قيد المعالجة',
        description: 'جاري تحضير طلب الوقود',
        status: 'processing',
      ),
      OrderStatusStep(
        title: 'جاهز للتوصيل',
        description: 'الطلب جاهز للتسليم',
        status: 'ready_for_delivery',
      ),
      OrderStatusStep(
        title: 'تم تعيين سائق',
        description: 'تم تعيين سائق لتوصيل الوقود',
        status: 'assigned_to_driver',
      ),
      OrderStatusStep(
        title: 'في الطريق',
        description: 'السائق في الطريق إليك',
        status: 'on_the_way',
      ),
      OrderStatusStep(
        title: 'جاري التعبئة',
        description: 'جاري تعبئة الوقود',
        status: 'fueling',
      ),
      OrderStatusStep(
        title: 'مكتمل',
        description: 'تم تسليم الوقود بنجاح',
        status: 'completed',
      ),
    ];
  }

  int _getCurrentStatusIndex(List<OrderStatusStep> steps) {
    final statusIndex = steps.indexWhere((step) => step.status == status);
    return statusIndex != -1 ? statusIndex : 0;
  }

  IconData _getTrackingIcon(String status) {
    switch (status) {
      case 'picked_up':
      case 'on_the_way':
        return Icons.directions_car;
      case 'in_transit':
        return Icons.local_shipping;
      case 'fueling':
        return Icons.local_gas_station;
      case 'delivered':
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'picked_up':
      case 'on_the_way':
      case 'in_transit':
      case 'fueling':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    final statusMap = {
      'pending': 'تم الاستلام',
      'approved': 'تمت الموافقة',
      'waiting_payment': 'بانتظار الدفع',
      'processing': 'قيد المعالجة',
      'ready_for_delivery': 'جاهز للتوصيل',
      'assigned_to_driver': 'تم تعيين سائق',
      'picked_up': 'تم الاستلام من السائق',
      'on_the_way': 'في الطريق',
      'in_transit': 'قيد التوصيل',
      'fueling': 'جاري التعبئة',
      'delivered': 'تم التسليم',
      'completed': 'مكتمل',
      'cancelled': 'ملغي',
    };
    return statusMap[status] ?? status;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays == 1) {
      return 'أمس في ${_formatTime(dateTime)}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class OrderStatusStep {
  final String title;
  final String description;
  final String status;
  final String? time;

  OrderStatusStep({
    required this.title,
    required this.description,
    required this.status,
    this.time,
  });
}

// استخدام المكون في الشاشات
class OrderStatusTimelineExample extends StatelessWidget {
  final FuelOrderModel order;
  final FuelOrderModel fuelOrder;

  const OrderStatusTimelineExample({
    Key? key,
    required this.order,
    required this.fuelOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // للمواد العادية
        OrderStatusTimeline(
          status: order.status,
          orderType: 'normal',
          tracking: order.tracking,
        ),
        
        SizedBox(height: 16),
        
        // للوقود
        OrderStatusTimeline(
          status: fuelOrder.status,
          orderType: 'fuel',
        ),
      ],
    );
  }
}