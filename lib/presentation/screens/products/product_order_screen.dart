// import 'package:customer/data/models/address_model.dart';
// import 'package:customer/data/models/product_model.dart';
// import 'package:customer/presentation/providers/address_provider.dart';
// import 'package:customer/presentation/providers/cart_provider.dart';
// import 'package:customer/presentation/providers/order_provider.dart';
// import 'package:customer/presentation/providers/product_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class ProductOrderScreen extends StatefulWidget {
//   final String? productId;

//   ProductOrderScreen({this.productId});

//   @override
//   _ProductOrderScreenState createState() => _ProductOrderScreenState();
// }

// class _ProductOrderScreenState extends State<ProductOrderScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _notesController = TextEditingController();
  
//   AddressModel? _selectedAddress;
//   int _quantity = 1;
//   ProductModel? _selectedProduct;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() {
//     final addressProvider = Provider.of<AddressProvider>(context, listen: false);
//     final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
//     addressProvider.loadAddresses();
    
//     if (widget.productId != null) {
//       productProvider.loadProduct(widget.productId!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<OrderProvider>(context);
//     final addressProvider = Provider.of<AddressProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//     final cartProvider = Provider.of<CartProvider>(context);

//     // Load product if provided
//     if (widget.productId != null && _selectedProduct == null) {
//       _selectedProduct = productProvider.selectedProduct;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('طلب منتج'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Selection (if not provided)
//               if (widget.productId == null) ...[
//                 Text(
//                   'اختر المنتج',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 _buildProductSelector(productProvider),
//                 SizedBox(height: 20),
//               ],

//               // Product Details
//               if (_selectedProduct != null) ...[
//                 Card(
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             image: DecorationImage(
//                               image: NetworkImage(_selectedProduct!.images.main),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _selectedProduct!.productType,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text('${_selectedProduct!.liters} لتر'),
//                               SizedBox(height: 4),
//                               Text(
//                                 '${_selectedProduct!.price.current} ر.س',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],

//               // Quantity Selector
//               if (_selectedProduct != null) ...[
//                 Text(
//                   'الكمية',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 _buildQuantitySelector(),
//                 SizedBox(height: 20),
//               ],

//               // Delivery Address
//               Text(
//                 'عنوان التوصيل',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               _buildAddressSelector(addressProvider),
//               SizedBox(height: 20),

//               // Delivery Instructions
//               Card(
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'تعليمات التسليم',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       TextFormField(
//                         controller: _notesController,
//                         maxLines: 3,
//                         decoration: InputDecoration(
//                           labelText: 'ملاحظات إضافية',
//                           border: OutlineInputBorder(),
//                           alignLabelWithHint: true,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Price Summary
//               if (_selectedProduct != null) ...[
//                 Card(
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'ملخص الطلب',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 12),
//                         _buildOrderSummary(),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],

//               // Error Message
//               if (orderProvider.error.isNotEmpty)
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.red[50],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.red),
//                   ),
//                   child: Text(
//                     orderProvider.error,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               SizedBox(height: 20),

//               // Action Buttons
//               if (_selectedProduct != null)
//                 _buildActionButtons(orderProvider, cartProvider),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductSelector(ProductProvider productProvider) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             if (productProvider.products.isEmpty)
//               Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Icon(Icons.inventory_2, size: 40, color: Colors.grey),
//                     SizedBox(height: 8),
//                     Text(
//                       'لا توجد منتجات',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               DropdownButtonFormField<ProductModel>(
//                 value: _selectedProduct,
//                 items: productProvider.products.map((product) {
//                   return DropdownMenuItem(
//                     value: product,
//                     child: Text(product.productType),
//                   );
//                 }).toList(),
//                 onChanged: (product) {
//                   setState(() {
//                     _selectedProduct = product;
//                     _quantity = 1;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'اختر المنتج',
//                 ),
//               ),
//             SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/products');
//               },
//               child: Text('تصفح المنتجات'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuantitySelector() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('الكمية'),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.remove),
//                   onPressed: _quantity > 1
//                       ? () {
//                           setState(() {
//                             _quantity--;
//                           });
//                         }
//                       : null,
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     '$_quantity',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: _selectedProduct != null && 
//                       _quantity < _selectedProduct!.stock.quantity
//                       ? () {
//                           setState(() {
//                             _quantity++;
//                           });
//                         }
//                       : null,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressSelector(AddressProvider addressProvider) {
//     if (addressProvider.addresses.isEmpty) {
//       return Card(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Icon(Icons.location_off, size: 40, color: Colors.grey),
//               SizedBox(height: 8),
//               Text(
//                 'لا توجد عناوين',
//                 style: TextStyle(color: Colors.grey),
//               ),
//               SizedBox(height: 12),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/add-address');
//                 },
//                 child: Text('إضافة عنوان جديد'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Column(
//       children: [
//         ...addressProvider.addresses.map((address) {
//           return Card(
//             margin: EdgeInsets.only(bottom: 8),
//             child: RadioListTile<AddressModel>(
//               title: Text(address.addressLine1),
//               subtitle: Text('${address.city} - ${address.district}'),
//               secondary: address.isDefault
//                   ? Icon(Icons.star, color: Colors.amber)
//                   : null,
//               value: address,
//               groupValue: _selectedAddress,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedAddress = value;
//                 });
//               },
//             ),
//           );
//         }),
//         SizedBox(height: 8),
//         TextButton.icon(
//           onPressed: () {
//             Navigator.pushNamed(context, '/add-address');
//           },
//           icon: Icon(Icons.add),
//           label: Text('إضافة عنوان جديد'),
//         ),
//       ],
//     );
//   }

//   Widget _buildOrderSummary() {
//     if (_selectedProduct == null) return SizedBox();

//     final totalPrice = _selectedProduct!.price.current * _quantity;

//     return Column(
//       children: [
//         _buildSummaryRow('سعر الوحدة', '${_selectedProduct!.price.current} ر.س'),
//         _buildSummaryRow('الكمية', '$_quantity'),
//         _buildSummaryRow('الإجمالي', '${totalPrice.toStringAsFixed(2)} ر.س'),
//       ],
//     );
//   }

//   Widget _buildSummaryRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label),
//           Text(value),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(OrderProvider orderProvider, CartProvider cartProvider) {
//     return Row(
//       children: [
//         // Add to Cart Button
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () {
//               cartProvider.addToCart(_selectedProduct!, quantity: _quantity);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
//               );
//             },
//             child: Text('إضافة إلى السلة'),
//           ),
//         ),
//         SizedBox(width: 16),

//         // Order Now Button
//         Expanded(
//           child: ElevatedButton(
//             onPressed: orderProvider.isLoading
//                 ? null
//                 : () => _createProductOrder(orderProvider),
//             child: orderProvider.isLoading
//                 ? CircularProgressIndicator()
//                 : Text('اطلب الآن'),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _createProductOrder(OrderProvider orderProvider) async {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedProduct == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('يرجى اختيار منتج')),
//         );
//         return;
//       }

//       if (_selectedAddress == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('يرجى اختيار عنوان التوصيل')),
//         );
//         return;
//       }

//       final orderData = {
//         'productId': _selectedProduct!.id,
//         'quantity': _quantity,
//         'deliveryLocation': {
//           'address': _selectedAddress!.addressLine1,
//           'coordinates': {
//             'lat': _selectedAddress!.coordinates.lat,
//             'lng': _selectedAddress!.coordinates.lng,
//           },
//           'contactName': _selectedAddress!.contactName,
//           'contactPhone': _selectedAddress!.contactPhone,
//           'instructions': _selectedAddress!.deliveryInstructions,
//         },
//         'customerNotes': _notesController.text,
//       };

//       try {
//         await orderProvider.createProductOrder(orderData);
        
//         if (orderProvider.error.isEmpty && context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('تم إنشاء طلب المنتج بنجاح')),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ أثناء إنشاء طلب المنتج')),
//         );
//       }
//     }
//   }
// }