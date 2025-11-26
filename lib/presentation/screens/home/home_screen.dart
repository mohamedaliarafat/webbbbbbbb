// ignore_for_file: deprecated_member_use, unused_local_variable, library_private_types_in_public_api

import 'dart:ui';

import 'package:customer/core/constants/app_router.dart';
import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:customer/presentation/providers/notification_provider.dart';
import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/presentation/providers/product_provider.dart';
import 'package:customer/presentation/screens/orders/fuel_order_screen.dart';
import 'package:customer/presentation/screens/orders/orders_list_screen.dart';
import 'package:customer/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    FuelOrderScreen(),
    FuelOrdersListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    productProvider.loadProducts();
    orderProvider.loadFuelOrders();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'البحيرة العربية للنقليات',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, '/notificiation');
                      },
                    ),
                  ),
                  if (notificationProvider.unreadCount > 0)
                    Positioned(
                      right: 4,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${notificationProvider.unreadCount > 99 ? '99+' : notificationProvider.unreadCount}',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Container(
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
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16), // هامش من جميع الجوانب
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25), // زوايا دائرية
          border: Border.all(
            color: Colors.white.withOpacity(0.2), // حدود بيضاء شفافة
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              selectedLabelStyle: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.cairo(
                fontSize: 11,
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _currentIndex == 0 
                        ? LinearGradient(
                            colors: [
                              Color(0xFF64B5F6),
                              Color(0xFF42A5F5),
                            ],
                          )
                        : null,
                      border: Border.all(
                        color: _currentIndex == 0 
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.transparent,
                      ),
                    ),
                    child: Icon(
                      Icons.dashboard, 
                      size: 22,
                      color: _currentIndex == 0 ? Colors.white : Colors.white54,
                    ),
                  ),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _currentIndex == 1 
                        ? LinearGradient(
                            colors: [
                              Color(0xFF81C784),
                              Color(0xFF66BB6A),
                            ],
                          )
                        : null,
                      border: Border.all(
                        color: _currentIndex == 1 
                          ? Colors.green.withOpacity(0.5)
                          : Colors.transparent,
                      ),
                    ),
                    child: Icon(
                      Icons.local_gas_station, 
                      size: 22,
                      color: _currentIndex == 1 ? Colors.white : Colors.white54,
                    ),
                  ),
                  label: 'طلب وقود',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _currentIndex == 2 
                        ? LinearGradient(
                            colors: [
                              Color(0xFFFFB74D),
                              Color(0xFFFFA726),
                            ],
                          )
                        : null,
                      border: Border.all(
                        color: _currentIndex == 2 
                          ? Colors.orange.withOpacity(0.5)
                          : Colors.transparent,
                      ),
                    ),
                    child: Icon(
                      Icons.list_alt, 
                      size: 22,
                      color: _currentIndex == 2 ? Colors.white : Colors.white54,
                    ),
                  ),
                  label: 'طلباتي',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _currentIndex == 3 
                        ? LinearGradient(
                            colors: [
                              Color(0xFFBA68C8),
                              Color(0xFFAB47BC),
                            ],
                          )
                        : null,
                      border: Border.all(
                        color: _currentIndex == 3 
                          ? Colors.purple.withOpacity(0.5)
                          : Colors.transparent,
                      ),
                    ),
                    child: Icon(
                      Icons.person, 
                      size: 22,
                      color: _currentIndex == 3 ? Colors.white : Colors.white54,
                    ),
                  ),
                  label: 'الملف الشخصي',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// باقي الكود يبقى كما هو بدون تغيير...
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
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
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF64B5F6),
                          Color(0xFF42A5F5),
                        ],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(authProvider.user?.profileImage ?? ''),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً ${authProvider.user?.phone ?? ''}',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'نتمنى لك يوماً سعيداً',
                          style: GoogleFonts.cairo(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),

          // Statistics Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: [
              _buildGlassStatCard(
                'إجمالي الطلبات',
                '${orderProvider.totalFuelOrdersCount}',
                Icons.local_gas_station,
                Color(0xFF64B5F6),
              ),
              _buildGlassStatCard(
                'طلبات قيد الانتظار',
                '${orderProvider.pendingFuelOrdersCount}',
                Icons.pending,
                Color(0xFFFFB74D),
              ),
              _buildGlassStatCard(
                'طلبات مكتملة',
                '${orderProvider.completedFuelOrdersCount}',
                Icons.check_circle,
                Color(0xFF81C784),
              ),
              _buildGlassStatCard(
                'إجمالي الوقود',
                '${orderProvider.totalFuelLiters} لتر',
                Icons.water_drop,
                Color(0xFFBA68C8),
              ),
            ],
          ),
          SizedBox(height: 25),

          // Quick Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'الإجراءات السريعة',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: [
              _buildGlassActionCard(
                'طلب وقود جديد',
                Icons.local_gas_station,
                Color(0xFF64B5F6),
                () {
                  Navigator.pushNamed(context, '/fuel');
                },
              ),
              _buildGlassActionCard(
                'خدمات النقل',
                Icons.train,
                Color(0xFF81C784),
                () {
                  Navigator.pushNamed(context, '/fuel-trans');
                },
              ),
              _buildGlassActionCard(
                'تشغيل المحطات',
                Icons.ev_station,
                Color(0xFFFFB74D),
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'سيتم تفعيل هذه الميزة قريباً',
                            style: GoogleFonts.cairo(fontSize: 16),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
              _buildGlassActionCard(
                'تتبع الطلبات',
                Icons.track_changes,
                Color(0xFFBA68C8),
                () {
                  AppRouter.navigateTo('/track-order');
                }
              ),
              _buildGlassActionCard(
                'المحادثات',
                Icons.chat,
                Color(0xFF9575CD),
                () {
                  AppRouter.navigateTo('/chat'); 
                },
              ),
              _buildGlassActionCard(
                'الإشعارات',
                Icons.notifications,
                Color(0xFF4DB6AC),
                () {
                  Navigator.pushNamed(context, '/notificiation');
                },
              ),
            ],
          ),
          SizedBox(height: 25),

          // Recent Fuel Orders
          Container(
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
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'آخر طلبات الوقود',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7986CB),
                              Color(0xFF5C6BC0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pushNamed(context, '/fuel-orders');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                'عرض الكل',
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  _buildRecentFuelOrders(orderProvider),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGlassStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
            color: color.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, size: 15, color: color),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
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
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, size: 25, color: color),
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentFuelOrders(OrderProvider orderProvider) {
    final recentFuelOrders = orderProvider.fuelOrders.take(3).toList();

    if (recentFuelOrders.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Icon(Icons.local_gas_station, size: 40, color: Colors.white54),
              ),
              SizedBox(height: 12),
              Text(
                'لا توجد طلبات وقود حالياً',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: recentFuelOrders.map((order) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                // TODO: Navigate to fuel order details
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: _getStatusColor(order.status).withOpacity(0.3)),
                      ),
                      child: Icon(Icons.local_gas_station, color: _getStatusColor(order.status), size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'طلب وقود #${order.orderNumber}',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${order.fuelTypeName ?? order.fuelType} - ${order.fuelLiters} لتر',
                            style: GoogleFonts.cairo(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _getStatusColor(order.status).withOpacity(0.3)),
                            ),
                            child: Text(
                              _getStatusText(order.status),
                              style: GoogleFonts.cairo(
                                color: _getStatusColor(order.status),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${order.pricing.finalPrice} ر.س',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getStatusColor(String status) {
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
}