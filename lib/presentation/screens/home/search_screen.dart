import 'package:customer/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategory = 0;

  final List<String> _categories = [
    'الكل',
    'بنزين',
    'ديزل',
    'كيروسين',
    'منتجات أخرى'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // final companyProvider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('البحث'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج أو شركة...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: _selectedCategory == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),

          // Search Results
          // Expanded(
          //   child: _buildSearchResults(productProvider, companyProvider),
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ProductProvider productProvider,  companyProvider) {
    if (_searchQuery.isEmpty) {
      return _buildRecentSearches();
    }

    final filteredProducts = productProvider.products.where((product) {
      final matchesSearch = product.productType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 0 || 
          product.productType == _categories[_selectedCategory];
      
      return matchesSearch && matchesCategory;
    }).toList();

    final filteredCompanies = companyProvider.companies.where((company) {
      return company.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          company.commercialName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return ListView(
      children: [
        if (filteredProducts.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'المنتجات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...filteredProducts.map((product) {
            return ListTile(
              leading: Image.network(
                product.images.main,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product.productType),
              subtitle: Text('${product.price.current} ر.س'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/product-details',
                  arguments: product.id,
                );
              },
            );
          }),
        ],

        if (filteredCompanies.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'الشركات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...filteredCompanies.map((company) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(company.images.logo),
              ),
              title: Text(company.name),
              subtitle: Text(company.commercialName),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/company-details',
                  arguments: company.id,
                );
              },
            );
          }),
        ],

        if (filteredProducts.isEmpty && filteredCompanies.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد نتائج',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRecentSearches() {
    // TODO: Load recent searches from local storage
    final recentSearches = ['بنزين 95', 'ديزل', 'شركة الوقود الوطنية'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'عمليات البحث الأخيرة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.history),
                title: Text(recentSearches[index]),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    // TODO: Remove from recent searches
                  },
                ),
                onTap: () {
                  _searchController.text = recentSearches[index];
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}