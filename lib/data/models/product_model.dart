import 'location_model.dart';

class ProductModel {
  final String id;
  final String productNumber;
  final String productType;
  final int liters;
  final ProductPrice price;
  final ProductImages images;
  final String description;
  final String status;
  final ProductStock stock;
  final String addedBy;
  final String? company;
  final ProductStats stats;
  final List<String> tags;
  final LocationModel? storageLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.productNumber,
    required this.productType,
    required this.liters,
    required this.price,
    required this.images,
    required this.description,
    required this.status,
    required this.stock,
    required this.addedBy,
    this.company,
    required this.stats,
    required this.tags,
    this.storageLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      productNumber: json['productNumber'] ?? '',
      productType: json['productType'] ?? 'بنزين',
      liters: json['liters'] ?? 20000,
      price: ProductPrice.fromJson(json['price'] ?? {}),
      images: ProductImages.fromJson(json['images'] ?? {}),
      description: json['description'] ?? '',
      status: json['status'] ?? 'متاح',
      stock: ProductStock.fromJson(json['stock'] ?? {}),
      addedBy: json['addedBy']?.toString() ?? '',
      company: json['company']?.toString(),
      stats: ProductStats.fromJson(json['stats'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      storageLocation: json['storageLocation'] != null ? LocationModel.fromJson(json['storageLocation']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ProductPrice {
  final double current;
  final double previous;
  final String currency;

  ProductPrice({
    required this.current,
    required this.previous,
    required this.currency,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
      current: (json['current'] ?? 0).toDouble(),
      previous: (json['previous'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'SAR',
    );
  }
}

class ProductImages {
  final String main;
  final List<String> gallery;

  ProductImages({
    required this.main,
    required this.gallery,
  });

  factory ProductImages.fromJson(Map<String, dynamic> json) {
    return ProductImages(
      main: json['main'] ?? '',
      gallery: List<String>.from(json['gallery'] ?? []),
    );
  }
}

class ProductStock {
  final int quantity;
  final int lowStockAlert;
  final bool isInStock;

  ProductStock({
    required this.quantity,
    required this.lowStockAlert,
    required this.isInStock,
  });

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      quantity: json['quantity'] ?? 0,
      lowStockAlert: json['lowStockAlert'] ?? 10,
      isInStock: json['isInStock'] ?? false,
    );
  }
}

class ProductStats {
  final int totalOrders;
  final double totalRevenue;
  final int views;

  ProductStats({
    required this.totalOrders,
    required this.totalRevenue,
    required this.views,
  });

  factory ProductStats.fromJson(Map<String, dynamic> json) {
    return ProductStats(
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      views: json['views'] ?? 0,
    );
  }
}