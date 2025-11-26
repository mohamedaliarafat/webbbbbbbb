import 'package:customer/data/models/address_model.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:customer/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedServiceType = 'delivery';
  AddressModel? _selectedAddress;

  final Map<String, String> _serviceTypes = {
    'delivery': 'توصيل',
    'shipping': 'شحن',
    'express': 'توصيل سريع',
    'sameday': 'توصيل في نفس اليوم',
  };

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء طلب جديد'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Type
              Text(
                'نوع الخدمة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                items: _serviceTypes.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedServiceType = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'وصف الطلب',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال وصف للطلب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Delivery Address
              Text(
                'عنوان التوصيل',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildAddressSelector(addressProvider),
              SizedBox(height: 20),

              // Pickup Location (if needed)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'موقع الاستلام',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'عنوان الاستلام',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'اسم جهة الاتصال',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'هاتف جهة الاتصال',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Delivery Instructions
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تعليمات التسليم',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'تعليمات خاصة للتسليم',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Error Message
              if (orderProvider.error.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    orderProvider.error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),

              // Create Order Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: orderProvider.isLoading
                      ? null
                      : () => _createOrder(orderProvider),
                  child: orderProvider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'إنشاء الطلب',
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

  Widget _buildAddressSelector(AddressProvider addressProvider) {
    if (addressProvider.addresses.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.location_off, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'لا توجد عناوين',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-address');
                },
                child: Text('إضافة عنوان جديد'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        ...addressProvider.addresses.map((address) {
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: RadioListTile<AddressModel>(
              title: Text(address.addressLine1),
              subtitle: Text('${address.city} - ${address.district}'),
              secondary: address.isDefault
                  ? Icon(Icons.star, color: Colors.amber)
                  : null,
              value: address,
              groupValue: _selectedAddress,
              onChanged: (value) {
                setState(() {
                  _selectedAddress = value;
                });
              },
            ),
          );
        }),
        SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/add-address');
          },
          icon: Icon(Icons.add),
          label: Text('إضافة عنوان جديد'),
        ),
      ],
    );
  }

  Future<void> _createOrder(OrderProvider orderProvider) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى اختيار عنوان التوصيل')),
        );
        return;
      }

      final orderData = {
        'serviceType': _selectedServiceType,
        'description': _descriptionController.text,
        'deliveryLocation': {
          'address': _selectedAddress!.addressLine1,
          'coordinates': {
            'lat': _selectedAddress!.coordinates.lat,
            'lng': _selectedAddress!.coordinates.lng,
          },
          'contactName': _selectedAddress!.contactName,
          'contactPhone': _selectedAddress!.contactPhone,
          'instructions': _selectedAddress!.deliveryInstructions,
        },
      };

      try {
        // await orderProvider.createOrder(orderData);
        
        if (orderProvider.error.isEmpty && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إنشاء الطلب بنجاح')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء إنشاء الطلب')),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}