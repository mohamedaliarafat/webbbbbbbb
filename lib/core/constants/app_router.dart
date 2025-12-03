// // import 'package:customer/data/models/fuel_order_model.dart';
// // import 'package:customer/data/models/location_model.dart';
// // import 'package:customer/presentation/screens/auth/login_screen.dart';
// // import 'package:customer/presentation/screens/auth/register_screen.dart';
// // import 'package:customer/presentation/screens/auth/reset_password_screen.dart';
// // import 'package:customer/presentation/screens/auth/splash_screen.dart';
// // import 'package:customer/presentation/screens/auth/verify_phone_screen.dart';
// // import 'package:customer/presentation/screens/chat/chat_screen.dart';
// // import 'package:customer/presentation/screens/home/companies_list_screen.dart';
// // import 'package:customer/presentation/screens/home/home_screen.dart';
// // import 'package:customer/presentation/screens/notifications/notifications_screen.dart';
// // import 'package:customer/presentation/screens/orders/fuel_order_screen.dart';
// // import 'package:customer/presentation/screens/orders/order_details_screen.dart';
// // import 'package:customer/presentation/screens/orders/orders_list_screen.dart';
// // import 'package:customer/presentation/screens/orders/track_order_screen.dart';
// // import 'package:customer/presentation/screens/payment/bank_transfer_screen.dart';
// // import 'package:customer/presentation/screens/payment/payment_history_screen.dart';
// // import 'package:customer/presentation/screens/payment/payment_proof_screen.dart';
// // import 'package:customer/presentation/screens/profile/addresses_screen.dart';
// // import 'package:customer/presentation/screens/supports/supports_helpr.dart';
// // import 'package:customer/presentation/widgets/address/location_picker.dart';
// // import 'package:flutter/material.dart';

// // class AppRouter {
// //   static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// //   static Route<dynamic> generateRoute(RouteSettings settings) {
// //     switch (settings.name) {
// //       case '/splash':
// //         return MaterialPageRoute(builder: (_) => SplashScreen());
      
// //       case '/login':
// //         return MaterialPageRoute(builder: (_) => LoginScreen());
      
// //       case '/register':
// //         return MaterialPageRoute(builder: (_) => RegisterScreen());
      
// //       case '/verify-phone':
// //         final phone = settings.arguments as String?;
// //         return MaterialPageRoute(
// //           builder: (_) => VerifyPhoneScreen(phone: phone ?? ''),
// //         );
      
// //       case '/reset-password':
// //         return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      
// //       case '/home':
// //         return MaterialPageRoute(builder: (_) => HomeScreen());
      
// //       case '/fuel':
// //         return MaterialPageRoute(builder: (_) => FuelOrderScreen());

// //       case '/supports':
// //         return MaterialPageRoute(builder: (_) => HelpSupportScreen());

// //        case '/payment':
// //           return MaterialPageRoute(builder: (_) {
// //             final order = settings.arguments as FuelOrderModel;
// //             return BankTransferScreen(order: order);
// //           });

// //        case '/payment-proof':
// //         final args = settings.arguments as Map<String, dynamic>;
// //         return MaterialPageRoute(builder: (_) => PaymentProofScreen(
// //           order: args['order'],
// //           paymentData: args['paymentData'],
// //         ));


// //           case '/notificiation':
// //         return MaterialPageRoute(builder: (_) => NotificationsScreen());

// //          case '/truckOrder':
// //         return MaterialPageRoute(builder: (_) => TrackOrderScreen(orderId: '', orderType: '',));


// //       case '/chat':
// //         return MaterialPageRoute(builder: (_) => ChatScreen(chatId: '', orderId: '',));

        
// //       case '/company':
// //         return MaterialPageRoute(builder: (_) => CompaniesListScreen());



// //         case '/addAddress':
// //         return MaterialPageRoute(builder: (_) => AddressesScreen());


// //         case '/fuel-orders':
// //         return MaterialPageRoute(builder: (_) => FuelOrdersListScreen());


// //         case '/orderDetails':
// //         return MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: '',));


// //         case '/hestoryPayments':
// //         return MaterialPageRoute(builder: (_) => PaymentHistoryScreen());



        

           
// //       case '/map':
// //         return MaterialPageRoute(builder: (_) => LocationPickerScreen(onLocationSelected: (LocationModel p1) {  },));







        
      
// //       default:
// //         return MaterialPageRoute(
// //           builder: (_) => Scaffold(
// //             body: Center(
// //               child: Text('الصفحة غير موجودة'),
// //             ),
// //           ),
// //         );
// //     }
// //   }

// //   static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
// //     return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
// //   }

// //   static Future<dynamic> navigateAndReplace(String routeName, {Object? arguments}) {
// //     return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
// //   }

// //   static void goBack() {
// //     navigatorKey.currentState!.pop();
// //   }
// // }


// import 'package:customer/data/models/fuel_order_model.dart';
// import 'package:customer/data/models/location_model.dart';
// import 'package:customer/presentation/screens/auth/login_screen.dart';
// import 'package:customer/presentation/screens/auth/register_screen.dart';
// import 'package:customer/presentation/screens/auth/reset_password_screen.dart';
// import 'package:customer/presentation/screens/auth/splash_screen.dart';
// import 'package:customer/presentation/screens/auth/verify_phone_screen.dart';
// import 'package:customer/presentation/screens/chat/chat_screen.dart';
// import 'package:customer/presentation/screens/fuelTransfer/fuel_transfer_request_screen.dart';
// import 'package:customer/presentation/screens/home/companies_list_screen.dart';
// import 'package:customer/presentation/screens/home/home_screen.dart';
// import 'package:customer/presentation/screens/notifications/notifications_screen.dart';
// import 'package:customer/presentation/screens/orders/fuel_order_screen.dart';
// import 'package:customer/presentation/screens/orders/order_details_screen.dart';
// import 'package:customer/presentation/screens/orders/orders_list_screen.dart';
// import 'package:customer/presentation/screens/orders/track_order_screen.dart';
// import 'package:customer/presentation/screens/payment/bank_transfer_screen.dart';
// import 'package:customer/presentation/screens/payment/payment_history_screen.dart';
// import 'package:customer/presentation/screens/payment/payment_proof_screen.dart';
// import 'package:customer/presentation/screens/payment/stripe_payment_screen.dart';
// import 'package:customer/presentation/screens/profile/addresses_screen.dart';
// import 'package:customer/presentation/screens/supports/supports_helpr.dart';
// import 'package:customer/presentation/widgets/address/location_picker.dart';
// import 'package:flutter/material.dart';

// class AppRouter {
//   static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/splash':
//         return MaterialPageRoute(builder: (_) => SplashScreen());
      
//       case '/login':
//         return MaterialPageRoute(builder: (_) => LoginScreen());
      
//       case '/register':
//         return MaterialPageRoute(builder: (_) => RegisterScreen());
      
//       case '/verify-phone':
//         final phone = settings.arguments as String?;
//         return MaterialPageRoute(
//           builder: (_) => VerifyPhoneScreen(phone: phone ?? ''),


//         );
 
      
//       case '/reset-password':
//         return MaterialPageRoute(builder: (_) => ResetPasswordScreen());


//         case '/stripe-payment':
//   final args = settings.arguments as Map<String, dynamic>? ?? {};
//   return MaterialPageRoute(builder: (_) => StripePaymentScreen(
//     amount: args['amount'] ?? 0.0,
//     orderId: args['orderId'] ?? '',
//     currency: args['currency'] ?? 'SAR',
//   ));

// // دالة مساعدة للتنقل لصفحة Stripe

      
//       case '/home':
//         return MaterialPageRoute(builder: (_) => HomeScreen());

     
//       case '/fuel':
//         return MaterialPageRoute(builder: (_) => FuelOrderScreen());

//       case '/supports':
//         return MaterialPageRoute(builder: (_) => HelpSupportScreen());

//       case '/payment':
//         final order = settings.arguments as FuelOrderModel;
//         return MaterialPageRoute(builder: (_) => BankTransferScreen(order: order));

//       case '/payment-proof':
//         final args = settings.arguments as Map<String, dynamic>;
//         return MaterialPageRoute(builder: (_) => PaymentProofScreen(
//           order: args['order'],
//           paymentData: args['paymentData'],
//         ));

//       // 🔔 شاشات الإشعارات والتنقل
//       case '/notifications':
//         return MaterialPageRoute(builder: (_) => NotificationsScreen());

//      case '/track-order':
//   final args = settings.arguments;

//   String orderId = '';
//   String orderType = 'fuel';

//   if (args != null) {
//     if (args is FuelOrderModel) {
//       orderId = args.id; // أو args.orderNumber حسب استخدامك
//     } else if (args is Map<String, dynamic>) {
//       orderId = args['orderId'] ?? '';
//       orderType = args['orderType'] ?? 'fuel';
//     }
//   }

//   return MaterialPageRoute(
//     builder: (_) => TrackOrderScreen(
//       orderId: orderId,
//       orderType: orderType,
//     ),
//   );


//       case '/chat':
//         final args = settings.arguments as Map<String, dynamic>? ?? {};
//         return MaterialPageRoute(builder: (_) => ChatScreen(
//           chatId: args['chatId'] ?? '',
//           orderId: args['orderId'] ?? '',
//         ));

//       case '/company':
//         return MaterialPageRoute(builder: (_) => CompaniesListScreen());

//       case '/addAddress':
//         return MaterialPageRoute(builder: (_) => AddressesScreen());

//       case '/fuel-orders':
//         return MaterialPageRoute(builder: (_) => FuelOrdersListScreen());

//       case '/fuel-trans':
//         return MaterialPageRoute(builder: (_) => FuelTransferRequestScreen());

//       case '/order-details':
//         final args = settings.arguments as Map<String, dynamic>? ?? {};
//         return MaterialPageRoute(builder: (_) => OrderDetailsScreen(
//           orderId: args['orderId'] ?? '',
//           orderType: args['orderType'] ?? 'fuel',
//         ));

//       case '/orderDetails':
//         final args = settings.arguments as Map<String, dynamic>? ?? {};
//         return MaterialPageRoute(builder: (_) => OrderDetailsScreen(
//           orderId: args['orderId'] ?? '',
//           orderType: args['orderType'] ?? 'fuel',
//         ));

//       case '/payment-history':
//         return MaterialPageRoute(builder: (_) => PaymentHistoryScreen());

//       case '/hestoryPayments':
//         return MaterialPageRoute(builder: (_) => PaymentHistoryScreen());

//       case '/map':
//         final args = settings.arguments as Map<String, dynamic>? ?? {};
//         final onLocationSelected = args['onLocationSelected'] as Function(LocationModel)?;
//         return MaterialPageRoute(builder: (_) => LocationPickerScreen(
//           onLocationSelected: onLocationSelected ?? (LocationModel location) {},
//         ));
      
//       default:
//         return MaterialPageRoute(
//           builder: (_) => NotificationsScreen()
//         );
//     }
//   }

//   static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
//   }

//   static Future<dynamic> navigateAndReplace(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
//   }

//   static void goBack() {
//     navigatorKey.currentState!.pop();
//   }

//   // 🔔 دوال مساعدة للتنقل من الإشعارات
//   static Future<dynamic> navigateToOrderDetails(String orderId, {String orderType = 'fuel'}) {
//     return navigateTo('/order-details', arguments: {
//       'orderId': orderId,
//       'orderType': orderType,
//     });
//   }

//   static Future<dynamic> navigateToTrackOrder(String orderId, {String orderType = 'fuel'}) {
//     return navigateTo('/track-order', arguments: {
//       'orderId': orderId,
//       'orderType': orderType,
//     });
//   }

//   static Future<dynamic> navigateToChat(String orderId, String chatId) {
//     return navigateTo('/chat', arguments: {
//       'orderId': orderId,
//       'chatId': chatId,
//     });
//   }

//   static Future<dynamic> navigateToNotifications() {
//     return navigateTo('/notifications');
//   }

//   static Future<dynamic> navigateToStripePayment({
//   required double amount,
//   required String orderId,
//   required String currency,
// }) {
//   return navigateTo('/stripe-payment', arguments: {
//     'amount': amount,
//     'orderId': orderId,
//     'currency': currency,
//   });
// }

//   static Future<dynamic> navigateToPaymentProof(FuelOrderModel order, Map<String, dynamic> paymentData) {
//     return navigateTo('/payment-proof', arguments: {
//       'order': order,
//       'paymentData': paymentData,
//     });
//   }

//   // 🔔 دالة معالجة الإشعارات
//   static Future<void> handleNotificationNavigation(Map<String, dynamic> notificationData) async {
//     try {
//       final screen = notificationData['screen']?.toString() ?? '';
//       final orderId = notificationData['orderId']?.toString() ?? '';
//       final chatId = notificationData['chatId']?.toString() ?? '';
//       final orderType = notificationData['orderType']?.toString() ?? 'fuel';

//       print('🎯 معالجة إشعار: $screen - orderId: $orderId');

//       switch (screen) {
//         case 'OrderDetails':
//           if (orderId.isNotEmpty) {
//             await navigateToOrderDetails(orderId, orderType: orderType);
//           }
//           break;

//         case 'TrackOrder':
//           if (orderId.isNotEmpty) {
//             await navigateToTrackOrder(orderId, orderType: orderType);
//           }
//           break;

//         case 'ChatScreen':
//           if (orderId.isNotEmpty && chatId.isNotEmpty) {
//             await navigateToChat(orderId, chatId);
//           }
//           break;

//         case 'PaymentReview':
//           if (orderId.isNotEmpty) {
//             // يمكنك إضافة منطق إضافي هنا لـ PaymentReview
//             await navigateToOrderDetails(orderId, orderType: orderType);
//           }
//           break;

//         case 'FuelOrderDetails':
//           if (orderId.isNotEmpty) {
//             await navigateToOrderDetails(orderId, orderType: 'fuel');
//           }
//           break;

//         case 'Notifications':
//           await navigateToNotifications();
//           break;

//         default:
//           // إذا لم تكن هناك شاشة محددة، الانتقال لشاشة الإشعارات
//           await navigateToNotifications();
//           break;
//       }
//     } catch (e) {
//       print('❌ خطأ في معالجة الإشعار: $e');
//       // الانتقال لشاشة الإشعارات كبديل آمن
//       await navigateToNotifications();
//     }
//   }

//   // 🔔 دالة للتحقق من صحة البيانات قبل التنقل
//   static bool isValidNotificationData(Map<String, dynamic> data) {
//     final screen = data['screen']?.toString() ?? '';
//     final orderId = data['orderId']?.toString() ?? '';

//     // التحقق من وجود البيانات المطلوبة بناءً على الشاشة
//     switch (screen) {
//       case 'OrderDetails':
//       case 'TrackOrder':
//       case 'FuelOrderDetails':
//       case 'PaymentReview':
//         return orderId.isNotEmpty;
      
//       case 'ChatScreen':
//         return orderId.isNotEmpty && data['chatId']?.toString()?.isNotEmpty == true;
      
//       case 'Notifications':
//         return true;
      
//       default:
//         return false;
//     }
//   }
// }


import 'package:customer/data/models/fuel_order_model.dart';
import 'package:customer/data/models/location_model.dart';
import 'package:customer/presentation/screens/auth/login_screen.dart';
import 'package:customer/presentation/screens/auth/register_screen.dart';
import 'package:customer/presentation/screens/auth/reset_password_screen.dart';
import 'package:customer/presentation/screens/auth/splash_screen.dart';
import 'package:customer/presentation/screens/auth/verify_phone_screen.dart';
import 'package:customer/presentation/screens/chat/chat_screen.dart';
import 'package:customer/presentation/screens/fuelTransfer/fuel_transfer_request_screen.dart';
import 'package:customer/presentation/screens/home/companies_list_screen.dart';
import 'package:customer/presentation/screens/home/home_screen.dart';
import 'package:customer/presentation/screens/orders/fuel_order_screen.dart';
import 'package:customer/presentation/screens/orders/order_details_screen.dart';
import 'package:customer/presentation/screens/orders/orders_list_screen.dart';
import 'package:customer/presentation/screens/orders/track_order_screen.dart';
import 'package:customer/presentation/screens/payment/bank_transfer_screen.dart';
import 'package:customer/presentation/screens/payment/payment_history_screen.dart';
import 'package:customer/presentation/screens/payment/payment_proof_screen.dart';
import 'package:customer/presentation/screens/payment/stripe_payment_screen.dart';
import 'package:customer/presentation/screens/profile/addresses_screen.dart';
import 'package:customer/presentation/screens/supports/supports_helpr.dart';
import 'package:customer/presentation/widgets/address/location_picker.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case '/verify-phone':
        final phone = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => VerifyPhoneScreen(phone: phone ?? ''),
        );

      case '/reset-password':
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());

      case '/stripe-payment':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(builder: (_) => StripePaymentScreen(
          amount: args['amount'] ?? 0.0,
          orderId: args['orderId'] ?? '',
          currency: args['currency'] ?? 'SAR',
        ));

      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/fuel':
        return MaterialPageRoute(builder: (_) => FuelOrderScreen());

      case '/supports':
        return MaterialPageRoute(builder: (_) => HelpSupportScreen());

      case '/payment':
        final order = settings.arguments as FuelOrderModel;
        return MaterialPageRoute(builder: (_) => BankTransferScreen(order: order));

      case '/payment-proof':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => PaymentProofScreen(
          order: args['order'],
          paymentData: args['paymentData'],
        ));

      case '/track-order':
        final args = settings.arguments;
        String orderId = '';
        String orderType = 'fuel';
        if (args != null) {
          if (args is FuelOrderModel) {
            orderId = args.id;
          } else if (args is Map<String, dynamic>) {
            orderId = args['orderId'] ?? '';
            orderType = args['orderType'] ?? 'fuel';
          }
        }
        return MaterialPageRoute(
          builder: (_) => TrackOrderScreen(
            orderId: orderId,
            orderType: orderType,
          ),
        );

      case '/chat':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(builder: (_) => ChatScreen(
          chatId: args['chatId'] ?? '',
          orderId: args['orderId'] ?? '',
        ));

      case '/company':
        return MaterialPageRoute(builder: (_) => CompaniesListScreen());

      case '/addAddress':
        return MaterialPageRoute(builder: (_) => AddressesScreen());

      case '/fuel-orders':
        return MaterialPageRoute(builder: (_) => FuelOrdersListScreen());

      case '/fuel-trans':
        return MaterialPageRoute(builder: (_) => FuelTransferRequestScreen());

      case '/order-details':
      case '/orderDetails':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(builder: (_) => OrderDetailsScreen(
          orderId: args['orderId'] ?? '',
          orderType: args['orderType'] ?? 'fuel',
        ));

      case '/payment-history':
      case '/hestoryPayments':
        return MaterialPageRoute(builder: (_) => PaymentHistoryScreen());

      case '/map':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final onLocationSelected = args['onLocationSelected'] as Function(LocationModel)?;
        return MaterialPageRoute(builder: (_) => LocationPickerScreen(
          onLocationSelected: onLocationSelected ?? (LocationModel location) {},
        ));

      default:
        // ⚠️ أي صفحة غير معروفة تظهر صفحة الـ Splash أولاً
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
    }
  }

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateAndReplace(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    navigatorKey.currentState!.pop();
  }

  // 🔔 دوال مساعدة للتنقل من الإشعارات
  static Future<dynamic> navigateToOrderDetails(String orderId, {String orderType = 'fuel'}) {
    return navigateTo('/order-details', arguments: {
      'orderId': orderId,
      'orderType': orderType,
    });
  }

  static Future<dynamic> navigateToTrackOrder(String orderId, {String orderType = 'fuel'}) {
    return navigateTo('/track-order', arguments: {
      'orderId': orderId,
      'orderType': orderType,
    });
  }

  static Future<dynamic> navigateToChat(String orderId, String chatId) {
    return navigateTo('/chat', arguments: {
      'orderId': orderId,
      'chatId': chatId,
    });
  }

  static Future<dynamic> navigateToNotifications() {
    return navigateTo('/notifications');
  }

  static Future<dynamic> navigateToStripePayment({
    required double amount,
    required String orderId,
    required String currency,
  }) {
    return navigateTo('/stripe-payment', arguments: {
      'amount': amount,
      'orderId': orderId,
      'currency': currency,
    });
  }

  static Future<dynamic> navigateToPaymentProof(FuelOrderModel order, Map<String, dynamic> paymentData) {
    return navigateTo('/payment-proof', arguments: {
      'order': order,
      'paymentData': paymentData,
    });
  }

  // 🔔 دالة معالجة الإشعارات
  static Future<void> handleNotificationNavigation(Map<String, dynamic> notificationData) async {
    try {
      final screen = notificationData['screen']?.toString() ?? '';
      final orderId = notificationData['orderId']?.toString() ?? '';
      final chatId = notificationData['chatId']?.toString() ?? '';
      final orderType = notificationData['orderType']?.toString() ?? 'fuel';

      print('🎯 معالجة إشعار: $screen - orderId: $orderId');

      switch (screen) {
        case 'OrderDetails':
          if (orderId.isNotEmpty) {
            await navigateToOrderDetails(orderId, orderType: orderType);
          }
          break;

        case 'TrackOrder':
          if (orderId.isNotEmpty) {
            await navigateToTrackOrder(orderId, orderType: orderType);
          }
          break;

        case 'ChatScreen':
          if (orderId.isNotEmpty && chatId.isNotEmpty) {
            await navigateToChat(orderId, chatId);
          }
          break;

        case 'PaymentReview':
          if (orderId.isNotEmpty) {
            await navigateToOrderDetails(orderId, orderType: orderType);
          }
          break;

        case 'FuelOrderDetails':
          if (orderId.isNotEmpty) {
            await navigateToOrderDetails(orderId, orderType: 'fuel');
          }
          break;

        case 'Notifications':
          await navigateToNotifications();
          break;

        default:
          // لا نفعل أي شيء بشكل افتراضي
          break;
      }
    } catch (e) {
      print('❌ خطأ في معالجة الإشعار: $e');
    }
  }

  static bool isValidNotificationData(Map<String, dynamic> data) {
    final screen = data['screen']?.toString() ?? '';
    final orderId = data['orderId']?.toString() ?? '';

    switch (screen) {
      case 'OrderDetails':
      case 'TrackOrder':
      case 'FuelOrderDetails':
      case 'PaymentReview':
        return orderId.isNotEmpty;
      case 'ChatScreen':
        return orderId.isNotEmpty && data['chatId']?.toString()?.isNotEmpty == true;
      case 'Notifications':
        return true;
      default:
        return false;
    }
  }
}
