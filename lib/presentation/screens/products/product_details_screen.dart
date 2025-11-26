import 'package:customer/data/models/product_model.dart';
import 'package:customer/presentation/providers/cart_provider.dart';
import 'package:customer/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  ProductDetailsScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final product = productProvider.selectedProduct;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('تفاصيل المنتج')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل المنتج'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Images
            Container(
              height: 300,
              child: PageView.builder(
                itemCount: 1 + product.images.gallery.length,
                itemBuilder: (context, index) {
                  final image = index == 0 
                      ? product.images.main 
                      : product.images.gallery[index - 1];
                  
                  return Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),

            // Product Info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productType,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'رقم المنتج: ${product.productNumber}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      Text(
                        '${product.price.current} ر.س',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (product.price.previous > 0) ...[
                        SizedBox(width: 8),
                        Text(
                          '${product.price.previous} ر.س',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 16),

                  // Specifications
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المواصفات',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildSpecItem('السعة', '${product.liters} لتر'),
                          _buildSpecItem('النوع', product.productType),
                          _buildSpecItem('الحالة', product.status),
                          _buildSpecItem('المخزون', '${product.stock.quantity} وحدة'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Description
                  if (product.description.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الوصف',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(product.description),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Company Info (if available)
                  if (product.company != null) ...[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الشركة الموردة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // TODO: Load and display company info
                            Text('معلومات الشركة'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(cartProvider, product),
    );
  }

  Widget _buildSpecItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider, ProductModel product) {
    final isInCart = cartProvider.isInCart(product.id);
    final cartQuantity = cartProvider.getProductQuantity(product.id);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 4,
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        children: [
          if (isInCart) ...[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                cartProvider.decrementQuantity(product.id);
              },
            ),
            Text('$cartQuantity'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                cartProvider.incrementQuantity(product.id);
              },
            ),
            Spacer(),
          ] else if (product.stock.isInStock) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  cartProvider.addToCart(product);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
                  // );
                },
                icon: Icon(Icons.shopping_cart),
                label: Text('إضافة إلى السلة'),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: null,
                child: Text('غير متوفر'),
              ),
            ),
          ],

          SizedBox(width: 16),

          // Order Now Button
          if (product.stock.isInStock)
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(
                //   context, 
                //   '/product-order',
                //   arguments: product.id,
                // );
              },
              child: Text('اطلب الآن'),
            ),
        ],
      ),
    );
  }
}