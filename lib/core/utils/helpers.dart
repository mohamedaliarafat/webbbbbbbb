// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:image_picker/image_picker.dart';
// import 'app_colors.dart';
// import 'app_constants.dart';

// class Helpers {
//   // فتح الرابط في المتصفح
//   static Future<void> launchUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   // فتح تطبيق الهاتف
//   static Future<void> makePhoneCall(String phoneNumber) async {
//     final uri = Uri.parse('tel:$phoneNumber');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $uri';
//     }
//   }

//   // فتح تطبيق البريد
//   static Future<void> sendEmail(String email) async {
//     final uri = Uri.parse('mailto:$email');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $uri';
//     }
//   }

//   // فتح الخريطة
//   static Future<void> openMap(double lat, double lng, String label) async {
//     final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $uri';
//     }
//   }

//   // اختيار صورة من المعرض
//   static Future<String?> pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     return pickedFile?.path;
//   }

//   // اختيار ملف
//   static Future<String?> pickFile() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     return pickedFile?.path;
//   }

//   // نسخ النص للحافظة
//   static Future<void> copyToClipboard(String text, BuildContext context) async {
//     await Clipboard.setData(ClipboardData(text: text));
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('تم النسخ')),
//     );
//   }

//   // التحقق من الاتصال بالإنترنت
//   static Future<bool> checkInternetConnection() async {
//     // يمكن استخدام package:connectivity_plus هنا
//     return true; // مؤقتاً
//   }

//   // تنسيق حجم الملف
//   static String formatFileSize(int bytes) {
//     if (bytes <= 0) return "0 B";
//     const suffixes = ["B", "KB", "MB", "GB"];
//     final i = (log(bytes) / log(1024)).floor();
//     return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
//   }

//   // إنشاء لون عشوائي
//   static Color generateRandomColor() {
//     final random = Random();
//     return Color.fromRGBO(
//       random.nextInt(256),
//       random.nextInt(256),
//       random.nextInt(256),
//       1,
//     );
//   }

//   // الحصول على لون بناءً على النص (للصورة الرمزية)
//   static Color getColorFromText(String text) {
//     int hash = 0;
//     for (int i = 0; i < text.length; i++) {
//       hash = text.codeUnitAt(i) + ((hash << 5) - hash);
//     }
    
//     final colors = [
//       AppColors.primary,
//       AppColors.secondary,
//       AppColors.info,
//       AppColors.success,
//       AppColors.warning,
//     ];
    
//     return colors[hash.abs() % colors.length];
//   }

//   // تحويل الوقت إلى توقيت محلي
//   static DateTime toLocalTime(DateTime utcTime) {
//     return utcTime.toLocal();
//   }

//   // تحويل الوقت إلى UTC
//   static DateTime toUtcTime(DateTime localTime) {
//     return localTime.toUtc();
//   }

//   // إنشاء معرف فريد
//   static String generateId() {
//     return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
//   }

//   // التحقق من صحة الصورة
//   static bool isValidImage(String path) {
//     final ext = path.toLowerCase().split('.').last;
//     return ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(ext);
//   }

//   // التحقق من صحة الملف
//   static bool isValidFile(String path) {
//     final ext = path.toLowerCase().split('.').last;
//     return ['pdf', 'doc', 'docx', 'xls', 'xlsx'].contains(ext);
//   }

//   // حساب العمر من التاريخ
//   static int calculateAge(DateTime birthDate) {
//     final now = DateTime.now();
//     int age = now.year - birthDate.year;
//     if (now.month < birthDate.month || 
//         (now.month == birthDate.month && now.day < birthDate.day)) {
//       age--;
//     }
//     return age;
//   }

//   // إخفاء جزء من النص (مثل رقم البطاقة)
//   static String maskText(String text, {int visibleStart = 4, int visibleEnd = 4}) {
//     if (text.length <= visibleStart + visibleEnd) return text;
    
//     final start = text.substring(0, visibleStart);
//     final end = text.substring(text.length - visibleEnd);
//     final masked = '*' * (text.length - visibleStart - visibleEnd);
    
//     return '$start$masked$end';
//   }

//   // تحويل القائمة إلى نص مفصول بفواصل
//   static String listToCommaString(List<dynamic> list) {
//     return list.map((e) => e.toString()).join(', ');
//   }
// }

// // فئة للمساعدة في التنقل
// class NavigationHelper {
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   static BuildContext? get context => navigatorKey.currentContext;

//   static Future<T?> push<T>(Widget page) {
//     return navigatorKey.currentState!.push<T>(
//       MaterialPageRoute(builder: (context) => page),
//     );
//   }

//   static void pop<T>([T? result]) {
//     navigatorKey.currentState!.pop<T>(result);
//   }

//   static Future<T?> pushReplacement<T>(Widget page) {
//     return navigatorKey.currentState!.pushReplacement<T, T>(
//       MaterialPageRoute(builder: (context) => page),
//     );
//   }

//   static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushNamed<T>(
//       routeName,
//       arguments: arguments,
//     );
//   }

//   static void popUntil(String routeName) {
//     navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
//   }
// }

// // فئة للمساعدة في التنسيق
// class FormatHelper {
//   static String formatPhoneNumber(String phone) {
//     if (phone.startsWith('+966')) {
//       return phone.replaceFirst('+966', '05');
//     }
//     return phone;
//   }

//   static String formatAddress(Map<String, dynamic> address) {
//     final parts = [
//       address['addressLine1'],
//       address['addressLine2'],
//       address['district'],
//       address['city'],
//     ].where((part) => part != null && part.isNotEmpty).toList();
    
//     return parts.join(', ');
//   }

//   static String formatOrderStatus(String status) {
//     final statusMap = {
//       'pending': 'قيد الانتظار',
//       'approved': 'تم الموافقة',
//       'waiting_payment': 'بانتظار الدفع',
//       'processing': 'قيد المعالجة',
//       'ready_for_delivery': 'جاهز للتوصيل',
//       'assigned_to_driver': 'تم التعيين للسائق',
//       'picked_up': 'تم الاستلام',
//       'in_transit': 'قيد التوصيل',
//       'delivered': 'تم التسليم',
//       'cancelled': 'ملغي',
//     };
    
//     return statusMap[status] ?? status;
//   }

//   static String formatPaymentStatus(String status) {
//     final statusMap = {
//       'hidden': 'مخفي',
//       'pending': 'قيد الانتظار',
//       'waiting_proof': 'بانتظار الإثبات',
//       'under_review': 'قيد المراجعة',
//       'verified': 'تم التحقق',
//       'failed': 'فشل',
//     };
    
//     return statusMap[status] ?? status;
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:customer/core/constants/app_constants.dart';
import 'package:customer/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  // Format date for display
  static String formatDate(DateTime date, {String format = AppConstants.displayDateFormat}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return date.toString();
    }
  }

  // Format date time for display
  static String formatDateTime(DateTime date, {String format = AppConstants.displayDateTimeFormat}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return date.toString();
    }
  }

  // Format date for API
  static String formatDateForApi(DateTime date) {
    return DateFormat(AppConstants.apiDateFormat).format(date);
  }

  // Format date time for API
  static String formatDateTimeForApi(DateTime date) {
    return DateFormat(AppConstants.apiDateTimeFormat).format(date.toUtc());
  }

  // Parse date from string
  static DateTime? parseDate(String dateString, {String format = AppConstants.apiDateFormat}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get relative time string
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return AppStrings.justNow;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${AppStrings.minutesAgo}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${AppStrings.hoursAgo}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${AppStrings.daysAgo}';
    } else {
      return formatDate(date);
    }
  }

  // Format currency
  static String formatCurrency(double amount, {String currency = AppConstants.currencySymbol}) {
    try {
      final formatter = NumberFormat.currency(
        symbol: currency,
        decimalDigits: 2,
        locale: 'ar_SA',
      );
      return formatter.format(amount);
    } catch (e) {
      return '$amount $currency';
    }
  }

  // Format number with commas
  static String formatNumber(double number, {int decimalDigits = 2}) {
    try {
      return NumberFormat.decimalPatternDigits(
        locale: 'ar_SA',
        decimalDigits: decimalDigits,
      ).format(number);
    } catch (e) {
      return number.toStringAsFixed(decimalDigits);
    }
  }

  // Calculate distance in readable format
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} ${AppStrings.meter}';
    } else {
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} ${AppStrings.km}';
    }
  }

  // Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Generate order number
  static String generateOrderNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final random = Random().nextInt(1000);
    return 'ORD${timestamp}_$random';
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }

  // Validate phone number format
  static bool isValidPhone(String phone) {
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final saudiPhoneRegex = RegExp(r'^05\d{8}$');
    final internationalRegex = RegExp(r'^\+9665\d{8}$');
    
    return saudiPhoneRegex.hasMatch(cleanedPhone) || 
           internationalRegex.hasMatch(cleanedPhone);
  }

  // Check if string is numeric
  static bool isNumeric(String str) {
    if (str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  // Get file size in readable format
  static String getFileSizeString(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  // Get file extension from path
  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  // Check if file is image
  static bool isImageFile(String path) {
    final ext = getFileExtension(path);
    return AppConstants.allowedImageTypes.contains(ext);
  }

  // Check if file is document
  static bool isDocumentFile(String path) {
    final ext = getFileExtension(path);
    return AppConstants.allowedDocumentTypes.contains(ext);
  }

  // Get temporary directory path
  static Future<String> getTempDirectory() async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  // Get documents directory path
  static Future<String> getDocumentsDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  // Launch URL
  static Future<bool> launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri as String);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Launch phone dialer
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final uri = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri as String);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Launch email
  static Future<bool> launchEmail(String email, {String? subject, String? body}) async {
    try {
      String uri = 'mailto:$email';
      if (subject != null) {
        uri += '?subject=${Uri.encodeComponent(subject)}';
      }
      if (body != null) {
        uri += '${subject != null ? '&' : '?'}body=${Uri.encodeComponent(body)}';
      }
      
      final emailUri = Uri.parse(uri);
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri as String);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get device info
  static Future<Map<String, String>> getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
      // 'package': Platform.packageName ?? 'Unknown',
    };
  }

  // Debounce function
  static Function debounce(Function func, Duration duration) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(duration, () => func());
    };
  }

  // Throttle function
  static Function throttle(Function func, Duration duration) {
    bool waiting = false;
    return () {
      if (!waiting) {
        func();
        waiting = true;
        Timer(duration, () => waiting = false);
      }
    };
  }

  // Deep copy of map
  static Map<String, dynamic> deepCopyMap(Map<String, dynamic> map) {
    return json.decode(json.encode(map));
  }

  // Merge two maps
  static Map<String, dynamic> mergeMaps(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    final result = Map<String, dynamic>.from(map1);
    result.addAll(map2);
    return result;
  }

  // Remove null values from map
  static Map<String, dynamic> removeNullValues(Map<String, dynamic> map) {
    map.removeWhere((key, value) => value == null);
    return map;
  }

  // Convert map to query string
  static String mapToQueryString(Map<String, dynamic> map) {
    final queryParams = map.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    
    return queryParams.isNotEmpty ? '?$queryParams' : '';
  }

  // Get color from hex
  static Color colorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.black;
    }
  }

  // Convert color to hex
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  // Calculate age from birth date
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Format duration
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  // Get initial from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    
    final names = name.split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    } else {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  // Get week number
  static int getWeekNumber(DateTime date) {
    final firstDay = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstDay).inDays;
    return ((daysDiff + firstDay.weekday) / 7).ceil();
  }

  // Generate QR code data
  static String generateQRCodeData(String type, String id) {
    return json.encode({
      'type': type,
      'id': id,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Parse QR code data
  static Map<String, dynamic>? parseQRCodeData(String data) {
    try {
      return json.decode(data);
    } catch (e) {
      return null;
    }
  }
}