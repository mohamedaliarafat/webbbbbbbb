
import 'package:customer/data/models/company_model.dart';
import 'package:customer/data/models/product_model.dart';
import 'package:customer/data/repositories/company_repository.dart' hide ProductModel;


import 'package:flutter/material.dart';

class CompanyProvider with ChangeNotifier {
  final CompanyRepository _companyRepository = CompanyRepository();
  
  List<CompanyModel> _companies = [];
  List<CompanyModel> _featuredCompanies = [];
  List<CompanyModel> _nearbyCompanies = [];
  CompanyModel? _selectedCompany;
  List<ProductModel> _companyProducts = [];
  Map<String, List<CompanyModel>> _companiesByType = {};
  
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  String _selectedCompanyType = 'all';
  Map<String, dynamic> _filters = {};
  bool _isDisposed = false;

  List<CompanyModel> get companies => _companies;
  List<CompanyModel> get featuredCompanies => _featuredCompanies;
  List<CompanyModel> get nearbyCompanies => _nearbyCompanies;
  CompanyModel? get selectedCompany => _selectedCompany;
  List<ProductModel> get companyProducts => _companyProducts;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCompanyType => _selectedCompanyType;
  Map<String, dynamic> get filters => _filters;

  // دالة آمنة لإشعار المستمعين
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          notifyListeners();
        }
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // جلب جميع الشركات
  Future<void> loadCompanies({
    String? companyType,
    String? verification,
    bool? featured,
    bool? isActive,
    String? search,
    Map<String, dynamic>? nearLocation,
    int page = 1,
    int limit = 10,
  }) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _companies = await _companyRepository.getCompanies(
        companyType: companyType,
        verification: verification,
        featured: featured,
        isActive: isActive,
        search: search,
        nearLocation: nearLocation,
        page: page,
        limit: limit,
      );
      
      _updateCompaniesByType();
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // جلب الشركات المميزة
  Future<void> loadFeaturedCompanies() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _featuredCompanies = await _companyRepository.getCompanies(
        featured: true,
        verification: 'Verified',
        isActive: true,
        limit: 10,
      );
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // جلب الشركات القريبة
  Future<void> loadNearbyCompanies(double lat, double lng, double radius) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _nearbyCompanies = await _companyRepository.getCompanies(
        nearLocation: {
          'lat': lat,
          'lng': lng,
          'radius': radius,
        },
        verification: 'Verified',
        isActive: true,
        limit: 15,
      );
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // جلب شركة محددة
  Future<void> loadCompany(String companyId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _selectedCompany = await _companyRepository.getCompany(companyId);
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // جلب منتجات الشركة
  Future<void> loadCompanyProducts(String companyId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _companyProducts = (await _companyRepository.getCompanyProducts(companyId)).cast<ProductModel>();
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // إنشاء شركة جديدة
  Future<CompanyModel> createCompany(Map<String, dynamic> companyData) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      final company = await _companyRepository.createCompany(companyData);
      _companies.insert(0, company);
      _updateCompaniesByType();
      _isLoading = false;
      _safeNotifyListeners();
      return company;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  // تحديث بيانات الشركة
  Future<CompanyModel> updateCompany(String companyId, Map<String, dynamic> updateData) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      final company = await _companyRepository.updateCompany(companyId, updateData);
      
      // تحديث الحالة المحلية
      final index = _companies.indexWhere((c) => c.id == companyId);
      if (index != -1) {
        _companies[index] = company;
      }
      
      if (_selectedCompany?.id == companyId) {
        _selectedCompany = company;
      }
      
      _updateCompaniesByType();
      _isLoading = false;
      _safeNotifyListeners();
      return company;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  // إضافة خدمة للشركة
  Future<void> addService(String companyId, Map<String, dynamic> service) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      await _companyRepository.addService(companyId, service);
      
      // تحديث الحالة المحلية
      if (_selectedCompany?.id == companyId) {
        final updatedServices = [..._selectedCompany!.services, CompanyService.fromJson(service)];
        _selectedCompany = _selectedCompany!.copyWith(services: updatedServices);
      }
      
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // التحقق من الشركة (للمسؤولين)
  Future<void> verifyCompany(String companyId, String verification, {String? message}) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      await _companyRepository.verifyCompany(companyId, verification, message: message);
      
      // تحديث الحالة المحلية
      final index = _companies.indexWhere((c) => c.id == companyId);
      if (index != -1) {
        _companies[index] = _companies[index].copyWith(
          verification: verification,
          verificationMessage: message ?? _companies[index].verificationMessage,
        );
      }
      
      if (_selectedCompany?.id == companyId) {
        _selectedCompany = _selectedCompany!.copyWith(
          verification: verification,
          verificationMessage: message ?? _selectedCompany!.verificationMessage,
        );
      }
      
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // جلب إحصائيات الشركات
  Future<Map<String, dynamic>> getCompanyStats() async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      final stats = await _companyRepository.getCompanyStats();
      _isLoading = false;
      _safeNotifyListeners();
      return stats;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
      return {};
    }
  }

  // البحث في الشركات
  Future<void> searchCompanies(String query) async {
    _searchQuery = query;
    _safeNotifyListeners();

    await loadCompanies(
      search: query.isEmpty ? null : query,
      companyType: _selectedCompanyType == 'all' ? null : _selectedCompanyType,
    );
  }

  // تصفية حسب نوع الشركة
  Future<void> filterByCompanyType(String companyType) async {
    _selectedCompanyType = companyType;
    _safeNotifyListeners();

    await loadCompanies(
      companyType: companyType == 'all' ? null : companyType,
      search: _searchQuery.isEmpty ? null : _searchQuery,
    );
  }

  // تطبيق فلاتر متعددة
  Future<void> applyFilters(Map<String, dynamic> newFilters) async {
    _filters = newFilters;
    _safeNotifyListeners();

    await loadCompanies(
      companyType: newFilters['companyType'] as String?,
      verification: newFilters['verification'] as String?,
      featured: newFilters['featured'] as bool?,
      isActive: newFilters['isActive'] as bool?,
      search: _searchQuery.isEmpty ? null : _searchQuery,
    );
  }

  // تحديث تصنيف الشركات حسب النوع
  void _updateCompaniesByType() {
    _companiesByType = {};
    
    for (final company in _companies) {
      if (!_companiesByType.containsKey(company.companyType)) {
        _companiesByType[company.companyType] = [];
      }
      _companiesByType[company.companyType]!.add(company);
    }
  }

  // الحصول على الشركات حسب النوع
  List<CompanyModel> getCompaniesByType(String companyType) {
    return _companiesByType[companyType] ?? [];
  }

  // الحصول على أنواع الشركات المتاحة
  List<String> getAvailableCompanyTypes() {
    final types = _companiesByType.keys.toList();
    return ['all', ...types];
  }

  // الحصول على عدد الشركات حسب النوع
  Map<String, int> getCompaniesCountByType() {
    final countMap = <String, int>{};
    
    for (final type in _companiesByType.keys) {
      countMap[type] = _companiesByType[type]!.length;
    }
    
    return countMap;
  }

  // الحصول على الشركات الموصى بها
  List<CompanyModel> getRecommendedCompanies() {
    return _companies.where((company) {
      return company.isVerified &&
             company.rating >= 4.0 &&
             company.isActive;
    }).toList();
  }

  // الحصول على الشركات التي تقدم خدمة التوصيل
  List<CompanyModel> getDeliveryCompanies() {
    return _companies.where((company) {
      return company.serviceSettings.hasDelivery &&
             company.isVerified &&
             company.isActive;
    }).toList();
  }

  // تقييم شركة
  Future<void> rateCompany(String companyId, double rating, String comment) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      // في التطبيق الحقيقي، ستقوم باستدعاء API التقييم
      await Future.delayed(Duration(seconds: 1));
      
      // تحديث الحالة المحلية
      final index = _companies.indexWhere((c) => c.id == companyId);
      if (index != -1) {
        final oldCompany = _companies[index];
        final newRating = ((oldCompany.rating * oldCompany.ratingCount) + rating) / (oldCompany.ratingCount + 1);
        
        _companies[index] = oldCompany.copyWith(
          rating: double.parse(newRating.toStringAsFixed(1)),
          ratingCount: oldCompany.ratingCount + 1,
        );
      }
      
      if (_selectedCompany?.id == companyId) {
        final oldCompany = _selectedCompany!;
        final newRating = ((oldCompany.rating * oldCompany.ratingCount) + rating) / (oldCompany.ratingCount + 1);
        
        _selectedCompany = oldCompany.copyWith(
          rating: double.parse(newRating.toStringAsFixed(1)),
          ratingCount: oldCompany.ratingCount + 1,
        );
      }
      
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // تبديل حالة المفضلة للشركة
  void toggleCompanyFavorite(String companyId) {
    // في التطبيق الحقيقي، ستقوم بحفظ المفضلة في الخادم
    final index = _companies.indexWhere((c) => c.id == companyId);
    if (index != -1) {
      // تحديث الحالة المحلية فقط
      // يمكن إضافة حقل isFavorite في CompanyModel إذا لزم الأمر
    }
    
    if (_selectedCompany?.id == companyId) {
      // تحديث الشركة المحددة
    }
    
    _safeNotifyListeners();
  }

  // التحقق من توفر خدمة في الشركة
  bool hasService(String companyId, String serviceName) {
    final company = _companies.firstWhere(
      (c) => c.id == companyId,
      orElse: () => _selectedCompany!,
    );
    
    return company.services.any((service) => 
      service.name == serviceName && service.isAvailable);
  }

  // الحصول على سعر خدمة معينة
  double getServicePrice(String companyId, String serviceName) {
    final company = _companies.firstWhere(
      (c) => c.id == companyId,
      orElse: () => _selectedCompany!,
    );
    
    final service = company.services.firstWhere(
      (s) => s.name == serviceName,
      orElse: () => CompanyService(
        name: serviceName,
        description: '',
        price: 0,
        isAvailable: false,
        estimatedTime: '',
      ),
    );
    
    return service.price;
  }

  // التحقق إذا كانت الشركة مفتوحة الآن
  bool isCompanyOpen(String companyId) {
    final company = _companies.firstWhere(
      (c) => c.id == companyId,
      orElse: () => _selectedCompany!,
    );
    
    return company.isOpenNow;
  }

  // الحصول على عنوان الشركة الكامل
  String getCompanyFullAddress(String companyId) {
    final company = _companies.firstWhere(
      (c) => c.id == companyId,
      orElse: () => _selectedCompany!,
    );
    
    return company.location.fullAddress;
  }

  // الحصول على نسبة إكمال الطلبات
  double getCompanyCompletionRate(String companyId) {
    final company = _companies.firstWhere(
      (c) => c.id == companyId,
      orElse: () => _selectedCompany!,
    );
    
    return company.completionRate;
  }

  // تعيين شركة محددة
  void setSelectedCompany(CompanyModel company) {
    _selectedCompany = company;
    _safeNotifyListeners();
  }

  // تحديث استعلام البحث
  void setSearchQuery(String query) {
    _searchQuery = query;
    _safeNotifyListeners();
  }

  // مسح الفلاتر
  void clearFilters() {
    _filters = {};
    _selectedCompanyType = 'all';
    _searchQuery = '';
    _safeNotifyListeners();
  }

  // مسح الخطأ
  void clearError() {
    _error = '';
    _safeNotifyListeners();
  }

  // إعادة تعيين الـ provider
  void reset() {
    _companies = [];
    _featuredCompanies = [];
    _nearbyCompanies = [];
    _selectedCompany = null;
    _companyProducts = [];
    _companiesByType = {};
    _isLoading = false;
    _error = '';
    _searchQuery = '';
    _selectedCompanyType = 'all';
    _filters = {};
    _safeNotifyListeners();
  }
}