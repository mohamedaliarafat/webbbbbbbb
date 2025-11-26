// ignore_for_file: unused_local_variable

import 'package:customer/data/models/address_model.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:customer/presentation/providers/location_provider.dart';
import 'package:customer/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PetrolOrderScreen extends StatefulWidget {
  @override
  _PetrolOrderScreenState createState() => _PetrolOrderScreenState();
}

class _PetrolOrderScreenState extends State<PetrolOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fuelLitersController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedFuelType = '95';
  String _selectedAddressId = '';
  AddressModel? _selectedAddress;
  bool _useCurrentLocation = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('طلب وقود جديد'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fuel Type Selection
              Text(
                'نوع الوقود',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedFuelType,
                items: [
                  DropdownMenuItem(value: '91', child: Text('بنزين 91')),
                  DropdownMenuItem(value: '95', child: Text('بنزين 95')),
                  DropdownMenuItem(value: '98', child: Text('بنزين 98')),
                  DropdownMenuItem(value: 'diesel', child: Text('ديزل')),
                  DropdownMenuItem(value: 'premium_diesel', child: Text('ديزل ممتاز')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFuelType = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              SizedBox(height: 20),

              // Fuel Liters
              TextFormField(
                controller: _fuelLitersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'عدد اللترات',
                  border: OutlineInputBorder(),
                  suffixText: 'لتر',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عدد اللترات';
                  }
                  final liters = int.tryParse(value);
                  if (liters == null || liters <= 0 || liters > 100) {
                    return 'عدد اللترات يجب أن يكون بين 1 و 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Vehicle Information
              Text(
                'معلومات المركبة (اختياري)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'نوع المركبة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'موديل المركبة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'رقم اللوحة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Delivery Location
              Text(
                'موقع التوصيل',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Use Current Location Option
              CheckboxListTile(
                title: Text('استخدام الموقع الحالي'),
                value: _useCurrentLocation,
                onChanged: (value) {
                  setState(() {
                    _useCurrentLocation = value!;
                    if (_useCurrentLocation) {
                      _selectedAddress = null;
                      _selectedAddressId = '';
                    }
                  });
                },
              ),

              if (!_useCurrentLocation) ...[
                SizedBox(height: 10),
                Text('اختر عنوان التوصيل:'),
                SizedBox(height: 10),
                
                if (addressProvider.addresses.isEmpty)
                  Text(
                    'لا توجد عناوين مسجلة',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  DropdownButtonFormField<String>(
                    value: _selectedAddressId.isEmpty ? null : _selectedAddressId,
                    items: addressProvider.addresses.map((address) {
                      return DropdownMenuItem(
                        value: address.id,
                        child: Text(
                          '${address.addressLine1}, ${address.city}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAddressId = value!;
                        _selectedAddress = addressProvider.addresses
                            .firstWhere((addr) => addr.id == value);
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'اختر عنوان التوصيل',
                    ),
                    validator: (value) {
                      if (!_useCurrentLocation && (value == null || value.isEmpty)) {
                        return 'يرجى اختيار عنوان التوصيل';
                      }
                      return null;
                    },
                  ),
                
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-address')
                        .then((value) {
                      if (value != null) {
                        addressProvider.loadAddresses();
                      }
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('إضافة عنوان جديد'),
                ),
              ],
              SizedBox(height: 20),

              // Additional Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'ملاحظات إضافية (اختياري)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 30),

              // Estimated Price
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'السعر التقديري:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _calculateEstimatedPrice().toStringAsFixed(2),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 18,
                      ),
                    ),
                    Text('ر.س'),
                  ],
                ),
              ),
              SizedBox(height: 20),

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

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: orderProvider.isLoading ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: orderProvider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'تأكيد الطلب',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateEstimatedPrice() {
    final liters = int.tryParse(_fuelLitersController.text) ?? 0;
    final fuelPrices = {
      '91': 2.18,
      '95': 2.33,
      '98': 2.55,
      'diesel': 1.85,
      'premium_diesel': 2.10,
    };
    final fuelPrice = fuelPrices[_selectedFuelType] ?? 2.00;
    final serviceFee = 15.0;
    return (liters * fuelPrice) + serviceFee;
  }

  void _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_useCurrentLocation && _selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار عنوان التوصيل')),
      );
      return;
    }

    final orderData = {
      'fuelType': _selectedFuelType,
      'fuelLiters': int.parse(_fuelLitersController.text),
      'notes': _notesController.text,
      'deliveryLocation': _useCurrentLocation
          ? {
              'address': 'الموقع الحالي',
              'coordinates': {
                'lat': 24.7136,
                'lng': 46.6753,
              },
            }
          : {
              'address': _selectedAddress!.addressLine1,
              'coordinates': _selectedAddress!.coordinates.toJson(),
              'contactName': _selectedAddress!.contactName,
              'contactPhone': _selectedAddress!.contactPhone,
              'instructions': _selectedAddress!.deliveryInstructions,
            },
    };

    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .createFuelOrder(orderData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إنشاء طلب الوقود بنجاح')),
        );
        Navigator.pushReplacementNamed(context, '/orders');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إنشاء الطلب: $e')),
      );
    }
  }

  @override
  void dispose() {
    _fuelLitersController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}