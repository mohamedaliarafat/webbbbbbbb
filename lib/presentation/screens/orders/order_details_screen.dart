// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:customer/presentation/providers/order_provider.dart';
// import 'package:customer/data/models/fuel_order_model.dart';

// class OrderDetailsScreen extends StatelessWidget {
//   final String orderId;

//   const OrderDetailsScreen({
//     Key? key,
//     required this.orderId, required orderType,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<OrderProvider>(context);

//     // Load fuel order data
//     if (orderProvider.selectedFuelOrder?.id != orderId) {
//       orderProvider.loadFuelOrder(orderId);
//     }

//     final FuelOrderModel? order = orderProvider.selectedFuelOrder;

//     if (order == null) {
//       return Scaffold(
//         backgroundColor: Color(0xFF0A0E21),
//         appBar: AppBar(
//           backgroundColor: Color(0xFF1A237E),
//           title: Text(
//             'تفاصيل طلب الوقود',
//             style: GoogleFonts.cairo(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'جاري تحميل بيانات الطلب...',
//                 style: GoogleFonts.cairo(
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Color(0xFF0A0E21),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1A237E),
//         title: Text(
//           'تفاصيل طلب الوقود',
//           style: GoogleFonts.cairo(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           Container(
//             margin: EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white.withOpacity(0.2)),
//             ),
//             child: IconButton(
//               icon: Icon(Icons.chat, color: Colors.white),
//               onPressed: () {
//                 Navigator.pushNamed(
//                   context,
//                   '/chat',
//                   arguments: {
//                     'orderId': orderId,
//                     'orderType': 'fuel',
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF1A237E),
//               Color(0xFF283593),
//               Color(0xFF303F9F),
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Order Header
//               _buildGlassOrderHeader(order),
//               SizedBox(height: 16),

//               // Fuel Details
//               _buildGlassFuelDetails(order),
//               SizedBox(height: 16),

//               // Pricing
//               _buildGlassPricingInfo(order),
//               SizedBox(height: 16),

//               // Delivery Information
//               _buildGlassDeliveryInfo(order),
//               SizedBox(height: 16),

//               // Payment Information
//               _buildGlassPaymentInfo(order),
//               SizedBox(height: 16),

//               // Tracking Information
//               _buildGlassTrackingInfo(order),
//               SizedBox(height: 16),

//               // Actions
//               if (_shouldShowActions(order.status))
//                 _buildGlassOrderActions(context, orderProvider, order),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassOrderHeader(FuelOrderModel order) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'طلب وقود #${order.orderNumber}',
//                       style: GoogleFonts.cairo(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor(order.status).withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: _getStatusColor(order.status).withOpacity(0.4)),
//                       ),
//                       child: Text(
//                         _getStatusText(order.status),
//                         style: GoogleFonts.cairo(
//                           color: _getStatusColor(order.status),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   _formatDate(order.createdAt),
//                   style: GoogleFonts.cairo(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Divider(color: Colors.white.withOpacity(0.1)),
//                 SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.orange.withOpacity(0.3)),
//                       ),
//                       child: Icon(Icons.local_gas_station, color: Colors.orange, size: 20),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       '${order.fuelTypeName ?? _getFuelTypeText(order.fuelType)}',
//                       style: GoogleFonts.cairo(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Spacer(),
//                     Text(
//                       '${order.fuelLiters} لتر',
//                       style: GoogleFonts.cairo(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassFuelDetails(FuelOrderModel order) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.blue.withOpacity(0.3)),
//                       ),
//                       child: Icon(Icons.info, color: Colors.blue, size: 18),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       'تفاصيل الوقود',
//                       style: GoogleFonts.cairo(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 _buildGlassDetailRow('نوع الوقود', _getFuelTypeText(order.fuelType)),
//                 _buildGlassDetailRow('الكمية', '${order.fuelLiters} لتر'),
//                 if (order.fuelTypeName != null && order.fuelTypeName!.isNotEmpty)
//                   _buildGlassDetailRow('اسم الوقود', order.fuelTypeName!),
                
//                 SizedBox(height: 12),
//                 Divider(color: Colors.white.withOpacity(0.1)),
//                 SizedBox(height: 12),
                
              
                           
//                 if (order.vehicleInfo != null && order.vehicleInfo!.isNotEmpty) ...[
//                   if (order.vehicleInfo!['type'] != null && order.vehicleInfo!['type'].toString().isNotEmpty)
//                     _buildGlassDetailRow('نوع المركبة', order.vehicleInfo!['type'].toString()),
//                   if (order.vehicleInfo!['model'] != null && order.vehicleInfo!['model'].toString().isNotEmpty)
//                     _buildGlassDetailRow('موديل المركبة', order.vehicleInfo!['model'].toString()),
//                   if (order.vehicleInfo!['licensePlate'] != null && order.vehicleInfo!['licensePlate'].toString().isNotEmpty)
//                     _buildGlassDetailRow('رقم اللوحة', order.vehicleInfo!['licensePlate'].toString()),
//                   if (order.vehicleInfo!['color'] != null && order.vehicleInfo!['color'].toString().isNotEmpty)
//                     _buildGlassDetailRow('لون المركبة', order.vehicleInfo!['color'].toString()),
//                 ] else ...[
//                   _buildGlassDetailRow('معلومات المركبة', 'لم يتم إضافة معلومات المركبة'),
//                 ],
                
//                 if (order.customerNotes.isNotEmpty) ...[
//                   SizedBox(height: 12),
//                   Divider(color: Colors.white.withOpacity(0.1)),
//                   SizedBox(height: 12),
//                   _buildGlassDetailRow('ملاحظات العميل', order.customerNotes),
//                 ],
                
//                 if (order.supervisorNotes.isNotEmpty)
//                   _buildGlassDetailRow('ملاحظات المشرف', order.supervisorNotes),
                
//                 if (order.adminNotes.isNotEmpty)
//                   _buildGlassDetailRow('ملاحظات الإدارة', order.adminNotes),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassPricingInfo(FuelOrderModel order) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.green.withOpacity(0.3)),
//                       ),
//                       child: Icon(Icons.attach_money, color: Colors.green, size: 18),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       'التكلفة',
//                       style: GoogleFonts.cairo(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 _buildGlassPriceRow('السعر النهائي', '${order.pricing.finalPrice} ر.س'),
                
//                 SizedBox(height: 12),
//                 Divider(color: Colors.white.withOpacity(0.1)),
//                 SizedBox(height: 12),
                
//                 if (order.pricing.priceSetAt != null)
//                   _buildGlassDetailRow('تم تحديد السعر في', _formatDate(order.pricing.priceSetAt!)),
                
//                 _buildGlassDetailRow('ظهور السعر', order.pricing.priceVisible ? 'مرئي' : 'مخفي'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassDeliveryInfo(FuelOrderModel order) {
//     final loc = order.deliveryLocation;

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.purple.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.purple.withOpacity(0.3)),
//                       ),
//                       child: Icon(Icons.location_on, color: Colors.purple, size: 18),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       'معلومات التوصيل',
//                       style: GoogleFonts.cairo(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 _buildGlassDetailRow('عنوان التوصيل', loc.address),
                
//                 if (loc.contactName != null && loc.contactName!.isNotEmpty)
//                   _buildGlassDetailRow('اسم المستلم', loc.contactName!),
                
//                 if (loc.contactPhone != null && loc.contactPhone!.isNotEmpty)
//                   _buildGlassDetailRow('هاتف المستلم', loc.contactPhone!),
                
//                 if (loc.instructions != null && loc.instructions!.isNotEmpty)
//                   _buildGlassDetailRow('تعليمات التسليم', loc.instructions!),
                
//                 SizedBox(height: 12),
//                 Divider(color: Colors.white.withOpacity(0.1)),
//                 SizedBox(height: 12),
                
//                 // زر عرض الموقع على الخريطة
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF7986CB),
//                         Color(0xFF5C6BC0),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // TODO: فتح الخريطة بالإحداثيات
//                       _openMap(loc.lat, loc.lng);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.map, color: Colors.white),
//                         SizedBox(width: 8),
//                         Text(
//                           'عرض الموقع على الخريطة',
//                           style: GoogleFonts.cairo(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 if (order.deliveryCode != null && order.deliveryCode!.isNotEmpty) ...[
//                   SizedBox(height: 12),
//                   _buildGlassDetailRow('كود التسليم', order.deliveryCode!),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassPaymentInfo(FuelOrderModel order) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.amber.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.amber.withOpacity(0.3)),
//                       ),
//                       child: Icon(Icons.payment, color: Colors.amber, size: 18),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       'معلومات الدفع',
//                       style: GoogleFonts.cairo(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 _buildGlassDetailRow('حالة الدفع', _getPaymentStatusText(order.payment.status)),
                
//                 if (order.payment.proof.image.isNotEmpty)
//                   _buildGlassDetailRow('إيصال الدفع', 'تم رفع الإيصال'),
                
//                 if (order.payment.proof.bankName.isNotEmpty)
//                   _buildGlassDetailRow('اسم البنك', order.payment.proof.bankName),
                
//                 if (order.payment.proof.accountNumber.isNotEmpty)
//                   _buildGlassDetailRow('رقم الحساب', order.payment.proof.accountNumber),
                
//                 if (order.payment.proof.transferDate != null)
//                   _buildGlassDetailRow('تاريخ التحويل', _formatDate(order.payment.proof.transferDate!)),
                
//                 if (order.payment.proof.amount > 0)
//                   _buildGlassDetailRow('المبلغ المحول', '${order.payment.proof.amount} ر.س'),
                
//                 if (order.payment.verifiedAt != null)
//                   _buildGlassDetailRow('تم التحقق في', _formatDate(order.payment.verifiedAt!)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassTrackingInfo(FuelOrderModel order) {
//     if (order.tracking.isNotEmpty) {
//       return Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF1A237E).withOpacity(0.7),
//               Color(0xFF283593).withOpacity(0.5),
//               Color(0xFF303F9F).withOpacity(0.3),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withOpacity(0.1)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 15,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: Colors.teal.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.teal.withOpacity(0.3)),
//                         ),
//                         child: Icon(Icons.track_changes, color: Colors.teal, size: 18),
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         'تتبع الطلب',
//                         style: GoogleFonts.cairo(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   ...order.tracking.map((tracking) => _buildGlassTrackingItem(tracking)).toList(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return SizedBox();
//   }

//   Widget _buildGlassOrderActions(BuildContext context, OrderProvider orderProvider, FuelOrderModel order) {
//     final status = order.status;
    
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'الإجراءات',
//                   style: GoogleFonts.cairo(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Wrap(
//                   spacing: 12,
//                   runSpacing: 12,
//                   children: [
//                     if (status == 'pending')
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.red.withOpacity(0.8),
//                               Colors.red.withOpacity(0.6),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             _cancelOrder(context, orderProvider, order);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             elevation: 0,
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                           ),
//                           child: Text(
//                             'إلغاء الطلب',
//                             style: GoogleFonts.cairo(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
                    
//                     if (status == 'waiting_payment')
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color(0xFF7986CB),
//                               Color(0xFF5C6BC0),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushNamed(
//                               context,
//                               '/payment',
//                               arguments: {
//                                 'orderId': order.id,
//                                 'orderType': 'fuel',
//                                 'amount': order.pricing.finalPrice,
//                               },
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             elevation: 0,
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                           ),
//                           child: Text(
//                             'دفع الطلب',
//                             style: GoogleFonts.cairo(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
                    
//                     if (status == 'assigned_to_driver' || status == 'in_progress')
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.green.withOpacity(0.8),
//                               Colors.green.withOpacity(0.6),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushNamed(
//                               context,
//                               '/track-order',
//                               arguments: {
//                                 'orderId': order.id,
//                                 'isFuelOrder': true,
//                               },
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             elevation: 0,
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                           ),
//                           child: Text(
//                             'تتبع الطلب',
//                             style: GoogleFonts.cairo(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
                    
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.blue.withOpacity(0.8),
//                             Colors.blue.withOpacity(0.6),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushNamed(
//                             context,
//                             '/chat',
//                             arguments: {
//                               'orderId': order.id,
//                               'orderType': 'fuel',
//                             },
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           elevation: 0,
//                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         ),
//                         child: Text(
//                           'التواصل مع الدعم',
//                           style: GoogleFonts.cairo(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper methods
//   Widget _buildGlassDetailRow(String label, String value) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 120,
//             child: Text(
//               '$label:',
//               style: GoogleFonts.cairo(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white70,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: GoogleFonts.cairo(
//                 height: 1.4,
//                 color: Colors.white,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGlassPriceRow(String label, String value) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.green.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.cairo(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.cairo(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.green,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGlassTrackingItem(FuelOrderTracking tracking) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: _getStatusColor(tracking.status).withOpacity(0.2),
//               shape: BoxShape.circle,
//               border: Border.all(color: _getStatusColor(tracking.status).withOpacity(0.4)),
//             ),
//             child: Icon(
//               _getTrackingIcon(tracking.status),
//               size: 18,
//               color: _getStatusColor(tracking.status),
//             ),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _getStatusText(tracking.status),
//                   style: GoogleFonts.cairo(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 if (tracking.note.isNotEmpty)
//                   Text(
//                     tracking.note,
//                     style: GoogleFonts.cairo(
//                       fontSize: 12,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 SizedBox(height: 4),
//                 Text(
//                   _formatDate(tracking.timestamp),
//                   style: GoogleFonts.cairo(
//                     fontSize: 10,
//                     color: Colors.white54,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _openMap(double lat, double lng) {
//     // TODO: تنفيذ فتح الخريطة بالإحداثيات
//     // يمكن استخدام package مثل url_launcher لفتح تطبيق الخرائط
//     print('فتح الخريطة بالإحداثيات: $lat, $lng');
//   }

//   void _cancelOrder(BuildContext context, OrderProvider orderProvider, FuelOrderModel order) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF1A237E).withOpacity(0.9),
//                 Color(0xFF283593).withOpacity(0.8),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.red.withOpacity(0.3)),
//                   ),
//                   child: Icon(Icons.warning, color: Colors.red, size: 32),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'إلغاء طلب الوقود',
//                   style: GoogleFonts.cairo(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'هل أنت متأكد من إلغاء طلب الوقود هذا؟',
//                   style: GoogleFonts.cairo(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.white.withOpacity(0.2)),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'تراجع',
//                             style: GoogleFonts.cairo(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.red.withOpacity(0.8),
//                               Colors.red.withOpacity(0.6),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             Navigator.pop(context);
//                             try {
//                               await orderProvider.updateFuelOrderStatus(order.id, 'cancelled');
                              
//                               if (orderProvider.error.isEmpty && context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text('تم إلغاء طلب الوقود بنجاح'),
//                                     backgroundColor: Colors.green,
//                                     behavior: SnackBarBehavior.floating,
//                                   ),
//                                 );
//                                 Navigator.pop(context);
//                               }
//                             } catch (e) {
//                               if (context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text('فشل في إلغاء الطلب: ${e.toString()}'),
//                                     backgroundColor: Colors.red,
//                                     behavior: SnackBarBehavior.floating,
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'تأكيد الإلغاء',
//                             style: GoogleFonts.cairo(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _getFuelTypeText(String fuelType) {
//     switch (fuelType) {
//       case '91': return 'بنزين 91';
//       case '95': return 'بنزين 95';
//       case 'diesel': return 'ديزل';
//       case 'كيروسين': return 'كيروسين';
//       default: return fuelType;
//     }
//   }

//   String _getPaymentStatusText(String status) {
//     switch (status) {
//       case 'hidden': return 'مخفي';
//       case 'pending': return 'بانتظار الدفع';
//       case 'waiting_proof': return 'بانتظار إثبات الدفع';
//       case 'verifying': return 'قيد التحقق';
//       case 'verified': return 'تم التحقق';
//       case 'failed': return 'فشل الدفع';
//       default: return status;
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'pending': return Colors.orange;
//       case 'approved': return Colors.blue;
//       case 'in_progress': return Colors.purple;
//       case 'waiting_payment': return Colors.amber;
//       case 'assigned_to_driver': return Colors.indigo;
//       case 'completed': return Colors.green;
//       case 'cancelled': return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   IconData _getTrackingIcon(String status) {
//     switch (status) {
//       case 'pending': return Icons.pending;
//       case 'approved': return Icons.thumb_up;
//       case 'in_progress': return Icons.local_shipping;
//       case 'assigned_to_driver': return Icons.person;
//       case 'completed': return Icons.check_circle;
//       case 'cancelled': return Icons.cancel;
//       default: return Icons.local_gas_station;
//     }
//   }

//   String _getStatusText(String status) {
//     switch (status) {
//       case 'pending': return 'قيد الانتظار';
//       case 'approved': return 'تم الموافقة';
//       case 'in_progress': return 'قيد التوصيل';
//       case 'waiting_payment': return 'بانتظار الدفع';
//       case 'assigned_to_driver': return 'تم تعيين سائق';
//       case 'completed': return 'مكتمل';
//       case 'cancelled': return 'ملغي';
//       default: return status;
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//   }

//   bool _shouldShowActions(String status) {
//     return ['pending', 'waiting_payment', 'assigned_to_driver', 'in_progress'].contains(status);
//   }
// }


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/data/models/fuel_order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({
    Key? key,
    required this.orderId, 
    required String orderType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    // Load fuel order data
    if (orderProvider.selectedFuelOrder?.id != orderId) {
      orderProvider.loadFuelOrder(orderId);
    }

    final FuelOrderModel? order = orderProvider.selectedFuelOrder;

    if (order == null) {
      return Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        appBar: AppBar(
          backgroundColor: Color(0xFF1A237E),
          title: Text(
            'تفاصيل طلب الوقود',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'جاري تحميل بيانات الطلب...',
                style: GoogleFonts.cairo(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        title: Text(
          'تفاصيل طلب الوقود',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: {
                    'orderId': orderId,
                    'orderType': 'fuel',
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF303F9F),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              _buildGlassOrderHeader(order),
              SizedBox(height: 16),

              // Fuel Details
              _buildGlassFuelDetails(order),
              SizedBox(height: 16),

              // Pricing
              _buildGlassPricingInfo(order),
              SizedBox(height: 16),

              // Delivery Information
              _buildGlassDeliveryInfo(order),
              SizedBox(height: 16),

              // Payment Information
              _buildGlassPaymentInfo(order),
              SizedBox(height: 16),

              // Tracking Information
              _buildGlassTrackingInfo(order),
              SizedBox(height: 16),

              // Actions
              if (_shouldShowActions(order.status))
                _buildGlassOrderActions(context, orderProvider, order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassOrderHeader(FuelOrderModel order) {
    return Container(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'طلب وقود #${order.orderNumber}',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _getStatusColor(order.status).withOpacity(0.4)),
                      ),
                      child: Text(
                        _getStatusText(order.status),
                        style: GoogleFonts.cairo(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  _formatDate(order.createdAt),
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Icon(Icons.local_gas_station, color: Colors.orange, size: 20),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '${order.fuelTypeName ?? _getFuelTypeText(order.fuelType)}',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${order.fuelLiters} لتر',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
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

  Widget _buildGlassFuelDetails(FuelOrderModel order) {
    return Container(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Icon(Icons.info, color: Colors.blue, size: 18),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'تفاصيل الوقود',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildGlassDetailRow('نوع الوقود', _getFuelTypeText(order.fuelType)),
                _buildGlassDetailRow('الكمية', '${order.fuelLiters} لتر'),
                if (order.fuelTypeName != null && order.fuelTypeName!.isNotEmpty)
                  _buildGlassDetailRow('اسم الوقود', order.fuelTypeName!),
                
                SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 12),
                
                if (order.vehicleInfo != null && order.vehicleInfo!.isNotEmpty) ...[
                  if (order.vehicleInfo!['type'] != null && order.vehicleInfo!['type'].toString().isNotEmpty)
                    _buildGlassDetailRow('نوع المركبة', order.vehicleInfo!['type'].toString()),
                  if (order.vehicleInfo!['model'] != null && order.vehicleInfo!['model'].toString().isNotEmpty)
                    _buildGlassDetailRow('موديل المركبة', order.vehicleInfo!['model'].toString()),
                  if (order.vehicleInfo!['licensePlate'] != null && order.vehicleInfo!['licensePlate'].toString().isNotEmpty)
                    _buildGlassDetailRow('رقم اللوحة', order.vehicleInfo!['licensePlate'].toString()),
                  if (order.vehicleInfo!['color'] != null && order.vehicleInfo!['color'].toString().isNotEmpty)
                    _buildGlassDetailRow('لون المركبة', order.vehicleInfo!['color'].toString()),
                ] else ...[
                  _buildGlassDetailRow('معلومات المركبة', 'لم يتم إضافة معلومات المركبة'),
                ],
                
                if (order.customerNotes.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  SizedBox(height: 12),
                  _buildGlassDetailRow('ملاحظات العميل', order.customerNotes),
                ],
                
                if (order.supervisorNotes.isNotEmpty)
                  _buildGlassDetailRow('ملاحظات المشرف', order.supervisorNotes),
                
                if (order.adminNotes.isNotEmpty)
                  _buildGlassDetailRow('ملاحظات الإدارة', order.adminNotes),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassPricingInfo(FuelOrderModel order) {
    return Container(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Icon(Icons.attach_money, color: Colors.green, size: 18),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'التكلفة',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildGlassPriceRow('السعر النهائي', '${order.pricing.finalPrice} ر.س'),
                
                SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 12),
                
                if (order.pricing.priceSetAt != null)
                  _buildGlassDetailRow('تم تحديد السعر في', _formatDate(order.pricing.priceSetAt!)),
                
                _buildGlassDetailRow('ظهور السعر', order.pricing.priceVisible ? 'مرئي' : 'مخفي'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDeliveryInfo(FuelOrderModel order) {
    final loc = order.deliveryLocation;

    return Container(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.purple.withOpacity(0.3)),
                      ),
                      child: Icon(Icons.location_on, color: Colors.purple, size: 18),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'معلومات التوصيل',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildGlassDetailRow('عنوان التوصيل', loc.address),
                
                if (loc.contactName != null && loc.contactName!.isNotEmpty)
                  _buildGlassDetailRow('اسم المستلم', loc.contactName!),
                
                if (loc.contactPhone != null && loc.contactPhone!.isNotEmpty)
                  _buildGlassDetailRow('هاتف المستلم', loc.contactPhone!),
                
                if (loc.instructions != null && loc.instructions!.isNotEmpty)
                  _buildGlassDetailRow('تعليمات التسليم', loc.instructions!),
                
                SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 12),
                
                // زر عرض الموقع على الخريطة
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
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: فتح الخريطة بالإحداثيات
                      _openMap(loc.lat, loc.lng);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'عرض الموقع على الخريطة',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (order.deliveryCode != null && order.deliveryCode!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  _buildGlassDetailRow('كود التسليم', order.deliveryCode!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassPaymentInfo(FuelOrderModel order) {
    return Container(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: Icon(Icons.payment, color: Colors.amber, size: 18),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'معلومات الدفع',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildGlassDetailRow('حالة الدفع', _getPaymentStatusText(order.payment.status)),
                
                if (order.payment.proof.image.isNotEmpty)
                  _buildGlassDetailRow('إيصال الدفع', 'تم رفع الإيصال'),
                
                if (order.payment.proof.bankName.isNotEmpty)
                  _buildGlassDetailRow('اسم البنك', order.payment.proof.bankName),
                
                if (order.payment.proof.accountNumber.isNotEmpty)
                  _buildGlassDetailRow('رقم الحساب', order.payment.proof.accountNumber),
                
                if (order.payment.proof.transferDate != null)
                  _buildGlassDetailRow('تاريخ التحويل', _formatDate(order.payment.proof.transferDate!)),
                
                if (order.payment.proof.amount > 0)
                  _buildGlassDetailRow('المبلغ المحول', '${order.payment.proof.amount} ر.س'),
                
                if (order.payment.verifiedAt != null)
                  _buildGlassDetailRow('تم التحقق في', _formatDate(order.payment.verifiedAt!)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTrackingInfo(FuelOrderModel order) {
    if (order.tracking.isNotEmpty) {
      return Container(
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
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.teal.withOpacity(0.3)),
                        ),
                        child: Icon(Icons.track_changes, color: Colors.teal, size: 18),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'تتبع الطلب',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ...order.tracking.map((tracking) => _buildGlassTrackingItem(tracking)).toList(),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox();
  }

  Widget _buildGlassOrderActions(BuildContext context, OrderProvider orderProvider, FuelOrderModel order) {
    final status = order.status;
    
    return Container(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإجراءات',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (status == 'pending')
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.8),
                              Colors.red.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _cancelOrder(context, orderProvider, order);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text(
                            'إلغاء الطلب',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    if (status == 'waiting_payment')
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7986CB),
                              Color(0xFF5C6BC0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: {
                                'orderId': order.id,
                                'orderType': 'fuel',
                                'amount': order.pricing.finalPrice,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text(
                            'دفع الطلب',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    if (status == 'assigned_to_driver' || status == 'in_progress')
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.8),
                              Colors.green.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/track-order',
                              arguments: {
                                'orderId': order.id,
                                'isFuelOrder': true,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text(
                            'تتبع الطلب',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.8),
                            Colors.blue.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/chat',
                            arguments: {
                              'orderId': order.id,
                              'orderType': 'fuel',
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          'التواصل مع الدعم',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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

  // Helper methods
  Widget _buildGlassDetailRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                height: 1.4,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassPriceRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTrackingItem(FuelOrderTracking tracking) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor(tracking.status).withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: _getStatusColor(tracking.status).withOpacity(0.4)),
            ),
            child: Icon(
              _getTrackingIcon(tracking.status),
              size: 18,
              color: _getStatusColor(tracking.status),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(tracking.status),
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (tracking.note.isNotEmpty)
                  Text(
                    tracking.note,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                SizedBox(height: 4),
                Text(
                  _formatDate(tracking.timestamp),
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openMap(double lat, double lng) {
    // TODO: تنفيذ فتح الخريطة بالإحداثيات
    // يمكن استخدام package مثل url_launcher لفتح تطبيق الخرائط
    print('فتح الخريطة بالإحداثيات: $lat, $lng');
  }

  void _cancelOrder(BuildContext context, OrderProvider orderProvider, FuelOrderModel order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A237E).withOpacity(0.9),
                Color(0xFF283593).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.warning, color: Colors.red, size: 32),
                ),
                SizedBox(height: 16),
                Text(
                  'إلغاء طلب الوقود',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'هل أنت متأكد من إلغاء طلب الوقود هذا؟',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
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
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.8),
                              Colors.red.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await orderProvider.updateFuelOrderStatus(order.id, 'cancelled');
                              
                              if (orderProvider.error.isEmpty && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم إلغاء طلب الوقود بنجاح'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('فشل في إلغاء الطلب: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            'تأكيد الإلغاء',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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

  String _getFuelTypeText(String fuelType) {
    switch (fuelType) {
      case '91': return 'بنزين 91';
      case '95': return 'بنزين 95';
      case 'diesel': return 'ديزل';
      case 'كيروسين': return 'كيروسين';
      default: return fuelType;
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'hidden': return 'مخفي';
      case 'pending': return 'بانتظار الدفع';
      case 'waiting_proof': return 'بانتظار إثبات الدفع';
      case 'verifying': return 'قيد التحقق';
      case 'verified': return 'تم التحقق';
      case 'failed': return 'فشل الدفع';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'approved': return Colors.blue;
      case 'in_progress': return Colors.purple;
      case 'waiting_payment': return Colors.amber;
      case 'assigned_to_driver': return Colors.indigo;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getTrackingIcon(String status) {
    switch (status) {
      case 'pending': return Icons.pending;
      case 'approved': return Icons.thumb_up;
      case 'in_progress': return Icons.local_shipping;
      case 'assigned_to_driver': return Icons.person;
      case 'completed': return Icons.check_circle;
      case 'cancelled': return Icons.cancel;
      default: return Icons.local_gas_station;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return 'قيد الانتظار';
      case 'approved': return 'تم الموافقة';
      case 'in_progress': return 'قيد التوصيل';
      case 'waiting_payment': return 'بانتظار الدفع';
      case 'assigned_to_driver': return 'تم تعيين سائق';
      case 'completed': return 'مكتمل';
      case 'cancelled': return 'ملغي';
      default: return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  bool _shouldShowActions(String status) {
    return ['pending', 'waiting_payment', 'assigned_to_driver', 'in_progress'].contains(status);
  }
}