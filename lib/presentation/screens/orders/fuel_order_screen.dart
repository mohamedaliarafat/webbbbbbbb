// import 'dart:ui';

// import 'package:customer/data/models/address_model.dart';
// import 'package:customer/presentation/providers/address_provider.dart';
// import 'package:customer/presentation/providers/complete_profile_provider.dart';
// import 'package:customer/presentation/providers/order_provider.dart';
// import 'package:customer/presentation/providers/user_provider.dart';
// import 'package:customer/presentation/screens/auth/complete_profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:provider/provider.dart';

// class FuelOrderScreen extends StatefulWidget {
//   @override
//   _FuelOrderScreenState createState() => _FuelOrderScreenState();
// }

// class _FuelOrderScreenState extends State<FuelOrderScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _notesController = TextEditingController();

//   String _selectedFuelType = '95';
//   int _selectedLiters = 20000;
//   AddressModel? _selectedAddress;

//   final Map<String, String> _fuelTypes = {
//     '91': 'بنزين 91 ممتاز',
//     '95': 'بنزين 95 ممتاز',
//     'diesel': 'ديزل',
//     'كيروسين': 'كيروسين',
//   };

//   final List<int> _literOptions = [20000, 32000];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final addressProvider = Provider.of<AddressProvider>(context, listen: false);
//       addressProvider.loadAddresses();
      
//       // تحميل بيانات الملف الشخصي
//       final completeProfileProvider = Provider.of<CompleteProfileProvider>(context, listen: false);
//       completeProfileProvider.loadCompleteProfile();

//       // تحميل الطلبات الحالية للتحقق من الطلبات غير المكتملة
//       final orderProvider = Provider.of<OrderProvider>(context, listen: false);
//       orderProvider.loadFuelOrders();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final addressProvider = Provider.of<AddressProvider>(context);
//     final completeProfileProvider = Provider.of<CompleteProfileProvider>(context);
//     final orderProvider = Provider.of<OrderProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1A237E),
//         title: Text(
//           "شركة البحيرة العربية للنقليات ",
//           style: TextStyle(fontFamily: "Cairo"),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       backgroundColor: Color(0xFF0A0E21),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF1A237E),
//               Color(0xFF283593),
//               Color(0xFF303F9F),
//               Color(0xFF3949AB),
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildSectionHeader('نوع الوقود'),
//                 SizedBox(height: 8),
//                 _buildFuelDropdown(),

//                 SizedBox(height: 20),
//                 _buildSectionHeader('الكمية (لتر)'),
//                 SizedBox(height: 8),
//                 _buildLiterSelection(),

//                 SizedBox(height: 20),
//                 _buildSectionHeader('عنوان التوصيل'),
//                 SizedBox(height: 8),
//                 _buildAddressSelector(addressProvider),

//                 SizedBox(height: 20),
//                 _buildGlassCard(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionHeader('تعليمات التسليم'),
//                       SizedBox(height: 12),
//                       _buildGlassTextArea(
//                         controller: _notesController,
//                         labelText: 'ملاحظات إضافية (اختياري)',
//                         maxLines: 4,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30),

//                 // عرض حالة الملف الشخصي
//                 _buildProfileStatus(completeProfileProvider),

//                 // عرض حالة الطلبات غير المكتملة
//                 _buildIncompleteOrdersStatus(orderProvider),

//                 Consumer<OrderProvider>(
//                   builder: (context, orderProvider, child) {
//                     return Column(
//                       children: [
//                         if (orderProvider.error.isNotEmpty)
//                           _buildErrorMessage(orderProvider.error),
//                         SizedBox(height: 20),
//                         _buildSubmitButton(orderProvider, completeProfileProvider),
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // عرض حالة الطلبات غير المكتملة
//   Widget _buildIncompleteOrdersStatus(OrderProvider orderProvider) {
//     if (orderProvider.isLoading) {
//       return _buildGlassCard(
//         child: Row(
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//             SizedBox(width: 12),
//             Text(
//               'جاري التحقق من الطلبات...',
//               style: TextStyle(color: Colors.white, fontFamily: "Cairo"),
//             ),
//           ],
//         ),
//       );
//     }

//     final incompleteOrders = orderProvider.fuelOrders.where((order) {
//       return order.status == 'pending' || 
//              order.status == 'accepted' || 
//              order.status == 'assigned' ||
//              order.status == 'on_the_way';
//     }).toList();

//     if (incompleteOrders.isNotEmpty) {
//       return _buildIncompleteOrdersCard(incompleteOrders.length);
//     }

//     return SizedBox.shrink();
//   }

//   Widget _buildIncompleteOrdersCard(int incompleteCount) {
//     return _buildGlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.pending_actions, color: Colors.orange, size: 24),
//               SizedBox(width: 12),
//               Text(
//                 'يوجد طلبات قيد التنفيذ',
//                 style: TextStyle(
//                   color: Colors.orange,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: "Cairo",
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             'لديك $incompleteCount طلب قيد التنفيذ. يجب إكمال الطلبات الحالية قبل إضافة طلب جديد.',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//               fontFamily: "Cairo",
//             ),
//           ),
//           SizedBox(height: 16),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.orange.withOpacity(0.3),
//                   Colors.orange.withOpacity(0.1),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.orange.withOpacity(0.5)),
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () {
//                   // الانتقال إلى شاشة الطلبات
//                   Navigator.pushNamed(context, '/orderDetails');
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.list_alt, color: Colors.white, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         'عرض الطلبات الحالية',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: "Cairo",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // التحقق من وجود طلبات غير مكتملة
//   bool _hasIncompleteOrders(OrderProvider orderProvider) {
//     return orderProvider.fuelOrders.any((order) {
//       return order.status == 'pending' || 
//              order.status == 'accepted' || 
//              order.status == 'assigned' ||
//              order.status == 'on_the_way';
//     });
//   }

//   // دالة التحقق من إمكانية تقديم الطلب (محدثة)
//   bool _canSubmitOrder(CompleteProfileProvider completeProfileProvider, OrderProvider orderProvider) {
//     return completeProfileProvider.hasCompleteProfile &&
//         completeProfileProvider.isProfileApproved &&
//         !_hasIncompleteOrders(orderProvider);
//   }

//   Future<void> _createFuelOrder(OrderProvider orderProvider, CompleteProfileProvider completeProfileProvider) async {
//     // التحقق من اكتمال الملف الشخصي أولاً
//     if (!completeProfileProvider.hasCompleteProfile || !completeProfileProvider.isProfileApproved) {
//       String errorMessage = 'لا يمكن تقديم الطلب لأن الملف الشخصي غير مكتمل أو غير معتمد';
      
//       if (!completeProfileProvider.hasCompleteProfile) {
//         errorMessage = 'يجب اكمال الملف الشخصي أولاً قبل تقديم طلبات الوقود';
//       } else if (completeProfileProvider.isProfileRejected) {
//         errorMessage = 'الملف الشخصي مرفوض. يجب تعديله والحصول على الموافقة أولاً';
//       } else if (completeProfileProvider.profileStatus == 'submitted') {
//         errorMessage = 'الملف الشخصي قيد المراجعة. يجب انتظار موافقة الإدارة أولاً';
//       }
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage, style: TextStyle(fontFamily: "Cairo")),
//           backgroundColor: Colors.orange,
//           duration: Duration(seconds: 4),
//         ),
//       );
//       return;
//     }

//     // التحقق من الطلبات غير المكتملة
//     if (_hasIncompleteOrders(orderProvider)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'لا يمكن إضافة طلب جديد يوجد طلبات قيد التنفيذ. يرجى إكمال الطلبات الحالية أولاً.',
//             style: TextStyle(fontFamily: "Cairo"),
//           ),
//           backgroundColor: Colors.orange,
//           duration: Duration(seconds: 4),
//         ),
//       );
//       return;
//     }

//     if (_formKey.currentState!.validate()) {
//       if (_selectedAddress == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('يرجى اختيار عنوان التوصيل', style: TextStyle(fontFamily: "Cairo")),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         return;
//       }

//       // 🔹 الهيكل الصحيح للبيانات حسب توقعات الـ API
//       final orderData = {
//         'fuelType': _selectedFuelType,
//         'fuelLiters': _selectedLiters,
//         'deliveryLocation': {
//           'address': _selectedAddress!.addressLine1,
//           'coordinates': {
//             'lat': _selectedAddress!.coordinates?.lat ?? 0.0,
//             'lng': _selectedAddress!.coordinates?.lng ?? 0.0,
//           },
//           'contactName': _selectedAddress!.contactName ?? '',
//           'contactPhone': _selectedAddress!.contactPhone ?? '',
//           'instructions': _selectedAddress!.deliveryInstructions ?? '',
//         },
//         'vehicleInfo': {
//           'type': '', // يمكن تركها فارغة أو إضافتها لاحقاً
//           'model': '',
//           'licensePlate': '',
//           'color': '',
//         },
//         'notes': _notesController.text.trim(),
//         // الحقول التالية ستضاف تلقائياً من الباك اند
//         'status': 'pending',
//         'pricing': {
//           'estimatedPrice': 0,
//           'finalPrice': 0,
//           'priceVisible': false,
//           'fuelPricePerLiter': 0,
//           'serviceFee': 0,
//         },
//         'payment': {
//           'status': 'hidden',
//           'proof': {
//             'image': '',
//             'bankName': '',
//             'amount': 0,
//           }
//         }
//       };

//       print('📦 البيانات المرسلة للـ API: $orderData');

//       try {
//         await orderProvider.createFuelOrder(orderData);

//         if (orderProvider.error.isEmpty && context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('تم تقديم طلب الوقود بنجاح', style: TextStyle(fontFamily: "Cairo")),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 3),
//             ),
//           );
//           Navigator.pop(context);
//         } else if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('خطأ: ${orderProvider.error}'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } catch (e) {
//         print('❌ Create order error: $e');
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('حدث خطأ أثناء تقديم طلب الوقود: $e'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   // زر تقديم الطلب (محدث)
//   Widget _buildSubmitButton(OrderProvider orderProvider, CompleteProfileProvider completeProfileProvider) {
//     final canSubmit = _canSubmitOrder(completeProfileProvider, orderProvider);
//     final hasIncompleteOrders = _hasIncompleteOrders(orderProvider);
    
//     String buttonText = 'تقديم طلب الوقود';
//     if (!completeProfileProvider.hasCompleteProfile || !completeProfileProvider.isProfileApproved) {
//       buttonText = 'اكمل الملف الشخصي أولاً';
//     } else if (hasIncompleteOrders) {
//       buttonText = 'يوجد طلبات قيد التنفيذ';
//     }
    
//     return Container(
//       width: double.infinity,
//       height: 56,
//       decoration: BoxDecoration(
//         gradient: canSubmit 
//             ? LinearGradient(
//                 colors: [
//                   Color(0xFF7986CB),
//                   Color(0xFF5C6BC0),
//                   Color(0xFF3F51B5),
//                 ],
//               )
//             : LinearGradient(
//                 colors: [
//                   Colors.grey.withOpacity(0.5),
//                   Colors.grey.withOpacity(0.3),
//                 ],
//               ),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: canSubmit
//             ? [
//                 BoxShadow(
//                   color: Colors.blueAccent.withOpacity(0.4),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ]
//             : [],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(15),
//           onTap: orderProvider.isLoading || !canSubmit
//               ? null
//               : () => _createFuelOrder(orderProvider, completeProfileProvider),
//           child: Center(
//             child: orderProvider.isLoading
//                 ? SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.local_gas_station, 
//                         color: canSubmit ? Colors.white : Colors.white70
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         buttonText,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontFamily: "Cairo",
//                           fontWeight: FontWeight.bold,
//                           color: canSubmit ? Colors.white : Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   // باقي الدوال بدون تغيير...
//   Widget _buildProfileStatus(CompleteProfileProvider completeProfileProvider) {
//     if (completeProfileProvider.isLoading) {
//       return _buildGlassCard(
//         child: Row(
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//             SizedBox(width: 12),
//             Text(
//               'جاري التحقق من الملف الشخصي...',
//               style: TextStyle(color: Colors.white, fontFamily: "Cairo"),
//             ),
//           ],
//         ),
//       );
//     }

//     if (!completeProfileProvider.hasCompleteProfile) {
//       return _buildProfileIncompleteCard(
//         'لم يتم اكمال الملف الشخصي',
//         'يجب اكمال الملف الشخصي قبل تقديم طلبات الوقود',
//         Icons.person_outline,
//         Colors.orange,
//       );
//     }

//     if (completeProfileProvider.isProfileRejected) {
//       return _buildProfileIncompleteCard(
//         'الملف الشخصي مرفوض',
//         completeProfileProvider.rejectionReason.isNotEmpty 
//             ? completeProfileProvider.rejectionReason
//             : 'يجب تعديل الملف الشخصي المرفوض قبل تقديم الطلبات',
//         Icons.error_outline,
//         Colors.red,
//       );
//     }

//     if (completeProfileProvider.profileStatus == 'submitted') {
//       return _buildProfileIncompleteCard(
//         'الملف الشخصي قيد المراجعة',
//         'يجب انتظار موافقة الإدارة على الملف الشخصي قبل تقديم الطلبات',
//         Icons.pending_actions,
//         Colors.blue,
//       );
//     }

//     if (!completeProfileProvider.isProfileApproved) {
//       return _buildProfileIncompleteCard(
//         'الملف الشخصي غير مكتمل',
//         'يجب اكمال الملف الشخصي والحصول على الموافقة قبل تقديم الطلبات',
//         Icons.warning_amber,
//         Colors.orange,
//       );
//     }

//     // إذا كان الملف الشخصي مكتملاً ومعتمداً
//     return _buildGlassCard(
//       child: Row(
//         children: [
//           Icon(Icons.verified, color: Colors.green, size: 24),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'الملف الشخصي مكتمل ومعتمد',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "Cairo",
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'يمكنك الآن تقديم طلبات الوقود',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                     fontFamily: "Cairo",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileIncompleteCard(String title, String message, IconData icon, Color color) {
//     return _buildGlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: color, size: 24),
//               SizedBox(width: 12),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: color,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: "Cairo",
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             message,
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//               fontFamily: "Cairo",
//             ),
//           ),
//           SizedBox(height: 16),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color.withOpacity(0.3),
//                   color.withOpacity(0.1),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.5)),
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CompleteProfileScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.person, color: Colors.white, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         'اكمال الملف الشخصي',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: "Cairo",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFuelDropdown() {
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
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(15),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: DropdownButtonFormField<String>(
//             value: _selectedFuelType,
//             items: _fuelTypes.entries.map((entry) {
//               return DropdownMenuItem(
//                 value: entry.key,
//                 child: Text(
//                   entry.value,
//                   style: TextStyle(color: Colors.white, fontFamily: "Cairo"),
//                 ),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedFuelType = value!;
//               });
//             },
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.transparent,
//               contentPadding: EdgeInsets.symmetric(horizontal: 16),
//             ),
//             dropdownColor: Color(0xFF1A237E),
//             style: TextStyle(color: Colors.white, fontFamily: "Cairo"),
//             icon: Icon(Icons.arrow_drop_down, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLiterSelection() {
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
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(15),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(child: _buildLiterOption(20000, '20,000 لتر')),
//                 SizedBox(width: 12),
//                 Expanded(child: _buildLiterOption(32000, '32,000 لتر')),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorMessage(String error) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.red.withOpacity(0.3),
//             Colors.red.withOpacity(0.1),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.red.withOpacity(0.5)),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.error_outline, color: Colors.red),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               error,
//               style: TextStyle(color: Colors.red, fontFamily: "Cairo"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLiterOption(int liters, String label) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: _selectedLiters == liters
//             ? LinearGradient(
//                 colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)])
//             : LinearGradient(
//                 colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: _selectedLiters == liters ? Colors.white : Colors.white30,
//           width: 2,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () {
//             setState(() {
//               _selectedLiters = liters;
//             });
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   _formatLiters(liters),
//                   style: TextStyle(
//                     fontFamily: "Cairo",
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(label,
//                     style: TextStyle(color: Colors.white70, fontSize: 12,
//                     fontFamily: "Cairo"
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatLiters(int liters) {
//     if (liters >= 1000) return '${(liters / 1000).toStringAsFixed(0)}K';
//     return liters.toString();
//   }

//   Widget _buildSectionHeader(String title) {
//     return Text(title,
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: "Cairo"));
//   }

//   Widget _buildGlassCard({required Widget child}) {
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
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 5))],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(padding: EdgeInsets.all(20), child: child),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassTextArea({required TextEditingController controller, required String labelText, int maxLines = 3}) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
//         ),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white30),
//       ),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         style: TextStyle(color: Colors.white, fontFamily: "Cairo"),
//         decoration: InputDecoration(
//           labelText: labelText,
//           labelStyle: TextStyle(color: Colors.white70, fontFamily: "Cairo"),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.all(16),
//           alignLabelWithHint: true,
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressSelector(AddressProvider addressProvider) {
//     if (addressProvider.addresses.isEmpty) {
//       return _buildGlassCard(
//         child: Column(
//           children: [
//             Icon(Icons.location_off, size: 50, color: Colors.white70),
//             SizedBox(height: 12),
//             Text('لا توجد عناوين', style: TextStyle(color: Colors.white70, fontSize: 16,
//             fontFamily: "Cairo"
//             )),
//             SizedBox(height: 16),
//             _buildAddAddressButton(),
//           ],
//         ),
//       );
//     }

//     return Column(
//       children: [
//         ...addressProvider.addresses.map((address) {
//           return _buildAddressItem(address);
//         }),
//         SizedBox(height: 12),
//         _buildAddAddressButton(),
//       ],
//     );
//   }

//   Widget _buildAddAddressButton() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white30),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () {
//             Navigator.pushNamed(context, '/addAddress');
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.add, color: Colors.white70, size: 20),
//                 SizedBox(width: 8),
//                 Text('إضافة عنوان جديد', style: TextStyle(color: Colors.white70,
//                 fontFamily: "Cairo"
//                 )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressItem(AddressModel address) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             _selectedAddress?.id == address.id
//                 ? Color(0xFF7986CB).withOpacity(0.5)
//                 : Color(0xFF1A237E).withOpacity(0.5),
//             _selectedAddress?.id == address.id
//                 ? Color(0xFF5C6BC0).withOpacity(0.3)
//                 : Color(0xFF283593).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: _selectedAddress?.id == address.id ? Colors.white : Colors.white30,
//           width: 1.5,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(15),
//           onTap: () {
//             setState(() {
//               _selectedAddress = address;
//             });
//           },
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)]),
//                   ),
//                   child: Icon(Icons.location_on, color: Colors.white, size: 20),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(address.addressLine1,
//                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Cairo")),
//                       SizedBox(height: 4),
//                       Text('${address.city} - ${address.district}',
//                           style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: "Cairo")),
//                     ],
//                   ),
//                 ),
//                 if (address.isDefault) Icon(Icons.star, color: Colors.amber, size: 20),
//                 SizedBox(width: 8),
//                 Icon(
//                   _selectedAddress?.id == address.id ? Icons.radio_button_checked : Icons.radio_button_unchecked,
//                   color: _selectedAddress?.id == address.id ? Colors.white : Colors.white70,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _notesController.dispose();
//     super.dispose();
//   }
// }


import 'dart:ui';

import 'package:customer/data/models/address_model.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:customer/presentation/providers/complete_profile_provider.dart';
import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/presentation/providers/user_provider.dart';
import 'package:customer/presentation/screens/auth/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FuelOrderScreen extends StatefulWidget {
  @override
  _FuelOrderScreenState createState() => _FuelOrderScreenState();
}

class _FuelOrderScreenState extends State<FuelOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  String _selectedFuelType = '95';
  int _selectedLiters = 20000;
  AddressModel? _selectedAddress;

  final Map<String, String> _fuelTypes = {
    '91': 'بنزين 91 ممتاز',
    '95': 'بنزين 95 ممتاز',
    'diesel': 'ديزل',
    'كيروسين': 'كيروسين',
  };

  final List<int> _literOptions = [20000, 32000];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      addressProvider.loadAddresses();
      
      // تحميل بيانات الملف الشخصي
      final completeProfileProvider = Provider.of<CompleteProfileProvider>(context, listen: false);
      completeProfileProvider.loadCompleteProfile();

      // تحميل الطلبات الحالية للتحقق من الطلبات غير المكتملة
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.loadFuelOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final completeProfileProvider = Provider.of<CompleteProfileProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "طلب وقود جديد",
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
      body: Container(
        decoration: BoxDecoration(
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('نوع الوقود'),
                SizedBox(height: 8),
                _buildFuelDropdown(),

                SizedBox(height: 20),
                _buildSectionHeader('الكمية (لتر)'),
                SizedBox(height: 8),
                _buildLiterSelection(),

                SizedBox(height: 20),
                _buildSectionHeader('عنوان التوصيل'),
                SizedBox(height: 8),
                _buildAddressSelector(addressProvider),

                SizedBox(height: 20),
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('تعليمات التسليم'),
                      SizedBox(height: 12),
                      _buildGlassTextArea(
                        controller: _notesController,
                        labelText: 'ملاحظات إضافية (اختياري)',
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // عرض حالة الملف الشخصي
                _buildProfileStatus(completeProfileProvider),

                // عرض حالة الطلبات غير المكتملة
                _buildIncompleteOrdersStatus(orderProvider),

                Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    return Column(
                      children: [
                        if (orderProvider.error.isNotEmpty)
                          _buildErrorMessage(orderProvider.error),
                        SizedBox(height: 20),
                        _buildSubmitButton(orderProvider, completeProfileProvider),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // عرض حالة الطلبات غير المكتملة
  Widget _buildIncompleteOrdersStatus(OrderProvider orderProvider) {
    if (orderProvider.isLoading) {
      return _buildGlassCard(
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'جاري التحقق من الطلبات...',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          ],
        ),
      );
    }

    final incompleteOrders = orderProvider.fuelOrders.where((order) {
      return order.status == 'pending' || 
             order.status == 'accepted' || 
             order.status == 'assigned' ||
             order.status == 'on_the_way';
    }).toList();

    if (incompleteOrders.isNotEmpty) {
      return _buildIncompleteOrdersCard(incompleteOrders.length);
    }

    return SizedBox.shrink();
  }

  Widget _buildIncompleteOrdersCard(int incompleteCount) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Icon(Icons.pending_actions, color: Colors.orange, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'يوجد طلبات قيد التنفيذ',
                style: GoogleFonts.cairo(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'لديك $incompleteCount طلب قيد التنفيذ. يجب إكمال الطلبات الحالية قبل إضافة طلب جديد.',
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.2),
                  Colors.orange.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.pushNamed(context, '/orderDetails');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'عرض الطلبات الحالية',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // التحقق من وجود طلبات غير مكتملة
  bool _hasIncompleteOrders(OrderProvider orderProvider) {
    return orderProvider.fuelOrders.any((order) {
      return order.status == 'pending' || 
             order.status == 'accepted' || 
             order.status == 'assigned' ||
             order.status == 'on_the_way';
    });
  }

  // دالة التحقق من إمكانية تقديم الطلب (محدثة)
  bool _canSubmitOrder(CompleteProfileProvider completeProfileProvider, OrderProvider orderProvider) {
    return completeProfileProvider.hasCompleteProfile &&
        completeProfileProvider.isProfileApproved &&
        !_hasIncompleteOrders(orderProvider);
  }

  Future<void> _createFuelOrder(OrderProvider orderProvider, CompleteProfileProvider completeProfileProvider) async {
    // التحقق من اكتمال الملف الشخصي أولاً
    if (!completeProfileProvider.hasCompleteProfile || !completeProfileProvider.isProfileApproved) {
      String errorMessage = 'لا يمكن تقديم الطلب لأن الملف الشخصي غير مكتمل أو غير معتمد';
      
      if (!completeProfileProvider.hasCompleteProfile) {
        errorMessage = 'يجب اكمال الملف الشخصي أولاً قبل تقديم طلبات الوقود';
      } else if (completeProfileProvider.isProfileRejected) {
        errorMessage = 'الملف الشخصي مرفوض. يجب تعديله والحصول على الموافقة أولاً';
      } else if (completeProfileProvider.profileStatus == 'submitted') {
        errorMessage = 'الملف الشخصي قيد المراجعة. يجب انتظار موافقة الإدارة أولاً';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, style: GoogleFonts.cairo()),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // التحقق من الطلبات غير المكتملة
    if (_hasIncompleteOrders(orderProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا يمكن إضافة طلب جديد يوجد طلبات قيد التنفيذ. يرجى إكمال الطلبات الحالية أولاً.',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى اختيار عنوان التوصيل', style: GoogleFonts.cairo()),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // 🔹 الهيكل الصحيح للبيانات حسب توقعات الـ API
      final orderData = {
        'fuelType': _selectedFuelType,
        'fuelLiters': _selectedLiters,
        'deliveryLocation': {
          'address': _selectedAddress!.addressLine1,
          'coordinates': {
            'lat': _selectedAddress!.coordinates?.lat ?? 0.0,
            'lng': _selectedAddress!.coordinates?.lng ?? 0.0,
          },
          'contactName': _selectedAddress!.contactName ?? '',
          'contactPhone': _selectedAddress!.contactPhone ?? '',
          'instructions': _selectedAddress!.deliveryInstructions ?? '',
        },
        'vehicleInfo': {
          'type': '', // يمكن تركها فارغة أو إضافتها لاحقاً
          'model': '',
          'licensePlate': '',
          'color': '',
        },
        'notes': _notesController.text.trim(),
        // الحقول التالية ستضاف تلقائياً من الباك اند
        'status': 'pending',
        'pricing': {
          'estimatedPrice': 0,
          'finalPrice': 0,
          'priceVisible': false,
          'fuelPricePerLiter': 0,
          'serviceFee': 0,
        },
        'payment': {
          'status': 'hidden',
          'proof': {
            'image': '',
            'bankName': '',
            'amount': 0,
          }
        }
      };

      print('📦 البيانات المرسلة للـ API: $orderData');

      try {
        await orderProvider.createFuelOrder(orderData);

        if (orderProvider.error.isEmpty && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تقديم طلب الوقود بنجاح', style: GoogleFonts.cairo()),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ: ${orderProvider.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('❌ Create order error: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ أثناء تقديم طلب الوقود: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // زر تقديم الطلب (محدث)
  Widget _buildSubmitButton(OrderProvider orderProvider, CompleteProfileProvider completeProfileProvider) {
    final canSubmit = _canSubmitOrder(completeProfileProvider, orderProvider);
    final hasIncompleteOrders = _hasIncompleteOrders(orderProvider);
    
    String buttonText = 'تقديم طلب الوقود';
    if (!completeProfileProvider.hasCompleteProfile || !completeProfileProvider.isProfileApproved) {
      buttonText = 'اكمل الملف الشخصي أولاً';
    } else if (hasIncompleteOrders) {
      buttonText = 'يوجد طلبات قيد التنفيذ';
    }
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: canSubmit 
            ? LinearGradient(
                colors: [
                  Color(0xFF64B5F6),
                  Color(0xFF42A5F5),
                ],
              )
            : LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.5),
                  Colors.grey.withOpacity(0.3),
                ],
              ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: canSubmit ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: canSubmit
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: orderProvider.isLoading || !canSubmit
              ? null
              : () => _createFuelOrder(orderProvider, completeProfileProvider),
          child: Center(
            child: orderProvider.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: canSubmit ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: canSubmit ? Colors.blue : Colors.grey),
                        ),
                        child: Icon(
                          Icons.local_gas_station, 
                          color: canSubmit ? Colors.white : Colors.white70,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        buttonText,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: canSubmit ? Colors.white : Colors.white70,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // باقي الدوال المعدلة...
  Widget _buildProfileStatus(CompleteProfileProvider completeProfileProvider) {
    if (completeProfileProvider.isLoading) {
      return _buildGlassCard(
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'جاري التحقق من الملف الشخصي...',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (!completeProfileProvider.hasCompleteProfile) {
      return _buildProfileIncompleteCard(
        'لم يتم اكمال الملف الشخصي',
        'يجب اكمال الملف الشخصي قبل تقديم طلبات الوقود',
        Icons.person_outline,
        Colors.orange,
      );
    }

    if (completeProfileProvider.isProfileRejected) {
      return _buildProfileIncompleteCard(
        'الملف الشخصي مرفوض',
        completeProfileProvider.rejectionReason.isNotEmpty 
            ? completeProfileProvider.rejectionReason
            : 'يجب تعديل الملف الشخصي المرفوض قبل تقديم الطلبات',
        Icons.error_outline,
        Colors.red,
      );
    }

    if (completeProfileProvider.profileStatus == 'submitted') {
      return _buildProfileIncompleteCard(
        'الملف الشخصي قيد المراجعة',
        'يجب انتظار موافقة الإدارة على الملف الشخصي قبل تقديم الطلبات',
        Icons.pending_actions,
        Colors.blue,
      );
    }

    if (!completeProfileProvider.isProfileApproved) {
      return _buildProfileIncompleteCard(
        'الملف الشخصي غير مكتمل',
        'يجب اكمال الملف الشخصي والحصول على الموافقة قبل تقديم الطلبات',
        Icons.warning_amber,
        Colors.orange,
      );
    }

    // إذا كان الملف الشخصي مكتملاً ومعتمداً
    return _buildGlassCard(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Icon(Icons.verified, color: Colors.green, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الملف الشخصي مكتمل ومعتمد',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'يمكنك الآن تقديم طلبات الوقود',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileIncompleteCard(String title, String message, IconData icon, Color color) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.cairo(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompleteProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'اكمال الملف الشخصي',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelDropdown() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedFuelType,
        items: _fuelTypes.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(
              entry.value,
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedFuelType = value!;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Container(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Icon(Icons.local_gas_station, color: Colors.white70),
          ),
        ),
        dropdownColor: Colors.black,
        style: GoogleFonts.cairo(color: Colors.white),
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      ),
    );
  }

  Widget _buildLiterSelection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: _buildLiterOption(20000, '20,000 لتر')),
            SizedBox(width: 12),
            Expanded(child: _buildLiterOption(32000, '32,000 لتر')),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.2),
            Colors.red.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Icon(Icons.error_outline, color: Colors.red, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: GoogleFonts.cairo(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiterOption(int liters, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: _selectedLiters == liters
            ? LinearGradient(
                colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)])
            : LinearGradient(
                colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.2)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedLiters == liters ? Colors.blue.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _selectedLiters = liters;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatLiters(liters),
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(label,
                    style: GoogleFonts.cairo(
                      color: Colors.white70, 
                      fontSize: 12,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatLiters(int liters) {
    if (liters >= 1000) return '${(liters / 1000).toStringAsFixed(0)}K';
    return liters.toString();
  }

  Widget _buildSectionHeader(String title) {
    return Text(title,
        style: GoogleFonts.cairo(
          fontSize: 16, 
          fontWeight: FontWeight.bold, 
          color: Colors.white,
        ));
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
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
      child: Padding(padding: EdgeInsets.all(20), child: child),
    );
  }

  Widget _buildGlassTextArea({required TextEditingController controller, required String labelText, int maxLines = 3}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.cairo(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.cairo(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildAddressSelector(AddressProvider addressProvider) {
    if (addressProvider.addresses.isEmpty) {
      return _buildGlassCard(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Icon(Icons.location_off, size: 40, color: Colors.white70),
            ),
            SizedBox(height: 12),
            Text('لا توجد عناوين', 
                style: GoogleFonts.cairo(
                  color: Colors.white70, 
                  fontSize: 16,
                )),
            SizedBox(height: 16),
            _buildAddAddressButton(),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...addressProvider.addresses.map((address) {
          return _buildAddressItem(address);
        }),
        SizedBox(height: 12),
        _buildAddAddressButton(),
      ],
    );
  }

  Widget _buildAddAddressButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.2)]
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, '/addAddress');
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.add, color: Colors.blue, size: 18),
                ),
                SizedBox(width: 8),
                Text('إضافة عنوان جديد', 
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressItem(AddressModel address) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _selectedAddress?.id == address.id
                ? Color(0xFF64B5F6).withOpacity(0.2)
                : Colors.black.withOpacity(0.3),
            _selectedAddress?.id == address.id
                ? Color(0xFF42A5F5).withOpacity(0.1)
                : Colors.black.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _selectedAddress?.id == address.id ? Colors.blue.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              _selectedAddress = address;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedAddress?.id == address.id 
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedAddress?.id == address.id 
                          ? Colors.blue 
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.location_on, 
                    color: _selectedAddress?.id == address.id ? Colors.blue : Colors.white70, 
                    size: 20
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.addressLine1,
                          style: GoogleFonts.cairo(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 4),
                      Text('${address.city} - ${address.district}',
                          style: GoogleFonts.cairo(
                            color: Colors.white70, 
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
                if (address.isDefault) 
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _selectedAddress?.id == address.id 
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedAddress?.id == address.id 
                          ? Colors.blue 
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    _selectedAddress?.id == address.id 
                        ? Icons.radio_button_checked 
                        : Icons.radio_button_unchecked,
                    color: _selectedAddress?.id == address.id ? Colors.blue : Colors.white70,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}