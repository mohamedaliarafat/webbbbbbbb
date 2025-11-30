

import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/presentation/widgets/order/order_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FuelOrdersListScreen extends StatefulWidget {
  @override
  _FuelOrdersListScreenState createState() => _FuelOrdersListScreenState();
}

class _FuelOrdersListScreenState extends State<FuelOrdersListScreen> {
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'pending', 'approved', 'in_progress', 'waiting_payment', 'completed', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _loadFuelOrders();
  }

  void _loadFuelOrders() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.loadFuelOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Color(0xFF1a1a1a).withOpacity(0.7),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: _selectedFilter == filter
                          ? LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.black.withOpacity(0.4),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.05),
                                Colors.white.withOpacity(0.02),
                              ],
                            ),
                      border: Border.all(
                        color: _selectedFilter == filter 
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                          _filterFuelOrders(orderProvider, filter);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            _getFilterText(filter),
                            style: GoogleFonts.cairo(
                              color: _selectedFilter == filter ? Colors.white : Colors.white70,
                              fontWeight: _selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Statistics Bar
          _buildGlassStatisticsBar(orderProvider),

          // Orders List
          Expanded(
            child: orderProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : orderProvider.fuelOrders.isEmpty
                    ? _buildEmptyState()
                    : _buildOrdersList(orderProvider),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.4),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/fuel');
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.local_gas_station, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildGlassStatisticsBar(OrderProvider orderProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildGlassStatItem('الإجمالي', '${orderProvider.totalFuelOrdersCount}'),
          _buildGlassStatItem('قيد الانتظار', '${orderProvider.pendingFuelOrdersCount}'),
          _buildGlassStatItem('مكتمل', '${orderProvider.completedFuelOrdersCount}'),
        ],
      ),
    );
  }

  Widget _buildGlassStatItem(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Icon(
                  Icons.local_gas_station,
                  size: 60,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'لا توجد طلبات وقود',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'انقر على أيقونة + لإنشاء طلب وقود جديد',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/fuel');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'طلب وقود جديد',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(OrderProvider orderProvider) {
    List<dynamic> filteredOrders = _getFilteredOrders(orderProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Color(0xFF1a1a1a),
            Colors.black,
          ],
        ),
      ),
      child: RefreshIndicator(
        backgroundColor: Colors.black,
        color: Colors.white,
        onRefresh: () async {
          await orderProvider.loadFuelOrders();
        },
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              child: OrderCard(
                order: order,
                orderType: 'fuel',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/fuel-order-details',
                    arguments: order.id,
                  );
                },
                onTrack: order.status == 'assigned_to_driver' ||
                        order.status == 'picked_up' ||
                        order.status == 'on_the_way'
                    ? () {
                        Navigator.pushNamed(context, '/track-order', arguments: order.id);
                      }
                    : null,
                onChat: () {
                  Navigator.pushNamed(context, '/chat', arguments: order.id);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  List<dynamic> _getFilteredOrders(OrderProvider orderProvider) {
    if (_selectedFilter == 'all') {
      return orderProvider.fuelOrders;
    }

    return orderProvider.fuelOrders.where((order) {
      switch (_selectedFilter) {
        case 'pending':
          return order.status == 'pending';
        case 'approved':
          return order.status == 'approved';
        case 'in_progress':
          return order.status == 'in_progress';
        case 'waiting_payment':
          return order.status == 'waiting_payment';
        case 'completed':
          return order.status == 'completed';
        case 'cancelled':
          return order.status == 'cancelled';
        default:
          return true;
      }
    }).toList();
  }

  String _getFilterText(String filter) {
    switch (filter) {
      case 'all':
        return 'الكل';
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'معتمد';
      case 'in_progress':
        return 'قيد التوصيل';
      case 'waiting_payment':
        return 'بانتظار الدفع';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return filter;
    }
  }

  void _filterFuelOrders(OrderProvider orderProvider, String filter) {
    if (filter == 'all') {
      orderProvider.loadFuelOrders();
    } else {
      orderProvider.loadFuelOrders(status: filter);
    }
  }
}