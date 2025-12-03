import 'package:customer/data/models/fuel_transfer_model.dart';
import 'package:customer/presentation/providers/fuel_transfer_provider.dart';
import 'package:customer/presentation/providers/language_provider.dart';
import 'package:customer/presentation/screens/fuelTransfer/fuel_transfer_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FuelTransferOrdersScreen extends StatefulWidget {
  const FuelTransferOrdersScreen({super.key});

  @override
  State<FuelTransferOrdersScreen> createState() => _FuelTransferOrdersScreenState();
}

class _FuelTransferOrdersScreenState extends State<FuelTransferOrdersScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    final provider = context.read<FuelTransferProvider>();
    await provider.fetchMyRequests(
      status: _selectedFilter == 'all' ? null : _selectedFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Directionality(
      textDirection: languageProvider.textDirection,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
  backgroundColor: Colors.black,
  elevation: 0,
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
  title: Text(
    languageProvider.translate('fuel_transfer_orders'),
    style: GoogleFonts.cairo(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
  actions: [
    _buildLanguageButton(languageProvider),
    const SizedBox(width: 8),
    IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FuelTransferRequestScreen(),
          ),
        );
      },
      icon: Icon(Icons.add, color: Colors.white),
      tooltip: languageProvider.translate('add_new_order'),
    ),
    const SizedBox(width: 16),
  ],
),

        body: Consumer<FuelTransferProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.orders.isEmpty) {
              return _buildLoading(languageProvider);
            }

            if (provider.error != null) {
              return _buildError(provider.error!, provider, languageProvider);
            }

            return Column(
              children: [
                _buildFilterButtons(languageProvider, provider),
                Expanded(child: _buildOrdersList(provider, languageProvider)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageButton(LanguageProvider languageProvider) {
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
  }

  Widget _buildFilterButtons(LanguageProvider languageProvider, FuelTransferProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            _buildFilterChip(languageProvider.translate('all_orders'), 'all', languageProvider, provider),
            _buildFilterChip(languageProvider.translate('pending_review'), 'pending', languageProvider, provider),
            _buildFilterChip(languageProvider.translate('approved'), 'approved', languageProvider, provider),
            _buildFilterChip(languageProvider.translate('out_for_delivery'), 'out_for_delivery', languageProvider, provider),
            _buildFilterChip(languageProvider.translate('completed'), 'completed', languageProvider, provider),
            _buildFilterChip(languageProvider.translate('cancelled'), 'cancelled', languageProvider, provider),
            _buildFilterChip(languageProvider.translate('rejected'), 'rejected', languageProvider, provider),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, LanguageProvider languageProvider, FuelTransferProvider provider) {
    final isSelected = _selectedFilter == value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.cairo(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
          _loadOrders();
        },
        backgroundColor: Colors.grey[800],
        selectedColor: Colors.blue,
      ),
    );
  }

  Widget _buildLoading(LanguageProvider languageProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue),
          const SizedBox(height: 16),
          Text(
            languageProvider.translate('loading_orders'),
            style: GoogleFonts.cairo(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, FuelTransferProvider provider, LanguageProvider languageProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 64),
            SizedBox(height: 16),
            Text(
              languageProvider.translate('error_occurred'),
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error,
                style: GoogleFonts.cairo(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrders,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                languageProvider.translate('retry'),
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(FuelTransferProvider provider, LanguageProvider languageProvider) {
    if (provider.orders.isEmpty) {
      return _buildEmptyState(languageProvider);
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      backgroundColor: Colors.black,
      color: Colors.blue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.orders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(provider.orders[index], provider, languageProvider);
        },
      ),
    );
  }

  Widget _buildEmptyState(LanguageProvider languageProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          Text(
            languageProvider.translate('no_orders'),
            style: GoogleFonts.cairo(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            languageProvider.translate('click_plus_to_create'),
            style: GoogleFonts.cairo(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(FuelTransferRequest order, FuelTransferProvider provider, LanguageProvider languageProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.company,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${languageProvider.translate('order_number')}: #${order.id}',
                          style: GoogleFonts.cairo(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: order.statusColor),
                    ),
                    child: Text(
                      order.statusText,
                      style: GoogleFonts.cairo(
                        color: order.statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Order Details
              _buildOrderDetailRow(
                languageProvider.translate('quantity'), 
                '${order.quantity} ${languageProvider.translate('liters')}',
                languageProvider,
              ),
              if (order.totalAmount > 0)
                _buildOrderDetailRow(
                  languageProvider.translate('amount'), 
                  '${order.totalAmount.toStringAsFixed(2)} ${languageProvider.translate('sar')}',
                  languageProvider,
                ),
              _buildOrderDetailRow(
                languageProvider.translate('payment_method'), 
                order.paymentMethod,
                languageProvider,
              ),
              _buildOrderDetailRow(
                languageProvider.translate('delivery_location'), 
                order.deliveryLocation,
                languageProvider,
              ),
              _buildOrderDetailRow(
                languageProvider.translate('order_date'), 
                _formatDate(order.createdAt),
                languageProvider,
              ),
              
              if (order.rejectionReason != null && order.rejectionReason!.isNotEmpty) ...[
                SizedBox(height: 8),
                _buildOrderDetailRow(
                  languageProvider.translate('rejection_reason'), 
                  order.rejectionReason!,
                  languageProvider,
                ),
              ],
              
              SizedBox(height: 16),
              
              // Actions
              if (order.canBeCancelled)
                _buildCancelButton(order, provider, languageProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value, LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(FuelTransferRequest order, FuelTransferProvider provider, LanguageProvider languageProvider) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showCancelDialog(order, provider, languageProvider),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          languageProvider.translate('cancel_order'),
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(FuelTransferRequest order, FuelTransferProvider provider, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: languageProvider.textDirection,
        child: AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            languageProvider.translate('cancel_order'),
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            languageProvider.translate('cancel_order_confirmation'),
            style: GoogleFonts.cairo(
              color: Colors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                languageProvider.translate('go_back'),
                style: GoogleFonts.cairo(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await provider.cancelOrder(order.id);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        languageProvider.translate('order_cancelled_success'),
                        style: GoogleFonts.cairo(),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  _loadOrders();
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.error ?? languageProvider.translate('order_cancelled_failed'),
                        style: GoogleFonts.cairo(),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                languageProvider.translate('confirm_cancellation'),
                style: GoogleFonts.cairo(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 String _formatDate(DateTime date) {
  try {
    final format = DateFormat('dd/MM/yyyy HH:mm', 'ar');
    return format.format(date);
  } catch (e) {
    debugPrint('Date format error: $e');
    return date.toString(); // fallback
  }
}

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return LanguageSelectionDialog(languageProvider: languageProvider);
      },
    );
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
                  languageProvider.translate('language'),
                  style: GoogleFonts.cairo(
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
                        ? Color(0xFF64B5F6).withOpacity(0.2)
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
                  style: GoogleFonts.cairo(
                    color: isSelected ? Color(0xFF64B5F6) : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Color(0xFF64B5F6))
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
