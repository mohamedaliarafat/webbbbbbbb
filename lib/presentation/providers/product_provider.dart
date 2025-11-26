import 'package:customer/data/models/company_model.dart';
import 'package:customer/data/models/product_model.dart';
import 'package:customer/data/repositories/product_repository.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  
  List<ProductModel> _products = [];
  List<CompanyModel> _companies = [];
  ProductModel? _selectedProduct;
  CompanyModel? _selectedCompany;
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  List<ProductModel> get products => _products;
  List<CompanyModel> get companies => _companies;
  ProductModel? get selectedProduct => _selectedProduct;
  CompanyModel? get selectedCompany => _selectedCompany;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  // Constructor - بدون أي عمليات تلقائية
  ProductProvider();

  // دالة منفصلة للتهيئة يتم استدعاؤها يدوياً
  Future<void> initialize() async {
    if (_products.isEmpty && _companies.isEmpty) {
      await Future.delayed(Duration.zero);
      // يمكنك تحميل بيانات افتراضية هنا إذا أردت
    }
  }

  Future<void> loadProducts({
    String? productType,
    int? liters,
    String? status,
    String? company,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _products = await _productRepository.getProducts(
        productType: productType,
        liters: liters,
        status: status,
        company: company,
        search: search,
        page: page,
        limit: limit,
      );
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

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
      _companies = await _productRepository.getCompanies(
        companyType: companyType,
        verification: verification,
        featured: featured,
        isActive: isActive,
        search: search,
        nearLocation: nearLocation,
        page: page,
        limit: limit,
      );
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<void> loadProduct(String productId) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _selectedProduct = await _productRepository.getProduct(productId);
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<void> loadCompany(String companyId) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      _selectedCompany = await _productRepository.getCompany(companyId);
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<ProductModel> createProduct(Map<String, dynamic> productData) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      final product = await _productRepository.createProduct(productData);
      _products.insert(0, product);
      _isLoading = false;
      _safeNotifyListeners();
      return product;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  Future<ProductModel> updateProduct(String productId, Map<String, dynamic> updateData) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      final product = await _productRepository.updateProduct(productId, updateData);
      
      // Update local state
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = product;
      }
      
      if (_selectedProduct?.id == productId) {
        _selectedProduct = product;
      }
      
      _isLoading = false;
      _safeNotifyListeners();
      return product;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      await _productRepository.deleteProduct(productId);
      
      // Remove from local state
      _products.removeWhere((p) => p.id == productId);
      if (_selectedProduct?.id == productId) {
        _selectedProduct = null;
      }
      
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<void> updateStock(String productId, int quantity, String action) async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      await _productRepository.updateStock(productId, quantity, action);
      
      // Update local state by reloading the product
      await loadProduct(productId);
      
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<Map<String, dynamic>> getProductStats() async {
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      final stats = await _productRepository.getProductStats();
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

  void setSearchQuery(String query) {
    _searchQuery = query;
    _safeNotifyListeners();
  }

  void setSelectedProduct(ProductModel product) {
    _selectedProduct = product;
    _safeNotifyListeners();
  }

  void setSelectedCompany(CompanyModel company) {
    _selectedCompany = company;
    _safeNotifyListeners();
  }

  void clearError() {
    _error = '';
    _safeNotifyListeners();
  }

  void clearProducts() {
    _products = [];
    _safeNotifyListeners();
  }

  void clearCompanies() {
    _companies = [];
    _safeNotifyListeners();
  }

  void clearSelection() {
    _selectedProduct = null;
    _selectedCompany = null;
    _safeNotifyListeners();
  }

  // دالة مساعدة للتحقق من التحميل المزدوج
  void _safeNotifyListeners() {
    if (!_isLoading) {
      // استخدام Future.microtask لتأجيل notifyListeners حتى انتهاء البناء
      Future.microtask(() {
        if (!_isDisposed) {
          notifyListeners();
        }
      });
    }
  }

  // إضافة خاصية لتتبع إذا كان الـ provider مغلق
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // دوال مساعدة للبحث والتصفية
  // List<ProductModel> get filteredProducts {
  //   if (_searchQuery.isEmpty) return _products;
    
  //   return _products.where((product) {
  //     return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
  //            product.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
  //   }).toList();
  // }

  List<CompanyModel> get filteredCompanies {
    if (_searchQuery.isEmpty) return _companies;
    
    return _companies.where((company) {
      return company.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             company.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
    }).toList();
  }

  // دوال للحصول على منتجات أو شركات محددة
  // List<ProductModel> getProductsByCompany(String companyId) {
  //   return _products.where((product) => product.companyId == companyId).toList();
  // }

  List<ProductModel> getAvailableProducts() {
    return _products.where((product) => product.status == 'available').toList();
  }

  // List<CompanyModel> getVerifiedCompanies() {
  //   return _companies.where((company) => company.isVerified).toList();
  // }

  // دالة لإعادة تعيين الحالة
  void reset() {
    _products = [];
    _companies = [];
    _selectedProduct = null;
    _selectedCompany = null;
    _isLoading = false;
    _error = '';
    _searchQuery = '';
    _safeNotifyListeners();
  }
}