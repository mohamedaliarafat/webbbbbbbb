// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:customer/data/models/fuel_order_model.dart';

// class BankTransferScreen extends StatelessWidget {
//   final FuelOrderModel order;
  
//   final Map<String, String> bankInfo = {
//     'اسم البنك': 'مصرف الراجحي',
//     'رقم الحساب': 'SA1234567890123456789012',
//     'اسم صاحب الحساب': 'شركة البحيرة العربية للنقليات',
//     'رقم IBAN': 'SA03 8000 0000 6080 1016 7519',
//     'الفرع': 'حائل - الصناعية الثانية',
//   };

//   BankTransferScreen({required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Padding(
//           padding: const EdgeInsets.only(right: 55),
//           child: Text(
//             'التحويل البنكي - ${order.orderNumber}',
//             style: GoogleFonts.cairo(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.black,
//               Color(0xFF1a1a1a),
//               Colors.black,
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Order Summary Card
//               _buildOrderSummaryCard(),
//               const SizedBox(height: 20),

//               // Instructions
//               _buildGlassInstructionsCard(),
//               const SizedBox(height: 20),

//               // Bank Information Title
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   'معلومات الحساب البنكي',
//                   style: GoogleFonts.cairo(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Expanded(
//                 child: ListView(
//                   children: [
//                     _buildGlassInfoCard(),
//                     const SizedBox(height: 20),

//                     // Important Notes
//                     _buildGlassNotesCard(),
//                   ],
//                 ),
//               ),

//               // Action Buttons
//               const SizedBox(height: 20),
//               _buildGlassActionButtons(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummaryCard() {
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
//             color: Colors.blue.withOpacity(0.2),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'ملخص الطلب',
//                   style: GoogleFonts.cairo(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                   ),
//                   child: Text(
//                     order.orderNumber,
//                     style: GoogleFonts.cairo(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildOrderDetailRow('نوع الوقود', _getFuelTypeText(order.fuelType)),
//             _buildOrderDetailRow('الكمية', '${order.fuelLiters} لتر'),
//             _buildOrderDetailRow('الموقع', order.deliveryLocation.address),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.green.withOpacity(0.3)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'المبلغ المستحق',
//                     style: GoogleFonts.cairo(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '${order.pricing.finalPrice.toStringAsFixed(2)} ر.س',
//                     style: GoogleFonts.cairo(
//                       color: Color(0xFF81C784),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderDetailRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.cairo(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.cairo(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGlassInstructionsCard() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.blue.withOpacity(0.1),
//             Colors.black.withOpacity(0.6),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.blue.withOpacity(0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.2),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.blue.withOpacity(0.3)),
//                   ),
//                   child: const Icon(Icons.info, color: Colors.blue, size: 20),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'تعليمات التحويل',
//                   style: GoogleFonts.cairo(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInstructionItem('قم بإجراء التحويل البنكي باستخدام المعلومات أدناه'),
//                 _buildInstructionItem('احتفظ بصورة إيصال التحويل'),
//                 _buildInstructionItem('استخدم رقم الطلب كمرجع للتحويل: ${order.orderNumber}'),
//                 _buildInstructionItem('سيتم تفعيل طلبك بعد التحقق من التحويل'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInstructionItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 4),
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: GoogleFonts.cairo(
//                 color: Colors.white70,
//                 fontSize: 14,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGlassInfoCard() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.black.withOpacity(0.6),
//             Colors.black.withOpacity(0.4),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.green.withOpacity(0.1),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.5),
//             blurRadius: 20,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: bankInfo.entries.map((entry) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 120,
//                     child: Text(
//                       entry.key,
//                       style: GoogleFonts.cairo(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       entry.value,
//                       style: GoogleFonts.cairo(
//                         fontSize: 14,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   if (entry.key == 'رقم الحساب' || entry.key == 'رقم IBAN')
//                     Builder(
//                       builder: (context) => Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.3),
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white.withOpacity(0.1)),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
//                           onPressed: () {
//                             _copyToClipboard(context, entry.value);
//                           },
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassNotesCard() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.orange.withOpacity(0.1),
//             Colors.black.withOpacity(0.6),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.orange.withOpacity(0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.withOpacity(0.2),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.orange.withOpacity(0.3)),
//                   ),
//                   child: const Icon(Icons.warning, color: Colors.orange, size: 20),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'ملاحظات هامة',
//                   style: GoogleFonts.cairo(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildNoteItem('تأكد من صحة معلومات التحويل'),
//                 _buildNoteItem('احتفظ بإيصال التحويل لمدة 30 يوم'),
//                 _buildNoteItem('في حال وجود أي استفسار، يرجى التواصل مع خدمة العملاء'),
//                 _buildNoteItem('وقت معالجة التحويل: 1-2 يوم عمل'),
//                 _buildNoteItem('المبلغ: ${order.pricing.finalPrice.toStringAsFixed(2)} ر.س'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNoteItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 4),
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.orange,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: GoogleFonts.cairo(
//                 color: Colors.white70,
//                 fontSize: 14,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGlassActionButtons(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildGlassButton(
//             text: 'نسخ المعلومات',
//             icon: Icons.copy,
//             color: Colors.blue,
//             onPressed: () {
//               _copyBankInfoToClipboard(context);
//             },
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildGlassButton(
//             text: 'رفع الإيصال',
//             icon: Icons.receipt,
//             color: Colors.green,
//             onPressed: () {
//               Navigator.pushNamed(
//                 context, 
//                 '/payment-proof',
//                 arguments: {
//                   'order': order,
//                   'orderType': 'fuel',
//                   'paymentData': {
//                     'amount': order.pricing.finalPrice,
//                     'orderNumber': order.orderNumber,
//                     'paymentMethod': 'bank_transfer',
//                   }
//                 }
//               );
//             },
//             isPrimary: true,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGlassButton({
//     required String text,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//     bool isPrimary = false,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//           decoration: BoxDecoration(
//             color: isPrimary ? color.withOpacity(0.2) : Colors.black.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: color.withOpacity(0.3)),
//             boxShadow: isPrimary
//                 ? [
//                     BoxShadow(
//                       color: color.withOpacity(0.3),
//                       blurRadius: 10,
//                       spreadRadius: 1,
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 20,
//                 color: isPrimary ? Colors.white : color,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 text,
//                 style: GoogleFonts.cairo(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: isPrimary ? Colors.white : color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _copyBankInfoToClipboard(BuildContext context) {
//     final bankInfoText = '''
// معلومات التحويل البنكي
// رقم الطلب: ${order.orderNumber}
// المبلغ: ${order.pricing.finalPrice.toStringAsFixed(2)} ر.س

// ${bankInfo.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n')}

// يرجى استخدام رقم الطلب كمرجع للتحويل
// ''';
    
//     // In a real app, you would use Clipboard.setData
//     print('Bank info copied: $bankInfoText');
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'تم نسخ معلومات البنك مع تفاصيل الطلب',
//           style: GoogleFonts.cairo(),
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   void _copyToClipboard(BuildContext context, String text) {
//     // In a real app, you would use Clipboard.setData
//     print('Copied to clipboard: $text');
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'تم النسخ: $text',
//           style: GoogleFonts.cairo(),
//         ),
//         backgroundColor: Colors.blue,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   String _getFuelTypeText(String fuelType) {
//     switch (fuelType) {
//       case '91':
//         return 'بنزين 91';
//       case '95':
//         return 'بنزين 95';
//       case '98':
//         return 'بنزين 98';
//       case 'diesel':
//         return 'ديزل';
//       case 'premium_diesel':
//         return 'ديزل ممتاز';
//       default:
//         return fuelType;
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer/data/models/fuel_order_model.dart';

class BankTransferScreen extends StatelessWidget {
  final FuelOrderModel order;
  
  final Map<String, String> bankInfo = {
    'اسم البنك': 'مصرف الراجحي',
    'رقم الحساب': 'SA1234567890123456789012',
    'اسم صاحب الحساب': 'شركة البحيرة العربية للنقليات',
    'رقم IBAN': 'SA03 8000 0000 6080 1016 7519',
    'الفرع': 'حائل - الصناعية الثانية',
  };

  BankTransferScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(right: 55),
          child: Text(
            'التحويل البنكي - ${order.orderNumber}',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Card
                _buildOrderSummaryCard(),
                const SizedBox(height: 20),

                // Instructions
                _buildGlassInstructionsCard(),
                const SizedBox(height: 20),

                // Bank Information Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'معلومات الحساب البنكي',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Bank Information Card
                _buildGlassInfoCard(),
                const SizedBox(height: 20),

                // Important Notes
                _buildGlassNotesCard(),
                const SizedBox(height: 20),

                // Action Buttons
                _buildGlassActionButtons(context),
                
                // Extra space for better scrolling
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
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
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ملخص الطلب',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    order.orderNumber,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildOrderDetailRow('نوع الوقود', _getFuelTypeText(order.fuelType)),
            _buildOrderDetailRow('الكمية', '${order.fuelLiters} لتر'),
            _buildOrderDetailRow('الموقع', order.deliveryLocation.address),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المبلغ المستحق',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${order.pricing.finalPrice.toStringAsFixed(2)} ر.س',
                    style: GoogleFonts.cairo(
                      color: Color(0xFF81C784),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInstructionsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.info, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'تعليمات التحويل',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionItem('قم بإجراء التحويل البنكي باستخدام المعلومات أدناه'),
                _buildInstructionItem('احتفظ بصورة إيصال التحويل'),
                _buildInstructionItem('استخدم رقم الطلب كمرجع للتحويل: ${order.orderNumber}'),
                _buildInstructionItem('سيتم تفعيل طلبك بعد التحقق من التحويل'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInfoCard() {
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
            color: Colors.green.withOpacity(0.1),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: bankInfo.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    child: Text(
                      entry.key,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (entry.key == 'رقم الحساب' || entry.key == 'رقم IBAN')
                    Builder(
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
                          onPressed: () {
                            _copyToClipboard(context, entry.value);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGlassNotesCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.warning, color: Colors.orange, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'ملاحظات هامة',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNoteItem('تأكد من صحة معلومات التحويل'),
                _buildNoteItem('احتفظ بإيصال التحويل لمدة 30 يوم'),
                _buildNoteItem('في حال وجود أي استفسار، يرجى التواصل مع خدمة العملاء'),
                _buildNoteItem('وقت معالجة التحويل: 1-2 يوم عمل'),
                _buildNoteItem('المبلغ: ${order.pricing.finalPrice.toStringAsFixed(2)} ر.س'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGlassButton(
            text: 'نسخ المعلومات',
            icon: Icons.copy,
            color: Colors.blue,
            onPressed: () {
              _copyBankInfoToClipboard(context);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGlassButton(
            text: 'رفع الإيصال',
            icon: Icons.receipt,
            color: Colors.green,
            onPressed: () {
              Navigator.pushNamed(
                context, 
                '/payment-proof',
                arguments: {
                  'order': order,
                  'orderType': 'fuel',
                  'paymentData': {
                    'amount': order.pricing.finalPrice,
                    'orderNumber': order.orderNumber,
                    'paymentMethod': 'bank_transfer',
                  }
                }
              );
            },
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isPrimary ? color.withOpacity(0.2) : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
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
                size: 20,
                color: isPrimary ? Colors.white : color,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyBankInfoToClipboard(BuildContext context) {
    final bankInfoText = '''
معلومات التحويل البنكي
رقم الطلب: ${order.orderNumber}
المبلغ: ${order.pricing.finalPrice.toStringAsFixed(2)} ر.س

${bankInfo.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n')}

يرجى استخدام رقم الطلب كمرجع للتحويل
''';
    
    // In a real app, you would use Clipboard.setData
    print('Bank info copied: $bankInfoText');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم نسخ معلومات البنك مع تفاصيل الطلب',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    // In a real app, you would use Clipboard.setData
    print('Copied to clipboard: $text');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم النسخ: $text',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  String _getFuelTypeText(String fuelType) {
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
}