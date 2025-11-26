import 'package:customer/data/models/product_model.dart';
import 'package:customer/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductDetailsView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsView({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isInCart(product.id);
    final cartQuantity = cartProvider.getProductQuantity(product.id);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Images
          _buildProductImages(),
          
          // Product Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Type
                _buildProductHeader(),
                SizedBox(height: 16),
                
                // Price and Stock
                _buildPriceAndStock(),
                SizedBox(height: 16),
                
                // Description
                _buildDescription(),
                SizedBox(height: 16),
                
                // Product Details
                _buildProductDetails(),
                SizedBox(height: 16),
                
                // Company Info (if available)
                if (product.company != null) _buildCompanyInfo(),
                
                // Add to Cart Section
                _buildAddToCartSection(cartProvider, isInCart, cartQuantity),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImages() {
    return Container(
      height: 300,
      child: Stack(
        children: [
          // Main Image
          PageView.builder(
            itemCount: product.images.gallery.length + 1,
            itemBuilder: (context, index) {
              final imageUrl = index == 0 
                  ? product.images.main 
                  : product.images.gallery[index - 1];
              
              return Image.network(
                imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  );
                },
              );
            },
          ),
          
          // Image Indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // You can add page indicators here if needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productType,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${product.liters} لتر',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndStock() {
    return Row(
      children: [
        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السعر',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${product.price.current} ${product.price.currency}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            if (product.price.previous > 0)
              Text(
                '${product.price.previous} ${product.price.currency}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
        
        Spacer(),
        
        // Stock Status
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStockColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStockIcon(),
                size: 16,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              Text(
                _getStockText(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
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
        Text(
          product.description.isNotEmpty 
              ? product.description 
              : 'لا يوجد وصف متوفر لهذا المنتج',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل المنتج',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          
          _buildDetailRow('نوع المنتج', product.productType),
          _buildDetailRow('السعة', '${product.liters} لتر'),
          _buildDetailRow('الحالة', product.status),
          _buildDetailRow('المخزون المتاح', '${product.stock.quantity} وحدة'),
          
          if (product.tags.isNotEmpty) ...[
            SizedBox(height: 8),
            _buildTags(),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: product.tags.map((tag) {
        return Chip(
          label: Text(
            tag,
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.blue[50],
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  Widget _buildCompanyInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.business,
            color: Colors.blue[700],
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الشركة الموردة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  'شركة ${product.company}',
                  style: TextStyle(
                    color: Colors.blue[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartSection(CartProvider cartProvider, bool isInCart, int cartQuantity) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Controls
          if (isInCart) ...[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (cartQuantity > 1) {
                        cartProvider.decrementQuantity(product.id);
                      } else {
                        cartProvider.removeFromCart(product.id);
                      }
                    },
                  ),
                  Container(
                    width: 40,
                    child: Center(
                      child: Text(
                        cartQuantity.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      cartProvider.incrementQuantity(product.id);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
          ],
          
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (isInCart) {
                  cartProvider.removeFromCart(product.id);
                } else {
                  cartProvider.addToCart(product);
                  // _showAddedToCartSnackbar(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                  ),
                  SizedBox(width: 8),
                  Text(
                    isInCart ? 'إزالة من السلة' : 'إضافة إلى السلة',
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
      ),
    );
  }

  void _showAddedToCartSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text('تمت الإضافة إلى السلة بنجاح'),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
  // Helper methods for stock status
  Color _getStockColor() {
    if (product.stock.quantity == 0) {
      return Colors.red;
    } else if (product.stock.quantity <= product.stock.lowStockAlert) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  IconData _getStockIcon() {
    if (product.stock.quantity == 0) {
      return Icons.cancel;
    } else if (product.stock.quantity <= product.stock.lowStockAlert) {
      return Icons.warning;
    } else {
      return Icons.check_circle;
    }
  }

  String _getStockText() {
    if (product.stock.quantity == 0) {
      return 'نفذ من المخزون';
    } else if (product.stock.quantity <= product.stock.lowStockAlert) {
      return 'مخزون منخفض';
    } else {
      return 'متوفر';
    }
  }
}