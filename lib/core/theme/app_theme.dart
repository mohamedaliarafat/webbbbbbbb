import 'dart:ui';

import 'package:customer/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الوضع الداكن - التصميم الزجاجي الأسود والكحلي
  static ThemeData get darkTheme {
    return ThemeData(
      // الألوان الأساسية
      primaryColor: AppColors.navyBlue,
      primaryColorDark: AppColors.navyBlueLight,
      primaryColorLight: AppColors.navyBlueLighter,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.navyBlueAccent,
        primaryContainer: AppColors.navyBlueAccentLight,
        secondary: AppColors.navyBlue,
        secondaryContainer: AppColors.navyBlueLight,
        surface: AppColors.glassBlack,
        background: AppColors.glassBlack,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),

      // نص الثيم
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        // العناوين
        displayLarge: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        
        // العناوين الرئيسية
        headlineLarge: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        
        // العناوين الفرعية
        titleLarge: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.cairo(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        
        // النصوص الأساسية
        bodyLarge: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: GoogleFonts.cairo(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        
        // النصوص على الأزرار
        labelLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.cairo(
          color: AppColors.textHint,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),

      // Bottom Navigation Bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.glassBlack.withOpacity(0.9),
        selectedItemColor: AppColors.navyBlueAccent,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(
          fontSize: 11,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.navyBlueAccent,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navyBlueAccent,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shadowColor: AppColors.navyBlueAccent.withOpacity(0.4),
        ),
      ),

      // Text Button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Outlined Button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white10,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.navyBlueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.cairo(
          color: AppColors.textHint,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.cairo(
          color: AppColors.textHint,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.cairo(
          color: AppColors.error,
          fontSize: 12,
        ),
        suffixIconColor: AppColors.textSecondary,
        prefixIconColor: AppColors.textSecondary,
      ),

      // Card theme
      // cardTheme: CardTheme(
      //   color: AppColors.cardDark,
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(20),
      //   ),
      //   margin: const EdgeInsets.all(8),
      //   shadowColor: AppColors.shadowDark,
      // ),

      // // Dialog theme
      // dialogTheme: DialogTheme(
      //   backgroundColor: AppColors.glassBlack,
      //   elevation: 8,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(20),
      //   ),
      //   titleTextStyle: GoogleFonts.cairo(
      //     fontSize: 18,
      //     fontWeight: FontWeight.bold,
      //     color: AppColors.textPrimary,
      //   ),
      //   contentTextStyle: GoogleFonts.cairo(
      //     fontSize: 14,
      //     color: AppColors.textSecondary,
      //   ),
      // ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white10,
        selectedColor: AppColors.navyBlueAccent,
        secondarySelectedColor: AppColors.navyBlue,
        labelStyle: GoogleFonts.cairo(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        secondaryLabelStyle: GoogleFonts.cairo(
          fontSize: 14,
          color: Colors.white,
        ),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.navyBlueAccent,
        linearTrackColor: AppColors.borderLight,
        circularTrackColor: AppColors.borderLight,
      ),

      // Snack bar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.glassBlack,
        contentTextStyle: GoogleFonts.cairo(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actionTextColor: AppColors.navyBlueAccent,
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.glassBlack,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        modalBackgroundColor: AppColors.glassBlack.withOpacity(0.8),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.navyBlueAccent;
          }
          return AppColors.textDisabled;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.navyBlueAccent.withOpacity(0.5);
          }
          return AppColors.textDisabled.withOpacity(0.5);
        }),
        trackOutlineColor: MaterialStateProperty.resolveWith<Color>((states) {
          return AppColors.borderLight;
        }),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.navyBlueAccent;
          }
          return AppColors.textSecondary;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.navyBlueAccent;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Use material 3
      useMaterial3: true,

      // Scaffold background
      scaffoldBackgroundColor: AppColors.glassBlack,
      
      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // الوضع الفاتح - نفس التصميم الزجاجي
  static ThemeData get lightTheme {
    return darkTheme.copyWith(
      brightness: Brightness.light,
      // يمكن إضافة تعديلات إضافية للوضع الفاتح هنا
    );
  }

  // الحصول على الثيم بناءً على الوضع
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }

  // تأثيرات الزجاج المخصصة
  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      gradient: AppColors.glassGradient,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.white10),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowDark,
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration get navyGlassDecoration {
    return BoxDecoration(
      gradient: AppColors.navyGradient,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.white20),
      boxShadow: [
        BoxShadow(
          color: AppColors.navyBlue.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static Widget createGlassContainer({
    required Widget child,
    double borderRadius = 20,
    bool useNavy = false,
  }) {
    return Container(
      decoration: useNavy ? AppTheme.navyGlassDecoration : AppTheme.glassDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: (useNavy ? AppColors.navyBlue : AppColors.glassBlack).withOpacity(0.3),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}