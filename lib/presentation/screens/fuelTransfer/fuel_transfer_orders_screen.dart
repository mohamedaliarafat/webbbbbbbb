// screens/fuel_transfer/fuel_transfer_orders_screen.dart (محدث ومصحح)
import 'package:customer/presentation/providers/fuel_transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer/data/models/fuel_transfer_model.dart';
import 'package:customer/presentation/screens/fuelTransfer/fuel_transfer_request_screen.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'طلبات نقل الوقود',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FuelTransferRequestScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Consumer<FuelTransferProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.orders.isEmpty) {
            return _buildLoading();
          }

          if (provider.error != null) {
            return _buildError(provider.error!, provider);
          }

          return Column(
            children: [
              _buildFilterButtons(provider),
              Expanded(child: _buildOrdersList(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterButtons(FuelTransferProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            _buildFilterChip('الكل', 'all', provider),
            _buildFilterChip('قيد المراجعة', 'pending', provider),
            _buildFilterChip('تم الموافقة', 'approved', provider),
            _buildFilterChip('قيد التوصيل', 'out_for_delivery', provider),
            _buildFilterChip('مكتمل', 'completed', provider),
            _buildFilterChip('ملغي', 'cancelled', provider),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, FuelTransferProvider provider) {
    final isSelected = _selectedFilter == value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
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

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'جاري تحميل الطلبات...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, FuelTransferProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          const Text(
            'حدث خطأ',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadOrders,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(FuelTransferProvider provider) {
    if (provider.orders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      backgroundColor: Colors.black,
      color: Colors.blue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.orders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(provider.orders[index], provider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
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
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'لا توجد طلبات',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'انقر على أيقونة + لإنشاء طلب جديد',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(FuelTransferRequest order, FuelTransferProvider provider) {
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.company,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'رقم الطلب: #${order.id}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status as String).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getStatusColor(order.status as String)),
                    ),
                    child: Text(
                      _getStatusText(order.status as String),
                      style: TextStyle(
                        color: _getStatusColor(order.status as String),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Order Details
              _buildOrderDetailRow('الكمية', '${order.quantity} لتر'),
              if (order.totalAmount > 0)
                _buildOrderDetailRow('المبلغ', '${order.totalAmount.toStringAsFixed(2)} ريال'),
              _buildOrderDetailRow('طريقة الدفع', order.paymentMethod),
              _buildOrderDetailRow('موقع التوصيل', order.deliveryLocation),
              _buildOrderDetailRow('تاريخ الطلب', _formatDate(order.createdAt)),
              
              if (order.rejectionReason != null && order.rejectionReason!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildOrderDetailRow('سبب الرفض', order.rejectionReason!),
              ],
              
              const SizedBox(height: 16),
              
              // Actions
              if (_canBeCancelled(order.status as String))
                _buildCancelButton(order, provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(FuelTransferRequest order, FuelTransferProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showCancelDialog(order, provider),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text('إلغاء الطلب'),
      ),
    );
  }

  void _showCancelDialog(FuelTransferRequest order, FuelTransferProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'إلغاء الطلب',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هل أنت متأكد من إلغاء هذا الطلب؟',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'تراجع',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.cancelOrder(order.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إلغاء الطلب بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadOrders();
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.error ?? 'فشل في إلغاء الطلب'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'تأكيد الإلغاء', 
              style: TextStyle(color: Colors.red)
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // دوال مساعدة للحالة
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'out_for_delivery':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد المراجعة';
      case 'approved':
        return 'تم الموافقة';
      case 'out_for_delivery':
        return 'قيد التوصيل';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }

  bool _canBeCancelled(String status) {
    return status == 'pending' || status == 'approved';
  }
}