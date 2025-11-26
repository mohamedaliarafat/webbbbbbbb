import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:customer/data/datasources/remote_datasource.dart';
import 'package:customer/data/models/notification_model.dart';
import 'package:customer/core/services/auth_service.dart';
import 'package:customer/core/constants/api_endpoints.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class LoadNotifications extends NotificationEvent {
  final int page;
  final int limit;
  final String? type;
  final bool? read;

  const LoadNotifications({
    this.page = 1,
    this.limit = 20,
    this.type,
    this.read,
  });

  @override
  List<Object?> get props => [page, limit, type, read];
}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class ReceiveNotification extends NotificationEvent {
  final AppNotification notification;

  const ReceiveNotification(this.notification);

  @override
  List<Object> get props => [notification];
}

class LoadNotificationStats extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class CheckPendingNotifications extends NotificationEvent {
  @override
  List<Object> get props => [];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasReachedMax;

  const NotificationLoaded({
    required this.notifications,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    this.hasReachedMax = false,
  });

  NotificationLoaded copyWith({
    List<AppNotification>? notifications,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    bool? hasReachedMax,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        notifications,
        currentPage,
        totalPages,
        totalCount,
        hasReachedMax,
      ];
}

class NotificationStatsLoaded extends NotificationState {
  final Map<String, dynamic> stats;

  const NotificationStatsLoaded({required this.stats});

  @override
  List<Object> get props => [stats];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AuthService _authService = AuthService();
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<ReceiveNotification>(_onReceiveNotification);
    on<LoadNotificationStats>(_onLoadNotificationStats);
    on<CheckPendingNotifications>(_onCheckPendingNotifications); // ✅ تمت الإضافة
  }

  // ✅ الدالة الجديدة: فحص الإشعارات المعلقة
  Future<void> _onCheckPendingNotifications(
    CheckPendingNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      print('🔍 فحص الإشعارات المعلقة...');
      
      // التحقق من حالة المصادقة أولاً
      final isAuthenticated = await _authService.validateAuthState();
      if (!isAuthenticated) {
        print('❌ المستخدم غير مسجل دخول - تخطي فحص الإشعارات');
        return;
      }

      // تحميل الإشعارات غير المقروءة
      final response = await _remoteDataSource.get(
        '/notifications/my-notifications',
        queryParams: {
          'page': '1',
          'limit': '10',
          'read': 'false', // الإشعارات غير المقروءة فقط
        },
      );

      if (response['success'] == true) {
        final data = response['data'];
        final notificationsData = data['notifications'] as List<dynamic>;
        
        if (notificationsData.isNotEmpty) {
          final unreadCount = notificationsData.length;
          print('📢 يوجد $unreadCount إشعار معلق غير مقروء');
          
          // إرسال إشعار محلي بالإشعارات المعلقة
          _showPendingNotificationsAlert(unreadCount);
        } else {
          print('✅ لا توجد إشعارات معلقة');
        }
      }
    } catch (e) {
      print('❌ خطأ في فحص الإشعارات المعلقة: $e');
    }
  }

  // ✅ دالة مساعدة لعرض تنبيه بالإشعارات المعلقة
  void _showPendingNotificationsAlert(int unreadCount) {
    // يمكنك استخدام أي طريقة لعرض التنبيهات
    // مثل Flutter Local Notifications أو SnackBar
    print('🎯 عرض تنبيه: لديك $unreadCount إشعار غير مقروء');
    
    // مثال باستخدام print (يمكن استبداله بمنظومة إشعارات حقيقية)
    if (unreadCount == 1) {
      print('🔔 لديك إشعار واحد غير مقروء');
    } else {
      print('🔔 لديك $unreadCount إشعارات غير مقروءة');
    }
  }

  Future<void> _debugAuthStatus() async {
    print('=== 🔍 فحص حالة المصادقة ===');
    
    // فحص AuthService
    print('✅ AuthService.isLoggedIn: ${_authService.isLoggedIn}');
    print('✅ AuthService.currentUser: ${_authService.currentUser != null}');
    
    if (_authService.currentUser != null) {
      print('✅ User ID: ${_authService.currentUser!.id}');
      print('✅ User Name: ${_authService.currentUser!.name}');
    }
    
    // فحص RemoteDataSource
    final hasToken = await _remoteDataSource.hasToken();
    print('✅ RemoteDataSource.hasToken: $hasToken');
    
    final token = await _remoteDataSource.getToken();
    print('✅ RemoteDataSource.getToken: ${token != null ? "موجود" : "غير موجود"}');
    
    if (token != null) {
      print('✅ Token length: ${token.length}');
      print('✅ Token preview: ${token.substring(0, min(20, token.length))}...');
    }
    
    print('=== انتهاء الفحص ===');
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // استخدام التحقق المحسن من المصادقة
      final isAuthenticated = await _authService.validateAuthState();
      
      if (!isAuthenticated) {
        // 🔥 محاولة إعادة تحميل المستخدم أولاً
        await _authService.reloadUser();
        
        // التحقق مرة أخرى بعد إعادة التحميل
        final retryAuth = await _authService.validateAuthState();
        if (!retryAuth) {
          emit(NotificationError('يجب تسجيل الدخول أولاً للوصول إلى الإشعارات'));
          return;
        }
      }

      // باقي الكود يبقى كما هو...
      if (event.page == 1) {
        emit(NotificationLoading());
      }

      final queryParams = {
        'page': event.page.toString(),
        'limit': event.limit.toString(),
        if (event.type != null) 'type': event.type!,
        if (event.read != null) 'read': event.read.toString(),
      };

      final response = await _remoteDataSource.get(
        '/notifications/my-notifications',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final data = response['data'];
        final notificationsData = data['notifications'] as List<dynamic>;
        
        final notifications = notificationsData
            .map((json) => AppNotification.fromJson(json))
            .toList();

        final currentPage = data['pagination']['page'] ?? event.page;
        final totalPages = data['pagination']['pages'] ?? 1;
        final totalCount = data['pagination']['total'] ?? notifications.length;
        final hasReachedMax = currentPage >= totalPages;

        emit(NotificationLoaded(
          notifications: notifications,
          currentPage: currentPage,
          totalPages: totalPages,
          totalCount: totalCount,
          hasReachedMax: hasReachedMax,
        ));

        print('✅ تم تحميل ${notifications.length} إشعار - الصفحة $currentPage من $totalPages');
      } else {
        emit(NotificationError(response['message'] ?? 'فشل في تحميل الإشعارات'));
      }
    } catch (e) {
      print('❌ خطأ في تحميل الإشعارات: $e');
      emit(NotificationError('❌ خطأ في تحميل الإشعارات: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // استخدام RemoteDataSource مباشرة
      final response = await _remoteDataSource.patch(
        '/notifications/${event.notificationId}/read',
        {},
      );

      if (response['success'] == true) {
        // تحديث الحالة المحلية
        if (state is NotificationLoaded) {
          final currentState = state as NotificationLoaded;
          final currentUserId = _authService.currentUser?.id;
          
          final updatedNotifications = currentState.notifications.map((notification) {
            if (notification.id == event.notificationId && currentUserId != null) {
              return notification.copyWith(
                isRead: true,
                readBy: [...notification.readBy, currentUserId],
              );
            }
            return notification;
          }).toList();

          emit(currentState.copyWith(notifications: updatedNotifications));
        }
        print('✅ تم تحديد الإشعار كمقروء: ${event.notificationId}');
      } else {
        print('❌ فشل في تحديد الإشعار كمقروء: ${response['message']}');
      }
    } catch (e) {
      print('❌ خطأ في تحديد الإشعار كمقروء: $e');
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // استخدام RemoteDataSource مباشرة
      final response = await _remoteDataSource.patch(
        '/notifications/mark-all-read',
        {},
      );

      if (response['success'] == true) {
        // تحديث جميع الإشعارات كمقروءة
        if (state is NotificationLoaded) {
          final currentState = state as NotificationLoaded;
          final currentUserId = _authService.currentUser?.id;
          
          final updatedNotifications = currentState.notifications
              .map((notification) => currentUserId != null 
                  ? notification.copyWith(
                      isRead: true,
                      readBy: [...notification.readBy, currentUserId],
                    )
                  : notification.copyWith(isRead: true))
              .toList();

          emit(currentState.copyWith(notifications: updatedNotifications));
        }
        print('✅ تم تحديد جميع الإشعارات كمقروءة');
      } else {
        print('❌ فشل في تحديد جميع الإشعارات كمقروءة: ${response['message']}');
      }
    } catch (e) {
      print('❌ خطأ في تحديد جميع الإشعارات كمقروءة: $e');
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // استخدام RemoteDataSource مباشرة
      final response = await _remoteDataSource.delete(
        '/notifications/${event.notificationId}',
      );

      if (response['success'] == true) {
        // إزالة الإشعار من القائمة
        if (state is NotificationLoaded) {
          final currentState = state as NotificationLoaded;
          final updatedNotifications = currentState.notifications
              .where((notification) => notification.id != event.notificationId)
              .toList();

          emit(currentState.copyWith(
            notifications: updatedNotifications,
            totalCount: currentState.totalCount - 1,
          ));
        }
        print('✅ تم حذف الإشعار: ${event.notificationId}');
      } else {
        print('❌ فشل في حذف الإشعار: ${response['message']}');
      }
    } catch (e) {
      print('❌ خطأ في حذف الإشعار: $e');
    }
  }

  void _onReceiveNotification(
    ReceiveNotification event,
    Emitter<NotificationState> emit,
  ) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final updatedNotifications = [event.notification, ...currentState.notifications];

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        totalCount: currentState.totalCount + 1,
      ));
    } else if (state is NotificationInitial) {
      // إذا كانت الحالة ابتدائية، أنشئ حالة جديدة
      emit(NotificationLoaded(
        notifications: [event.notification],
        currentPage: 1,
        totalPages: 1,
        totalCount: 1,
        hasReachedMax: true,
      ));
    }
  }

  Future<void> _onLoadNotificationStats(
    LoadNotificationStats event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // استخدام RemoteDataSource مباشرة
      final response = await _remoteDataSource.get(
        '/notifications/stats',
      );

      if (response['success'] == true) {
        emit(NotificationStatsLoaded(stats: response['data']));
        print('✅ تم تحميل إحصائيات الإشعارات');
      } else {
        emit(NotificationError(response['message'] ?? 'فشل في جلب الإحصائيات'));
      }
    } catch (e) {
      print('❌ خطأ في جلب الإحصائيات: $e');
      emit(NotificationError('❌ خطأ في جلب الإحصائيات: ${e.toString()}'));
    }
  }

  // ✅ دالة مساعدة لإعادة تحميل الإشعارات
  void reloadNotifications() {
    add(LoadNotifications());
  }

  // ✅ دالة مساعدة لتحميل المزيد من الإشعارات
  void loadMoreNotifications() {
    final currentState = state;
    if (currentState is NotificationLoaded && !currentState.hasReachedMax) {
      add(LoadNotifications(page: currentState.currentPage + 1));
    }
  }

  // ✅ دالة جديدة لفحص الإشعارات المعلقة (للاستخدام الخارجي)
  void checkPendingNotifications() {
    add(CheckPendingNotifications());
  }

  // ✅ دالة لفحص حالة المصادقة
  Future<void> checkAuthStatus() async {
    print('=== فحص حالة المصادقة ===');
    print('✅ AuthService.isLoggedIn: ${_authService.isLoggedIn}');
    print('✅ AuthService.currentUser: ${_authService.currentUser != null}');
    
    final hasToken = await _remoteDataSource.hasToken();
    print('✅ RemoteDataSource.hasToken: $hasToken');
    
    final token = await _remoteDataSource.getToken();
    print('✅ RemoteDataSource.getToken: ${token != null ? "موجود" : "غير موجود"}');
    
    if (token != null) {
      print('✅ طول الـ Token: ${token.length}');
      print('✅ أول 20 حرف من الـ Token: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
    }
    
    if (_authService.currentUser != null) {
      print('✅ User ID: ${_authService.currentUser!.id}');
      print('✅ User Name: ${_authService.currentUser!.name}');
    }
  }
}