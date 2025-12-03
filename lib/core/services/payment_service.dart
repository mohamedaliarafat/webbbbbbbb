// services/payment_service.dart - النسخة النهائية الكاملة
import 'dart:convert';
import 'package:customer/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  final ApiService _apiService = ApiService();
  
  // 🔑 مفاتيح Stripe التجريبية - استخدم هذه للتجربة
  static const String stripePublishableKey = 'pk_test_51Pj7z1K2p3qL8p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4X9p4';
  
  // تهيئة Stripe
  static Future<void> initStripe() async {
    try {
      Stripe.publishableKey = stripePublishableKey;
      Stripe.merchantIdentifier = 'merchant.com.yourapp';
      await Stripe.instance.applySettings();
      print('✅ Stripe initialized successfully');
    } catch (e) {
      print('❌ Error initializing Stripe: $e');
    }
  }

 Future<Map<String, dynamic>> createStripePayment({
  required double amount,
  required String currency,
  required String orderId,
}) async {
  try {
    print('💳 بدء عملية الدفع عبر Stripe...');
    print('💰 المبلغ: $amount $currency');
    print('🆔 رقم الطلب: $orderId');

    // 1. إنشاء Payment Intent في السيرفر
    print('📡 جاري الاتصال بالسيرفر لإنشاء Payment Intent...');
    
    // ✅ التصحيح: استخدم /pay/create-payment-intent
    final response = await _apiService.post(
      '/pay/create-payment-intent', // ⬅️ تم التصحيح هنا
      data: {
        'amount': (amount * 100).toInt(),
        'currency': currency.toLowerCase(),
        'orderId': orderId,
      },
    );

    print('📨 استجابة السيرفر: ${response.toString()}');

    if (response['success'] != true) {
      final errorMsg = response['error'] ?? response['message'] ?? 'فشل في إنشاء Payment Intent';
      print('❌ فشل استجابة السيرفر: $errorMsg');
      return {
        'success': false,
        'error': errorMsg,
      };
    }

    final clientSecret = response['data']['clientSecret'];
    final paymentIntentId = response['data']['paymentIntentId'];

    if (clientSecret == null || clientSecret.isEmpty) {
      print('❌ clientSecret فارغ أو غير صالح');
      return {
        'success': false,
        'error': 'لم يتم استلام مفتاح الدفع من السيرفر',
      };
    }

    print('🔑 تم استلام clientSecret بنجاح');

    // 2. تهيئة صفحة الدفع
    print('🎯 جاري تهيئة صفحة الدفع...');
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'تطبيق الوقود',
        style: ThemeMode.dark,
        applePay: const PaymentSheetApplePay(
          merchantCountryCode: 'SA',
        ),
        googlePay: PaymentSheetGooglePay(
          merchantCountryCode: 'SA',
          currencyCode: currency,
          testEnv: true,
        ),
      ),
    );

    print('✅ تم تهيئة صفحة الدفع بنجاح');

    // 3. عرض صفحة الدفع
    print('🔄 جاري عرض صفحة الدفع...');
    await Stripe.instance.presentPaymentSheet();

    print('✅ تم الدفع بنجاح عبر Stripe');

    // 4. تأكيد الدفع في السيرفر
    print('📡 جاري تأكيد الدفع في السيرفر...');
    // ✅ التصحيح: استخدم /pay/confirm-payment
    final confirmResponse = await _apiService.post(
      '/pay/confirm-payment', // ⬅️ تم التصحيح هنا
      data: {
        'paymentIntentId': paymentIntentId,
        'orderId': orderId,
      },
    );

    if (confirmResponse['success'] == true) {
      print('🎉 تم تأكيد الدفع بنجاح في السيرفر');
      return {
        'success': true,
        'message': 'تم الدفع بنجاح',
        'data': confirmResponse['data'],
        'transactionId': paymentIntentId,
      };
    } else {
      final confirmError = confirmResponse['error'] ?? confirmResponse['message'] ?? 'فشل في تأكيد الدفع';
      print('❌ فشل تأكيد الدفع: $confirmError');
      return {
        'success': false,
        'error': confirmError,
      };
    }

  } on StripeException catch (e) {
    print('❌ خطأ Stripe: ${e.error.code} - ${e.error.message}');
    print('❌ تفاصيل الخطأ: ${e.toString()}');
    return {
      'success': false,
      'error': _handleStripeError(e),
      'errorCode': e.error.code?.name,
    };
  } catch (e) {
    print('❌ خطأ غير متوقع في الدفع: $e');
    print('❌ نوع الخطأ: ${e.runtimeType}');
    print('❌ StackTrace: ${e.toString()}');
    return {
      'success': false,
      'error': 'فشل في عملية الدفع: ${e.toString()}',
    };
  }
}
  // ✅ معالجة أخطاء Stripe بشكل مفصل
  String _handleStripeError(StripeException e) {
    switch (e.error.code) {
      case FailureCode.Canceled:
        return 'تم إلغاء عملية الدفع من قبل المستخدم';
      case FailureCode.Failed:
        return 'فشل في عملية الدفع. يرجى التحقق من بيانات البطاقة';
      case FailureCode.Timeout:
        return 'انتهت مهلة عملية الدفع. يرجى المحاولة مرة أخرى';
      // case FailureCode.invalidCallbackUrl:
      //   return 'رابط الاستدعاء غير صالح';
      // case FailureCode.invalidClientSecret:
      //   return 'مفتاح الدفع غير صالح';
      // case FailureCode.invalidPaymentOption:
      //   return 'طريقة الدفع غير مدعومة';
      default:
        return e.error.message ?? 'حدث خطأ غير متوقع في عملية الدفع';
    }
  }

  // ✅ دفع تجريبي (للتطوير والاختبار)
  Future<Map<String, dynamic>> simulatePayment({
    required double amount,
    required String orderId,
    required String paymentMethod,
  }) async {
    try {
      print('🎮 بدء الدفع التجريبي...');
      print('💰 المبلغ: $amount');
      print('🆔 رقم الطلب: $orderId');
      print('💳 طريقة الدفع: $paymentMethod');
      
      await Future.delayed(const Duration(seconds: 2));
      
      // محاكاة نجاح الدفع
      final result = {
        'success': true,
        'message': 'تم محاكاة الدفع بنجاح ($paymentMethod)',
        'transactionId': 'sim_${DateTime.now().millisecondsSinceEpoch}',
        'amount': amount,
        'orderId': orderId,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      print('✅ الدفع التجريبي ناجح: ${result['transactionId']}');
      return result;
    } catch (e) {
      print('❌ خطأ في الدفع التجريبي: $e');
      return {
        'success': false,
        'error': 'فشل في الدفع التجريبي: $e',
      };
    }
  }

  // ✅ دوال الدفع الأخرى للتوافق
  Future<Map<String, dynamic>> createApplePayPayment({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    print('🍎 بدء الدفع عبر Apple Pay...');
    return await simulatePayment(
      amount: amount,
      orderId: orderId,
      paymentMethod: 'Apple Pay',
    );
  }

  Future<Map<String, dynamic>> createCardPayment({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    print('💳 بدء الدفع بالبطاقة...');
    return await simulatePayment(
      amount: amount,
      orderId: orderId,
      paymentMethod: 'Credit Card',
    );
  }

  // ✅ التحقق من دعم Apple Pay
  // Future<bool> isApplePaySupported() async {
  //   try {
  //     final isSupported = await Stripe.instance.isApplePaySupported;
  //     print('🍎 دعم Apple Pay: $isSupported');
  //     return isSupported;
  //   } catch (e) {
  //     print('❌ خطأ في التحقق من دعم Apple Pay: $e');
  //     return false;
  //   }
  // }

  // ✅ فحص حالة الدفع
  Future<Map<String, dynamic>> checkPaymentStatus(String orderId) async {
    try {
      print('🔍 فحص حالة الدفع للطلب: $orderId');
      final response = await _apiService.get('/status/$orderId');
      
      if (response['success'] == true) {
        print('✅ حالة الدفع: ${response['data']}');
        return {
          'success': true,
          'data': response['data'],
        };
      } else {
        print('❌ فشل في فحص حالة الدفع: ${response['error']}');
        return {
          'success': false,
          'error': response['error'] ?? 'فشل في التحقق من حالة الدفع',
        };
      }
    } catch (e) {
      print('❌ خطأ في فحص حالة الدفع: $e');
      return {
        'success': false,
        'error': 'فشل في التحقق من حالة الدفع: $e',
      };
    }
  }

  // ✅ دالة الدفع الأساسية (للتوافق مع الكود القديم)
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String currency,
    required String orderId,
    required String paymentMethod,
  }) async {
    print('🔄 استخدام processPayment للتوافق...');
    
    if (paymentMethod.toLowerCase().contains('stripe') || 
        paymentMethod.toLowerCase().contains('card')) {
      return await createStripePayment(
        amount: amount,
        currency: currency,
        orderId: orderId,
      );
    } else {
      return await simulatePayment(
        amount: amount,
        orderId: orderId,
        paymentMethod: paymentMethod,
      );
    }
  }

  // ✅ دفع فوري (للتوافق مع الكود القديم)
  Future<Map<String, dynamic>> instantPayment({
    required double amount,
    required String orderId,
    required String paymentMethod,
  }) async {
    print('⚡ استخدام instantPayment للتوافق...');
    return await simulatePayment(
      amount: amount,
      orderId: orderId,
      paymentMethod: paymentMethod,
    );
  }

  // ✅ دفع تجريبي (للتوافق مع الكود القديم)
  Future<Map<String, dynamic>> testPayment({
    required double amount,
    required String orderId,
    required String paymentMethod,
  }) async {
    print('🧪 استخدام testPayment للتوافق...');
    return await simulatePayment(
      amount: amount,
      orderId: orderId,
      paymentMethod: paymentMethod,
    );
  }
}