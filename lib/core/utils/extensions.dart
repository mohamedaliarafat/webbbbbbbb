import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// String extensions
extension StringExtensions on String {
  // Check if string is empty or null
  bool get isNullOrEmpty => isEmpty;

  // Check if string is not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  // Capitalize first letter
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  // Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  // Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  // Check if string is numeric
  bool get isNumeric {
    if (isEmpty) return false;
    return double.tryParse(this) != null;
  }

  // Check if string is email
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(this);
  }

  // Check if string is phone number
  bool get isPhone {
    final cleanedPhone = replaceAll(RegExp(r'[^\d+]'), '');
    final saudiPhoneRegex = RegExp(r'^05\d{8}$');
    final internationalRegex = RegExp(r'^\+9665\d{8}$');
    
    return saudiPhoneRegex.hasMatch(cleanedPhone) || 
           internationalRegex.hasMatch(cleanedPhone);
  }

  // Truncate with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Parse to int
  int? toInt() => int.tryParse(this);

  // Parse to double
  double? toDouble() => double.tryParse(this);

  // Parse to DateTime
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }

  // Convert to currency format
  String toCurrency({String symbol = 'ر.س'}) {
    final number = toDouble();
    if (number == null) return this;
    
    try {
      final formatter = NumberFormat.currency(
        symbol: symbol,
        decimalDigits: 2,
        locale: 'ar_SA',
      );
      return formatter.format(number);
    } catch (e) {
      return '$this $symbol';
    }
  }

  // Get file extension
  String get fileExtension {
    final parts = split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  // Check if string is image file
  bool get isImageFile {
    final ext = fileExtension;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  // Check if string is document file
  bool get isDocumentFile {
    final ext = fileExtension;
    return ['pdf', 'doc', 'docx', 'txt'].contains(ext);
  }

  // Mask sensitive data (like phone numbers)
  String mask({int start = 3, int end = 2, String maskChar = '*'}) {
    if (length < start + end) return this;
    
    final visibleStart = substring(0, start);
    final visibleEnd = substring(length - end);
    final maskedLength = length - start - end;
    final masked = maskChar * maskedLength;
    
    return '$visibleStart$masked$visibleEnd';
  }
}

// DateTime extensions
extension DateTimeExtensions on DateTime {
  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  // Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  // Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  // Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  // Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  // Get age from birth date
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  // Format date
  String format({String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(this);
  }

  // Format date time
  String formatDateTime({String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern).format(this);
  }

  // Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقائق';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعات';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} أيام';
    } else {
      return format();
    }
  }

  // Add business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    var result = this;
    for (var i = 0; i < days; i++) {
      result = result.add(const Duration(days: 1));
      // Skip weekends (Friday and Saturday)
      while (result.weekday == 5 || result.weekday == 6) {
        result = result.add(const Duration(days: 1));
      }
    }
    return result;
  }

  // Check if date is weekend
  bool get isWeekend {
    return weekday == 5 || weekday == 6; // Friday or Saturday
  }

  // Check if date is weekday
  bool get isWeekday => !isWeekend;
}

// Int extensions
extension IntExtensions on int {
  // Convert to duration in seconds
  Duration get seconds => Duration(seconds: this);

  // Convert to duration in minutes
  Duration get minutes => Duration(minutes: this);

  // Convert to duration in hours
  Duration get hours => Duration(hours: this);

  // Convert to duration in days
  Duration get days => Duration(days: this);

  // Format as currency
  String toCurrency({String symbol = 'ر.س'}) {
    try {
      final formatter = NumberFormat.currency(
        symbol: symbol,
        decimalDigits: 0,
        locale: 'ar_SA',
      );
      return formatter.format(this);
    } catch (e) {
      return '$this $symbol';
    }
  }

  // Format with commas
  String get withCommas {
    return NumberFormat.decimalPattern('ar_SA').format(this);
  }

  // Check if number is even
  bool get isEven => this % 2 == 0;

  // Check if number is odd
  bool get isOdd => this % 2 != 0;

  // Check if number is positive
  bool get isPositive => this > 0;

  // Check if number is negative
  bool get isNegative => this < 0;

  // Check if number is zero
  bool get isZero => this == 0;

  // Convert to double
  double toDouble() => toDouble();

  // Convert to string with leading zero
  String toStringWithLeadingZero(int width) {
    return toString().padLeft(width, '0');
  }
}

// Double extensions
extension DoubleExtensions on double {
  // Format as currency
  String toCurrency({String symbol = 'ر.س', int decimalDigits = 2}) {
    try {
      final formatter = NumberFormat.currency(
        symbol: symbol,
        decimalDigits: decimalDigits,
        locale: 'ar_SA',
      );
      return formatter.format(this);
    } catch (e) {
      return '${toStringAsFixed(decimalDigits)} $symbol';
    }
  }

  // Format with commas
  String withCommas({int decimalDigits = 2}) {
    return NumberFormat.decimalPatternDigits(
      locale: 'ar_SA',
      decimalDigits: decimalDigits,
    ).format(this);
  }

  // Round to nearest
  double roundToNearest(double nearest) {
    return (this / nearest).round() * nearest;
  }

  // Check if number is integer
  bool get isInteger => this == roundToDouble();

  // Convert to int
  int toInt() => round();

  // Check if number is positive
  bool get isPositive => this > 0;

  // Check if number is negative
  bool get isNegative => this < 0;

  // Check if number is zero
  bool get isZero => this == 0;

  // Convert to percentage string
  String toPercentage({int decimalDigits = 1}) {
    return '${(this * 100).toStringAsFixed(decimalDigits)}%';
  }
}

// List extensions
extension ListExtensions<T> on List<T> {
  // Check if list is empty or null
  bool get isNullOrEmpty => isEmpty;

  // Check if list is not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  // Get safe element at index
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  // Get first element or null
  T? get firstOrNull => isNotEmpty ? first : null;

  // Get last element or null
  T? get lastOrNull => isNotEmpty ? last : null;

  // Split list into chunks
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  // Remove duplicates
  List<T> removeDuplicates() {
    return toSet().toList();
  }

  // Remove null values
  List<T> removeNulls() {
    return where((element) => element != null).toList();
  }

  // Toggle element (add if not exists, remove if exists)
  List<T> toggle(T element) {
    final newList = List<T>.from(this);
    if (contains(element)) {
      newList.remove(element);
    } else {
      newList.add(element);
    }
    return newList;
  }

  // Convert to comma separated string
  String toCommaSeparatedString() {
    return join(', ');
  }
}

// Map extensions
extension MapExtensions<K, V> on Map<K, V> {
  // Check if map is empty or null
  bool get isNullOrEmpty => isEmpty;

  // Check if map is not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  // Get value or null
  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  // Remove null values
  Map<K, V> removeNulls() {
    return Map<K, V>.from(this)..removeWhere((key, value) => value == null);
  }

  // Merge with another map
  Map<K, V> merge(Map<K, V> other) {
    return Map<K, V>.from(this)..addAll(other);
  }

  // Convert to query string
  String toQueryString() {
    final queryParams = entries
        .where((entry) => entry.value != null)
        .map((entry) => '${Uri.encodeComponent(entry.key.toString())}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    
    return queryParams.isNotEmpty ? '?$queryParams' : '';
  }
}

// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  // Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  // Get screen width
  double get screenWidth => screenSize.width;

  // Get screen height
  double get screenHeight => screenSize.height;

  // Check if screen is small (mobile)
  bool get isSmallScreen => screenWidth < 600;

  // Check if screen is medium (tablet)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  // Check if screen is large (desktop)
  bool get isLargeScreen => screenWidth >= 1200;

  // Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Get theme
  ThemeData get theme => Theme.of(this);

  // Check if dark mode is enabled
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Navigate to route
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  // Navigate and replace
  Future<T?> navigateReplacement<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  // Navigate and remove until
  Future<T?> navigateAndRemoveUntil<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}