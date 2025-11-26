import 'dart:convert';

import 'package:customer/data/datasources/remote_datasource.dart';
import '../models/company_model.dart';

class CompanyRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

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
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (nearLocation != null) {
        queryParams['nearLocation'] = jsonEncode(nearLocation);
      }

      final response = await _remoteDataSource.get(
        '/companies',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final List companies = response['data']['companies'] ?? response['companies'] ?? [];
        return companies.map((company) => CompanyModel.fromJson(company)).toList();
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Get companies failed');
      }
    } catch (e) {
      throw Exception('Get companies error: $e');
    }
  }

  Future<CompanyModel> getCompany(String companyId) async {
    try {
      final response = await _remoteDataSource.get('/companies/$companyId');

      if (response['success'] == true) {
        return CompanyModel.fromJson(response['data']['company'] ?? response['company']);
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Get company failed');
      }
    } catch (e) {
      throw Exception('Get company error: $e');
    }
  }

  Future<List<CompanyModel>> getUserCompanies() async {
    try {
      final response = await _remoteDataSource.get('/companies/my-companies');

      if (response['success'] == true) {
        final List companies = response['data']['companies'] ?? response['companies'] ?? [];
        return companies.map((company) => CompanyModel.fromJson(company)).toList();
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Get user companies failed');
      }
    } catch (e) {
      throw Exception('Get user companies error: $e');
    }
  }

  Future<CompanyModel> createCompany(Map<String, dynamic> companyData) async {
    try {
      final response = await _remoteDataSource.post('/companies', companyData);

      if (response['success'] == true) {
        return CompanyModel.fromJson(response['data']['company'] ?? response['company']);
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Create company failed');
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
        return CompanyModel.fromJson(response['data']['company'] ?? response['company']);
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Update company failed');
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
        throw Exception(response['error'] ?? response['message'] ?? 'Add service failed');
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
        throw Exception(response['error'] ?? response['message'] ?? 'Verify company failed');
      }
    } catch (e) {
      throw Exception('Verify company error: $e');
    }
  }

  Future<Map<String, dynamic>> getCompanyStats() async {
    try {
      final response = await _remoteDataSource.get('/companies/stats');

      if (response['success'] == true) {
        return response['data']['stats'] ?? response['stats'] ?? {};
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Get company stats failed');
      }
    } catch (e) {
      throw Exception('Get company stats error: $e');
    }
  }

  // دوال إضافية لتتوافق مع الـ Provider
  Future<List<ProductModel>> getCompanyProducts(String companyId) async {
    try {
      final response = await _remoteDataSource.get('/companies/$companyId/products');

      if (response['success'] == true) {
        final List products = response['data']['products'] ?? response['products'] ?? [];
        return products.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Get company products failed');
      }
    } catch (e) {
      throw Exception('Get company products error: $e');
    }
  }

  Future<void> deleteCompany(String companyId) async {
    try {
      final response = await _remoteDataSource.delete('/companies/$companyId');

      if (response['success'] != true) {
        throw Exception(response['error'] ?? response['message'] ?? 'Delete company failed');
      }
    } catch (e) {
      throw Exception('Delete company error: $e');
    }
  }

  Future<void> updateCompanyStatus(String companyId, bool isActive) async {
    try {
      final response = await _remoteDataSource.patch(
        '/companies/$companyId/status',
        {'isActive': isActive},
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? response['message'] ?? 'Update company status failed');
      }
    } catch (e) {
      throw Exception('Update company status error: $e');
    }
  }

  Future<List<CompanyModel>> getFeaturedCompanies() async {
    try {
      final response = await _remoteDataSource.get('/companies/featured');

      if (response['success'] == true) {
        final List companies = response['data']['companies'] ?? response['companies'] ?? [];
        return companies.map((company) => CompanyModel.fromJson(company)).toList();
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Get featured companies failed');
      }
    } catch (e) {
      throw Exception('Get featured companies error: $e');
    }
  }

  Future<List<CompanyModel>> getNearbyCompanies(double lat, double lng, double radius) async {
    try {
      final response = await _remoteDataSource.get(
        '/companies/nearby',
        queryParams: {
          'lat': lat.toString(),
          'lng': lng.toString(),
          'radius': radius.toString(),
        },
      );

      if (response['success'] == true) {
        final List companies = response['data']['companies'] ?? response['companies'] ?? [];
        return companies.map((company) => CompanyModel.fromJson(company)).toList();
      } else {
        throw Exception(response['error'] ?? response['message'] ?? 'Get nearby companies failed');
      }
    } catch (e) {
      throw Exception('Get nearby companies error: $e');
    }
  }
}

// نموذج ProductModel مؤقت - استبدله بالنموذج الحقيقي
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isAvailable;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isAvailable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}