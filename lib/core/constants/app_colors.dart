import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية - الأسود الزجاجي والكحلي
  static const Color glassBlack = Color(0xFF0A0E21);
  static const Color glassBlackLight = Color(0xFF1A1A2E);
  static const Color glassBlackLighter = Color(0xFF16213E);
  
  static const Color navyBlue = Color(0xFF1A237E);
  static const Color navyBlueLight = Color(0xFF283593);
  static const Color navyBlueLighter = Color(0xFF303F9F);
  static const Color navyBlueAccent = Color(0xFF7986CB);
  static const Color navyBlueAccentLight = Color(0xFF9FA8DA);

  // ألوان التدرجات الزجاجية
  static const Gradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      glassBlack,
      navyBlue,
      glassBlackLight,
    ],
  );

  static const Gradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      navyBlue,
      navyBlueLight,
      navyBlueLighter,
    ],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      navyBlueAccent,
      navyBlueAccentLight,
    ],
  );

  // ألوان النصوص
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textHint = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFF808080);

  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // ألوان إضافية
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);

  static const Color black10 = Color(0x1A000000);
  static const Color black20 = Color(0x33000000);
  static const Color black30 = Color(0x4D000000);
  static const Color black50 = Color(0x80000000);

  // ألوان البطاقات وال containers
  static const Color cardDark = Color(0xFF1A1A2E);
  static const Color cardLight = Color(0xFF16213E);
  static const Color surfaceDark = Color(0xFF0F3460);
  static const Color surfaceLight = Color(0xFF1F4068);

  // ألوان الأزرار
  static const Color buttonPrimary = navyBlueAccent;
  static const Color buttonSecondary = Color(0xFF3949AB);
  static const Color buttonDisabled = Color(0xFF424242);

  // ألوان الحدود
  static const Color borderLight = Color(0x1AFFFFFF);
  static const Color borderMedium = Color(0x33FFFFFF);
  static const Color borderDark = Color(0x4DFFFFFF);

  // ألوان الظلال
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  // ألوان خاصة بالوقود
  static const Color fuelPetrol = Color(0xFFFF5722);
  static const Color fuelDiesel = Color(0xFF795548);
  static const Color fuelPremium = Color(0xFFFF9800);
  static const Color fuelKerosene = Color(0xFF607D8B);

  // ألوان حالة الطلبات
  static const Color orderPending = Color(0xFFFFC107);
  static const Color orderApproved = Color(0xFF4CAF50);
  static const Color orderProcessing = Color(0xFF2196F3);
  static const Color orderDelivered = Color(0xFF4CAF50);
  static const Color orderCancelled = Color(0xFFF44336);
  static const Color orderWaiting = Color(0xFFFF9800);

  // طرق مساعدة
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return orderPending;
      case 'approved':
        return orderApproved;
      case 'processing':
      case 'in_progress':
        return orderProcessing;
      case 'delivered':
      case 'completed':
        return orderDelivered;
      case 'cancelled':
      case 'rejected':
        return orderCancelled;
      case 'waiting':
      case 'waiting_payment':
        return orderWaiting;
      default:
        return textHint;
    }
  }

  static Color getFuelTypeColor(String fuelType) {
    switch (fuelType.toLowerCase()) {
      case '91':
      case '95':
      case '98':
        return fuelPetrol;
      case 'diesel':
      case 'premium_diesel':
        return fuelDiesel;
      case 'kerosene':
        return fuelKerosene;
      default:
        return fuelPremium;
    }
  }

  // تأثيرات الزجاج
  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      gradient: glassGradient,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: white10),
      boxShadow: [
        BoxShadow(
          color: shadowDark,
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration get navyGlassDecoration {
    return BoxDecoration(
      gradient: navyGradient,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: white20),
      boxShadow: [
        BoxShadow(
          color: navyBlue.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static BoxDecoration get accentGlassDecoration {
    return BoxDecoration(
      gradient: accentGradient,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: navyBlueAccent.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}