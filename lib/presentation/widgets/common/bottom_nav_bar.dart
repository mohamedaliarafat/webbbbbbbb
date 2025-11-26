import 'package:customer/presentation/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
        ),
        items: [
          // Home
          BottomNavigationBarItem(
            icon: _NavBarIcon(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              isActive: widget.currentIndex == 0,
            ),
            label: 'الرئيسية',
          ),

          // Orders
          BottomNavigationBarItem(
            icon: _NavBarIcon(
              icon: Icons.shopping_cart_outlined,
              activeIcon: Icons.shopping_cart,
              isActive: widget.currentIndex == 1,
            ),
            label: 'الطلبات',
          ),

          // Products
          BottomNavigationBarItem(
            icon: _NavBarIcon(
              icon: Icons.local_gas_station_outlined,
              activeIcon: Icons.local_gas_station,
              isActive: widget.currentIndex == 2,
            ),
            label: 'المنتجات',
          ),

          // Chat
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                _NavBarIcon(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat,
                  isActive: widget.currentIndex == 3,
                ),
                // يمكن إضافة مؤشر للمحادثات غير المقروءة هنا
              ],
            ),
            label: 'المحادثات',
          ),

          // Notifications
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                _NavBarIcon(
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  isActive: widget.currentIndex == 4,
                ),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationProvider.unreadCount > 99 
                            ? '99+' 
                            : notificationProvider.unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'الإشعارات',
          ),

          // Profile
          BottomNavigationBarItem(
            icon: _NavBarIcon(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              isActive: widget.currentIndex == 5,
            ),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;

  const _NavBarIcon({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: Icon(
            isActive ? activeIcon : icon,
            key: ValueKey(isActive ? 'active' : 'inactive'),
            size: 24,
          ),
        ),
        SizedBox(height: 2),
        if (isActive)
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

// نسخة متقدمة مع تأثيرات إضافية
class AnimatedBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedBottomNavBarState createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();

    return Container(
      margin: EdgeInsets.all(16),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AnimatedNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'الرئيسية',
            isActive: widget.currentIndex == 0,
            hasNotification: false,
            notificationCount: 0,
            onTap: () => widget.onTap(0),
          ),
          _AnimatedNavItem(
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart,
            label: 'الطلبات',
            isActive: widget.currentIndex == 1,
            hasNotification: false,
            notificationCount: 0,
            onTap: () => widget.onTap(1),
          ),
          _AnimatedNavItem(
            icon: Icons.local_gas_station_outlined,
            activeIcon: Icons.local_gas_station,
            label: 'المنتجات',
            isActive: widget.currentIndex == 2,
            hasNotification: false,
            notificationCount: 0,
            onTap: () => widget.onTap(2),
          ),
          _AnimatedNavItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat,
            label: 'المحادثات',
            isActive: widget.currentIndex == 3,
            hasNotification: false,
            notificationCount: 0,
            onTap: () => widget.onTap(3),
          ),
          _AnimatedNavItem(
            icon: Icons.notifications_outlined,
            activeIcon: Icons.notifications,
            label: 'الإشعارات',
            isActive: widget.currentIndex == 4,
            hasNotification: notificationProvider.unreadCount > 0,
            notificationCount: notificationProvider.unreadCount,
            onTap: () => widget.onTap(4),
          ),
          _AnimatedNavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'الملف',
            isActive: widget.currentIndex == 5,
            hasNotification: false,
            notificationCount: 0,
            onTap: () => widget.onTap(5),
          ),
        ],
      ),
    );
  }
}

class _AnimatedNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool hasNotification;
  final int notificationCount;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.hasNotification,
    required this.notificationCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.blue[50] : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? activeIcon : icon,
                        color: isActive ? Colors.blue[700] : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    if (hasNotification)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            notificationCount > 99 
                                ? '99+' 
                                : notificationCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isActive ? 12 : 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.blue[700] : Colors.grey[600],
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// استخدام البوتوم ناف بار في التطبيق
class MainScaffoldWithNavBar extends StatefulWidget {
  final List<Widget> screens;

  const MainScaffoldWithNavBar({
    Key? key,
    required this.screens,
  }) : super(key: key);

  @override
  _MainScaffoldWithNavBarState createState() => _MainScaffoldWithNavBarState();
}

class _MainScaffoldWithNavBarState extends State<MainScaffoldWithNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// مثال للاستخدام مع الشاشات
class ExampleUsage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MainScaffoldWithNavBar(
        screens: [
          HomeScreen(),
          OrdersScreen(),
          ProductsScreen(),
          ChatListScreen(),
          NotificationsScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}

// شاشات مثاليه (يجب استبدالها بالشاشات الحقيقية)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الرئيسية')),
      body: Center(child: Text('شاشة الرئيسية')),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الطلبات')),
      body: Center(child: Text('شاشة الطلبات')),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المنتجات')),
      body: Center(child: Text('شاشة المنتجات')),
    );
  }
}

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المحادثات')),
      body: Center(child: Text('شاشة المحادثات')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الإشعارات')),
      body: Center(child: Text('شاشة الإشعارات')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الملف الشخصي')),
      body: Center(child: Text('شاشة الملف الشخصي')),
    );
  }
}