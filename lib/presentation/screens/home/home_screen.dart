import 'dart:ui';
import 'package:customer/core/constants/app_router.dart';
import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:customer/presentation/providers/language_provider.dart';
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
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Directionality(
      textDirection: languageProvider.textDirection,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            languageProvider.translate('app_name'),
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
            // أيقونة تغيير اللغة
            _buildLanguageButton(languageProvider),
            SizedBox(width: 8),
            
            // أيقونة الإشعارات
            _buildNotificationButton(context),
            SizedBox(width: 16),
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
        bottomNavigationBar: _buildBottomNavigationBar(languageProvider),
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

  Widget _buildNotificationButton(BuildContext context) {
    return Consumer<NotificationProvider>(
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
    );
  }

  Widget _buildBottomNavigationBar(LanguageProvider languageProvider) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
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
                label: languageProvider.translate('dashboard'),
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
                label: languageProvider.translate('fuel_order'),
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
                label: languageProvider.translate('my_orders'),
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
                label: languageProvider.translate('profile'),
              ),
            ],
          ),
        ),
      ),
    );
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
                  languageProvider.translate('change_language'),
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

// ============ DashboardScreen ============
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(authProvider, languageProvider),
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
                languageProvider.translate('total_orders'),
                '${orderProvider.totalFuelOrdersCount}',
                Icons.local_gas_station,
                Color(0xFF64B5F6),
                languageProvider,
              ),
              _buildGlassStatCard(
                languageProvider.translate('pending_orders'),
                '${orderProvider.pendingFuelOrdersCount}',
                Icons.pending,
                Color(0xFFFFB74D),
                languageProvider,
              ),
              _buildGlassStatCard(
                languageProvider.translate('completed_orders'),
                '${orderProvider.completedFuelOrdersCount}',
                Icons.check_circle,
                Color(0xFF81C784),
                languageProvider,
              ),
              _buildGlassStatCard(
                languageProvider.translate('total_fuel'),
                '${orderProvider.totalFuelLiters} ${languageProvider.translate('liters')}',
                Icons.water_drop,
                Color(0xFFBA68C8),
                languageProvider,
              ),
            ],
          ),
          SizedBox(height: 25),

          // Quick Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              languageProvider.translate('quick_actions'),
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 15),
          _buildQuickActionsGrid(context, languageProvider),
          SizedBox(height: 25),

          // Recent Fuel Orders
          _buildRecentFuelOrdersSection(orderProvider, languageProvider, context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(AuthProvider authProvider, LanguageProvider languageProvider) {
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
                    '${languageProvider.translate('welcome')} ${authProvider.user?.phone ?? ''}',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    languageProvider.translate('good_day'),
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
    );
  }

  Widget _buildGlassStatCard(
    String title, 
    String value, 
    IconData icon, 
    Color color,
    LanguageProvider languageProvider,
  ) {
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

  Widget _buildQuickActionsGrid(BuildContext context, LanguageProvider languageProvider) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _buildGlassActionCard(
          languageProvider.translate('new_fuel_order'),
          Icons.local_gas_station,
          Color(0xFF64B5F6),
          () {
            Navigator.pushNamed(context, '/fuel');
          },
          languageProvider,
        ),
        _buildGlassActionCard(
          languageProvider.translate('transport_services'),
          Icons.train,
          Color(0xFF81C784),
          () {
            Navigator.pushNamed(context, '/fuel-trans');
          },
          languageProvider,
        ),
        _buildGlassActionCard(
          languageProvider.translate('station_operation'),
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
                      languageProvider.translate('feature_coming_soon'),
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
          languageProvider,
        ),
        _buildGlassActionCard(
          languageProvider.translate('track_orders'),
          Icons.track_changes,
          Color(0xFFBA68C8),
          () {
            AppRouter.navigateTo('/track-order');
          },
          languageProvider,
        ),
        _buildGlassActionCard(
          languageProvider.translate('chat'),
          Icons.chat,
          Color(0xFF9575CD),
          () {
            AppRouter.navigateTo('/chat'); 
          },
          languageProvider,
        ),
        _buildGlassActionCard(
          languageProvider.translate('view_all_notifications'),
          Icons.notifications,
          Color(0xFF4DB6AC),
          () {
            Navigator.pushNamed(context, '/notificiation');
          },
          languageProvider,
        ),
      ],
    );
  }

  Widget _buildGlassActionCard(
    String title, 
    IconData icon, 
    Color color, 
    VoidCallback onTap,
    LanguageProvider languageProvider,
  ) {
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

  Widget _buildRecentFuelOrdersSection(
    OrderProvider orderProvider, 
    LanguageProvider languageProvider,
    BuildContext context,
  ) {
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
                  languageProvider.translate('recent_fuel_orders'),
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
                          languageProvider.translate('view_all'),
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
            _buildRecentFuelOrders(orderProvider, languageProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentFuelOrders(OrderProvider orderProvider, LanguageProvider languageProvider) {
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
                languageProvider.translate('no_fuel_orders'),
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
                            '${languageProvider.translate('fuel_order')} #${order.orderNumber}',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${order.fuelTypeName ?? order.fuelType} - ${order.fuelLiters} ${languageProvider.translate('liters')}',
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
                              _getStatusText(order.status, languageProvider),
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
                      '${order.pricing.finalPrice} ${languageProvider.translate('sar')}',
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

 String _getStatusText(String status, LanguageProvider languageProvider) {
  switch (status) {
    case 'pending':
      return languageProvider.translate('pending');
    case 'approved':
      return languageProvider.translate('approved');
    case 'in_progress':
      return languageProvider.translate('in_progress');
    case 'completed':
      return languageProvider.translate('completed');
    case 'cancelled':
      return languageProvider.translate('cancelled');
    default:
      return status;
  }
}
}