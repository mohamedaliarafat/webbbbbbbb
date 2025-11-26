import 'package:customer/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    final Map<String, Map<String, dynamic>> categories = {
      'بنزين': {
        'icon': Icons.local_gas_station,
        'color': Colors.blue,
        'subcategories': ['91', '95', '98']
      },
      'ديزل': {
        'icon': Icons.local_gas_station,
        'color': Colors.green,
        'subcategories': ['ديزل عادي', 'ديزل ممتاز']
      },
      'كيروسين': {
        'icon': Icons.local_gas_station,
        'color': Colors.orange,
        'subcategories': ['كيروسين']
      },
      'أخرى': {
        'icon': Icons.category,
        'color': Colors.purple,
        'subcategories': ['منتجات أخرى']
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('الفئات'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
          final spacing = _getSpacing(constraints.maxWidth);
          final childAspectRatio = _getAspectRatio(constraints.maxWidth);

          return GridView.builder(
            padding: EdgeInsets.all(spacing),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoryKey = categories.keys.elementAt(index);
              final category = categories[categoryKey]!;

              return _buildCategoryCard(
                context,
                categoryKey,
                category['icon'] as IconData,
                category['color'] as Color,
                category['subcategories'] as List<String>,
                productProvider,
                constraints.maxWidth,
              );
            },
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1000) return 4; // Desktop
    if (screenWidth > 600) return 3;  // Tablet
    if (screenWidth > 400) return 2;  // Large phone
    return 2; // Small phone
  }

  double _getSpacing(double screenWidth) {
    if (screenWidth > 1000) return 24; // Desktop
    if (screenWidth > 600) return 20;  // Tablet
    if (screenWidth > 400) return 16;  // Large phone
    return 12; // Small phone
  }

  double _getAspectRatio(double screenWidth) {
    if (screenWidth > 1000) return 1.1; // Desktop
    if (screenWidth > 600) return 1.2;  // Tablet
    if (screenWidth > 400) return 1.3;  // Large phone
    return 1.4; // Small phone
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String categoryName,
    IconData icon,
    Color color,
    List<String> subcategories,
    ProductProvider productProvider,
    double screenWidth,
  ) {
    final categoryProducts = productProvider.products
        .where((product) => product.productType == categoryName)
        .toList();

    final iconSize = _getIconSize(screenWidth);
    final titleSize = _getTitleSize(screenWidth);
    final subtitleSize = _getSubtitleSize(screenWidth);
    final chipTextSize = _getChipTextSize(screenWidth);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigator.pushNamed(
          //   context,
          //   '/products',
          //   arguments: {'category': categoryName},
          // );
        },
        child: Container(
          padding: EdgeInsets.all(_getCardPadding(screenWidth)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة الفئة
              Container(
                padding: EdgeInsets.all(_getIconPadding(screenWidth)),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: iconSize, color: color),
              ),
              
              SizedBox(height: _getSpacing(screenWidth) * 0.8),
              
              // اسم الفئة
              Text(
                categoryName,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 4),
              
              // عدد المنتجات
              Text(
                '${categoryProducts.length} منتج',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.grey[600],
                ),
              ),
              
              SizedBox(height: _getSpacing(screenWidth) * 0.5),
              
              // التصنيفات الفرعية
              if (subcategories.isNotEmpty)
                Container(
                  height: _getChipsHeight(screenWidth),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: subcategories.take(2).map((subcategory) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            subcategory,
                            style: TextStyle(
                              fontSize: chipTextSize,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _getIconSize(double screenWidth) {
    if (screenWidth > 1000) return 40; // Desktop
    if (screenWidth > 600) return 36;  // Tablet
    if (screenWidth > 400) return 32;  // Large phone
    return 28; // Small phone
  }

  double _getIconPadding(double screenWidth) {
    if (screenWidth > 1000) return 16; // Desktop
    if (screenWidth > 600) return 14;  // Tablet
    if (screenWidth > 400) return 12;  // Large phone
    return 10; // Small phone
  }

  double _getTitleSize(double screenWidth) {
    if (screenWidth > 1000) return 20; // Desktop
    if (screenWidth > 600) return 18;  // Tablet
    if (screenWidth > 400) return 16;  // Large phone
    return 14; // Small phone
  }

  double _getSubtitleSize(double screenWidth) {
    if (screenWidth > 1000) return 14; // Desktop
    if (screenWidth > 600) return 13;  // Tablet
    if (screenWidth > 400) return 12;  // Large phone
    return 11; // Small phone
  }

  double _getChipTextSize(double screenWidth) {
    if (screenWidth > 1000) return 12; // Desktop
    if (screenWidth > 600) return 11;  // Tablet
    if (screenWidth > 400) return 10;  // Large phone
    return 9; // Small phone
  }

  double _getCardPadding(double screenWidth) {
    if (screenWidth > 1000) return 20; // Desktop
    if (screenWidth > 600) return 16;  // Tablet
    if (screenWidth > 400) return 12;  // Large phone
    return 8; // Small phone
  }

  double _getChipsHeight(double screenWidth) {
    if (screenWidth > 1000) return 40; // Desktop
    if (screenWidth > 600) return 36;  // Tablet
    if (screenWidth > 400) return 32;  // Large phone
    return 28; // Small phone
  }
}