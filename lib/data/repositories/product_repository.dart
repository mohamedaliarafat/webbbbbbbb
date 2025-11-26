import 'dart:convert';

import 'package:customer/data/datasources/remote_datasource.dart';

import '../models/product_model.dart';
import '../models/company_model.dart';


class ProductRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  // 🛍️ المنتجات
  Future<List<ProductModel>> getProducts({
    String? productType,
    int? liters,
    String? status,
    String? company,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (productType != null) queryParams['productType'] = productType;
      if (liters != null) queryParams['liters'] = liters.toString();
      if (status != null) queryParams['status'] = status;
      if (company != null) queryParams['company'] = company;
      if (search != null) queryParams['search'] = search;

      final response = await _remoteDataSource.get(
        '/products',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final List products = response['products'] ?? [];
        return products.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        throw Exception(response['error'] ?? 'Get products failed');
      }
    } catch (e) {
      throw Exception('Get products error: $e');
    }
  }

  Future<ProductModel> getProduct(String productId) async {
    try {
      final response = await _remoteDataSource.get('/products/$productId');

      if (response['success'] == true) {
        return ProductModel.fromJson(response['product']);
      } else {
        throw Exception(response['error'] ?? 'Get product failed');
      }
    } catch (e) {
      throw Exception('Get product error: $e');
    }
  }

  Future<ProductModel> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _remoteDataSource.post('/products', productData);

      if (response['success'] == true) {
        return ProductModel.fromJson(response['product']);
      } else {
        throw Exception(response['error'] ?? 'Create product failed');
      }
    } catch (e) {
      throw Exception('Create product error: $e');
    }
  }

  Future<ProductModel> updateProduct(String productId, Map<String, dynamic> updateData) async {
    try {
      final response = await _remoteDataSource.put(
        '/products/$productId',
        updateData,
      );

      if (response['success'] == true) {
        return ProductModel.fromJson(response['product']);
      } else {
        throw Exception(response['error'] ?? 'Update product failed');
      }
    } catch (e) {
      throw Exception('Update product error: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await _remoteDataSource.delete('/products/$productId');

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Delete product failed');
      }
    } catch (e) {
      throw Exception('Delete product error: $e');
    }
  }

  Future<void> updateStock(String productId, int quantity, String action) async {
    try {
      final response = await _remoteDataSource.patch(
        '/products/$productId/stock',
        {
          'quantity': quantity,
          'action': action,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update stock failed');
      }
    } catch (e) {
      throw Exception('Update stock error: $e');
    }
  }

  Future<Map<String, dynamic>> getProductStats() async {
    try {
      final response = await _remoteDataSource.get('/products/stats/overview');

      if (response['success'] == true) {
        return response['stats'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'Get product stats failed');
      }
    } catch (e) {
      throw Exception('Get product stats error: $e');
    }
  }

  Future<List<ProductModel>> getUserProducts(String userId) async {
    try {
      final response = await _remoteDataSource.get('/products/user/$userId/products');

      if (response['success'] == true) {
        final List products = response['products'] ?? [];
        return products.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        throw Exception(response['error'] ?? 'Get user products failed');
      }
    } catch (e) {
      throw Exception('Get user products error: $e');
    }
  }

  Future<List<ProductModel>> getCompanyProducts(String companyId) async {
    try {
      final response = await _remoteDataSource.get('/products/company/$companyId/products');

      if (response['success'] == true) {
        final List products = response['products'] ?? [];
        return products.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        throw Exception(response['error'] ?? 'Get company products failed');
      }
    } catch (e) {
      throw Exception('Get company products error: $e');
    }
  }

  // 🏢 الشركات
  Future<List<CompanyModel>> getCompanies({
    String? companyType,
    String? verification,
    bool? featured,
    bool? isActive,
    String? search,
    Map<String, dynamic>? nearLocation,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (companyType != null) queryParams['companyType'] = companyType;
      if (verification != null) queryParams['verification'] = verification;
      if (featured != null) queryParams['featured'] = featured.toString();
      if (isActive != null) queryParams['isActive'] = isActive.toString();
      if (search != null) queryParams['search'] = search;
      if (nearLocation != null) queryParams['nearLocation'] = jsonEncode(nearLocation);

      final response = await _remoteDataSource.get(
        '/companies',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final List companies = response['companies'] ?? [];
        return companies.map((company) => CompanyModel.fromJson(company)).toList();
      } else {
        throw Exception(response['error'] ?? 'Get companies failed');
      }
    } catch (e) {
      throw Exception('Get companies error: $e');
    }
  }

  Future<CompanyModel> getCompany(String companyId) async {
    try {
      final response = await _remoteDataSource.get('/companies/$companyId');

      if (response['success'] == true) {
        return CompanyModel.fromJson(response['company']);
      } else {
        throw Exception(response['error'] ?? 'Get company failed');
      }
    } catch (e) {
      throw Exception('Get company error: $e');
    }
  }

  Future<CompanyModel> createCompany(Map<String, dynamic> companyData) async {
    try {
      final response = await _remoteDataSource.post('/companies', companyData);

      if (response['success'] == true) {
        return CompanyModel.fromJson(response['company']);
      } else {
        throw Exception(response['error'] ?? 'Create company failed');
      }
    } catch (e) {
      throw Exception('Create company error: $e');
    }
  }

  Future<CompanyModel> updateCompany(String companyId, Map<String, dynamic> updateData) async {
    try {
      final response = await _remoteDataSource.put(
        '/companies/$companyId',
        updateData,
      );

      if (response['success'] == true) {
        return CompanyModel.fromJson(response['company']);
      } else {
        throw Exception(response['error'] ?? 'Update company failed');
      }
    } catch (e) {
      throw Exception('Update company error: $e');
    }
  }

  Future<void> addService(String companyId, Map<String, dynamic> service) async {
    try {
      final response = await _remoteDataSource.patch(
        '/companies/$companyId/services',
        {'service': service},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Add service failed');
      }
    } catch (e) {
      throw Exception('Add service error: $e');
    }
  }

  Future<void> verifyCompany(String companyId, String verification, {String? message}) async {
    try {
      final response = await _remoteDataSource.patch(
        '/companies/$companyId/verify',
        {
          'verification': verification,
          if (message != null) 'verificationMessage': message,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Verify company failed');
      }
    } catch (e) {
      throw Exception('Verify company error: $e');
    }
  }

  Future<Map<String, dynamic>> getCompanyStats() async {
    try {
      final response = await _remoteDataSource.get('/companies/stats');

      if (response['success'] == true) {
        return response['stats'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'Get company stats failed');
      }
    } catch (e) {
      throw Exception('Get company stats error: $e');
    }
  }
}