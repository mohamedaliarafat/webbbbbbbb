import 'dart:io';
import 'package:customer/data/models/address_model.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:customer/presentation/providers/fuel_transfer_provider.dart';
import 'package:customer/presentation/providers/language_provider.dart';
import 'package:customer/presentation/screens/fuelTransfer/fuel_transfer_orders_screen.dart';
import 'package:customer/presentation/screens/payment/stripe_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FuelTransferRequestScreen extends StatefulWidget {
  const FuelTransferRequestScreen({super.key});

  @override
  State<FuelTransferRequestScreen> createState() => _FuelTransferRequestScreenState();
}

class _FuelTransferRequestScreenState extends State<FuelTransferRequestScreen> {
  int _currentStep = 0;
  String? _selectedCompany;
  final TextEditingController _quantityController = TextEditingController();
  File? _uploadedFile;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  AddressModel? _selectedAddress;

  final Map<String, double> _fuelPrices = {
    'energex': 2.18,
    'nahal': 2.25,
    'petrogen': 2.32,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      addressProvider.loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Directionality(
      textDirection: languageProvider.textDirection,
      child: Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        appBar: AppBar(
          backgroundColor: Color(0xFF1A237E),
          title: Text(
            languageProvider.translate('fuel_transfer_request'),
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 0,
           leading: IconButton(
    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
          actions: [
            // أيقونة تغيير اللغة
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return GestureDetector(
                  onTap: () => _showLanguageDialog(context, languageProvider),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Center(
                      child: Text(
                        languageProvider.getCurrentLanguageFlag(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
            // أيقونة طلبات النقل
            IconButton(
              icon: Icon(Icons.list_alt, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuelTransferOrdersScreen(),
                  ),
                );
              },
              tooltip: languageProvider.translate('transfer_orders'),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A237E),
                Color(0xFF283593),
                Color(0xFF303F9F),
              ],
            ),
          ),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (_currentStep == 0) {
      return _buildInitialScreen(languageProvider);
    } else {
      return _buildRequestForm(addressProvider, languageProvider);
    }
  }

  Widget _buildInitialScreen(LanguageProvider languageProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF283593),
            Color(0xFF303F9F),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة رئيسية
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              Icons.local_gas_station,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          
          Text(
            languageProvider.translate('fuel_transfer_service'),
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              languageProvider.translate('service_description'),
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          
          // أزرار الإجراءات السريعة
          _buildQuickActions(languageProvider),
        ],
      ),
    );
  }

  Widget _buildQuickActions(LanguageProvider languageProvider) {
    return Column(
      children: [
        // زر تقديم طلب نقل
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7986CB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              shadowColor: Colors.blue.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 24),
                SizedBox(width: 12),
                Text(
                  languageProvider.translate('submit_transfer_request'),
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        
        // أزرار إضافية
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر تتبع الطلبات
            _buildQuickActionButton(
              icon: Icons.track_changes,
              text: languageProvider.translate('track_order'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuelTransferOrdersScreen(),
                  ),
                );
              },
              color: Colors.green,
              languageProvider: languageProvider,
            ),
            SizedBox(width: 16),
            
            // زر طلبات النقل
            _buildQuickActionButton(
              icon: Icons.list_alt,
              text: languageProvider.translate('transfer_orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuelTransferOrdersScreen(),
                  ),
                );
              },
              color: Colors.orange,
              languageProvider: languageProvider,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
    required LanguageProvider languageProvider,
  }) {
    return Container(
      width: 140,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.2),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.3)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestForm(AddressProvider addressProvider, LanguageProvider languageProvider) {
    return Column(
      children: [
        _buildProgressIndicator(languageProvider),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                if (_currentStep == 1) _buildAramcoStep(languageProvider),
                if (_currentStep == 2) _buildCompanySelectionStep(languageProvider),
                if (_currentStep == 3) _buildInvoiceUploadStep(languageProvider),
                if (_currentStep == 4) _buildPriceAndLocationStep(addressProvider, languageProvider),
                
                const SizedBox(height: 40),
                
                _buildNavigationButtons(languageProvider),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(LanguageProvider languageProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A237E),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          bool isActive = index < _currentStep;
          bool isCurrent = index == _currentStep - 1;
          
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? Color(0xFF7986CB) : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getStepTitle(index, languageProvider),
                  style: GoogleFonts.cairo(
                    color: isCurrent ? Color(0xFF7986CB) : Colors.white70,
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getStepTitle(int index, LanguageProvider languageProvider) {
    switch (index) {
      case 0: return languageProvider.translate('step_aramex');
      case 1: return languageProvider.translate('step_company');
      case 2: return languageProvider.translate('step_invoice');
      case 3: return languageProvider.translate('step_price_location');
      default: return '';
    }
  }

  Widget _buildAramcoStep(LanguageProvider languageProvider) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_gas_station,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              languageProvider.translate('aramex_filling_request'),
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              languageProvider.translate('aramex_description'),
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward),
                    SizedBox(width: 8),
                    Text(
                      languageProvider.translate('continue_to_company'),
                      style: GoogleFonts.cairo(fontSize: 16),
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

  Widget _buildCompanySelectionStep(LanguageProvider languageProvider) {
    return Column(
      children: [
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.business, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 12),
                    Text(
                      languageProvider.translate('select_fuel_company'),
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ..._getCompanies(languageProvider).map((company) => _buildCompanyCard(company, languageProvider)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getCompanies(LanguageProvider languageProvider) {
    return [
      {'id': 'energex', 'name': languageProvider.translate('energex')},
      {'id': 'nahal', 'name': languageProvider.translate('nahal')},
      {'id': 'petrogen', 'name': languageProvider.translate('petrogen')},
    ];
  }

  Widget _buildCompanyCard(Map<String, dynamic> company, LanguageProvider languageProvider) {
    bool isSelected = _selectedCompany == company['id'];
    double price = _fuelPrices[company['id']] ?? 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCompany = company['id'];
            });
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF7986CB).withOpacity(0.2) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Color(0xFF7986CB) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF7986CB) : Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected ? Icons.check : Icons.business,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company['name'],
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${languageProvider.translate('price_per_liter')}: ${price.toStringAsFixed(2)} ${languageProvider.translate('sar')}',
                        style: GoogleFonts.cairo(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceUploadStep(LanguageProvider languageProvider) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.receipt_long, color: Colors.white, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  languageProvider.translate('upload_invoice'),
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _uploadedFile == null ? Icons.cloud_upload : Icons.check_circle,
                    size: 60,
                    color: _uploadedFile == null ? Color(0xFF7986CB) : Colors.green,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _uploadedFile == null 
                      ? languageProvider.translate('upload_document_here')
                      : languageProvider.translate('file_uploaded_success'),
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    languageProvider.translate('supported_formats'),
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildUploadButton(
                        icon: Icons.photo_library,
                        text: languageProvider.translate('gallery'),
                        onPressed: _pickImageFromGallery,
                        color: Color(0xFF7986CB),
                        languageProvider: languageProvider,
                      ),
                      SizedBox(width: 12),
                      _buildUploadButton(
                        icon: Icons.camera_alt,
                        text: languageProvider.translate('camera'),
                        onPressed: _pickImageFromCamera,
                        color: Colors.green,
                        languageProvider: languageProvider,
                      ),
                    ],
                  ),
                  if (_uploadedFile != null) ...[
                    SizedBox(height: 16),
                    Text(
                      _uploadedFile!.path.split('/').last,
                      style: GoogleFonts.cairo(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _uploadedFile = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text(languageProvider.translate('remove_file')),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required LanguageProvider languageProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.cairo(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndLocationStep(AddressProvider addressProvider, LanguageProvider languageProvider) {
    if (_selectedCompany == null) return SizedBox();
    
    double pricePerLiter = _fuelPrices[_selectedCompany!] ?? 0.0;
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    double totalPrice = pricePerLiter * quantity;
    double deliveryFee = 25.0;
    double vat = totalPrice * 0.15;
    double grandTotal = totalPrice + deliveryFee + vat;

    return Column(
      children: [
        // Price Display
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.attach_money, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 12),
                    Text(
                      languageProvider.translate('price_details'),
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // Quantity Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.translate('fuel_quantity'),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.cairo(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: languageProvider.translate('enter_quantity'),
                            hintStyle: GoogleFonts.cairo(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                if (quantity > 0) ...[
                  // Price Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow(
                          languageProvider.translate('price_per_liter'),
                          '${pricePerLiter.toStringAsFixed(2)} ${languageProvider.translate('sar')}',
                          languageProvider: languageProvider,
                        ),
                        _buildPriceRow(
                          languageProvider.translate('quantity'),
                          '${quantity.toStringAsFixed(0)} ${languageProvider.translate('liters')}',
                          languageProvider: languageProvider,
                        ),
                        _buildPriceRow(
                          languageProvider.translate('total_price'),
                          '${totalPrice.toStringAsFixed(2)} ${languageProvider.translate('sar')}',
                          languageProvider: languageProvider,
                        ),
                        _buildPriceRow(
                          languageProvider.translate('delivery_fee'),
                          '${deliveryFee.toStringAsFixed(2)} ${languageProvider.translate('sar')}',
                          languageProvider: languageProvider,
                        ),
                        _buildPriceRow(
                          languageProvider.translate('vat'),
                          '${vat.toStringAsFixed(2)} ${languageProvider.translate('sar')}',
                          languageProvider: languageProvider,
                        ),
                        Divider(color: Colors.white.withOpacity(0.3)),
                        _buildPriceRow(
                          languageProvider.translate('grand_total'),
                          '${grandTotal.toStringAsFixed(2)} ${languageProvider.translate('sar')}',
                          isTotal: true,
                          languageProvider: languageProvider,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: 20),

        // Location Selection
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.location_on, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 12),
                    Text(
                      languageProvider.translate('delivery_location'),
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                if (addressProvider.isLoading) ...[
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ] else if (addressProvider.addresses.isEmpty) ...[
                  _buildNoAddressesState(languageProvider),
                ] else ...[
                  _buildAddressesList(addressProvider, languageProvider),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoAddressesState(LanguageProvider languageProvider) {
    return Column(
      children: [
        Icon(Icons.location_off, size: 60, color: Colors.white70),
        SizedBox(height: 16),
        Text(
          languageProvider.translate('no_addresses'),
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          languageProvider.translate('add_address_message'),
          style: GoogleFonts.cairo(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            onPressed: () {
              _showAddAddressMessage(languageProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.translate('add_new_address')),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressesList(AddressProvider addressProvider, LanguageProvider languageProvider) {
    return Column(
      children: [
        ...addressProvider.addresses.map((address) {
          return _buildAddressCard(address, addressProvider, languageProvider);
        }),
      ],
    );
  }

  Widget _buildAddressCard(AddressModel address, AddressProvider addressProvider, LanguageProvider languageProvider) {
    final isSelected = _selectedAddress?.id == address.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF7986CB).withOpacity(0.2) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? Color(0xFF7986CB) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedAddress = address;
            });
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF7986CB) : Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getAddressTypeIcon(address.addressType),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.addressLine1,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (address.addressLine2.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          address.addressLine2,
                          style: GoogleFonts.cairo(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      SizedBox(height: 4),
                      Text(
                        '${address.district.isNotEmpty ? '${address.district}, ' : ''}${address.city}',
                        style: GoogleFonts.cairo(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      if (address.isDefault) ...[
                        SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            languageProvider.translate('default_address'),
                            style: GoogleFonts.cairo(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Color(0xFF7986CB) : Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getAddressTypeIcon(String addressType) {
    switch (addressType) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildPriceRow(String label, String value, {
    bool isTotal = false,
    required LanguageProvider languageProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              color: isTotal ? Colors.green : Colors.white,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: isTotal ? Colors.green : Colors.white,
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(LanguageProvider languageProvider) {
    return Row(
      children: [
        if (_currentStep > 1)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  languageProvider.translate('previous'),
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        if (_currentStep > 1) SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: _canProceedToNextStep() 
                  ? LinearGradient(
                      colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
                    )
                  : LinearGradient(
                      colors: [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.1)],
                    ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : (_canProceedToNextStep() ? () {
                if (_currentStep < 4) {
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  _submitRequest(languageProvider);
                }
              } : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _buildButtonContent(languageProvider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonContent(LanguageProvider languageProvider) {
    if (_isSubmitting) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 8),
          Text(
            languageProvider.translate('processing'),
            style: GoogleFonts.cairo(),
          ),
        ],
      );
    }

    if (_currentStep == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payment, size: 20),
          SizedBox(width: 8),
          Text(
            languageProvider.translate('pay_with_stripe'),
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Text(
        languageProvider.translate('next'),
        style: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 1: return true; // Aramco step
      case 2: return _selectedCompany != null; // Company selection
      case 3: return _uploadedFile != null; // Invoice upload
      case 4: 
        double quantity = double.tryParse(_quantityController.text) ?? 0.0;
        return quantity > 0 && _selectedAddress != null;
      default: return false;
    }
  }

  Future<void> _submitRequest(LanguageProvider languageProvider) async {
    if (!_validatePaymentData(languageProvider)) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final provider = Provider.of<FuelTransferProvider>(context, listen: false);
      
      print('🔄 بدء إنشاء طلب نقل الوقود...');
      print('📦 البيانات المدخلة:');
      print('   - الشركة: $_selectedCompany');
      print('   - الكمية: ${_quantityController.text}');
      print('   - العنوان: ${_selectedAddress?.addressLine1}');
      
      // 1. إنشاء الطلب مع العنوان المختار
      final success = await provider.createRequest(
        company: _selectedCompany!,
        quantity: double.parse(_quantityController.text),
        paymentMethod: 'stripe',
        deliveryLocation: _buildDeliveryLocation(),
      );

      print('✅ نتيجة إنشاء الطلب: $success');
      print('🔍 خطأ Provider: ${provider.error}');
      print('🔍 الطلب الحالي: ${provider.currentRequest}');

      if (success && provider.currentRequest != null) {
        final order = provider.currentRequest!;
        print('🎉 تم إنشاء الطلب بنجاح: ${order.id}');
        
        // 2. رفع الفاتورة إذا كانت موجودة
        if (_uploadedFile != null) {
          print('📤 رفع الفاتورة...');
          await provider.uploadAramcoInvoice(order.id, _uploadedFile!);
        }

        // 3. الانتقال مباشرة لصفحة Stripe للدفع
        print('💳 الانتقال لصفحة الدفع...');
        final paymentSuccess = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StripePaymentScreen(
              amount: _calculateTotalAmount(),
              orderId: order.id,
              currency: 'SAR',
            ),
          ),
        );
        
        if (paymentSuccess == true) {
          print('✅ الدفع ناجح - تحديث حالة الطلب');
          // نجح الدفع - تحديث حالة الطلب
          await provider.updateOrderStatus(
            orderId: order.id,
            status: 'paid',
          );

          // الانتقال لشاشة الطلبات في حالة النجاح
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => FuelTransferOrdersScreen(),
              ),
              (route) => false,
            );
            
            // عرض رسالة نجاح
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      languageProvider.translate('request_created_success'),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          print('❌ تم إلغاء الدفع');
          _showError(languageProvider.translate('payment_cancelled'), languageProvider);
        }
      } else {
        print('❌ فشل في إنشاء الطلب: ${provider.error}');
        _showError('${languageProvider.translate('request_failed')} - ${languageProvider.translate('no_internet')}', languageProvider);
      }
    } catch (e) {
      print('❌ خطأ غير متوقع: $e');
      _showError('${languageProvider.translate('error')}: $e', languageProvider);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _buildDeliveryLocation() {
    if (_selectedAddress == null) return '';
    
    final address = _selectedAddress!;
    String location = address.addressLine1;
    
    if (address.addressLine2.isNotEmpty) {
      location += ' - ${address.addressLine2}';
    }
    
    if (address.district.isNotEmpty) {
      location += ' - ${address.district}';
    }
    
    if (address.city.isNotEmpty) {
      location += ' - ${address.city}';
    }
    
    return location;
  }

  double _calculateTotalAmount() {
    if (_selectedCompany == null || _quantityController.text.isEmpty) {
      return 0.0;
    }
    
    double pricePerLiter = _fuelPrices[_selectedCompany!] ?? 0.0;
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    
    if (quantity <= 0) {
      return 0.0;
    }
    
    double totalPrice = pricePerLiter * quantity;
    double deliveryFee = 25.0;
    double vat = totalPrice * 0.15;
    
    return double.parse((totalPrice + deliveryFee + vat).toStringAsFixed(2));
  }

  void _showError(String message, LanguageProvider languageProvider) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message, style: GoogleFonts.cairo())),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showAddAddressMessage(LanguageProvider languageProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(languageProvider.translate('feature_coming_soon'), style: GoogleFonts.cairo()),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );
  }

  bool _validatePaymentData(LanguageProvider languageProvider) {
    if (_selectedCompany == null) {
      _showError(languageProvider.translate('select_company_error'), languageProvider);
      return false;
    }
    
    if (_quantityController.text.isEmpty || double.tryParse(_quantityController.text) == null) {
      _showError(languageProvider.translate('enter_valid_quantity'), languageProvider);
      return false;
    }
    
    double quantity = double.parse(_quantityController.text);
    if (quantity <= 0) {
      _showError(languageProvider.translate('quantity_greater_than_zero'), languageProvider);
      return false;
    }
    
    if (_selectedAddress == null) {
      _showError(languageProvider.translate('select_delivery_address'), languageProvider);
      return false;
    }
    
    return true;
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (file != null) {
        setState(() {
          _uploadedFile = File(file.path);
        });
      }
    } catch (e) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      _showError('${languageProvider.translate('image_selection_failed')}: $e', languageProvider);
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (file != null) {
        setState(() {
          _uploadedFile = File(file.path);
        });
      }
    } catch (e) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      _showError('${languageProvider.translate('camera_failed')}: $e', languageProvider);
    }
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: languageProvider.textDirection,
          child: LanguageSelectionDialog(languageProvider: languageProvider),
        );
      },
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}

// ============ LanguageSelectionDialog ============
class LanguageSelectionDialog extends StatelessWidget {
  final LanguageProvider languageProvider;

  const LanguageSelectionDialog({
    Key? key,
    required this.languageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = languageProvider.getAvailableLanguages();

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageProvider.translate('change_language'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              final isSelected = languageProvider.locale.languageCode == lang['code'];
              
              return ListTile(
                onTap: () {
                  languageProvider.changeLanguage(lang['locale']);
                  Navigator.pop(context);
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected 
                        ? Color(0xFF7986CB).withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      lang['flag'],
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(
                  lang['name'],
                  style: TextStyle(
                    color: isSelected ? Color(0xFF7986CB) : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Color(0xFF7986CB))
                    : null,
              );
            },
          ),
          
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ============ GlassCard ============
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}