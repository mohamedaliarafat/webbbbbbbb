import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryText;
  final bool showIcon;

  const ErrorWidget({
    Key? key,
    required this.message,
    this.title,
    this.icon,
    this.onRetry,
    this.retryText,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon)
              Icon(
                icon ?? Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
            if (showIcon) SizedBox(height: 16),
            
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
            ],
            
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            if (onRetry != null) ...[
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryText ?? 'إعادة المحاولة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// نوع خاص لأخطاء الشبكة
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const NetworkErrorWidget({
    Key? key,
    required this.onRetry,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.wifi_off,
      title: 'خطأ في الاتصال',
      message: message ?? 'تعذر الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.',
      onRetry: onRetry,
      retryText: 'إعادة الاتصال',
    );
  }
}

// نوع خاص لأخطاء الخادم
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const ServerErrorWidget({
    Key? key,
    required this.onRetry,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.cloud_off,
      title: 'خطأ في الخادم',
      message: message ?? 'حدث خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.',
      onRetry: onRetry,
      retryText: 'إعادة المحاولة',
    );
  }
}

// نوع خاص للبيانات غير موجودة
class EmptyDataWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onReload;

  const EmptyDataWidget({
    Key? key,
    required this.message,
    this.title,
    this.onReload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.inbox_outlined,
      title: title ?? 'لا توجد بيانات',
      message: message,
      onRetry: onReload,
      retryText: 'تحديث',
      showIcon: true,
    );
  }
}

// نوع خاص للأخطاء العامة
class GeneralErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const GeneralErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.error_outline,
      title: 'حدث خطأ',
      message: message,
      onRetry: onRetry,
      retryText: 'إعادة المحاولة',
    );
  }
}

// نوع خاص للوصول المرفوض
class AccessDeniedWidget extends StatelessWidget {
  final VoidCallback? onLogin;
  final String? message;

  const AccessDeniedWidget({
    Key? key,
    this.onLogin,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.lock_outline,
      title: 'وصول مرفوض',
      message: message ?? 'ليس لديك صلاحية للوصول إلى هذه الصفحة.',
      onRetry: onLogin,
      retryText: 'تسجيل الدخول',
    );
  }
}

// نوع خاص للبحث بدون نتائج
class NoResultsWidget extends StatelessWidget {
  final String query;
  final VoidCallback onClearSearch;

  const NoResultsWidget({
    Key? key,
    required this.query,
    required this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.search_off,
      title: 'لا توجد نتائج',
      message: 'لم يتم العثور على نتائج لـ "$query"',
      onRetry: onClearSearch,
      retryText: 'مسح البحث',
      showIcon: true,
    );
  }
}

// نوع خاص للصفحات تحت التطوير
class UnderDevelopmentWidget extends StatelessWidget {
  final String featureName;

  const UnderDevelopmentWidget({
    Key? key,
    required this.featureName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.construction,
      title: 'قيد التطوير',
      message: 'ميزة $featureName قيد التطوير حالياً. ستكون متاحة قريباً.',
      showIcon: true,
    );
  }
}

// نوع خاص لأخطاء التحميل
class LoadingErrorWidget extends StatelessWidget {
  final String entityName;
  final VoidCallback onRetry;

  const LoadingErrorWidget({
    Key? key,
    required this.entityName,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.refresh,
      title: 'فشل في التحميل',
      message: 'تعذر تحميل $entityName. يرجى المحاولة مرة أخرى.',
      onRetry: onRetry,
      retryText: 'إعادة التحميل',
    );
  }
}

// نوع خاص للاستخدام في ListView
class SliverErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;

  const SliverErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.retryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ErrorWidget(
        message: message,
        onRetry: onRetry,
        retryText: retryText,
        showIcon: false,
      ),
    );
  }
}

// نوع خاص مع إمكانية تخصيص كاملة
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final Widget? icon;
  final Widget? title;
  final Widget? actionButton;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.icon,
    this.title,
    this.actionButton,
    this.backgroundColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: padding ?? EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(height: 16),
            ],
            
            if (title != null) ...[
              title!,
              SizedBox(height: 8),
            ],
            
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionButton != null) ...[
              SizedBox(height: 24),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}

// أداة مساعدة لعرض الأخطاء بناءً على نوع الخطأ
class ErrorHandler {
  static Widget buildErrorWidget({
    required dynamic error,
    required VoidCallback onRetry,
    String? customMessage,
  }) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || 
        errorString.contains('connection') || 
        errorString.contains('socket')) {
      return NetworkErrorWidget(onRetry: onRetry);
    }
    
    else if (errorString.contains('server') || 
             errorString.contains('500') || 
             errorString.contains('internal')) {
      return ServerErrorWidget(onRetry: onRetry);
    }
    
    else if (errorString.contains('unauthorized') || 
             errorString.contains('401') || 
             errorString.contains('forbidden')) {
      return AccessDeniedWidget(onLogin: onRetry);
    }
    
    else if (errorString.contains('not found') || 
             errorString.contains('404')) {
      return EmptyDataWidget(
        message: customMessage ?? 'البيانات المطلوبة غير موجودة.',
        onReload: onRetry,
      );
    }
    
    else {
      return GeneralErrorWidget(
        message: customMessage ?? error.toString(),
        onRetry: onRetry,
      );
    }
  }
}