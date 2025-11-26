import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;
  final Widget? actionButton;
  final bool showIcon;

  const EmptyState({
    Key? key,
    required this.title,
    required this.description,
    this.iconPath = '',
    this.icon,
    this.iconColor,
    this.iconSize = 80,
    this.actionButton,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ...[
              _buildIcon(),
              const SizedBox(height: 24),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionButton != null) ...[
              const SizedBox(height: 24),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon != null) {
      return Icon(
        icon,
        size: iconSize,
        color: iconColor ?? Colors.grey[400],
      );
    } else if (iconPath.isNotEmpty) {
      return Image.asset(
        iconPath,
        width: iconSize,
        height: iconSize,
        color: iconColor,
      );
    } else {
      return Icon(
        Icons.inbox_outlined,
        size: iconSize,
        color: iconColor ?? Colors.grey[400],
      );
    }
  }
}

// أنواع محددة مسبقاً من Empty States
class EmptyOrdersState extends StatelessWidget {
  final VoidCallback? onAddOrder;

  const EmptyOrdersState({Key? key, this.onAddOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد طلبات',
      description: 'لم تقم بإنشاء أي طلبات حتى الآن. ابدأ بإنشاء طلبك الأول!',
      icon: Icons.shopping_cart_outlined,
      iconColor: Colors.blue,
      actionButton: onAddOrder != null
          ? ElevatedButton.icon(
              onPressed: onAddOrder,
              icon: Icon(Icons.add),
              label: Text('إنشاء طلب جديد'),
            )
          : null,
    );
  }
}

class EmptyProductsState extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyProductsState({Key? key, this.onExplore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد منتجات',
      description: 'لا توجد منتجات متاحة حالياً. يرجى المحاولة لاحقاً.',
      icon: Icons.local_gas_station_outlined,
      iconColor: Colors.orange,
      actionButton: onExplore != null
          ? OutlinedButton.icon(
              onPressed: onExplore,
              icon: Icon(Icons.explore),
              label: Text('استكشاف المتجر'),
            )
          : null,
    );
  }
}

class EmptyChatsState extends StatelessWidget {
  final VoidCallback? onStartChat;

  const EmptyChatsState({Key? key, this.onStartChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد محادثات',
      description: 'سيظهر هنا محادثات الطلبات الخاصة بك مع السائقين.',
      icon: Icons.chat_bubble_outline,
      iconColor: Colors.green,
      actionButton: onStartChat != null
          ? ElevatedButton.icon(
              onPressed: onStartChat,
              icon: Icon(Icons.chat),
              label: Text('بدء محادثة'),
            )
          : null,
    );
  }
}

class EmptyNotificationsState extends StatelessWidget {
  const EmptyNotificationsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد إشعارات',
      description: 'سيتم إعلامك هنا بأي تحديثات جديدة على طلباتك.',
      icon: Icons.notifications_none,
      iconColor: Colors.purple,
    );
  }
}

class EmptyAddressesState extends StatelessWidget {
  final VoidCallback onAddAddress;

  const EmptyAddressesState({
    Key? key,
    required this.onAddAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد عناوين',
      description: 'أضف عنوانك الأول لتسهيل عملية التوصيل.',
      icon: Icons.location_on_outlined,
      iconColor: Colors.red,
      actionButton: ElevatedButton.icon(
        onPressed: onAddAddress,
        icon: Icon(Icons.add_location),
        label: Text('إضافة عنوان جديد'),
      ),
    );
  }
}

class EmptyPaymentsState extends StatelessWidget {
  const EmptyPaymentsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد مدفوعات',
      description: 'سيظهر هنا سجل المدفوعات الخاصة بطلباتك.',
      icon: Icons.payment_outlined,
      iconColor: Colors.teal,
    );
  }
}

class EmptySearchState extends StatelessWidget {
  final String searchQuery;

  const EmptySearchState({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد نتائج',
      description: 'لم نتمكن من العثور على نتائج لـ "$searchQuery"',
      icon: Icons.search_off,
      iconColor: Colors.grey,
    );
  }
}

class EmptyNetworkState extends StatelessWidget {
  final VoidCallback onRetry;

  const EmptyNetworkState({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'فقدان الاتصال',
      description: 'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.',
      icon: Icons.wifi_off,
      iconColor: Colors.amber,
      actionButton: ElevatedButton.icon(
        onPressed: onRetry,
        icon: Icon(Icons.refresh),
        label: Text('إعادة المحاولة'),
      ),
    );
  }
}

class EmptyErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const EmptyErrorState({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'حدث خطأ',
      description: errorMessage,
      icon: Icons.error_outline,
      iconColor: Colors.red,
      actionButton: ElevatedButton.icon(
        onPressed: onRetry,
        icon: Icon(Icons.refresh),
        label: Text('إعادة المحاولة'),
      ),
    );
  }
}

class EmptyFavoritesState extends StatelessWidget {
  final VoidCallback onExplore;

  const EmptyFavoritesState({
    Key? key,
    required this.onExplore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'لا توجد مفضلات',
      description: 'أضف المنتجات المفضلة لديك لتظهر هنا.',
      icon: Icons.favorite_border,
      iconColor: Colors.pink,
      actionButton: OutlinedButton.icon(
        onPressed: onExplore,
        icon: Icon(Icons.explore),
        label: Text('استكشاف المنتجات'),
      ),
    );
  }
}

class EmptyCartState extends StatelessWidget {
  final VoidCallback onStartShopping;

  const EmptyCartState({
    Key? key,
    required this.onStartShopping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'سلة التسوق فارغة',
      description: 'أضف بعض المنتجات إلى سلة التسوق لتبدأ طلبك.',
      icon: Icons.shopping_cart_outlined,
      iconColor: Colors.blue,
      actionButton: ElevatedButton.icon(
        onPressed: onStartShopping,
        icon: Icon(Icons.shopping_bag),
        label: Text('بدء التسوق'),
      ),
    );
  }
}

// Empty State قابل للتخصيص بشكل كامل
class CustomEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;

  const CustomEmptyState({
    Key? key,
    required this.title,
    required this.description,
    this.icon,
    this.actions,
    this.padding = const EdgeInsets.all(24.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 24),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 24),
              ...actions!,
            ],
          ],
        ),
      ),
    );
  }
}