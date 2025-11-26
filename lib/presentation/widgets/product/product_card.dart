import 'package:customer/data/models/product_model.dart';
import 'package:customer/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final bool showAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.showAddToCart = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final isInCart = cartProvider.isInCart(product.id);
    final cartQuantity = cartProvider.getProductQuantity(product.id);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              _buildProductImage(),
              SizedBox(height: 8),

              // Product Type and Status
              _buildProductHeader(),
              SizedBox(height: 8),

              // Product Details
              _buildProductDetails(),
              SizedBox(height: 8),

              // Price and Actions
              _buildPriceAndActions(context, isInCart, cartQuantity),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(
            product.images.main.isNotEmpty
                ? product.images.main
                : 'https://via.placeholder.com/150',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Stock Status Badge
          if (!product.stock.isInStock)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'نفذ من المخزون',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Low Stock Warning
          if (product.stock.isInStock && product.stock.quantity <= product.stock.lowStockAlert)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'كمية محدودة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Gallery Indicator
          if (product.images.gallery.isNotEmpty)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_library, size: 12, color: Colors.white),
                    SizedBox(width: 2),
                    Text(
                      '${product.images.gallery.length + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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

  Widget _buildProductHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Product Type
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getProductTypeColor(product.productType),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _getProductTypeText(product.productType),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Product Number
        Text(
          product.productNumber,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Liters
        Row(
          children: [
            Icon(Icons.local_gas_station, size: 16, color: Colors.blue),
            SizedBox(width: 4),
            Text(
              '${product.liters} لتر',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),

        // Description
        if (product.description.isNotEmpty)
          Text(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),

        // Stock Information
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.inventory_2, size: 14, color: Colors.grey),
            SizedBox(width: 4),
            Text(
              'المخزون: ${product.stock.quantity}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        // Tags
        if (product.tags.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4),
            height: 20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.tags.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 4),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    product.tags[index],
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndActions(BuildContext context, bool isInCart, int cartQuantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product.price.current} ر.س',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            if (product.price.previous > 0 && product.price.previous != product.price.current)
              Text(
                '${product.price.previous} ر.س',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),

        // Add to Cart Button
        if (showAddToCart && product.stock.isInStock)
          _buildCartActions(context, isInCart, cartQuantity),

        // Out of Stock Message
        if (!product.stock.isInStock)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'غير متوفر',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCartActions(BuildContext context, bool isInCart, int cartQuantity) {
    final cartProvider = context.read<CartProvider>();

    if (isInCart) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrement Button
            IconButton(
              icon: Icon(Icons.remove, size: 16, color: Colors.white),
              onPressed: () {
                cartProvider.decrementQuantity(product.id);
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
            ),

            // Quantity
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                cartQuantity.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            // Increment Button
            IconButton(
              icon: Icon(Icons.add, size: 16, color: Colors.white),
              onPressed: () {
                cartProvider.incrementQuantity(product.id);
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          cartProvider.addToCart(product);
          _showAddToCartSnackbar(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart, size: 16),
            SizedBox(width: 4),
            Text(
              'أضف',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }
  }

  void _showAddToCartSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة ${product.productType} إلى السلة'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'عرض السلة',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart screen
          },
        ),
      ),
    );
  }

  // Helper Methods
  Color _getProductTypeColor(String productType) {
    switch (productType) {
      case 'بنزين':
        return Colors.orange;
      case 'ديزل':
        return Colors.blue;
      case 'كيروسين':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getProductTypeText(String productType) {
    switch (productType) {
      case 'بنزين':
        return 'بنزين';
      case 'ديزل':
        return 'ديزل';
      case 'كيروسين':
        return 'كيروسين';
      default:
        return 'أخرى';
    }
  }
}

// Compact Product Card for Grid View
class CompactProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const CompactProductCard({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: NetworkImage(
                      product.images.main.isNotEmpty
                          ? product.images.main
                          : 'https://via.placeholder.com/150',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 6),

              // Product Type
              Text(
                _getProductTypeText(product.productType),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getProductTypeColor(product.productType),
                ),
              ),

              // Liters
              Text(
                '${product.liters} لتر',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),

              Spacer(),

              // Price
              Text(
                '${product.price.current} ر.س',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProductTypeColor(String productType) {
    switch (productType) {
      case 'بنزين':
        return Colors.orange;
      case 'ديزل':
        return Colors.blue;
      case 'كيروسين':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getProductTypeText(String productType) {
    switch (productType) {
      case 'بنزين':
        return 'بنزين';
      case 'ديزل':
        return 'ديزل';
      case 'كيروسين':
        return 'كيروسين';
      default:
        return 'أخرى';
    }
  }
}

// Product Card with Company Info
class ProductCardWithCompany extends StatelessWidget {
  final ProductModel product;
  final String companyName;
  final String companyLogo;
  final VoidCallback? onTap;

  const ProductCardWithCompany({
    Key? key,
    required this.product,
    required this.companyName,
    required this.companyLogo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(companyLogo),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      companyName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Product Image and Details
              _buildProductImage(),
              SizedBox(height: 8),
              _buildProductDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(
            product.images.main.isNotEmpty
                ? product.images.main
                : 'https://via.placeholder.com/150',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getProductTypeText(product.productType),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${product.liters} لتر',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          '${product.price.current} ر.س',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  String _getProductTypeText(String productType) {
    switch (productType) {
      case 'بنزين':
        return 'بنزين';
      case 'ديزل':
        return 'ديزل';
      case 'كيروسين':
        return 'كيروسين';
      default:
        return 'أخرى';
    }
  }
}