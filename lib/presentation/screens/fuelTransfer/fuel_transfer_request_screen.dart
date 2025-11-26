// screens/fuel_transfer/fuel_transfer_request_screen.dart
import 'dart:io';
import 'package:customer/core/services/payment_service.dart';
import 'package:customer/data/models/address_model.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:customer/presentation/providers/fuel_transfer_provider.dart';
import 'package:customer/presentation/screens/payment/stripe_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:customer/data/models/fuel_transfer_model.dart';
import 'package:customer/presentation/screens/fuelTransfer/fuel_transfer_orders_screen.dart';

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

  final List<String> _companies = ['إنرجكس', 'نهل', 'بيتروجين'];

  final Map<String, double> _fuelPrices = {
    'إنرجكس': 2.18,
    'نهل': 2.25,
    'بيتروجين': 2.32,
  };

  @override
  void initState() {
    super.initState();
    // تحميل العناوين عند بدء التشغيل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      addressProvider.loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        title: Text(
          'طلب نقل وقود',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
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
            tooltip: 'طلبات النقل',
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
        child: _buildContent(addressProvider),
      ),
    );
  }

  Widget _buildContent(AddressProvider addressProvider) {
    if (_currentStep == 0) {
      return _buildInitialScreen();
    } else {
      return _buildRequestForm(addressProvider);
    }
  }

  Widget _buildInitialScreen() {
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
            'خدمة نقل الوقود',
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
              'نقدم لكم خدمة نقل الوقود بأسعار تنافسية وخدمة سريعة من محطات أرامكو',
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
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
                  'تقديم طلب نقل',
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
              text: 'تتبع الطلب',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuelTransferOrdersScreen(),
                  ),
                );
              },
              color: Colors.green,
            ),
            SizedBox(width: 16),
            
            // زر طلبات النقل
            _buildQuickActionButton(
              icon: Icons.list_alt,
              text: 'طلبات النقل',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuelTransferOrdersScreen(),
                  ),
                );
              },
              color: Colors.orange,
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

  Widget _buildRequestForm(AddressProvider addressProvider) {
    return Column(
      children: [
        _buildProgressIndicator(),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                if (_currentStep == 1) _buildAramcoStep(),
                if (_currentStep == 2) _buildCompanySelectionStep(),
                if (_currentStep == 3) _buildInvoiceUploadStep(),
                if (_currentStep == 4) _buildPriceAndLocationStep(addressProvider),
                
                const SizedBox(height: 40),
                
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
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
                  _getStepTitle(index),
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

  String _getStepTitle(int index) {
    switch (index) {
      case 0: return 'أرامكو';
      case 1: return 'الشركة';
      case 2: return 'الفاتورة';
      case 3: return 'السعر والموقع';
      default: return '';
    }
  }

  Widget _buildAramcoStep() {
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
              'طلب التعبئة من أرامكو',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'سيتم توجيه طلبك لمحطات أرامكو للتعبئة\nيرجى التأكد من توفر المستندات المطلوبة',
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
                      'متابعة لاختيار الشركة',
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

  Widget _buildCompanySelectionStep() {
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
                      'اختر شركة الوقود',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ..._companies.map((company) => _buildCompanyCard(company)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyCard(String company) {
    bool isSelected = _selectedCompany == company;
    double price = _fuelPrices[company] ?? 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCompany = company;
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
                        company,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'سعر اللتر: ${price.toStringAsFixed(2)} ريال',
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

  Widget _buildInvoiceUploadStep() {
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
                  'رفع الفاتورة',
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
                    _uploadedFile == null ? 'ارفق فاتورة أرامكو أو ما يثبت الطلب' : 'تم رفع الملف بنجاح',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'PDF, JPG, PNG - الحد الأقصى 10MB',
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
                        text: 'المعرض',
                        onPressed: _pickImageFromGallery,
                        color: Color(0xFF7986CB),
                      ),
                      SizedBox(width: 12),
                      _buildUploadButton(
                        icon: Icons.camera_alt,
                        text: 'الكاميرا',
                        onPressed: _pickImageFromCamera,
                        color: Colors.green,
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
                      child: Text('إزالة الملف'),
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

  Widget _buildPriceAndLocationStep(AddressProvider addressProvider) {
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
                      'تفاصيل السعر',
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
                        'كمية الوقود (لتر)',
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
                            hintText: 'أدخل الكمية المطلوبة',
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
                        _buildPriceRow('سعر اللتر', '${pricePerLiter.toStringAsFixed(2)} ريال'),
                        _buildPriceRow('الكمية', '${quantity.toStringAsFixed(0)} لتر'),
                        _buildPriceRow('السعر الإجمالي', '${totalPrice.toStringAsFixed(2)} ريال'),
                        _buildPriceRow('رسوم التوصيل', '${deliveryFee.toStringAsFixed(2)} ريال'),
                        _buildPriceRow('الضريبة (15%)', '${vat.toStringAsFixed(2)} ريال'),
                        Divider(color: Colors.white.withOpacity(0.3)),
                        _buildPriceRow(
                          'المبلغ الإجمالي',
                          '${grandTotal.toStringAsFixed(2)} ريال',
                          isTotal: true,
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
                      'موقع التوصيل',
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
                  _buildNoAddressesState(),
                ] else ...[
                  _buildAddressesList(addressProvider),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoAddressesState() {
    return Column(
      children: [
        Icon(Icons.location_off, size: 60, color: Colors.white70),
        SizedBox(height: 16),
        Text(
          'لا توجد عناوين',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'يجب إضافة عنوان لتوصيل الوقود',
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
              _showAddAddressMessage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            child: Text('إضافة عنوان جديد'),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressesList(AddressProvider addressProvider) {
    return Column(
      children: [
        ...addressProvider.addresses.map((address) {
          return _buildAddressCard(address, addressProvider);
        }),
      ],
    );
  }

  Widget _buildAddressCard(AddressModel address, AddressProvider addressProvider) {
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
                            'افتراضي',
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

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
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

  Widget _buildNavigationButtons() {
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
                  'السابق',
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
                  _submitRequest();
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
              child: _buildButtonContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonContent() {
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
            'جاري المعالجة...',
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
            'الدفع عبر Stripe',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Text(
        'التالي',
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

  Future<void> _submitRequest() async {
    if (!_validatePaymentData()) return;

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
                      'تم إنشاء الطلب والدفع بنجاح',
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
          _showError('تم إلغاء عملية الدفع');
        }
      } else {
        print('❌ فشل في إنشاء الطلب: ${provider.error}');
        _showError(provider.error ?? 'فشل في إنشاء الطلب - تأكد من اتصال الإنترنت');
      }
    } catch (e) {
      print('❌ خطأ غير متوقع: $e');
      _showError('حدث خطأ غير متوقع: $e');
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

  void _showError(String message) {
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

  void _showAddAddressMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم إضافة شاشة إضافة العناوين قريباً', style: GoogleFonts.cairo()),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );
  }

  bool _validatePaymentData() {
    if (_selectedCompany == null) {
      _showError('يرجى اختيار شركة الوقود');
      return false;
    }
    
    if (_quantityController.text.isEmpty || double.tryParse(_quantityController.text) == null) {
      _showError('يرجى إدخال كمية صحيحة');
      return false;
    }
    
    double quantity = double.parse(_quantityController.text);
    if (quantity <= 0) {
      _showError('يجب أن تكون الكمية أكبر من الصفر');
      return false;
    }
    
    if (_selectedAddress == null) {
      _showError('يرجى اختيار عنوان التوصيل');
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
      _showError('فشل في اختيار الصورة: $e');
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
      _showError('فشل في التقاط الصورة: $e');
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}

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