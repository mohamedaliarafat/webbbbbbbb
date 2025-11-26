// import 'package:customer/data/models/payment_model.dart';
// import 'package:customer/presentation/providers/payment_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PaymentHistoryScreen extends StatefulWidget {
//   @override
//   _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
// }

// class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
//   final List<String> _statusFilters = ['all', 'pending', 'verified', 'rejected'];
//   String _selectedFilter = 'all';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<PaymentProvider>(context, listen: false).loadPayments();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paymentProvider = Provider.of<PaymentProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('سجل المدفوعات'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               paymentProvider.loadPayments();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filter Chips
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: _statusFilters.map((filter) {
//                   return Padding(
//                     padding: EdgeInsets.only(right: 8),
//                     child: FilterChip(
//                       label: Text(_getFilterText(filter)),
//                       selected: _selectedFilter == filter,
//                       onSelected: (selected) {
//                         setState(() {
//                           _selectedFilter = filter;
//                         });
//                         _loadFilteredPayments(paymentProvider, filter);
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),

//           // Payments List
//           Expanded(
//             child: paymentProvider.isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : _buildPaymentsList(paymentProvider),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getFilterText(String filter) {
//     switch (filter) {
//       case 'all':
//         return 'الكل';
//       case 'pending':
//         return 'قيد المراجعة';
//       case 'verified':
//         return 'تم التحقق';
//       case 'rejected':
//         return 'مرفوض';
//       default:
//         return filter;
//     }
//   }

//   void _loadFilteredPayments(PaymentProvider provider, String filter) {
//     final status = filter == 'all' ? null : filter;
//     provider.loadPayments(status: status);
//   }

//   Widget _buildPaymentsList(PaymentProvider provider) {
//     final filteredPayments = _selectedFilter == 'all'
//         ? provider.payments
//         : provider.payments.where((payment) => 
//             payment.status == _selectedFilter).toList();

//     if (filteredPayments.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.receipt_long,
//               size: 80,
//               color: Colors.grey,
//             ),
//             SizedBox(height: 16),
//             Text(
//               _getEmptyStateText(),
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () async {
//         await provider.loadPayments();
//       },
//       child: ListView.builder(
//         itemCount: filteredPayments.length,
//         itemBuilder: (context, index) {
//           final payment = filteredPayments[index];
//           return _buildPaymentCard(payment);
//         },
//       ),
//     );
//   }

//   String _getEmptyStateText() {
//     switch (_selectedFilter) {
//       case 'pending':
//         return 'لا توجد مدفوعات قيد المراجعة';
//       case 'verified':
//         return 'لا توجد مدفوعات تم التحقق منها';
//       case 'rejected':
//         return 'لا توجد مدفوعات مرفوضة';
//       default:
//         return 'لا توجد مدفوعات';
//     }
//   }

//   Widget _buildPaymentCard(PaymentModel payment) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     'رقم الطلب: ${payment.orderId}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 _buildStatusChip(payment.status),
//               ],
//             ),
//             SizedBox(height: 12),
//             _buildPaymentInfoRow('المبلغ', '${payment.totalAmount.toStringAsFixed(2)} ر.س'),
//             _buildPaymentInfoRow('طريقة الدفع', payment.paymentMethodText),
//             _buildPaymentInfoRow('التاريخ', _formatDate(payment.createdAt)),
            
//             // عرض رابط الإيصال إذا موجود
//             if (payment.receiptUrl.isNotEmpty) ..._buildReceiptInfo(payment),
            
//             if (payment.status == 'pending') ..._buildPendingActions(payment),
//             if (payment.status == 'rejected' && payment.rejectionReason.isNotEmpty) ..._buildRejectedInfo(payment),
//             if (payment.status == 'verified') ..._buildVerifiedInfo(payment),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildReceiptInfo(PaymentModel payment) {
//     return [
//       SizedBox(height: 8),
//       _buildPaymentInfoRow('الإيصال', 'مرفوع'),
//       if (payment.receiptUrl.startsWith('http'))
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             icon: Icon(Icons.visibility, size: 16),
//             label: Text('عرض الإيصال'),
//             onPressed: () {
//               _showReceiptImage(payment.receiptUrl);
//             },
//           ),
//         ),
//     ];
//   }

//   List<Widget> _buildPendingActions(PaymentModel payment) {
//     return [
//       SizedBox(height: 12),
//       Divider(),
//       SizedBox(height: 8),
//       Text(
//         'بانتظار مراجعة الأدمن',
//         style: TextStyle(
//           color: Colors.orange,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       SizedBox(height: 8),
//       Row(
//         children: [
//           Expanded(
//             child: OutlinedButton.icon(
//               icon: Icon(Icons.visibility, size: 18),
//               label: Text('عرض التفاصيل'),
//               onPressed: () {
//                 _showPaymentDetails(payment);
//               },
//             ),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: Icon(Icons.receipt, size: 18),
//               label: Text('إعادة الرفع'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 _reuploadPaymentProof(payment);
//               },
//             ),
//           ),
//         ],
//       ),
//     ];
//   }

//   List<Widget> _buildRejectedInfo(PaymentModel payment) {
//     return [
//       SizedBox(height: 12),
//       Divider(),
//       SizedBox(height: 8),
//       Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.red[50],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.red[100]!),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.error_outline, color: Colors.red, size: 18),
//                 SizedBox(width: 8),
//                 Text(
//                   'تم رفض الدفع',
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               'سبب الرفض: ${payment.rejectionReason}',
//               style: TextStyle(
//                 color: Colors.red[700],
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 8),
//       SizedBox(
//         width: double.infinity,
//         child: ElevatedButton.icon(
//           icon: Icon(Icons.replay, size: 18),
//           label: Text('إعادة رفع الإيصال'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//           ),
//           onPressed: () {
//             _reuploadPaymentProof(payment);
//           },
//         ),
//       ),
//     ];
//   }

//   List<Widget> _buildVerifiedInfo(PaymentModel payment) {
//     return [
//       SizedBox(height: 12),
//       Divider(),
//       SizedBox(height: 8),
//       Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.green[50],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.green[100]!),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green, size: 18),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 'تم التحقق من الدفع بنجاح',
//                 style: TextStyle(
//                   color: Colors.green[800],
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 8),
//       if (payment.verifiedAt != null)
//         _buildPaymentInfoRow('تاريخ التحقق', _formatDate(payment.verifiedAt!)),
//     ];
//   }

//   Widget _buildPaymentInfoRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey[600],
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color chipColor;
//     Color textColor;
//     String statusText;
//     IconData icon;

//     switch (status) {
//       case 'verified':
//         chipColor = Colors.green;
//         textColor = Colors.white;
//         statusText = 'تم التحقق';
//         icon = Icons.check_circle;
//         break;
//       case 'rejected':
//         chipColor = Colors.red;
//         textColor = Colors.white;
//         statusText = 'مرفوض';
//         icon = Icons.cancel;
//         break;
//       case 'pending':
//       default:
//         chipColor = Colors.orange;
//         textColor = Colors.white;
//         statusText = 'قيد المراجعة';
//         icon = Icons.access_time;
//     }

//     return Chip(
//       label: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: textColor),
//           SizedBox(width: 4),
//           Text(
//             statusText,
//             style: TextStyle(color: textColor, fontSize: 12),
//           ),
//         ],
//       ),
//       backgroundColor: chipColor,
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//   }

//   void _showPaymentDetails(PaymentModel payment) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.receipt_long, color: Colors.blue),
//             SizedBox(width: 8),
//             Text('تفاصيل الدفع'),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildDetailRow('رقم الطلب', payment.orderId),
//               _buildDetailRow('المبلغ', '${payment.totalAmount.toStringAsFixed(2)} ر.س'),
//               _buildDetailRow('طريقة الدفع', payment.paymentMethodText),
//               _buildDetailRow('الحالة', payment.statusText),
//               _buildDetailRow('تاريخ الإنشاء', _formatDate(payment.createdAt)),
              
//               if (payment.status == 'verified' && payment.verifiedAt != null)
//                 _buildDetailRow('تاريخ التحقق', _formatDate(payment.verifiedAt!)),
              
//               if (payment.bankTransfer.bankName.isNotEmpty) ...[
//                 SizedBox(height: 16),
//                 Text(
//                   'معلومات التحويل:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 _buildDetailRow('اسم البنك', payment.bankTransfer.bankName),
//                 _buildDetailRow('رقم الحساب', payment.bankTransfer.accountNumber),
//                 _buildDetailRow('رقم المرجع', payment.bankTransfer.referenceNumber),
//               ],
              
//               if (payment.receiptUrl.isNotEmpty) ...[
//                 SizedBox(height: 16),
//                 Text(
//                   'معلومات الإيصال:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 _buildDetailRow('رابط الإيصال', payment.receiptUrl),
//                 if (payment.receiptUrl.startsWith('http'))
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       icon: Icon(Icons.visibility),
//                       label: Text('عرض صورة الإيصال'),
//                       onPressed: () {
//                         Navigator.pop(context); // Close details dialog
//                         _showReceiptImage(payment.receiptUrl);
//                       },
//                     ),
//                   ),
//               ],
              
//               if (payment.rejectionReason.isNotEmpty) ...[
//                 SizedBox(height: 16),
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.red[50],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'سبب الرفض:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(payment.rejectionReason),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('إغلاق'),
//           ),
//           if (payment.status == 'pending')
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _reuploadPaymentProof(payment);
//               },
//               child: Text('إعادة الرفع'),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showReceiptImage(String receiptUrl) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'إيصال الدفع',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 width: double.infinity,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: NetworkImage(receiptUrl),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('إغلاق'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _reuploadPaymentProof(PaymentModel payment) {
//     // Navigate to payment proof upload screen with existing payment data
//     Navigator.pushNamed(
//       context,
//       '/payment-proof',
//       arguments: {
//         'order': payment.orderId,
//         'payment': payment,
//         'isReupload': true,
//       },
//     ).then((_) {
//       // Refresh the list when returning from upload screen
//       Provider.of<PaymentProvider>(context, listen: false).loadPayments();
//     });
//   }
// }



import 'package:customer/data/models/payment_model.dart';
import 'package:customer/presentation/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final List<String> _statusFilters = ['all', 'pending', 'verified', 'rejected'];
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaymentProvider>(context, listen: false).loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF283593).withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 55),
          child: Padding(
            padding: const EdgeInsets.only(left: 35),
            child: Text(
              'سجل المدفوعات',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(4),
            
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                paymentProvider.loadPayments();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A237E).withOpacity(0.8),
                  Color(0xFF283593).withOpacity(0.7),
                  Color(0xFF303F9F).withOpacity(0.6),
                ],
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              itemCount: _statusFilters.length,
              itemBuilder: (context, index) {
                final filter = _statusFilters[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: _selectedFilter == filter
                          ? LinearGradient(
                              colors: [
                                Color(0xFF7986CB),
                                Color(0xFF5C6BC0),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                      border: Border.all(
                        color: _selectedFilter == filter 
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                          _loadFilteredPayments(paymentProvider, filter);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            _getFilterText(filter),
                            textAlign: TextAlign.center, 
                            style: GoogleFonts.cairo(
                              color: _selectedFilter == filter ? Colors.white : Colors.white70,
                              fontWeight: _selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                              
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Payments List
          Expanded(
            child: paymentProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : _buildPaymentsList(paymentProvider),
          ),
        ],
      ),
    );
  }

  String _getFilterText(String filter) {
    switch (filter) {
      case 'all':
        return 'الكل';
      case 'pending':
        return 'قيد المراجعة';
      case 'verified':
        return 'تم التحقق';
      case 'rejected':
        return 'مرفوض';
      default:
        return filter;
    }
  }

  void _loadFilteredPayments(PaymentProvider provider, String filter) {
    final status = filter == 'all' ? null : filter;
    provider.loadPayments(status: status);
  }

  Widget _buildPaymentsList(PaymentProvider provider) {
    final filteredPayments = _selectedFilter == 'all'
        ? provider.payments
        : provider.payments.where((payment) => 
            payment.status == _selectedFilter).toList();

    if (filteredPayments.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
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
      child: RefreshIndicator(
        backgroundColor: Color(0xFF1A237E),
        color: Colors.white,
        onRefresh: () async {
          await provider.loadPayments();
        },
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: filteredPayments.length,
          itemBuilder: (context, index) {
            final payment = filteredPayments[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: _buildGlassPaymentCard(payment),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
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
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Container(
            padding: EdgeInsets.all(32),
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
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    size: 60,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                 _getEmptyStateText(),
                 textAlign: TextAlign.center, 
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                   ),
                ),
                SizedBox(height: 8),
                Text(
                  _getEmptyStateSubtitle(),
                  textAlign: TextAlign.center, 
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white70,
                   
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getEmptyStateText() {
    switch (_selectedFilter) {
      case 'pending':
        return 'لا توجد مدفوعات قيد المراجعة';
      case 'verified':
        return 'لا توجد مدفوعات تم التحقق منها';
      case 'rejected':
        return 'لا توجد مدفوعات مرفوضة';
      default:
        return 'لا توجد مدفوعات';
    }
  }

  String _getEmptyStateSubtitle() {
    switch (_selectedFilter) {
      case 'all':
        return 'سيظهر هنا سجل مدفوعاتك عند توفرها';
      case 'pending':
        return 'لا توجد مدفوعات تنتظر المراجعة حالياً';
      case 'verified':
        return 'جميع المدفوعات التي تم التحقق منها ستظهر هنا';
      case 'rejected':
        return 'لا توجد مدفوعات مرفوضة في سجلك';
      default:
        return 'سيظهر هنا سجل مدفوعاتك عند توفرها';
    }
  }

  Widget _buildGlassPaymentCard(PaymentModel payment) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showGlassPaymentDetails(payment);
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'طلب #${payment.orderId}',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _buildGlassStatusChip(payment.status),
                  ],
                ),
                SizedBox(height: 16),
                _buildGlassPaymentInfoRow('المبلغ', '${payment.totalAmount.toStringAsFixed(2)} ر.س'),
                _buildGlassPaymentInfoRow('طريقة الدفع', payment.paymentMethodText),
                _buildGlassPaymentInfoRow('التاريخ', _formatDate(payment.createdAt)),
                
                // عرض رابط الإيصال إذا موجود
                if (payment.receiptUrl.isNotEmpty) ..._buildGlassReceiptInfo(payment),
                
                if (payment.status == 'pending') ..._buildGlassPendingActions(payment),
                if (payment.status == 'rejected' && payment.rejectionReason!.isNotEmpty) ..._buildGlassRejectedInfo(payment),
                if (payment.status == 'verified') ..._buildGlassVerifiedInfo(payment),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGlassReceiptInfo(PaymentModel payment) {
    return [
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.receipt, color: Colors.blue, size: 18),
            SizedBox(width: 8),
            Text(
              'الإيصال: مرفوع',
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Spacer(),
            if (payment.receiptUrl.startsWith('http'))
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      _showGlassReceiptImage(payment.receiptUrl);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.visibility, size: 14, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            'عرض',
                            style: GoogleFonts.cairo(
                              color: Colors.blue,
                              fontSize: 12,
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
      ),
    ];
  }

  List<Widget> _buildGlassPendingActions(PaymentModel payment) {
    return [
      SizedBox(height: 16),
      Divider(color: Colors.white.withOpacity(0.1)),
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Colors.orange, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'بانتظار مراجعة الأدمن',
                style: GoogleFonts.cairo(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _buildGlassActionButton(
              text: 'عرض التفاصيل',
              icon: Icons.visibility,
              color: Colors.blue,
              onPressed: () {
                _showGlassPaymentDetails(payment);
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildGlassActionButton(
              text: 'إعادة الرفع',
              icon: Icons.receipt,
              color: Colors.orange,
              onPressed: () {
                _reuploadPaymentProof(payment);
              },
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildGlassRejectedInfo(PaymentModel payment) {
    return [
      SizedBox(height: 16),
      Divider(color: Colors.white.withOpacity(0.1)),
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Text(
                  'تم رفض الدفع',
                  style: GoogleFonts.cairo(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'سبب الرفض: ${payment.rejectionReason}',
              style: GoogleFonts.cairo(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 12),
      _buildGlassActionButton(
        text: 'إعادة رفع الإيصال',
        icon: Icons.replay,
        color: Colors.red,
        onPressed: () {
          _reuploadPaymentProof(payment);
        },
        isFullWidth: true,
      ),
    ];
  }

  List<Widget> _buildGlassVerifiedInfo(PaymentModel payment) {
    return [
      SizedBox(height: 16),
      Divider(color: Colors.white.withOpacity(0.1)),
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'تم التحقق من الدفع بنجاح',
                style: GoogleFonts.cairo(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 8),
      if (payment.verifiedAt != null)
        _buildGlassPaymentInfoRow('تاريخ التحقق', _formatDate(payment.verifiedAt!)),
    ];
  }

  Widget _buildGlassPaymentInfoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassStatusChip(String status) {
    Color chipColor;
    String statusText;
    IconData icon;

    switch (status) {
      case 'verified':
        chipColor = Colors.green;
        statusText = 'تم التحقق';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        chipColor = Colors.red;
        statusText = 'مرفوض';
        icon = Icons.cancel;
        break;
      case 'pending':
      default:
        chipColor = Colors.orange;
        statusText = 'قيد المراجعة';
        icon = Icons.access_time;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          SizedBox(width: 4),
          Text(
            statusText,
            style: GoogleFonts.cairo(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color),
                SizedBox(width: 8),
                Text(
                  text,
                  style: GoogleFonts.cairo(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showGlassPaymentDetails(PaymentModel payment) {
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
                Color(0xFF303F9F).withOpacity(0.7),
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Icon(Icons.receipt_long, color: Colors.blue, size: 24),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'تفاصيل الدفع',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildGlassDetailRow('رقم الطلب', payment.orderId),
                        _buildGlassDetailRow('المبلغ', '${payment.totalAmount.toStringAsFixed(2)} ر.س'),
                        _buildGlassDetailRow('طريقة الدفع', payment.paymentMethodText),
                        _buildGlassDetailRow('الحالة', payment.statusText),
                        _buildGlassDetailRow('تاريخ الإنشاء', _formatDate(payment.createdAt)),
                        
                        if (payment.status == 'verified' && payment.verifiedAt != null)
                          _buildGlassDetailRow('تاريخ التحقق', _formatDate(payment.verifiedAt!)),
                        
                        if (payment.bankTransfer.bankName.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Text(
                            'معلومات التحويل:',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildGlassDetailRow('اسم البنك', payment.bankTransfer.bankName),
                          _buildGlassDetailRow('رقم الحساب', payment.bankTransfer.accountNumber),
                          _buildGlassDetailRow('رقم المرجع', payment.bankTransfer.referenceNumber),
                        ],
                        
                        if (payment.receiptUrl.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Text(
                            'معلومات الإيصال:',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildGlassDetailRow('رابط الإيصال', payment.receiptUrl),
                          if (payment.receiptUrl.startsWith('http'))
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 8),
                              child: _buildGlassActionButton(
                                text: 'عرض صورة الإيصال',
                                icon: Icons.visibility,
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showGlassReceiptImage(payment.receiptUrl);
                                },
                                isFullWidth: true,
                              ),
                            ),
                        ],
                        
                        if (payment.hasRejectionReason) ...[
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'سبب الرفض:',
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  payment.rejectionReason!,
                                  style: GoogleFonts.cairo(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildGlassDialogButton(
                        text: 'إغلاق',
                        color: Colors.grey,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    if (payment.status == 'pending') ...[
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildGlassDialogButton(
                          text: 'إعادة الرفع',
                          color: Colors.orange,
                          onPressed: () {
                            Navigator.pop(context);
                            _reuploadPaymentProof(payment);
                          },
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGlassReceiptImage(String receiptUrl) {
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
                Color(0xFF303F9F).withOpacity(0.7),
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
                Text(
                  'إيصال الدفع',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    image: DecorationImage(
                      image: NetworkImage(receiptUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildGlassDialogButton(
                  text: 'إغلاق',
                  color: Colors.grey,
                  onPressed: () => Navigator.pop(context),
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDetailRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassDialogButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary ? color.withOpacity(0.3) : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _reuploadPaymentProof(PaymentModel payment) {
    Navigator.pushNamed(
      context,
      '/payment-proof',
      arguments: {
        'order': payment.orderId,
        'payment': payment,
        'isReupload': true,
      },
    ).then((_) {
      Provider.of<PaymentProvider>(context, listen: false).loadPayments();
    });
  }
}