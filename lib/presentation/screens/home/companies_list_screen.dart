
import 'package:customer/data/models/company_model.dart';
import 'package:customer/presentation/providers/company_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CompaniesListScreen extends StatefulWidget {
  @override
  _CompaniesListScreenState createState() => _CompaniesListScreenState();
}

class _CompaniesListScreenState extends State<CompaniesListScreen> {
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'fuel_supplier', 'logistics', 'services'];

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  void _loadCompanies() {
    final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
    companyProvider.loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('الشركات'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: FilterChip(
                    label: Text(_getFilterText(filter)),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _filterCompanies(companyProvider, filter);
                    },
                  ),
                );
              },
            ),
          ),

          // Companies List
          Expanded(
            child: companyProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : companyProvider.companies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.business, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'لا توجد شركات',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: companyProvider.companies.length,
                        itemBuilder: (context, index) {
                          final company = companyProvider.companies[index];
                          return _buildCompanyCard(company);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(CompanyModel company) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/company-details',
            arguments: company.id,
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Company Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(company.images.logo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Company Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      company.commercialName,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(company.rating.toStringAsFixed(1)),
                        SizedBox(width: 16),
                        Icon(Icons.location_on, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(company.location.city),
                      ],
                    ),
                  ],
                ),
              ),

              // Verification Badge
              if (company.verification == 'Verified')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 12, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'موثوق',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterText(String filter) {
    switch (filter) {
      case 'all':
        return 'الكل';
      case 'fuel_supplier':
        return 'موردو وقود';
      case 'logistics':
        return 'الخدمات اللوجستية';
      case 'services':
        return 'الخدمات';
      default:
        return filter;
    }
  }

  void _filterCompanies(CompanyProvider companyProvider, String filter) {
    if (filter == 'all') {
      companyProvider.loadCompanies();
    } else {
      companyProvider.loadCompanies(companyType: filter);
    }
  }
}