import 'package:customer/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle heading6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Caption text
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle captionBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Button text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.4,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.4,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.4,
  );

  // Label text
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Overline text
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 1.5,
  );

  // Special text styles
  static const TextStyle priceLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.navyBlueAccent,
    height: 1.2,
  );

  static const TextStyle priceMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.navyBlueAccent,
    height: 1.3,
  );

  static const TextStyle priceSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.navyBlueAccent,
    height: 1.4,
  );

  static const TextStyle discount = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    height: 1.4,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle successText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.success,
    height: 1.4,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    height: 1.4,
  );

  static const TextStyle warningText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.warning,
    height: 1.4,
  );

  static const TextStyle infoText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.info,
    height: 1.4,
  );

  // Chat text styles
  static const TextStyle chatMessage = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle chatTimestamp = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
    height: 1.2,
  );

  static const TextStyle chatSender = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  // Glass effect text styles
  static const TextStyle glassHeading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 10,
        color: Colors.black38,
        offset: Offset(2, 2),
      ),
    ],
  );

  static const TextStyle glassSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    shadows: [
      Shadow(
        blurRadius: 5,
        color: Colors.black26,
        offset: Offset(1, 1),
      ),
    ],
  );

  static const TextStyle glassBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 3,
        color: Colors.black12,
        offset: Offset(1, 1),
      ),
    ],
  );

  // Navigation text styles
  static const TextStyle navSelected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.navyBlueAccent,
    height: 1.4,
  );

  static const TextStyle navUnselected = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Card text styles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle cardValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.navyBlueAccent,
    height: 1.3,
  );

  // Form text styles
  static const TextStyle formLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle formHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
    height: 1.4,
  );

  static const TextStyle formError = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );

  // Order status text styles
  static TextStyle orderStatus(String status) {
    Color color = AppColors.getStatusColor(status);
    
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
      shadows: [
        Shadow(
          blurRadius: 4,
          color: color.withOpacity(0.3),
          offset: const Offset(1, 1),
        ),
      ],
    );
  }

  // Payment status text styles
  static TextStyle paymentStatus(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'waiting_proof':
        color = AppColors.warning;
      case 'verified':
      case 'completed':
        color = AppColors.success;
      case 'failed':
      case 'rejected':
      case 'cancelled':
        color = AppColors.error;
      case 'under_review':
      case 'processing':
        color = AppColors.info;
      default:
        color = AppColors.textSecondary;
    }

    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
    );
  }

  // Fuel type text styles
  static TextStyle fuelType(String fuelType) {
    Color color = AppColors.getFuelTypeColor(fuelType);
    
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
    );
  }

  // Badge text styles
  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle badgeLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
  );

  // Statistics text styles
  static const TextStyle statValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
    height: 1.4,
  );

  // Profile text styles
  static const TextStyle profileName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.3,
  );

  static const TextStyle profileDetail = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
    height: 1.4,
  );

  // Text theme for Material 3
  static TextTheme get textTheme {
    return TextTheme(
      // Headlines
      headlineLarge: heading1,
      headlineMedium: heading2,
      headlineSmall: heading3,

      // Titles
      titleLarge: heading4,
      titleMedium: heading5,
      titleSmall: heading6,

      // Body
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,

      // Label
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,

      // Display (not commonly used)
      displayLarge: heading1,
      displayMedium: heading2,
      displaySmall: heading3,
    );
  }

  // Helper methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  static TextStyle withShadow(TextStyle style, List<Shadow> shadows) {
    return style.copyWith(shadows: shadows);
  }

  // Glass effect helper
  static TextStyle getGlassTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      shadows: const [
        Shadow(
          blurRadius: 5,
          color: Colors.black26,
          offset: Offset(1, 1),
        ),
      ],
    );
  }

  // Gradient text style (for special headings)
  static TextStyle getGradientText({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: [
            AppColors.navyBlueAccent,
            AppColors.navyBlueAccentLight,
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
      height: 1.2,
    );
  }
}