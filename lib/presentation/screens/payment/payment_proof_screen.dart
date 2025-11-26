import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/presentation/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class PaymentProofScreen extends StatefulWidget {
  final dynamic order;
  final Map<String, dynamic>? paymentData;

  const PaymentProofScreen({
    Key? key,
    required this.order,
    this.paymentData,
  }) : super(key: key);

  @override
  _PaymentProofScreenState createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _receiptImage;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    
    final orderId = widget.order?.id ?? '';
    final orderType = 'fuel';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(right: 55),
          child: Text(
            'رفع إثبات الدفع - ${widget.order?.orderNumber ?? ''}',
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
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Details
                if (widget.order != null) _buildOrderDetailsCard(),
                if (widget.order != null) const SizedBox(height: 20),

                // Payment Details
                _buildGlassPaymentDetailsCard(),
                const SizedBox(height: 20),

                // Receipt Upload
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'إيصال التحويل',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'يرجى رفع صورة إيصال التحويل البنكي',
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Image Preview
                _buildGlassImagePreview(),
                const SizedBox(height: 16),

                // Upload Buttons
                _buildGlassUploadButtons(),
                const SizedBox(height: 20),

                // Error Message
                if (paymentProvider.error.isNotEmpty)
                  _buildGlassErrorCard(paymentProvider.error),

                const SizedBox(height: 20),

                // Submit Button
                _buildGlassSubmitButton(paymentProvider, orderId, orderType),
                
                // Extra space for better scrolling
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
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
                  'تفاصيل الطلب',
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
                    widget.order.orderNumber,
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
            _buildOrderDetailRow('نوع الوقود', _getFuelTypeText(widget.order.fuelType)),
            _buildOrderDetailRow('الكمية', '${widget.order.fuelLiters} لتر'),
            _buildOrderDetailRow('الموقع', widget.order.deliveryLocation.address),
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
                    '${widget.order.pricing.finalPrice.toStringAsFixed(2)} ر.س',
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

  Widget _buildGlassPaymentDetailsCard() {
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
                  child: const Icon(Icons.payment, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'تفاصيل التحويل',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGlassDetailRow('اسم البنك', 'مصرف الراجحي'),
            _buildGlassDetailRow('رقم الحساب', 'SA1234567890123456789012'),
            _buildGlassDetailRow('اسم صاحب الحساب', 'شركة البحيرة العربية للنقليات'),
            _buildGlassDetailRow('رقم IBAN', 'SA03 8000 0000 6080 1016 7519'),
            _buildGlassDetailRow('رقم المرجع', widget.order?.orderNumber ?? ''),
            _buildGlassDetailRow('المبلغ', '${widget.order?.pricing.finalPrice.toStringAsFixed(2) ?? '0.00'} ر.س'),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassImagePreview() {
    return Container(
      width: double.infinity,
      height: 200,
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
        border: Border.all(
          color: _receiptImage != null ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: (_receiptImage != null ? Colors.green : Colors.grey).withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: _receiptImage != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    _receiptImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () {
                        setState(() {
                          _receiptImage = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Icon(
                    Icons.receipt,
                    size: 40,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'لم يتم رفع أي صورة',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'انقر على أحد الأزرار أدناه لرفع الإيصال',
                  style: GoogleFonts.cairo(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGlassUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildGlassUploadButton(
            text: 'التقاط صورة',
            icon: Icons.camera_alt,
            color: Colors.blue,
            onPressed: () => _pickImage(ImageSource.camera),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGlassUploadButton(
            text: 'من المعرض',
            icon: Icons.photo_library,
            color: Colors.purple,
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassUploadButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassErrorCard(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error, color: Colors.red, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: GoogleFonts.cairo(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassSubmitButton(
    PaymentProvider paymentProvider,
    String orderId,
    String orderType,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: paymentProvider.isLoading || _receiptImage == null
            ? null
            : () async {
                await _submitPaymentProof(
                  orderId,
                  orderType,
                  paymentProvider,
                );
              },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: paymentProvider.isLoading || _receiptImage == null
                ? LinearGradient(
                    colors: [
                      Colors.grey.withOpacity(0.3),
                      Colors.grey.withOpacity(0.1),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.withOpacity(0.3),
                      Colors.green.withOpacity(0.1),
                    ],
                  ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: paymentProvider.isLoading || _receiptImage == null
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.green.withOpacity(0.3),
            ),
            boxShadow: paymentProvider.isLoading || _receiptImage == null
                ? null
                : [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: Center(
            child: paymentProvider.isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        color: _receiptImage == null ? Colors.grey : Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _receiptImage == null ? 'يرجى رفع الإيصال أولاً' : 'تأكيد رفع الإيصال',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _receiptImage == null ? Colors.grey : Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _receiptImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ في اختيار الصورة: $e',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _submitPaymentProof(
    String orderId,
    String orderType,
    PaymentProvider paymentProvider,
  ) async {
    try {
      final receiptUrl = _receiptImage!.path;

      final paymentProofData = {
        'orderNumber': widget.order?.orderNumber ?? '',
        'amount': widget.order?.pricing.finalPrice ?? 0.0,
        'bankName': 'مصرف الراجحي',
        'accountNumber': 'SA1234567890123456789012',
        'accountName': 'شركة البحيرة العربية للنقليات',
        'iban': 'SA03 8000 0000 6080 1016 7519',
        'receiptFile': receiptUrl,
        'transferDate': DateTime.now().toString(),
        'paymentMethod': 'bank_transfer',
      };

      await paymentProvider.uploadPaymentProof(
        orderId: orderId,
        orderType: orderType,
        paymentData: paymentProofData,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم رفع إثبات الدفع بنجاح',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        Navigator.pushReplacementNamed(
          context,
          '/fuel-orders',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ في رفع الإيصال: $e',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
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