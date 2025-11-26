import 'package:flutter/material.dart';


class PriceSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final VoidCallback? onCheckoutPressed;
  final bool showCheckoutButton;

  const PriceSummary({
    Key? key,
    required this.subtotal,
    this.deliveryFee = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    this.onCheckoutPressed,
    this.showCheckoutButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee + tax - discount;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 8,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // عنوان ملخص السعر
          _buildSectionTitle('ملخص الطلب'),
          SizedBox(height: 16),

          // تفاصيل الأسعار
          _buildPriceRow('المجموع الفرعي', _formatPrice(subtotal)),
          SizedBox(height: 8),

          if (deliveryFee > 0) ...[
            _buildPriceRow('رسوم التوصيل', _formatPrice(deliveryFee)),
            SizedBox(height: 8),
          ],

          if (tax > 0) ...[
            _buildPriceRow('الضريبة', _formatPrice(tax)),
            SizedBox(height: 8),
          ],

          if (discount > 0) ...[
            _buildPriceRow(
              'الخصم',
              '-${_formatPrice(discount)}',
              textColor: Colors.green,
            ),
            SizedBox(height: 8),
          ],

          // الخط الفاصل
          Divider(height: 20, thickness: 1),
          SizedBox(height: 8),

          // الإجمالي
          _buildTotalRow('المجموع الكلي', _formatPrice(total)),
          SizedBox(height: 16),

          // زر الدفع (اختياري)
          if (showCheckoutButton && onCheckoutPressed != null)
            _buildCheckoutButton(context, total),
        ],
      ),
    );
  }

  // بناء عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Icon(Icons.receipt, color: Colors.blue, size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // بناء صف السعر
  Widget _buildPriceRow(String label, String value, {Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // بناء صف الإجمالي
  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  // بناء زر الدفع
  Widget _buildCheckoutButton(BuildContext context, double total) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onCheckoutPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_checkout, size: 20),
            SizedBox(width: 8),
            Text(
              'إتمام الطلب',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              _formatPrice(total),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تنسيق السعر
  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ر.س';
  }
}

// نسخة متقدمة من PriceSummary مع المزيد من الخيارات
class AdvancedPriceSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final String discountCode;
  final VoidCallback? onCheckoutPressed;
  final VoidCallback? onApplyDiscount;
  final bool isLoading;
  final bool showDetails;

  const AdvancedPriceSummary({
    Key? key,
    required this.subtotal,
    this.deliveryFee = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    this.discountCode = '',
    this.onCheckoutPressed,
    this.onApplyDiscount,
    this.isLoading = false,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee + tax - discount;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          _buildHeader(),
          SizedBox(height: 16),

          // تفاصيل الأسعار
          _buildPriceDetails(),

          // خصم (إذا كان موجوداً)
          if (discount > 0) _buildDiscountSection(),

          // الإجمالي
          _buildTotalSection(total),

          // زر الإجراء
          if (onCheckoutPressed != null) _buildActionButton(context, total),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.price_check, color: Colors.blue, size: 24),
        SizedBox(width: 8),
        Text(
          'ملخص السعر',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceDetails() {
    return Column(
      children: [
        _buildDetailRow('المجموع الفرعي', subtotal),
        if (deliveryFee > 0) _buildDetailRow('رسوم التوصيل', deliveryFee),
        if (tax > 0) _buildDetailRow('الضريبة', tax),
      ],
    );
  }

  Widget _buildDetailRow(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            _formatPrice(value),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Column(
      children: [
        Divider(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.discount, color: Colors.green, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'الخصم',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  if (discountCode.isNotEmpty) ...[
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        discountCode,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                '-${_formatPrice(discount)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSection(double total) {
    return Column(
      children: [
        Divider(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الكلي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                _formatPrice(total),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, double total) {
    return Column(
      children: [
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : onCheckoutPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: isLoading
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
                      Icon(Icons.shopping_cart_checkout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'متابعة للدفع',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        _formatPrice(total),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ر.س';
  }
}

// PriceSummary مخصص لطلبات الوقود
class FuelOrderPriceSummary extends StatelessWidget {
  final String fuelType;
  final int liters;
  final double pricePerLiter;
  final double serviceFee;
  final double totalPrice;
  final VoidCallback? onOrderPressed;
  final bool isLoading;

  const FuelOrderPriceSummary({
    Key? key,
    required this.fuelType,
    required this.liters,
    required this.pricePerLiter,
    required this.serviceFee,
    required this.totalPrice,
    this.onOrderPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fuelCost = pricePerLiter * liters;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              Icon(Icons.local_gas_station, color: Colors.orange, size: 24),
              SizedBox(width: 8),
              Text(
                'ملخص طلب الوقود',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // تفاصيل الوقود
          _buildFuelDetailRow('نوع الوقود', _getFuelTypeName(fuelType)),
          _buildFuelDetailRow('الكمية', '$liters لتر'),
          _buildFuelDetailRow('سعر اللتر', _formatPrice(pricePerLiter)),
          _buildFuelDetailRow('تكلفة الوقود', _formatPrice(fuelCost)),
          _buildFuelDetailRow('رسوم الخدمة', _formatPrice(serviceFee)),

          // الإجمالي
          Divider(height: 20),
          _buildTotalRow('المجموع الكلي', _formatPrice(totalPrice)),

          // زر الطلب
          if (onOrderPressed != null) _buildOrderButton(context),
        ],
      ),
    );
  }

  Widget _buildFuelDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onOrderPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_gas_station),
                  SizedBox(width: 8),
                  Text(
                    'تأكيد طلب الوقود',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _getFuelTypeName(String fuelType) {
    final Map<String, String> fuelNames = {
      '91': 'بنزين 91',
      '95': 'بنزين 95',
      '98': 'بنزين 98',
      'diesel': 'ديزل',
      'premium_diesel': 'ديزل ممتاز',
    };
    return fuelNames[fuelType] ?? fuelType;
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ر.س';
  }
}