import 'package:customer/data/models/product_model.dart';
import 'package:flutter/material.dart';


class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel) onAddToCart;
  final bool showAddToCart;
  final int crossAxisCount;
  final double childAspectRatio;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    this.showAddToCart = true,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      padding: EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductGridItem(
          product: product,
          onTap: () => onProductTap(product),
          onAddToCart: () => onAddToCart(product),
          showAddToCart: showAddToCart,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد منتجات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'سيتم عرض المنتجات هنا عند توفرها',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProductGridItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final bool showAddToCart;

  const _ProductGridItem({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    required this.showAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(),
            
            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Type and Status
                    _buildProductHeader(),
                    
                    // Product Description
                    _buildProductDescription(),
                    
                    // Price and Add to Cart
                    _buildProductFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
        
        // Stock Status Badge
        Positioned(
          top: 8,
          left: 8,
          child: _buildStockBadge(),
        ),
        
        // Favorite Button
        Positioned(
          top: 8,
          right: 8,
          child: _buildFavoriteButton(),
        ),
      ],
    );
  }

  Widget _buildStockBadge() {
    Color backgroundColor;
    String text;
    
    if (product.status == 'متاح' && product.stock.isInStock) {
      backgroundColor = Colors.green;
      text = 'متوفر';
    } else if (product.status == 'نفذ من المخزون') {
      backgroundColor = Colors.red;
      text = 'نفذ';
    } else {
      backgroundColor = Colors.orange;
      text = 'غير متوفر';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.favorite_border,
          size: 18,
          color: Colors.grey[600],
        ),
        onPressed: () {
          // Implement favorite functionality
        },
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _getProductTypeText(product.productType),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (product.liters > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Text(
              '${product.liters} لتر',
              style: TextStyle(
                fontSize: 10,
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductDescription() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          product.description.isNotEmpty 
              ? product.description 
              : 'منتج وقود عالي الجودة',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildProductFooter() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${product.price.current} ر.س',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              if (product.price.previous > 0 && product.price.previous != product.price.current)
                Text(
                  '${product.price.previous} ر.س',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ),
        
        if (showAddToCart && product.status == 'متاح' && product.stock.isInStock)
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
                size: 18,
                color: Colors.white,
              ),
              onPressed: onAddToCart,
              padding: EdgeInsets.all(6),
              constraints: BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
      ],
    );
  }

  String _getProductTypeText(String type) {
    switch (type) {
      case 'بنزين':
        return '⛽ بنزين';
      case 'ديزل':
        return '🚛 ديزل';
      case 'كيروسين':
        return '🔥 كيروسين';
      case 'أخرى':
        return '🛢️ منتج آخر';
      default:
        return type;
    }
  }
}

// Alternative Grid View with different layout
class ProductCompactGrid extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel) onAddToCart;

  const ProductCompactGrid({
    Key? key,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCompactItem(
          product: product,
          onTap: () => onProductTap(product),
          onAddToCart: () => onAddToCart(product),
        );
      },
    );
  }
}

class _ProductCompactItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _ProductCompactItem({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            // Product Image
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
            
            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getProductTypeText(product.productType),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 2),
                    
                    if (product.liters > 0)
                      Text(
                        '${product.liters} لتر',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    
                    Spacer(),
                    
                    Row(
                      children: [
                        Text(
                          '${product.price.current} ر.س',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Spacer(),
                        if (product.status == 'متاح' && product.stock.isInStock)
                          GestureDetector(
                            onTap: onAddToCart,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getProductTypeText(String type) {
    switch (type) {
      case 'بنزين':
        return 'بنزين';
      case 'ديزل':
        return 'ديزل';
      case 'كيروسين':
        return 'كيروسين';
      default:
        return type;
    }
  }
}

// Loading Grid Shimmer
class ProductGridShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const ProductGridShimmer({
    Key? key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      padding: EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Shimmer
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
              
              // Content Shimmer
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 80,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 120,
                        color: Colors.grey[300],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            height: 18,
                            width: 60,
                            color: Colors.grey[300],
                          ),
                          Spacer(),
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}