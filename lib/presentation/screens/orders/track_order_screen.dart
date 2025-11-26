import 'package:customer/data/models/fuel_order_model.dart';
import 'package:customer/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderId;
  final String? orderType;

  const TrackOrderScreen({
    Key? key,
    required this.orderId,
    this.orderType,
  }) : super(key: key);

  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  void _loadOrder() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .loadFuelOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.selectedFuelOrder;

    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(
          'تتبع طلب الوقود',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A237E).withOpacity(0.8),
                Color(0xFF283593).withOpacity(0.6),
              ],
            ),
          ),
        ),
      ),
      body: orderProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : order == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white70, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'طلب الوقود غير موجود',
                        style: GoogleFonts.cairo(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildFuelOrderTracking(order),
    );
  }

  Widget _buildFuelOrderTracking(FuelOrderModel order) {
    final status = order.status;
    final orderNumber = order.orderNumber;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Order Header
          _buildGlassContainer(
            child: Column(
              children: [
                // Order Number Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF7986CB),
                        Color(0xFF5C6BC0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_number, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'طلب #$orderNumber',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Order Information
                _buildGlassInfoRow(
                  icon: Icons.local_gas_station,
                  label: 'نوع الطلب',
                  value: 'طلب وقود',
                  valueColor: Color(0xFF4CAF50),
                ),
                SizedBox(height: 12),
                _buildGlassInfoRow(
                  icon: Icons.timeline,
                  label: 'الحالة',
                  value: _getStatusText(status),
                  valueColor: _getStatusColor(status),
                  isStatus: true,
                ),
                
                // Price if waiting for payment
                if (status == 'waiting_payment' && order.pricing.finalPrice > 0)
                  Column(
                    children: [
                      SizedBox(height: 12),
                      _buildGlassInfoRow(
                        icon: Icons.attach_money,
                        label: 'المبلغ المستحق',
                        value: '${order.pricing.finalPrice.toStringAsFixed(2)} ر.س',
                        valueColor: Color(0xFF4CAF50),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Tracking Timeline
          _buildGlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timeline, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'مراحل طلب الوقود',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildTimeline(status),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Fuel Order Details
          _buildGlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'تفاصيل طلب الوقود',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildFuelOrderDetails(order),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Location Details
          _buildGlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'موقع التسليم',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.place, color: Colors.green, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          order.deliveryLocation.address,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Pricing Information
          if (order.pricing.priceVisible && order.pricing.finalPrice > 0)
            _buildGlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'التسعير',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildPricingDetails(order.pricing, order.fuelLiters),
                ],
              ),
            ),

          SizedBox(height: 20),

          // Payment Button for waiting_payment status
          if (status == 'waiting_payment')
            _buildGlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment, color: Colors.orange, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'إتمام الدفع',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'يرجى إتمام عملية الدفع للمتابعة في تنفيذ طلبك',
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7986CB),
                          Color(0xFF5C6BC0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _proceedToPayment(order),
                      icon: Icon(Icons.payment, color: Colors.white, size: 24),
                      label: Text(
                        'إتمام الدفع - ${order.pricing.finalPrice.toStringAsFixed(2)} ر.س',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Action Buttons Section
          if (_showChatButton(status) || 
              status == 'pending' || 
              status == 'approved' || 
              status == 'waiting_payment')
            _buildGlassContainer(
              child: Column(
                children: [
                  if (_showChatButton(status))
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF7986CB),
                            Color(0xFF5C6BC0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/chat',
                            arguments: {
                              'orderId': widget.orderId,
                              'orderType': 'fuel',
                            },
                          );
                        },
                        icon: Icon(Icons.chat, color: Colors.white),
                        label: Text(
                          'محادثة مع السائق',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                  if (_showChatButton(status) && 
                      (status == 'pending' || status == 'approved' || status == 'waiting_payment'))
                    SizedBox(height: 12),

                  // Cancel Button for pending orders
                  if (status == 'pending' || status == 'approved' || status == 'waiting_payment')
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _showCancelDialog(order),
                        icon: Icon(Icons.cancel, color: Colors.white),
                        label: Text(
                          'إلغاء الطلب',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E).withOpacity(0.7),
            Color(0xFF283593).withOpacity(0.5),
            Color(0xFF303F9F).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGlassInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    bool isStatus = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: valueColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: valueColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: valueColor, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          if (isStatus)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: valueColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: valueColor.withOpacity(0.3)),
              ),
              child: Text(
                value,
                style: GoogleFonts.cairo(
                  color: valueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              value,
              style: GoogleFonts.cairo(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeline(String currentStatus) {
    final steps = _getFuelOrderSteps();
    
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = _isStepCompleted(step['status']!, currentStatus);
        final isCurrent = step['status'] == currentStatus;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Dot with Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : (isCurrent ? Colors.orange : Colors.grey.withOpacity(0.3)),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? Colors.green : (isCurrent ? Colors.orange : Colors.grey),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isCompleted || isCurrent) 
                          ? (isCompleted ? Colors.green : Colors.orange).withOpacity(0.3)
                          : Colors.transparent,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _getStepIcon(step['status']!),
                  color: Colors.white,
                  size: 22,
                ),
              ),
              SizedBox(width: 16),
              // Timeline Content
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isCompleted || isCurrent) ? Colors.white.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: (isCompleted || isCurrent) ? Colors.white.withOpacity(0.2) : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title']!,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: isCompleted || isCurrent ? Colors.white : Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        step['description']!,
                        style: GoogleFonts.cairo(
                          color: isCompleted || isCurrent ? Colors.white70 : Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getStepIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.access_time;
      case 'approved':
        return Icons.thumb_up;
      case 'waiting_payment':
        return Icons.payment;
      case 'processing':
        return Icons.build;
      case 'assigned_to_driver':
        return Icons.person;
      case 'on_the_way':
        return Icons.directions_car;
      case 'arrived':
        return Icons.location_on;
      case 'fueling':
        return Icons.local_gas_station;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  Widget _buildFuelOrderDetails(FuelOrderModel order) {
    return Column(
      children: [
        _buildGlassDetailRow(
          icon: Icons.local_gas_station,
          label: 'نوع الوقود',
          value: _getFuelTypeText(order.fuelType),
        ),
        SizedBox(height: 12),
        _buildGlassDetailRow(
          icon: Icons.water_drop,
          label: 'الكمية',
          value: '${order.fuelLiters} لتر',
        ),
        if (order.vehicleInfo != null && order.vehicleInfo!['type']!.isNotEmpty)
          Column(
            children: [
              SizedBox(height: 12),
              _buildGlassDetailRow(
                icon: Icons.directions_car,
                label: 'نوع المركبة',
                value: order.vehicleInfo!['type'] ?? '',
              ),
            ],
          ),
        if (order.driverId != null)
          Column(
            children: [
              SizedBox(height: 12),
              _buildGlassDetailRow(
                icon: Icons.person,
                label: 'الحالة',
                value: 'تم تعيين سائق للتوصيل',
                valueColor: Colors.green,
              ),
            ],
          ),
        if (order.customerNotes.isNotEmpty)
          Column(
            children: [
              SizedBox(height: 12),
              _buildGlassDetailRow(
                icon: Icons.note,
                label: 'ملاحظات',
                value: order.customerNotes,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildGlassDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingDetails(FuelOrderPricing pricing, int fuelLiters) {
    return Column(
      children: [
        _buildGlassDetailRow(
          icon: Icons.local_gas_station,
          label: 'سعر الوقود',
          value: '${(pricing.fuelPricePerLiter * fuelLiters).toStringAsFixed(2)} ر.س',
        ),
        SizedBox(height: 12),
        _buildGlassDetailRow(
          icon: Icons.percent,
          label: 'رسوم الخدمة',
          value: '${pricing.serviceFee.toStringAsFixed(2)} ر.س',
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.attach_money, color: Colors.green, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'الإجمالي',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${pricing.finalPrice.toStringAsFixed(2)} ر.س',
                style: GoogleFonts.cairo(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _getFuelOrderSteps() {
    return [
      {
        'status': 'pending',
        'title': 'قيد الانتظار',
        'description': 'جاري مراجعة طلب الوقود',
      },
      {
        'status': 'approved',
        'title': 'تمت الموافقة',
        'description': 'تمت الموافقة على طلب الوقود',
      },
      {
        'status': 'waiting_payment',
        'title': 'بانتظار الدفع',
        'description': 'بانتظار تأكيد الدفع للمتابعة',
      },
      {
        'status': 'processing',
        'title': 'قيد المعالجة',
        'description': 'جاري تجهيز طلب الوقود',
      },
      {
        'status': 'assigned_to_driver',
        'title': 'تم تعيين سائق',
        'description': 'تم تعيين سائق لتوصيل الوقود',
      },
      {
        'status': 'on_the_way',
        'title': 'في الطريق',
        'description': 'سيارة الوقود في الطريق إليك',
      },
      {
        'status': 'arrived',
        'title': 'وصل الموقع',
        'description': 'سيارة الوقود وصلت موقع التسليم',
      },
      {
        'status': 'fueling',
        'title': 'جاري التعبئة',
        'description': 'جاري تعبئة الوقود',
      },
      {
        'status': 'completed',
        'title': 'مكتمل',
        'description': 'تم إكمال طلب الوقود بنجاح',
      },
    ];
  }

  bool _isStepCompleted(String stepStatus, String currentStatus) {
    final steps = _getFuelOrderSteps();
    final currentIndex = steps.indexWhere((step) => step['status'] == currentStatus);
    final stepIndex = steps.indexWhere((step) => step['status'] == stepStatus);
    return stepIndex <= currentIndex;
  }

  bool _showChatButton(String status) {
    return status == 'assigned_to_driver' || 
           status == 'on_the_way' ||
           status == 'arrived' ||
           status == 'fueling';
  }

  void _proceedToPayment(FuelOrderModel order) {
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'orderId': order.id,
        'orderNumber': order.orderNumber,
        'amount': order.pricing.finalPrice,
        'orderType': 'fuel',
      },
    );
  }

  void _showCancelDialog(FuelOrderModel order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A237E).withOpacity(0.9),
                Color(0xFF283593).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 50),
                SizedBox(height: 16),
                Text(
                  'إلغاء طلب الوقود',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'هل أنت متأكد من إلغاء طلب الوقود #${order.orderNumber}؟',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            'تراجع',
                            style: GoogleFonts.cairo(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.red.shade700],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _cancelOrder(order.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            'نعم، إلغاء',
                            style: GoogleFonts.cairo(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cancelOrder(String orderId) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.updateFuelOrderStatus(orderId, 'cancelled');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إلغاء طلب الوقود'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      case 'waiting_payment':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'assigned_to_driver':
      case 'on_the_way':
      case 'arrived':
      case 'fueling':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    final statusMap = {
      'pending': 'قيد الانتظار',
      'approved': 'تمت الموافقة',
      'waiting_payment': 'بانتظار الدفع',
      'processing': 'قيد المعالجة',
      'assigned_to_driver': 'تم تعيين سائق',
      'on_the_way': 'في الطريق',
      'arrived': 'وصل الموقع',
      'fueling': 'جاري التعبئة',
      'completed': 'مكتمل',
      'cancelled': 'ملغي',
    };
    return statusMap[status] ?? status;
  }

  String _getFuelTypeText(String fuelType) {
    final fuelTypeMap = {
      '91': 'بنزين 91',
      '95': 'بنزين 95',
      '98': 'بنزين 98',
      'diesel': 'ديزل',
      'premium_diesel': 'ديزل ممتاز',
      'كيروسين': 'كيروسين',
    };
    return fuelTypeMap[fuelType] ?? fuelType;
  }
}