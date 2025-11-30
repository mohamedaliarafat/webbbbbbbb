// main.dart - النسخة النهائية المحدثة والمتوافقة مع الويب ✅

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:customer/bloc/notification_bloc.dart';
import 'package:customer/core/constants/app_router.dart';
import 'package:customer/core/services/api_service.dart';
import 'package:customer/core/services/payment_service.dart';
import 'package:customer/core/theme/app_theme.dart';
import 'package:customer/data/datasources/local_datasource.dart';
import 'package:customer/data/repositories/fuel_transfer_repository.dart';
import 'package:customer/firebase_options.dart';
import 'package:customer/presentation/providers/address_provider.dart';
import 'package:customer/presentation/providers/cart_provider.dart';
import 'package:customer/presentation/providers/chat_provider.dart';
import 'package:customer/presentation/providers/company_provider.dart';
import 'package:customer/presentation/providers/complete_profile_provider.dart';
import 'package:customer/presentation/providers/fuel_transfer_provider.dart';
import 'package:customer/presentation/providers/language_provider.dart';
import 'package:customer/presentation/providers/location_provider.dart';
import 'package:customer/presentation/providers/notification_provider.dart';
import 'package:customer/presentation/providers/order_provider.dart';
import 'package:customer/presentation/providers/payment_provider.dart';
import 'package:customer/presentation/providers/product_provider.dart';
import 'package:customer/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔄 Starting Firebase initialization...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ تهيئة Stripe قبل أي شيء (تُتخطى على الويب)
  if (!kIsWeb) {
    print('💳 Initializing Stripe...');
    Stripe.publishableKey = 'pk_test_51SXLdo8WSqRur5EqdnU4CBk4JtBYaR2RHvMBwT5S2z1mW7aPXSzqIni5d4jAqBwLffWuURnTHS1BtGmzDN3bzzhl001qUP1aGo';
    Stripe.merchantIdentifier = 'merchant.com.yourapp';
    await Stripe.instance.applySettings();
    print('✅ Stripe initialized successfully');
  } else {
    print('🌐 Skipping Stripe initialization on Web');
  }

  // ✅ تهيئة ApiService
  print('🌐 Initializing ApiService...');
  final apiService = ApiService();
  apiService.init();
  
  await LocalDataSource().init();
  
  // ✅ تهيئة الإشعارات (تُتخطى على الويب)
  if (!kIsWeb) {
    await _initializeNotifications();
  } else {
    print('🌐 Skipping Firebase Notifications on Web');
  }
  
  print('✅ Firebase initialized successfully - Apps count: ${Firebase.apps.length}');

  runApp(MyApp(apiService: apiService));
}

Future<void> _initializeNotifications() async {
  try {
    print('🔔 Initializing notifications...');
    await FirebaseNotificationService.initializeLocalNotifications();
    await FirebaseNotificationService.initializeFCM();
    await FirebaseNotificationService.setupNotificationNavigation();
    print('✅ Notifications initialized successfully');
  } catch (e) {
    print('❌ Error initializing notifications: $e');
  }
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LanguageProvider()),
          // ✅ Providers الأساسية
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => AddressProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => CompanyProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(create: (_) => CompleteProfileProvider()),
          
          // ✅ Provider لنقل الوقود مع التهيئة الصحيحة
          ChangeNotifierProvider(
            create: (_) {
              final repository = FuelTransferRepository(apiService: apiService);
              return FuelTransferProvider(
                repository: repository,
                apiService: apiService,
              );
            },
          ),
        ],
       child: MaterialApp(
  title: 'تطبيق الوقود',
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  initialRoute: kIsWeb ? '/' : '/splash',
  onGenerateRoute: AppRouter.generateRoute,
  navigatorKey: AppRouter.navigatorKey,
  debugShowCheckedModeBanner: false,
  builder: (context, child) {
    // ✅ fallback للويب فقط لو المسار فشل
    return _AppWrapper(
      child: child ??
          (kIsWeb
              ? Scaffold(
                  appBar: AppBar(title: const Text('Fuel App Web')),
                  body: const Center(
                    child: Text(
                      '🚀 Fuel App Web is running successfully!',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
    );
  },
),

      ),
    );
  }
}

class _AppWrapper extends StatefulWidget {
  final Widget child;

  const _AppWrapper({required this.child});

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAppServices();
    _checkInitialNotification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kIsWeb) {
      _setupNotificationListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kIsWeb) return; // ✅ تجاهل لحالات دورة الحياة على الويب

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onAppResumed() {
    print('📱 App resumed - checking for pending actions...');
    _checkPendingNotifications();
  }

  void _onAppPaused() {
    print('📱 App paused - saving state...');
  }

  void _setupNotificationListeners() {
    print('🎧 Setting up notification listeners...');
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(() {
      if (authProvider.isLoggedIn) {
        print('👤 User logged in - loading notifications...');
        final notificationBloc = context.read<NotificationBloc>();
        notificationBloc.add(LoadNotifications());
      }
    });
  }

  void _checkInitialNotification() {
    if (kIsWeb) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState();
    });
  }

  void _checkAuthState() {
    if (kIsWeb) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      print('👤 User is logged in, loading notifications...');
      final notificationBloc = context.read<NotificationBloc>();
      notificationBloc.add(LoadNotifications());
    }
  }

  void _checkPendingNotifications() {
    if (kIsWeb) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      final notificationBloc = context.read<NotificationBloc>();
      notificationBloc.add(CheckPendingNotifications());
    }
  }

  void _initializeAppServices() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('⚙️ Initializing additional app services...');
      final paymentService = PaymentService();
      print('✅ All app services initialized successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
