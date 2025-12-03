import 'dart:ui';

import 'package:customer/core/constants/app_router.dart';
import 'package:customer/data/models/fuel_order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  final dynamic order;
  final String orderType;
  final VoidCallback? onTap;
  final VoidCallback? onTrack;
  final VoidCallback? onChat;

  const OrderCard({
    Key? key,
    required this.order,
    required this.orderType,
    this.onTap,
    this.onTrack,
    this.onChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildOrderDetails(),
                const SizedBox(height: 16),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getOrderTitle(),
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _getOrderNumber(),
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _getStatusColor().withOpacity(0.3)),
          ),
          child: Text(
            _getStatusText(),
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_getOrderDescription().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _getOrderDescription(),
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),

        _buildGlassInfoRow(
          icon: Icons.location_on,
          text: _getDeliveryAddress(),
          iconColor: Colors.orange,
        ),
        const SizedBox(height: 10),

        _buildGlassInfoRow(
          icon: Icons.calendar_today,
          text: _getOrderDate(),
          iconColor: Colors.blue,
        ),

        if (_hasDriver()) ...[
          const SizedBox(height: 10),
          // _buildGlassInfoRow(
          //   icon: Icons.person,
          //   // text: 'السائق: ${_getDriverName()}',
          //   iconColor: Colors.purple,
          // ),
        ],

        if (orderType == 'fuel') ...[
          const SizedBox(height: 10),
          _buildGlassInfoRow(
            icon: Icons.local_gas_station,
            text: '${_getFuelLiters()} لتر ${_getFuelType()}',
            iconColor: Colors.green,
          ),
        ],
      ],
    );
  }

  Widget _buildGlassInfoRow({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: iconColor.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final fuelOrder = order as FuelOrderModel;
    final showPayButton = fuelOrder.pricing.priceVisible && fuelOrder.status == 'waiting_payment';

    return Column(
      children: [
        // Price Section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_shouldShowPrice())
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getPrice(),
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'في انتظار التسعير',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.orange,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Action Buttons
        Row(
          children: [
            if (showPayButton)
              Expanded(
                child: _buildGlassActionButton(
                  icon: Icons.payment,
                  text: 'ادفع الآن',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/payment',
                      arguments: order,
                    );
                  },
                  color: Colors.purple,
                  isPrimary: true,
                ),
              ),

            if (showPayButton) const SizedBox(width: 8),

            if (_canTrack() && onTrack != null)
              Expanded(
                child: _buildGlassActionButton(
                  icon: Icons.my_location,
                  text: 'تتبع',
                  onPressed: onTrack!,
                  color: Colors.blue,
                ),
              ),

            if (_canTrack() && onTrack != null) const SizedBox(width: 8),

            if (_canChat() && onChat != null)
              Expanded(
                child: _buildGlassActionButton(
                  icon: Icons.track_changes,
                  text: 'تتبع',
                  onPressed:() {
                    AppRouter.navigateTo('/track-order');
                  },
                  color: Colors.teal,
                ),
              ),

            if (_canChat() && onChat != null) const SizedBox(width: 8),

            if (onTap != null)
              Expanded(
                child: _buildGlassActionButton(
                  icon: Icons.visibility,
                  text: 'تفاصيل',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/orderDetails',
                      arguments: fuelOrder,
                    );
                  },
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGlassActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color color,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isPrimary ? color.withOpacity(0.2) : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isPrimary ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: isPrimary ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  String _getOrderTitle() {
    switch (orderType) {
      case 'fuel':
        return 'طلب وقود';
      case 'product':
        return 'طلب منتج';
      default:
        return 'طلب توصيل';
    }
  }

  String _getOrderNumber() => orderType == 'fuel'
      ? (order as FuelOrderModel).orderNumber
      : (order as FuelOrderModel).orderNumber;

  String _getStatusText() {
    final status = orderType == 'fuel' ? (order as FuelOrderModel).status : (order as FuelOrderModel).status;
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'تم الموافقة';
      case 'waiting_payment':
        return 'بانتظار الدفع';
      case 'processing':
        return 'قيد المعالجة';
      case 'ready_for_delivery':
        return 'جاهز للتوصيل';
      case 'assigned_to_driver':
        return 'تم تعيين سائق';
      case 'picked_up':
      case 'on_the_way':
        return 'قيد التوصيل';
      case 'delivered':
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  Color _getStatusColor() {
    final status = orderType == 'fuel' ? (order as FuelOrderModel).status : (order as FuelOrderModel).status;
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'waiting_payment':
        return Colors.purple;
      case 'processing':
      case 'ready_for_delivery':
        return Colors.indigo;
      case 'assigned_to_driver':
      case 'picked_up':
      case 'on_the_way':
        return Colors.teal;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getOrderDescription() => orderType == 'fuel'
      ? 'توصيل وقود إلى الموقع'
      : (order as FuelOrderModel).description;

  String _getDeliveryAddress() =>
      orderType == 'fuel' ? (order as FuelOrderModel).deliveryLocation.address : (order as FuelOrderModel).deliveryLocation.address;

  String _getOrderDate() {
    final date = orderType == 'fuel' ? (order as FuelOrderModel).createdAt : (order as FuelOrderModel).createdAt;
    return '${_formatDate(date)} - ${_formatTime(date)}';
  }

  bool _hasDriver() => orderType == 'fuel'
      ? (order as FuelOrderModel).driverId != null
      : (order as FuelOrderModel).driverId != null;

  // String _getDriverName() => 'محمد أحمد';

  String _getFuelLiters() => orderType == 'fuel' ? (order as FuelOrderModel).fuelLiters.toString() : '';

  String _getFuelType() {
    if (orderType == 'fuel') {
      final fuelType = (order as FuelOrderModel).fuelType;
      switch (fuelType) {
        case '91':
          return 'بنزين 91';
        case '95':
          return 'بنزين 95';
        case '98':
          return 'بنزين 98';
        case 'diesel':
          return 'ديزل';
        case 'premium_diesel':
          return 'ديزل ممتاز';
        default:
          return fuelType;
      }
    }
    return '';
  }

  bool _shouldShowPrice() => orderType == 'fuel'
      ? (order as FuelOrderModel).pricing.priceVisible
      : (order as FuelOrderModel).pricing.priceVisible;

  String _getPrice() {
    final price = orderType == 'fuel'
        ? (order as FuelOrderModel).pricing.finalPrice
        : (order as FuelOrderModel).pricing.finalPrice;
    return '${price.toStringAsFixed(2)} ر.س';
  }

  bool _canTrack() {
    final status = orderType == 'fuel' ? (order as FuelOrderModel).status : (order as FuelOrderModel).status;
    return ['assigned_to_driver', 'picked_up', 'on_the_way', 'in_transit'].contains(status);
  }

  bool _canChat() {
    final status = orderType == 'fuel' ? (order as FuelOrderModel).status : (order as FuelOrderModel).status;
    return [
      'approved',
      'waiting_payment',
      'processing',
      'ready_for_delivery',
      'assigned_to_driver',
      'picked_up',
      'on_the_way',
      'in_transit'
    ].contains(status);
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
  String _formatTime(DateTime date) => '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}