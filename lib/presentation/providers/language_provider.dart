import 'package:customer/core/languages/translations/transf/fuel_transfer_ar.dart';
import 'package:customer/core/languages/translations/transf/fuel_transfer_bn.dart';
import 'package:customer/core/languages/translations/transf/fuel_transfer_en.dart';
import 'package:customer/core/languages/translations/transf/fuel_transfer_hi.dart';
import 'package:customer/core/languages/translations/transf/fuel_transfer_ne.dart';
import 'package:customer/core/languages/translations/transf/fuel_transfer_tl.dart';
import 'package:customer/core/languages/translations/transf/fuel_transfer_ur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer/core/languages/translations/home_ar.dart';
import 'package:customer/core/languages/translations/home_en.dart';
import 'package:customer/core/languages/translations/home_bn.dart';
import 'package:customer/core/languages/translations/home_hi.dart';
import 'package:customer/core/languages/translations/home_ur.dart';
import 'package:customer/core/languages/translations/home_ne.dart';
import 'package:customer/core/languages/translations/home_tl.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('ar', 'SA');
  Locale get locale => _locale;

  Map<String, Map<String, String>> _translations = {};

  LanguageProvider() {
    _loadTranslations();
    _loadSavedLocale();
  }

  void _loadTranslations() {
    _translations = {
       'ar': {...homeArabicTranslations, ...fuelTransferArabicTranslations},
      'en': {...homeEnglishTranslations, ...fuelTransferEnglishTranslations},
      'bn': {...homeBengaliTranslations, ...fuelTransferBengaliTranslations },
      'hi': {...homeHindiTranslations, ...fuelTransferHindiTranslations },
      'ur': {...homeUrduTranslations, ...fuelTransferUrduTranslations},
      'ne': {...homeNepaliTranslations, ...fuelTransferNepaliTranslations },
      'tl': {...homeFilipinoTranslations, ...fuelTransferFilipinoTranslations}
    };
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code') ?? 'ar';
      final countryCode = prefs.getString('country_code') ?? 'SA';
      
      // التحقق من أن اللغة مدعومة
      if (_translations.containsKey(languageCode)) {
        _locale = Locale(languageCode, countryCode);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved locale: $e');
    }
  }

  String translate(String key) {
    return _translations[_locale.languageCode]?[key] ?? 
           _translations['en']?[key] ?? 
           key;
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (!_translations.containsKey(newLocale.languageCode)) {
      return;
    }

    _locale = newLocale;
    
    // حفظ التفضيلات
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', newLocale.languageCode);
      await prefs.setString('country_code', newLocale.countryCode ?? '');
    } catch (e) {
      print('Error saving locale: $e');
    }

    // تغيير اتجاه النص بناءً على اللغة
    if (newLocale.languageCode == 'ar' || newLocale.languageCode == 'ur') {
      // لغات RTL
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      // لغات LTR
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    notifyListeners();
  }

  String getCurrentLanguageName() {
    switch (_locale.languageCode) {
      case 'ar': return 'العربية';
      case 'en': return 'English';
      case 'bn': return 'বাংলা';
      case 'hi': return 'हिन्दी';
      case 'ur': return 'اردو';
      case 'ne': return 'नेपाली';
      case 'tl': return 'Filipino';
      default: return _locale.languageCode;
    }
  }

  String getCurrentLanguageFlag() {
    switch (_locale.languageCode) {
      case 'ar': return '🇸🇦';
      case 'en': return '🇺🇸';
      case 'bn': return '🇧🇩';
      case 'hi': return '🇮🇳';
      case 'ur': return '🇵🇰';
      case 'ne': return '🇳🇵';
      case 'tl': return '🇵🇭';
      default: return '🏳️';
    }
  }

  List<Map<String, dynamic>> getAvailableLanguages() {
    return [
      {
        'locale': const Locale('ar', 'SA'),
        'name': 'العربية',
        'flag': '🇸🇦',
        'code': 'ar',
        'isRTL': true,
      },
      {
        'locale': const Locale('en', 'US'),
        'name': 'English',
        'flag': '🇺🇸',
        'code': 'en',
        'isRTL': false,
      },
      {
        'locale': const Locale('bn', 'BD'),
        'name': 'বাংলা',
        'flag': '🇧🇩',
        'code': 'bn',
        'isRTL': false,
      },
      {
        'locale': const Locale('hi', 'IN'),
        'name': 'हिन्दी',
        'flag': '🇮🇳',
        'code': 'hi',
        'isRTL': false,
      },
      {
        'locale': const Locale('ur', 'PK'),
        'name': 'اردو',
        'flag': '🇵🇰',
        'code': 'ur',
        'isRTL': true,
      },
      {
        'locale': const Locale('ne', 'NP'),
        'name': 'नेपाली',
        'flag': '🇳🇵',
        'code': 'ne',
        'isRTL': false,
      },
      {
        'locale': const Locale('tl', 'PH'),
        'name': 'Filipino',
        'flag': '🇵🇭',
        'code': 'tl',
        'isRTL': false,
      },
    ];
  }

  bool isRTL() {
    return _locale.languageCode == 'ar' || _locale.languageCode == 'ur';
  }

  TextDirection get textDirection {
    return isRTL() ? TextDirection.rtl : TextDirection.ltr;
  }

  // دالة مساعدة للحصول على الترجمات بشكل مباشر
  static String staticTranslate(BuildContext context, String key) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return languageProvider.translate(key);
  }
}