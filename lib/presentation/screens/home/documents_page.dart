import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحكم'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Statistics Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: [
                _buildStatCard(
                  'إجمالي طلبات الوقود',
                  '${orderProvider.totalFuelOrdersCount}',
                  Icons.local_gas_station,
                  Colors.green,
                ),
                _buildStatCard(
                  'طلبات قيد الانتظار',
                  '${orderProvider.pendingFuelOrdersCount}',
                  Icons.pending,
                  Colors.orange,
                ),
                _buildStatCard(
                  'طلبات مكتملة',
                  '${orderProvider.completedFuelOrdersCount}',
                  Icons.check_circle,
                  Colors.blue,
                ),
                _buildStatCard(
                  'المنتجات المتاحة',
                  '${productProvider.products.length}',
                  Icons.inventory,
                  Colors.purple,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Quick Actions
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإجراءات السريعة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildQuickAction(
                          'طلب وقود جديد',
                          Icons.local_gas_station,
                          Colors.green,
                          () => Navigator.pushNamed(context, '/fuel-order'),
                        ),
                        _buildQuickAction(
                          'عرض المنتجات',
                          Icons.shopping_basket,
                          Colors.blue,
                          () => Navigator.pushNamed(context, '/products'),
                        ),
                        _buildQuickAction(
                          'إدارة طلبات الوقود',
                          Icons.list_alt,
                          Colors.orange,
                          () => Navigator.pushNamed(context, '/fuel-orders'),
                        ),
                        _buildQuickAction(
                          'إضافة عنوان',
                          Icons.location_on,
                          Colors.purple,
                          () => Navigator.pushNamed(context, '/add-address'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Recent Fuel Orders
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'طلبات الوقود الحديثة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/fuel-orders'),
                          child: Text('عرض الكل'),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    _buildFuelOrdersList(orderProvider),
                  ],
                ),
              ),
            ),

            // Fuel Type Statistics
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إحصائيات أنواع الوقود',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    _buildFuelTypeStats(orderProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelOrdersList(OrderProvider orderProvider) {
    final recentFuelOrders = orderProvider.fuelOrders.take(5).toList();

    if (recentFuelOrders.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.local_gas_station, size: 50, color: Colors.grey[300]),
            SizedBox(height: 10),
            Text(
              'لا توجد طلبات وقود حديثة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: recentFuelOrders.map((order) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getOrderColor(order.status).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getOrderIcon(order.status),
                size: 20,
                color: _getOrderColor(order.status),
              ),
            ),
            title: Text(
              'طلب وقود #${order.orderNumber}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${order.fuelTypeName ?? order.fuelType} - ${order.fuelLiters} لتر'),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getOrderColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getStatusText(order.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getOrderColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${order.pricing.finalPrice} ر.س',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _formatDate(order.createdAt),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              // TODO: Navigate to fuel order details
              // Navigator.pushNamed(
              //   context,
              //   '/fuel-order-details',
              //   arguments: order.id,
              // );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFuelTypeStats(OrderProvider orderProvider) {
    final stats = orderProvider.fuelTypeStats;
    
    if (stats.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'لا توجد إحصائيات متاحة',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: stats.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  _getFuelTypeName(entry.key),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${entry.value} طلب',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Expanded(
                flex: 3,
                child: LinearProgressIndicator(
                  value: entry.value / orderProvider.totalFuelOrdersCount,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_getFuelTypeColor(entry.key)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getFuelTypeName(String fuelType) {
    switch (fuelType) {
      case '91':
        return 'بنزين 91';
      case '95':
        return 'بنزين 95';
      case 'diesel':
        return 'ديزل';
      case 'كيروسين':
        return 'كيروسين';
      default:
        return fuelType;
    }
  }

  Color _getFuelTypeColor(String fuelType) {
    switch (fuelType) {
      case '91':
        return Colors.blue;
      case '95':
        return Colors.green;
      case 'diesel':
        return Colors.orange;
      case 'كيروسين':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getOrderIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'approved':
        return Icons.thumb_up;
      case 'in_progress':
        return Icons.local_shipping;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.local_gas_station;
    }
  }

  Color _getOrderColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'معتمد';
      case 'in_progress':
        return 'قيد التوصيل';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}