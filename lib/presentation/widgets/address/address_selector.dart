// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:customer/data/models/address_model.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddressSelector extends StatefulWidget {
  final Function(AddressModel)? onAddressSelected;
  final bool showOnlyActive;
  final bool showDefaultFirst;
  final String? selectedAddressId;
  final bool showAddButton;

  const AddressSelector({
    Key? key,
    this.onAddressSelected,
    this.showOnlyActive = true,
    this.showDefaultFirst = true,
    this.selectedAddressId,
    this.showAddButton = true,
  }) : super(key: key);

  @override
  _AddressSelectorState createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses(
        isDefault: widget.showOnlyActive ? null : false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'اختر عنوان التوصيل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // قائمة العناوين
        if (addressProvider.isLoading)
          _buildLoadingState()
        else if (addressProvider.addresses.isEmpty)
          _buildEmptyState()
        else
          _buildAddressesList(addressProvider),

        // زر إضافة عنوان جديد
        if (widget.showAddButton)
          _buildAddAddressButton(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري تحميل العناوين...'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد عناوين',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'قم بإضافة عنوان لتتمكن من استقبال الطلبات',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesList(AddressProvider addressProvider) {
    List<AddressModel> addresses = _getSortedAddresses(addressProvider.addresses);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final address = addresses[index];
            final isSelected = _selectedAddress?.id == address.id || 
                widget.selectedAddressId == address.id;

            return _AddressCard(
              address: address,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedAddress = address;
                });
                widget.onAddressSelected?.call(address);
              },
              onSetDefault: () => _setDefaultAddress(address.id),
              onEdit: () => _editAddress(address),
              onDelete: () => _deleteAddress(address.id),
            );
          },
        ),
      ],
    );
  }

  List<AddressModel> _getSortedAddresses(List<AddressModel> addresses) {
    if (!widget.showDefaultFirst) return addresses;

    // وضع العنوان الافتراضي في البداية
    final defaultAddress = addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => addresses.first,
    );

    final sortedAddresses = List<AddressModel>.from(addresses)
      ..remove(defaultAddress)
      ..insert(0, defaultAddress);

    return sortedAddresses;
  }

  Widget _buildAddAddressButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: _addNewAddress,
        icon: Icon(Icons.add),
        label: Text('إضافة عنوان جديد'),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }

  void _addNewAddress() {
    Navigator.pushNamed(context, '/add-address').then((_) {
      _loadAddresses(); // إعادة تحميل العناوين بعد الإضافة
    });
  }

  void _editAddress(AddressModel address) {
    Navigator.pushNamed(
      context,
      '/add-address',
      arguments: address,
    ).then((_) {
      _loadAddresses(); // إعادة تحميل العناوين بعد التعديل
    });
  }

  Future<void> _setDefaultAddress(String addressId) async {
    final addressProvider = context.read<AddressProvider>();
    
    try {
      await addressProvider.setDefaultAddress(addressId);
      
      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تعيين العنوان كافتراضي'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في تعيين العنوان الافتراضي'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final addressProvider = context.read<AddressProvider>();
    
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف العنوان'),
        content: Text('هل أنت متأكد من حذف هذا العنوان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await addressProvider.deleteAddress(addressId);
        
        // إذا كان العنوان المحذوف هو المحدد، قم بإلغاء التحديد
        if (_selectedAddress?.id == addressId) {
          setState(() {
            _selectedAddress = null;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف العنوان بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في حذف العنوان'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isSelected ? Colors.blue[50] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نوع العنوان والافتراضي
              Row(
                children: [
                  _buildAddressTypeIcon(),
                  SizedBox(width: 8),
                  if (address.isDefault)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        'افتراضي',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Spacer(),
                  if (!address.isDefault)
                    _buildSetDefaultButton(),
                ],
              ),
              SizedBox(height: 8),

              // العنوان الرئيسي
              Text(
                address.addressLine1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),

              // العنوان الثانوي
              if (address.addressLine2.isNotEmpty)
                Text(
                  address.addressLine2,
                  style: TextStyle(color: Colors.grey[600]),
                ),

              // المدينة والحي
              Row(
                children: [
                  Icon(Icons.location_city, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${address.city} - ${address.district}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 4),

              // معلومات الاتصال
              if (address.contactName.isNotEmpty || address.contactPhone.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${address.contactName} - ${address.contactPhone}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),

              // تعليمات التسليم
              if (address.deliveryInstructions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.note, size: 16, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          'تعليمات التسليم:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      address.deliveryInstructions,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

              // أزرار التحكم
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit, size: 16),
                      label: Text('تعديل'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, size: 16, color: Colors.red),
                      label: Text('حذف', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeIcon() {
    IconData icon;
    Color color;

    switch (address.addressType) {
      case 'home':
        icon = Icons.home;
        color = Colors.blue;
        break;
      case 'work':
        icon = Icons.work;
        color = Colors.green;
        break;
      default:
        icon = Icons.location_on;
        color = Colors.orange;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 4),
        Text(
          _getAddressTypeText(address.addressType),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSetDefaultButton() {
    return TextButton(
      onPressed: onSetDefault,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border, size: 14, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            'تعيين افتراضي',
            style: TextStyle(fontSize: 12, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  String _getAddressTypeText(String type) {
    switch (type) {
      case 'home':
        return 'منزل';
      case 'work':
        return 'عمل';
      default:
        return 'أخرى';
    }
  }
}