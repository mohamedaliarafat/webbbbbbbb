import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatefulWidget {
  final String? selectedMethod;
  final ValueChanged<String> onMethodSelected;
  final bool enabled;

  const PaymentMethodSelector({
    Key? key,
    this.selectedMethod,
    required this.onMethodSelected,
    this.enabled = true,
  }) : super(key: key);

  @override
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String? _selectedMethod;

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'bank_transfer',
      name: 'تحويل بنكي',
      description: 'تحويل مباشر إلى الحساب البنكي',
      icon: Icons.account_balance,
      color: Colors.blue,
      isAvailable: true,
    ),
    PaymentMethod(
      id: 'mada',
      name: 'مدى',
      description: 'الدفع ببطاقة مدى',
      icon: Icons.credit_card,
      color: Colors.green,
      isAvailable: true,
    ),
    PaymentMethod(
      id: 'apple_pay',
      name: 'Apple Pay',
      description: 'الدفع عبر Apple Pay',
      icon: Icons.phone_iphone,
      color: Colors.black,
      isAvailable: false,
    ),
    PaymentMethod(
      id: 'google_pay',
      name: 'Google Pay',
      description: 'الدفع عبر Google Pay',
      icon: Icons.phone_android,
      color: Colors.purple,
      isAvailable: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod;
  }

  @override
  void didUpdateWidget(covariant PaymentMethodSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMethod != oldWidget.selectedMethod) {
      setState(() {
        _selectedMethod = widget.selectedMethod;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طريقة الدفع',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _paymentMethods.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final method = _paymentMethods[index];
            return _PaymentMethodCard(
              method: method,
              isSelected: _selectedMethod == method.id,
              isEnabled: widget.enabled && method.isAvailable,
              onTap: () {
                if (widget.enabled && method.isAvailable) {
                  setState(() {
                    _selectedMethod = method.id;
                  });
                  widget.onMethodSelected(method.id);
                }
              },
            );
          },
        ),
        
        SizedBox(height: 16),
        
        // معلومات إضافية عن طريقة الدفع المختارة
        if (_selectedMethod != null)
          _PaymentMethodDetails(
            method: _paymentMethods.firstWhere(
              (m) => m.id == _selectedMethod,
            ),
          ),
      ],
    );
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isAvailable;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isAvailable,
  });
}

class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.method,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 1,
      color: isEnabled 
          ? (isSelected ? method.color.withOpacity(0.1) : Colors.white)
          : Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? method.color : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: method.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  method.icon,
                  color: isEnabled ? method.color : Colors.grey,
                  size: 24,
                ),
              ),
              
              SizedBox(width: 16),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          method.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isEnabled ? Colors.black : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 8),
                        if (!method.isAvailable)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'قريباً',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      method.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isEnabled ? Colors.grey[600] : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Radio Button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? method.color : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: method.color,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodDetails extends StatelessWidget {
  final PaymentMethod method;

  const _PaymentMethodDetails({
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات ${method.name}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          
          if (method.id == 'bank_transfer') ..._buildBankTransferDetails(),
          if (method.id == 'mada') ..._buildMadaDetails(),
          if (method.id == 'apple_pay') ..._buildApplePayDetails(),
          if (method.id == 'google_pay') ..._buildGooglePayDetails(),
        ],
      ),
    );
  }

  List<Widget> _buildBankTransferDetails() {
    return [
      _DetailItem(
        icon: Icons.account_balance,
        title: 'اسم البنك',
        value: 'البنك الأهلي السعودي',
      ),
      _DetailItem(
        icon: Icons.account_balance_wallet,
        title: 'رقم الحساب',
        value: 'SA08 8000 1234 5678 9012 3456',
      ),
      _DetailItem(
        icon: Icons.person,
        title: 'اسم المستفيد',
        value: 'شركة الوقود المثالية',
      ),
      _DetailItem(
        icon: Icons.info,
        title: 'ملاحظات',
        value: 'يرجى إرفاق إيصال التحويل بعد الدفع',
      ),
    ];
  }

  List<Widget> _buildMadaDetails() {
    return [
      _DetailItem(
        icon: Icons.credit_card,
        title: 'مدى',
        value: 'مدعوم بجميع البطاقات',
      ),
      _DetailItem(
        icon: Icons.security,
        title: 'آمن',
        value: 'معاملات آمنة ومشفرة',
      ),
      _DetailItem(
        icon: Icons.speed,
        title: 'فوري',
        value: 'معالجة فورية للدفع',
      ),
    ];
  }

  List<Widget> _buildApplePayDetails() {
    return [
      _DetailItem(
        icon: Icons.info,
        title: 'غير متاح حالياً',
        value: 'ستتوفر هذه الخدمة قريباً',
      ),
    ];
  }

  List<Widget> _buildGooglePayDetails() {
    return [
      _DetailItem(
        icon: Icons.info,
        title: 'غير متاح حالياً',
        value: 'ستتوفر هذه الخدمة قريباً',
      ),
    ];
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// استخدام المكون في التطبيق
class PaymentMethodSelectorExample extends StatefulWidget {
  @override
  _PaymentMethodSelectorExampleState createState() => _PaymentMethodSelectorExampleState();
}

class _PaymentMethodSelectorExampleState extends State<PaymentMethodSelectorExample> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر طريقة الدفع'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            PaymentMethodSelector(
              selectedMethod: _selectedPaymentMethod,
              onMethodSelected: (method) {
                setState(() {
                  _selectedPaymentMethod = method;
                });
                print('تم اختيار طريقة الدفع: $method');
              },
              enabled: true,
            ),
            
            SizedBox(height: 24),
            
            if (_selectedPaymentMethod != null)
              ElevatedButton(
                onPressed: () {
                  // متابعة عملية الدفع
                  _proceedToPayment();
                },
                child: Text(
                  'متابعة الدفع',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _proceedToPayment() {
    // التنقل لشاشة الدفع المناسبة
    switch (_selectedPaymentMethod) {
      case 'bank_transfer':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BankTransferScreen(),
          ),
        );
        break;
      case 'mada':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MadaPaymentScreen(),
          ),
        );
        break;
    }
  }
}

// شاشات وهمية للتوضيح
class BankTransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('التحويل البنكي')),
      body: Center(child: Text('شاشة التحويل البنكي')),
    );
  }
}

class MadaPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('دفع ببطاقة مدى')),
      body: Center(child: Text('شاشة الدفع ببطاقة مدى')),
    );
  }
}