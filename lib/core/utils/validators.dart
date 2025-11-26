class Validators {
  // Empty validation
  static String? validateEmpty(String? value, {String fieldName = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    // Remove any non-digit characters
    final cleanedPhone = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Saudi phone number validation (starts with 05 and 9 digits)
    final saudiPhoneRegex = RegExp(r'^05\d{8}$');
    
    // International format (starts with +9665 and 8 digits)
    final internationalRegex = RegExp(r'^\+9665\d{8}$');

    if (!saudiPhoneRegex.hasMatch(cleanedPhone) && 
        !internationalRegex.hasMatch(cleanedPhone)) {
      return 'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 05 ويحتوي على 10 أرقام';
    }

    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صحيح';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < 6) {
      return 'كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل';
    }

    if (value.length > 128) {
      return 'كلمة المرور يجب أن لا تتعدى 128 حرف';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }

    if (value != originalPassword) {
      return 'كلمات المرور غير متطابقة';
    }

    return null;
  }

  // Verification code validation
  static String? validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز التحقق مطلوب';
    }

    if (value.length != 6) {
      return 'رمز التحقق يجب أن يحتوي على 6 أرقام';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'يجب أن يحتوي رمز التحقق على أرقام فقط';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value, {String fieldName = 'الاسم'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    if (value.trim().length < 2) {
      return '$fieldName يجب أن يحتوي على حرفين على الأقل';
    }

    if (value.trim().length > 50) {
      return '$fieldName يجب أن لا يتعدى 50 حرف';
    }

    // Allow Arabic and English letters, spaces, and some special characters
    final nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s\-\.]+$');

   if (!nameRegex.hasMatch(value.trim())) {
  return 'يحتوي على رموز غير مسموحة'; // أو اسم الحقل مباشرة
}

    return null;
  }

  // Address validation
  static String? validateAddress(String? value, {String fieldName = 'العنوان'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    if (value.trim().length < 5) {
      return '$fieldName يجب أن يحتوي على 5 أحرف على الأقل';
    }

    if (value.trim().length > 200) {
      return '$fieldName يجب أن لا يتعدى 200 حرف';
    }

    return null;
  }

  // City validation
  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'المدينة مطلوبة';
    }

    if (value.trim().length < 2) {
      return 'اسم المدينة يجب أن يحتوي على حرفين على الأقل';
    }

    return null;
  }

  // Postal code validation
  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Postal code is optional
    }

    // Saudi postal code validation (5 digits)
    final postalCodeRegex = RegExp(r'^\d{5}$');

    if (!postalCodeRegex.hasMatch(value.trim())) {
      return 'الرمز البريدي يجب أن يحتوي على 5 أرقام';
    }

    return null;
  }

  // Number validation
  static String? validateNumber(String? value, {
    String fieldName = 'القيمة',
    double? minValue,
    double? maxValue,
    bool isRequired = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? '$fieldName مطلوبة' : null;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName يجب أن تكون رقمية';
    }

    if (minValue != null && number < minValue) {
      return '$fieldName يجب أن تكون $minValue على الأقل';
    }

    if (maxValue != null && number > maxValue) {
      return '$fieldName يجب أن تكون $maxValue على الأكثر';
    }

    return null;
  }

  // Integer validation
  static String? validateInteger(String? value, {
    String fieldName = 'القيمة',
    int? minValue,
    int? maxValue,
    bool isRequired = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? '$fieldName مطلوبة' : null;
    }

    final integer = int.tryParse(value);
    if (integer == null) {
      return '$fieldName يجب أن تكون رقمية صحيحة';
    }

    if (minValue != null && integer < minValue) {
      return '$fieldName يجب أن تكون $minValue على الأقل';
    }

    if (maxValue != null && integer > maxValue) {
      return '$fieldName يجب أن تكون $maxValue على الأكثر';
    }

    return null;
  }

  // Fuel liters validation
  static String? validateFuelLiters(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كمية الوقود مطلوبة';
    }

    final liters = int.tryParse(value);
    if (liters == null) {
      return 'كمية الوقود يجب أن تكون رقمية';
    }

    if (liters < 1) {
      return 'كمية الوقود يجب أن تكون 1 لتر على الأقل';
    }

    if (liters > 100) {
      return 'كمية الوقود يجب أن تكون 100 لتر على الأكثر';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(String? value, {String fieldName = 'السعر'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return '$fieldName يجب أن يكون رقمية';
    }

    if (price <= 0) {
      return '$fieldName يجب أن يكون أكبر من صفر';
    }

    if (price > 1000000) {
      return '$fieldName كبير جداً';
    }

    return null;
  }

  // Description validation
  static String? validateDescription(String? value, {
    String fieldName = 'الوصف',
    int minLength = 10,
    int maxLength = 500,
    bool isRequired = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? '$fieldName مطلوب' : null;
    }

    if (value.trim().length < minLength) {
      return '$fieldName يجب أن يحتوي على $minLength أحرف على الأقل';
    }

    if (value.trim().length > maxLength) {
      return '$fieldName يجب أن لا يتعدى $maxLength حرف';
    }

    return null;
  }

  // Date validation
  static String? validateDate(String? value, {String fieldName = 'التاريخ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'صيغة التاريخ غير صحيحة';
    }
  }

  // Time validation
  static String? validateTime(String? value, {String fieldName = 'الوقت'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    
    if (!timeRegex.hasMatch(value)) {
      return 'صيغة الوقت غير صحيحة (HH:MM)';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'الرابط مطلوب' : null;
    }

    final urlRegex = RegExp(
      r'^(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/\S*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'الرابط غير صحيح';
    }

    return null;
  }

  // File validation
  static String? validateFile(String? filePath, {
    String fieldName = 'الملف',
    List<String>? allowedExtensions,
    int maxSizeInMB = 10,
    bool isRequired = true,
  }) {
    if (filePath == null || filePath.isEmpty) {
      return isRequired ? '$fieldName مطلوب' : null;
    }

    // Check file extension
    if (allowedExtensions != null) {
      final extension = filePath.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        return 'نوع الملف غير مسموح. المسموح: ${allowedExtensions.join(', ')}';
      }
    }

    // Note: File size validation should be done when actually reading the file
    // This is just a placeholder for the validation structure

    return null;
  }

  // Multiple fields validation
  static Map<String, String> validateMultiple(Map<String, String> fields) {
    final errors = <String, String>{};

    fields.forEach((fieldName, value) {
      final error = validateEmpty(value, fieldName: fieldName);
      if (error != null) {
        errors[fieldName] = error;
      }
    });

    return errors;
  }

  // Credit card validation (for future use)
  static String? validateCreditCard(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم البطاقة مطلوب';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');

    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'رقم البطاقة غير صحيح';
    }

    // Luhn algorithm check
    if (!_isValidLuhn(cleaned)) {
      return 'رقم البطاقة غير صحيح';
    }

    return null;
  }

  // Luhn algorithm for credit card validation
  static bool _isValidLuhn(String cardNumber) {
    try {
      int sum = 0;
      bool isEven = false;

      for (int i = cardNumber.length - 1; i >= 0; i--) {
        int digit = int.parse(cardNumber[i]);

        if (isEven) {
          digit *= 2;
          if (digit > 9) {
            digit -= 9;
          }
        }

        sum += digit;
        isEven = !isEven;
      }

      return sum % 10 == 0;
    } catch (e) {
      return false;
    }
  }

  // CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV مطلوب';
    }

    final cvvRegex = RegExp(r'^\d{3,4}$');

    if (!cvvRegex.hasMatch(value.trim())) {
      return 'CVV يجب أن يحتوي على 3 أو 4 أرقام';
    }

    return null;
  }

  // Expiry date validation
  static String? validateExpiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'تاريخ الانتهاء مطلوب';
    }

    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');

    if (!expiryRegex.hasMatch(value.trim())) {
      return 'صيغة التاريخ غير صحيحة (MM/YY)';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}'); // Convert to full year

    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0); // Last day of expiry month

    if (expiryDate.isBefore(now)) {
      return 'البطاقة منتهية الصلاحية';
    }

    return null;
  }
}