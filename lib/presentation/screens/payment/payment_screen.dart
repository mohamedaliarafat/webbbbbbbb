import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/presentation/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _ibanController = TextEditingController();
  final _referenceNumberController = TextEditingController();
  final _transferDateController = TextEditingController();

  String? _paymentMethod;
  double? _amount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _paymentMethod = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    

    final selectedFuelOrder = orderProvider.selectedFuelOrder;
    
    _amount = selectedFuelOrder?.pricing.finalPrice ?? 
              selectedFuelOrder?.pricing.finalPrice ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('الدفع'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Order Summary
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملخص الطلب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('المبلغ الإجمالي:'),
                          Text(
                            '${_amount?.toStringAsFixed(2)} ر.س',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('طريقة الدفع:'),
                          Text(
                            _getPaymentMethodName(_paymentMethod),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Bank Transfer Form
              if (_paymentMethod == 'bank_transfer') ...[
                Text(
                  'معلومات التحويل البنكي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(
                    labelText: 'اسم البنك',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم البنك';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: InputDecoration(
                    labelText: 'رقم الحساب',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الحساب';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    labelText: 'اسم صاحب الحساب',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم صاحب الحساب';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _ibanController,
                  decoration: InputDecoration(
                    labelText: 'رقم IBAN',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم IBAN';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _referenceNumberController,
                  decoration: InputDecoration(
                    labelText: 'رقم المرجع',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم المرجع';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _transferDateController,
                  decoration: InputDecoration(
                    labelText: 'تاريخ التحويل',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى اختيار تاريخ التحويل';
                    }
                    return null;
                  },
                ),
              ],

              // Other Payment Methods
              if (_paymentMethod != 'bank_transfer') ...[
                Text(
                  'سيتم توجيهك إلى صفحة الدفع الآمن',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Icon(
                  Icons.payment,
                  size: 80,
                  color: Colors.grey,
                ),
              ],

              Spacer(),

              // Error Message
              if (paymentProvider.error.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    paymentProvider.error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: paymentProvider.isLoading
                      ? null
                      : () async {
                          if (_paymentMethod == 'bank_transfer') {
                            if (_formKey.currentState!.validate()) {
                              _proceedToPaymentProof();
                            }
                          } else {
                            _processOtherPayment();
                          }
                        },
                  child: paymentProvider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'متابعة الدفع',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPaymentMethodName(String? method) {
    switch (method) {
      case 'bank_transfer':
        return 'تحويل بنكي';
      case 'mada':
        return 'مدى';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      default:
        return 'طريقة الدفع';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _transferDateController.text = 
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _proceedToPaymentProof() {
    final paymentData = {
      'bankName': _bankNameController.text,
      'accountNumber': _accountNumberController.text,
      'accountName': _accountNameController.text,
      'iban': _ibanController.text,
      'referenceNumber': _referenceNumberController.text,
      'transferDate': _transferDateController.text,
      'amount': _amount,
    };

    Navigator.pushNamed(
      context,
      '/payment-proof',
      arguments: paymentData,
    );
  }

  void _processOtherPayment() {
    // Handle other payment methods
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تنبيه'),
        content: Text('هذه الطريقة قيد التطوير حالياً. يرجى استخدام التحويل البنكي.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _ibanController.dispose();
    _referenceNumberController.dispose();
    _transferDateController.dispose();
    super.dispose();
  }
}