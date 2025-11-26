// import 'package:customer/core/constants/app_router.dart';
// import 'package:customer/data/models/address_model.dart';
// import 'package:customer/data/models/location_model.dart';
// import 'package:customer/presentation/providers/address_provider.dart';
// import 'package:customer/presentation/providers/location_provider.dart';
// import 'package:customer/presentation/widgets/address/location_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddAddressScreen extends StatefulWidget {
//   final AddressModel? addressToEdit;

//   const AddAddressScreen({Key? key, this.addressToEdit}) : super(key: key);

//   @override
//   _AddAddressScreenState createState() => _AddAddressScreenState();
// }

// class _AddAddressScreenState extends State<AddAddressScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _addressLine1Controller = TextEditingController();
//   final _addressLine2Controller = TextEditingController();
//   final _cityController = TextEditingController();
//   final _districtController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _postalCodeController = TextEditingController();
//   final _contactNameController = TextEditingController();
//   final _contactPhoneController = TextEditingController();
//   final _deliveryInstructionsController = TextEditingController();

//   String _addressType = 'home';
//   bool _isDefault = false;
//   bool _isLoading = false;
//   bool _isGettingLocation = false;
//   LocationModel? _selectedLocation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeForm();
//     _initializeLocation();
//   }

//   void _initializeForm() {
//     if (widget.addressToEdit != null) {
//       final address = widget.addressToEdit!;
//       _addressLine1Controller.text = address.addressLine1;
//       _addressLine2Controller.text = address.addressLine2 ?? '';
//       _cityController.text = address.city;
//       _districtController.text = address.district ?? '';
//       _stateController.text = address.state ?? '';
//       _postalCodeController.text = address.postalCode ?? '';
//       _contactNameController.text = address.contactName;
//       _contactPhoneController.text = address.contactPhone;
//       _deliveryInstructionsController.text = address.deliveryInstructions ?? '';
//       _addressType = address.addressType;
//       _isDefault = address.isDefault;
//       _selectedLocation = address.coordinates;
//     }
//   }

//   void _initializeLocation() {
//     final locationProvider = context.read<LocationProvider>();
//     if (locationProvider.currentLocation != null) {
//       _selectedLocation = locationProvider.currentLocation;
//       _updateAddressFromLocation(_selectedLocation!);
//     }
//   }

//   void _updateAddressFromLocation(LocationModel location) {
//     setState(() {
//       _selectedLocation = location;
      
//       // ✅ تحليل العنوان وتعبئة الحقول تلقائياً
//       _parseAndFillAddress(location.address);
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('✅ تم تحديث البيانات تلقائياً'),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   // ✅ دالة محسنة لتحليل العنوان وتعبئة الحقول
//   void _parseAndFillAddress(String fullAddress) {
//     final addressParts = fullAddress.split(',');
//     final partsCount = addressParts.length;
    
//     // خوارزمية ذكية لتحليل العنوان بناءً على عدد الأجزاء
//     switch (partsCount) {
//       case 1:
//         // عنوان بسيط - نضعه في العنوان التفصيلي
//         if (_addressLine1Controller.text.isEmpty) {
//           _addressLine1Controller.text = addressParts[0].trim();
//         }
//         break;
        
//       case 2:
//         // عنوان مكون من جزئين (الشارع، الحي/المدينة)
//         if (_addressLine1Controller.text.isEmpty) {
//           _addressLine1Controller.text = addressParts[0].trim();
//         }
//         if (_districtController.text.isEmpty) {
//           _districtController.text = addressParts[1].trim();
//         }
//         if (_cityController.text.isEmpty) {
//           _cityController.text = addressParts[1].trim();
//         }
//         break;
        
//       case 3:
//         // عنوان مكون من ثلاثة أجزاء (الشارع، الحي، المدينة)
//         if (_addressLine1Controller.text.isEmpty) {
//           _addressLine1Controller.text = addressParts[0].trim();
//         }
//         if (_districtController.text.isEmpty) {
//           _districtController.text = addressParts[1].trim();
//         }
//         if (_cityController.text.isEmpty) {
//           _cityController.text = addressParts[2].trim();
//         }
//         break;
        
//       default:
//         // عنوان طويل - نأخذ الأجزاء المهمة
//         if (_addressLine1Controller.text.isEmpty) {
//           _addressLine1Controller.text = addressParts[0].trim();
//         }
//         if (_districtController.text.isEmpty && partsCount > 1) {
//           _districtController.text = addressParts[1].trim();
//         }
//         if (_cityController.text.isEmpty && partsCount > 2) {
//           _cityController.text = addressParts[2].trim();
//         }
//         if (_stateController.text.isEmpty && partsCount > 3) {
//           _stateController.text = addressParts[3].trim();
//         }
//         break;
//     }
//   }

//   // ✅ دالة محسنة لتحديد الموقع
//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _isGettingLocation = true;
//     });

//     try {
//       final locationProvider = context.read<LocationProvider>();
      
//       // التحقق من الصلاحيات أولاً
//       final hasPermission = await locationProvider.requestLocationPermission();
      
//       if (!hasPermission) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('يجب منح صلاحيات الموقع أولاً'),
//             action: SnackBarAction(
//               label: 'الإعدادات',
//               onPressed: () => locationProvider.openAppSettings(),
//             ),
//           ),
//         );
//         return;
//       }

//       // الحصول على الموقع مع إعادة المحاولة
//       await locationProvider.getCurrentLocationWithRetry();
      
//       if (locationProvider.currentLocation != null) {
//         _updateAddressFromLocation(locationProvider.currentLocation!);
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('✅ تم تحديد موقعك بدقة في السعودية'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       } else if (locationProvider.error.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('❌ ${locationProvider.error}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ حدث خطأ: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isGettingLocation = false;
//         });
//       }
//     }
//   }

//   // ✅ فتح الخريطة لتحديد الموقع
//   void _openMapPicker() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LocationPickerScreen(
//           onLocationSelected: (LocationModel location) {
//             _updateAddressFromLocation(location);
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final addressProvider = context.watch<AddressProvider>();
//     final locationProvider = context.watch<LocationProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.addressToEdit != null ? 'تعديل العنوان' : 'إضافة عنوان جديد',
//         ),
//         actions: [
//           if (widget.addressToEdit != null)
//             IconButton(
//               icon: Icon(Icons.delete, color: Colors.red),
//               onPressed: _showDeleteDialog,
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // العنوان الأساسي
//                     _buildSectionHeader('الموقع الجغرافي'),
//                     SizedBox(height: 16),
                    
//                     // استخدام الموقع الحالي
//                     _buildCurrentLocationCard(locationProvider),
//                     SizedBox(height: 16),

//                     // العنوان التفصيلي
//                     TextFormField(
//                       controller: _addressLine1Controller,
//                       decoration: InputDecoration(
//                         labelText: 'العنوان التفصيلي *',
//                         hintText: 'اسم الشارع، رقم المبنى، الحي',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.location_on),
//                         suffixIcon: _addressLine1Controller.text.isNotEmpty
//                             ? IconButton(
//                                 icon: Icon(Icons.clear),
//                                 onPressed: () => _addressLine1Controller.clear(),
//                               )
//                             : null,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'يرجى إدخال العنوان التفصيلي';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16),

//                     // عنوان إضافي
//                     TextFormField(
//                       controller: _addressLine2Controller,
//                       decoration: InputDecoration(
//                         labelText: 'عنوان إضافي (اختياري)',
//                         hintText: 'رقم الشقة، الطابق، إلخ',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.home),
//                         suffixIcon: _addressLine2Controller.text.isNotEmpty
//                             ? IconButton(
//                                 icon: Icon(Icons.clear),
//                                 onPressed: () => _addressLine2Controller.clear(),
//                               )
//                             : null,
//                       ),
//                     ),
//                     SizedBox(height: 16),

//                     // معلومات الموقع
//                     _buildSectionHeader('معلومات الموقع'),
//                     SizedBox(height: 16),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _cityController,
//                             decoration: InputDecoration(
//                               labelText: 'المدينة *',
//                               hintText: 'المدينة',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.location_city),
//                               suffixIcon: _cityController.text.isNotEmpty
//                                   ? IconButton(
//                                       icon: Icon(Icons.clear),
//                                       onPressed: () => _cityController.clear(),
//                                     )
//                                   : null,
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'يرجى إدخال المدينة';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: TextFormField(
//                             controller: _districtController,
//                             decoration: InputDecoration(
//                               labelText: 'الحي *',
//                               hintText: 'الحي',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.place),
//                               suffixIcon: _districtController.text.isNotEmpty
//                                   ? IconButton(
//                                       icon: Icon(Icons.clear),
//                                       onPressed: () => _districtController.clear(),
//                                     )
//                                   : null,
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'يرجى إدخال الحي';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _stateController,
//                             decoration: InputDecoration(
//                               labelText: 'المنطقة',
//                               hintText: 'المنطقة',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.map),
//                               suffixIcon: _stateController.text.isNotEmpty
//                                   ? IconButton(
//                                       icon: Icon(Icons.clear),
//                                       onPressed: () => _stateController.clear(),
//                                     )
//                                   : null,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: TextFormField(
//                             controller: _postalCodeController,
//                             decoration: InputDecoration(
//                               labelText: 'الرمز البريدي',
//                               hintText: 'الرمز البريدي',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.local_post_office),
//                               suffixIcon: _postalCodeController.text.isNotEmpty
//                                   ? IconButton(
//                                       icon: Icon(Icons.clear),
//                                       onPressed: () => _postalCodeController.clear(),
//                                     )
//                                   : null,
//                               // keyboardType: TextInputType.number,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 24),

//                     // معلومات الاتصال
//                     _buildSectionHeader('معلومات الاتصال'),
//                     SizedBox(height: 16),

//                     TextFormField(
//                       controller: _contactNameController,
//                       decoration: InputDecoration(
//                         labelText: 'اسم جهة الاتصال *',
//                         hintText: 'اسم الشخص المسؤول',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.person),
//                         suffixIcon: _contactNameController.text.isNotEmpty
//                             ? IconButton(
//                                 icon: Icon(Icons.clear),
//                                 onPressed: () => _contactNameController.clear(),
//                               )
//                             : null,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'يرجى إدخال اسم جهة الاتصال';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16),

//                     TextFormField(
//                       controller: _contactPhoneController,
//                       decoration: InputDecoration(
//                         labelText: 'رقم الهاتف *',
//                         hintText: '05XXXXXXXX',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.phone),
//                         suffixIcon: _contactPhoneController.text.isNotEmpty
//                             ? IconButton(
//                                 icon: Icon(Icons.clear),
//                                 onPressed: () => _contactPhoneController.clear(),
//                               )
//                             : null,
//                         // keyboardType: TextInputType.phone,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'يرجى إدخال رقم الهاتف';
//                         }
//                         if (!RegExp(r'^05\d{8}$').hasMatch(value)) {
//                           return 'رقم الهاتف يجب أن يبدأ بـ 05 ويحتوي على 10 أرقام';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 24),

//                     // إعدادات إضافية
//                     _buildSectionHeader('إعدادات إضافية'),
//                     SizedBox(height: 16),

//                     // نوع العنوان
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'نوع العنوان *',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Wrap(
//                           spacing: 8,
//                           children: [
//                             _buildAddressTypeChip('home', 'منزل', Icons.home),
//                             _buildAddressTypeChip('work', 'عمل', Icons.work),
//                             _buildAddressTypeChip('other', 'أخرى', Icons.place),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),

//                     // تعليمات التسليم
//                     TextFormField(
//                       controller: _deliveryInstructionsController,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         labelText: 'تعليمات التسليم (اختياري)',
//                         hintText: 'مثال: الطابق الثالث، الجرس الأزرق، إلخ',
//                         border: OutlineInputBorder(),
//                         alignLabelWithHint: true,
//                         suffixIcon: _deliveryInstructionsController.text.isNotEmpty
//                             ? IconButton(
//                                 icon: Icon(Icons.clear),
//                                 onPressed: () => _deliveryInstructionsController.clear(),
//                               )
//                             : null,
//                       ),
//                     ),
//                     SizedBox(height: 16),

//                     // العنوان الافتراضي
//                     SwitchListTile(
//                       title: Text(
//                         'تعيين كعنوان افتراضي',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('سيتم استخدام هذا العنوان تلقائياً للطلبات الجديدة'),
//                       value: _isDefault,
//                       onChanged: (value) {
//                         setState(() {
//                           _isDefault = value;
//                         });
//                       },
//                       secondary: Icon(Icons.star, color: _isDefault ? Colors.amber : Colors.grey),
//                     ),
//                     SizedBox(height: 32),

//                     // زر الحفظ
//                     _buildSaveButton(addressProvider),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.blue[700],
//       ),
//     );
//   }

//   Widget _buildCurrentLocationCard(LocationProvider locationProvider) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.blue.shade100, width: 1),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.gps_fixed, color: Colors.blue),
//                 SizedBox(width: 8),
//                 Text(
//                   'الموقع الجغرافي',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
            
//             if (_selectedLocation != null)
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.green.shade100),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.check_circle, color: Colors.green, size: 16),
//                         SizedBox(width: 4),
//                         Text(
//                           'تم تحديد الموقع',
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       _selectedLocation!.address,
//                       style: TextStyle(
//                         color: Colors.green[800],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'الإحداثيات: ${_selectedLocation!.lat.toStringAsFixed(6)}, ${_selectedLocation!.lng.toStringAsFixed(6)}',
//                       style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.orange.shade100),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.location_off, color: Colors.orange, size: 16),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'لم يتم تحديد الموقع بعد',
//                         style: TextStyle(color: Colors.orange.shade800),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
            
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: _isGettingLocation
//                         ? SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : Icon(Icons.gps_fixed, size: 20),
//                     label: Text(_isGettingLocation ? 'جاري التحديد...' : 'تحديد موقعي'),
//                     onPressed: _isGettingLocation ? null : _getCurrentLocation,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: Icon(Icons.map, size: 20),
//                     label: Text('اختيار من الخريطة'),
//                     onPressed: _openMapPicker,
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressTypeChip(String type, String label, IconData icon) {
//     final isSelected = _addressType == type;
//     return ChoiceChip(
//       label: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
//           SizedBox(width: 6),
//           Text(label, style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black87,
//           )),
//         ],
//       ),
//       selected: isSelected,
//       onSelected: (selected) {
//         setState(() {
//           _addressType = type;
//         });
//       },
//       selectedColor: Colors.blue.shade600,
//       backgroundColor: Colors.grey.shade200,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );
//   }

//   Widget _buildSaveButton(AddressProvider addressProvider) {
//     final isValid = _formKey.currentState?.validate() ?? false;
//     final hasLocation = _selectedLocation != null;

//     return SizedBox(
//       width: double.infinity,
//       height: 54,
//       child: ElevatedButton(
//         onPressed: (addressProvider.isLoading || !isValid || !hasLocation) 
//             ? null 
//             : _saveAddress,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: (!isValid || !hasLocation) ? Colors.grey : Colors.blue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: addressProvider.isLoading
//             ? CircularProgressIndicator(color: Colors.white)
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.save, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text(
//                     widget.addressToEdit != null ? 'تحديث العنوان' : 'حفظ العنوان',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _saveAddress() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (_selectedLocation == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ يرجى تحديد الموقع أولاً'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//               final address = AddressModel.createNew(
//             addressLine1: _addressLine1Controller.text.trim(),
//             addressLine2: _addressLine2Controller.text.trim().isEmpty ? '' : _addressLine2Controller.text.trim(),
//             city: _cityController.text.trim(),
//             district: _districtController.text.trim().isEmpty ? '' : _districtController.text.trim(),
//             state: _stateController.text.trim().isEmpty ? '' : _stateController.text.trim(),
//             country: 'Saudi Arabia',
//             postalCode: _postalCodeController.text.trim().isEmpty ? '' : _postalCodeController.text.trim(),
//             addressType: _addressType,
//             contactName: _contactNameController.text.trim(),
//             contactPhone: _contactPhoneController.text.trim(),
//             coordinates: _selectedLocation!,
//             deliveryInstructions: _deliveryInstructionsController.text.trim().isEmpty 
//                 ? '' 
//                 : _deliveryInstructionsController.text.trim(),
//             isDefault: _isDefault,
//           );

//       final addressProvider = context.read<AddressProvider>();
      
//       if (widget.addressToEdit != null) {
//         await addressProvider.updateAddress(widget.addressToEdit!.id, address as Map<String, dynamic>);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('✅ تم تحديث العنوان بنجاح'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         await addressProvider.createAddress(address as Map<String, dynamic>);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('✅ تم إضافة العنوان بنجاح'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }

//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ خطأ: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _showDeleteDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.warning, color: Colors.orange),
//             SizedBox(width: 8),
//             Text('حذف العنوان'),
//           ],
//         ),
//         content: Text('هل أنت متأكد من أنك تريد حذف هذا العنوان؟ لا يمكن التراجع عن هذا الإجراء.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('إلغاء'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: _deleteAddress,
//             child: Text('حذف', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _deleteAddress() async {
//     Navigator.pop(context); // Close dialog
    
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final addressProvider = context.read<AddressProvider>();
//       await addressProvider.deleteAddress(widget.addressToEdit!.id);
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('✅ تم حذف العنوان بنجاح'),
//           backgroundColor: Colors.green,
//         ),
//       );
      
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ خطأ في حذف العنوان: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _addressLine1Controller.dispose();
//     _addressLine2Controller.dispose();
//     _cityController.dispose();
//     _districtController.dispose();
//     _stateController.dispose();
//     _postalCodeController.dispose();
//     _contactNameController.dispose();
//     _contactPhoneController.dispose();
//     _deliveryInstructionsController.dispose();
//     super.dispose();
//   }
// }




import 'package:customer/core/constants/app_router.dart';
import 'package:customer/data/models/address_model.dart';
import 'package:customer/data/models/location_model.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:customer/presentation/providers/location_provider.dart';
import 'package:customer/presentation/widgets/address/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressModel? addressToEdit;

  const AddAddressScreen({Key? key, this.addressToEdit}) : super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _deliveryInstructionsController = TextEditingController();

  String _addressType = 'home';
  bool _isDefault = false;
  bool _isLoading = false;
  bool _isGettingLocation = false;
  LocationModel? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _initializeLocation();
  }

  void _initializeForm() {
    if (widget.addressToEdit != null) {
      final address = widget.addressToEdit!;
      _addressLine1Controller.text = address.addressLine1;
      _addressLine2Controller.text = address.addressLine2;
      _cityController.text = address.city;
      _districtController.text = address.district;
      _stateController.text = address.state;
      _postalCodeController.text = address.postalCode;
      _contactNameController.text = address.contactName;
      _contactPhoneController.text = address.contactPhone;
      _deliveryInstructionsController.text = address.deliveryInstructions;
      _addressType = address.addressType;
      _isDefault = address.isDefault;
      _selectedLocation = address.coordinates;
    }
  }

  void _initializeLocation() {
    final locationProvider = context.read<LocationProvider>();
    if (locationProvider.currentLocation != null) {
      _selectedLocation = locationProvider.currentLocation;
      _updateAddressFromLocation(_selectedLocation!);
    }
  }

  void _updateAddressFromLocation(LocationModel location) {
    setState(() {
      _selectedLocation = location;
      _parseAndFillAddress(location.address);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ تم تحديث البيانات تلقائياً'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _parseAndFillAddress(String fullAddress) {
    final addressParts = fullAddress.split(',');
    final partsCount = addressParts.length;
    
    switch (partsCount) {
      case 1:
        if (_addressLine1Controller.text.isEmpty) {
          _addressLine1Controller.text = addressParts[0].trim();
        }
        break;
        
      case 2:
        if (_addressLine1Controller.text.isEmpty) {
          _addressLine1Controller.text = addressParts[0].trim();
        }
        if (_districtController.text.isEmpty) {
          _districtController.text = addressParts[1].trim();
        }
        if (_cityController.text.isEmpty) {
          _cityController.text = addressParts[1].trim();
        }
        break;
        
      case 3:
        if (_addressLine1Controller.text.isEmpty) {
          _addressLine1Controller.text = addressParts[0].trim();
        }
        if (_districtController.text.isEmpty) {
          _districtController.text = addressParts[1].trim();
        }
        if (_cityController.text.isEmpty) {
          _cityController.text = addressParts[2].trim();
        }
        break;
        
      default:
        if (_addressLine1Controller.text.isEmpty) {
          _addressLine1Controller.text = addressParts[0].trim();
        }
        if (_districtController.text.isEmpty && partsCount > 1) {
          _districtController.text = addressParts[1].trim();
        }
        if (_cityController.text.isEmpty && partsCount > 2) {
          _cityController.text = addressParts[2].trim();
        }
        if (_stateController.text.isEmpty && partsCount > 3) {
          _stateController.text = addressParts[3].trim();
        }
        break;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final locationProvider = context.read<LocationProvider>();
      final hasPermission = await locationProvider.requestLocationPermission();
      
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يجب منح صلاحيات الموقع أولاً'),
            action: SnackBarAction(
              label: 'الإعدادات',
              onPressed: () => locationProvider.openAppSettings(),
            ),
          ),
        );
        return;
      }

      await locationProvider.getCurrentLocationWithRetry();
      
      if (locationProvider.currentLocation != null) {
        _updateAddressFromLocation(locationProvider.currentLocation!);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم تحديد موقعك بدقة في السعودية'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (locationProvider.error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${locationProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ حدث خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  void _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          onLocationSelected: (LocationModel location) {
            _updateAddressFromLocation(location);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.addressToEdit != null ? 'تعديل العنوان' : 'إضافة عنوان جديد',
        ),
        actions: [
          if (widget.addressToEdit != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _showDeleteDialog,
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('الموقع الجغرافي'),
                    SizedBox(height: 16),
                    
                    _buildCurrentLocationCard(locationProvider),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _addressLine1Controller,
                      decoration: InputDecoration(
                        labelText: 'العنوان التفصيلي *',
                        hintText: 'اسم الشارع، رقم المبنى، الحي',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                        suffixIcon: _addressLine1Controller.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => _addressLine1Controller.clear(),
                              )
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال العنوان التفصيلي';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _addressLine2Controller,
                      decoration: InputDecoration(
                        labelText: 'عنوان إضافي (اختياري)',
                        hintText: 'رقم الشقة، الطابق، إلخ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                        suffixIcon: _addressLine2Controller.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => _addressLine2Controller.clear(),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 16),

                    _buildSectionHeader('معلومات الموقع'),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'المدينة *',
                              hintText: 'المدينة',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_city),
                              suffixIcon: _cityController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () => _cityController.clear(),
                                    )
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال المدينة';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _districtController,
                            decoration: InputDecoration(
                              labelText: 'الحي *',
                              hintText: 'الحي',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.place),
                              suffixIcon: _districtController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () => _districtController.clear(),
                                    )
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال الحي';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: InputDecoration(
                              labelText: 'المنطقة',
                              hintText: 'المنطقة',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.map),
                              suffixIcon: _stateController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () => _stateController.clear(),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _postalCodeController,
                            decoration: InputDecoration(
                              labelText: 'الرمز البريدي',
                              hintText: 'الرمز البريدي',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.local_post_office),
                              suffixIcon: _postalCodeController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () => _postalCodeController.clear(),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    _buildSectionHeader('معلومات الاتصال'),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _contactNameController,
                      decoration: InputDecoration(
                        labelText: 'اسم جهة الاتصال *',
                        hintText: 'اسم الشخص المسؤول',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: _contactNameController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => _contactNameController.clear(),
                              )
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم جهة الاتصال';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _contactPhoneController,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف *',
                        hintText: '05XXXXXXXX',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        suffixIcon: _contactPhoneController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => _contactPhoneController.clear(),
                              )
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        }
                        if (!RegExp(r'^05\d{8}$').hasMatch(value)) {
                          return 'رقم الهاتف يجب أن يبدأ بـ 05 ويحتوي على 10 أرقام';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                    _buildSectionHeader('إعدادات إضافية'),
                    SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نوع العنوان *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildAddressTypeChip('home', 'منزل', Icons.home),
                            _buildAddressTypeChip('work', 'عمل', Icons.work),
                            _buildAddressTypeChip('other', 'أخرى', Icons.place),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _deliveryInstructionsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'تعليمات التسليم (اختياري)',
                        hintText: 'مثال: الطابق الثالث، الجرس الأزرق، إلخ',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        suffixIcon: _deliveryInstructionsController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => _deliveryInstructionsController.clear(),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 16),

                    SwitchListTile(
                      title: Text(
                        'تعيين كعنوان افتراضي',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('سيتم استخدام هذا العنوان تلقائياً للطلبات الجديدة'),
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value;
                        });
                      },
                      secondary: Icon(Icons.star, color: _isDefault ? Colors.amber : Colors.grey),
                    ),
                    SizedBox(height: 32),

                    _buildSaveButton(addressProvider),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue[700],
      ),
    );
  }

  Widget _buildCurrentLocationCard(LocationProvider locationProvider) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade100, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.gps_fixed, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'الموقع الجغرافي',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            
            if (_selectedLocation != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'تم تحديد الموقع',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _selectedLocation!.address,
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'الإحداثيات: ${_selectedLocation!.lat.toStringAsFixed(6)}, ${_selectedLocation!.lng.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_off, color: Colors.orange, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'لم يتم تحديد الموقع بعد',
                        style: TextStyle(color: Colors.orange.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: _isGettingLocation
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(Icons.gps_fixed, size: 20),
                    label: Text(_isGettingLocation ? 'جاري التحديد...' : 'تحديد موقعي'),
                    onPressed: _isGettingLocation ? null : _getCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.map, size: 20),
                    label: Text('اختيار من الخريطة'),
                    onPressed: _openMapPicker,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeChip(String type, String label, IconData icon) {
    final isSelected = _addressType == type;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
          SizedBox(width: 6),
          Text(label, style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
          )),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _addressType = type;
        });
      },
      selectedColor: Colors.blue.shade600,
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildSaveButton(AddressProvider addressProvider) {
    final isValid = _formKey.currentState?.validate() ?? false;
    final hasLocation = _selectedLocation != null;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: (addressProvider.isLoading || !isValid || !hasLocation) 
            ? null 
            : _saveAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: (!isValid || !hasLocation) ? Colors.grey : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: addressProvider.isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    widget.addressToEdit != null ? 'تحديث العنوان' : 'حفظ العنوان',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }

  // ✅ الدالة المصححة - تم إصلاح المشكلة الرئيسية
  void _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ يرجى تحديد الموقع أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final address = AddressModel.createNew(
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim(),
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
        state: _stateController.text.trim(),
        country: 'Saudi Arabia',
        postalCode: _postalCodeController.text.trim(),
        addressType: _addressType,
        contactName: _contactNameController.text.trim(),
        contactPhone: _contactPhoneController.text.trim(),
        coordinates: _selectedLocation!,
        deliveryInstructions: _deliveryInstructionsController.text.trim(),
        isDefault: _isDefault,
      );

      final addressProvider = context.read<AddressProvider>();
      
      // ✅ الحل: استخدم toMap() بدلاً من as Map<String, dynamic>
      final addressData = address.toMap();
      
      if (widget.addressToEdit != null) {
        await addressProvider.updateAddress(widget.addressToEdit!.id, addressData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم تحديث العنوان بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await addressProvider.createAddress(addressData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم إضافة العنوان بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('حذف العنوان'),
          ],
        ),
        content: Text('هل أنت متأكد من أنك تريد حذف هذا العنوان؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _deleteAddress,
            child: Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteAddress() async {
    Navigator.pop(context);
    
    setState(() {
      _isLoading = true;
    });

    try {
      final addressProvider = context.read<AddressProvider>();
      await addressProvider.deleteAddress(widget.addressToEdit!.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ تم حذف العنوان بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ خطأ في حذف العنوان: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _deliveryInstructionsController.dispose();
    super.dispose();
  }
}