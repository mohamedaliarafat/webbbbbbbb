import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      // App
      'appTitle': 'البحيرة العربية للنقليات',
      'welcome': 'مرحباً',
      'welcomeMessage': 'نتمنى لك يوماً سعيداً',
      
      // Navigation
      'home': 'الرئيسية',
      'fuelOrder': 'طلب وقود',
      'myOrders': 'طلباتي',
      'profile': 'الملف الشخصي',
      'notifications': 'الإشعارات',
      
      // Dashboard
      'quickActions': 'الإجراءات السريعة',
      'recentOrders': 'آخر الطلبات',
      'viewAll': 'عرض الكل',
      'newFuelOrder': 'طلب وقود جديد',
      'transportServices': 'خدمات النقل',
      'stationOperation': 'تشغيل المحطات',
      'orderTracking': 'تتبع الطلبات',
      'chats': 'المحادثات',
      
      // Statistics
      'totalOrders': 'إجمالي الطلبات',
      'pendingOrders': 'طلبات قيد الانتظار',
      'completedOrders': 'طلبات مكتملة',
      'totalFuel': 'إجمالي الوقود',
      
      // Orders
      'orderNumber': 'طلب #',
      'fuelType': 'نوع الوقود',
      'quantity': 'الكمية',
      'status': 'الحالة',
      'price': 'السعر',
      
      // Order Status
      'pending': 'قيد الانتظار',
      'approved': 'معتمد',
      'inProgress': 'قيد التوصيل',
      'completed': 'مكتمل',
      'cancelled': 'ملغي',
      
      // Profile
      'completeProfile': 'إكمال الملف الشخصي',
      'personalInfo': 'المعلومات الشخصية',
      'documents': 'المستندات',
      'companyName': 'اسم الشركة',
      'email': 'البريد الإلكتروني',
      'contactPerson': 'اسم الشخص المسؤول',
      'contactPhone': 'هاتف الشخص المسؤول',
      'position': 'المنصب',
      
      // Documents
      'commercialLicense': 'الرخصة التجارية',
      'energyLicense': 'رخصة الطاقة',
      'commercialRecord': 'السجل التجاري',
      'taxNumber': 'الرقم الضريبي',
      'nationalAddress': 'وثيقة العنوان الوطني',
      'civilDefense': 'رخصة الدفاع المدني',
      'uploadFile': 'رفع الملف',
      'changeFile': 'تغيير الملف',
      'fileUploaded': 'تم رفع الملف',
      'viewFile': 'معاينة الملف',
      'fileName': 'اسم الملف',
      'fileSize': 'الحجم',
      'fileType': 'النوع',
      
      // Messages
      'success': 'تم بنجاح',
      'error': 'خطأ',
      'warning': 'تحذير',
      'info': 'معلومة',
      'loading': 'جاري التحميل...',
      'noData': 'لا توجد بيانات',
      'noOrders': 'لا توجد طلبات حالياً',
      'allDocumentsReady': 'جميع المستندات جاهزة',
      'completionLevel': 'مستوى الإكمال',
      'documentsUploaded': 'تم رفع @count من أصل @total مستند',
      
      // Validation
      'requiredField': 'هذا الحقل مطلوب',
      'invalidEmail': 'بريد إلكتروني غير صحيح',
      'invalidPhone': 'رقم هاتف غير صحيح',
      
      // Actions
      'continue': 'متابعة',
      'back': 'رجوع',
      'submit': 'إرسال',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'edit': 'تعديل',
      'delete': 'حذف',
      'confirm': 'تأكيد',
      'close': 'إغلاق',
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      
      // Fuel Types
      'fuel91': 'بنزين 91',
      'fuel95': 'بنزين 95',
      'fuel98': 'بنزين 98',
      'diesel': 'ديزل',
      'premiumDiesel': 'ديزل ممتاز',
      'kerosene': 'كيروسين',
    },
    'en': {
      // App
      'appTitle': 'Al Buhaira Arabian Transport',
      'welcome': 'Welcome',
      'welcomeMessage': 'Have a nice day',
      
      // Navigation
      'home': 'Home',
      'fuelOrder': 'Fuel Order',
      'myOrders': 'My Orders',
      'profile': 'Profile',
      'notifications': 'Notifications',
      
      // Dashboard
      'quickActions': 'Quick Actions',
      'recentOrders': 'Recent Orders',
      'viewAll': 'View All',
      'newFuelOrder': 'New Fuel Order',
      'transportServices': 'Transport Services',
      'stationOperation': 'Station Operation',
      'orderTracking': 'Order Tracking',
      'chats': 'Chats',
      
      // Statistics
      'totalOrders': 'Total Orders',
      'pendingOrders': 'Pending Orders',
      'completedOrders': 'Completed Orders',
      'totalFuel': 'Total Fuel',
      
      // Orders
      'orderNumber': 'Order #',
      'fuelType': 'Fuel Type',
      'quantity': 'Quantity',
      'status': 'Status',
      'price': 'Price',
      
      // Order Status
      'pending': 'Pending',
      'approved': 'Approved',
      'inProgress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      
      // Profile
      'completeProfile': 'Complete Profile',
      'personalInfo': 'Personal Information',
      'documents': 'Documents',
      'companyName': 'Company Name',
      'email': 'Email',
      'contactPerson': 'Contact Person',
      'contactPhone': 'Contact Phone',
      'position': 'Position',
      
      // Documents
      'commercialLicense': 'Commercial License',
      'energyLicense': 'Energy License',
      'commercialRecord': 'Commercial Record',
      'taxNumber': 'Tax Number',
      'nationalAddress': 'National Address Document',
      'civilDefense': 'Civil Defense License',
      'uploadFile': 'Upload File',
      'changeFile': 'Change File',
      'fileUploaded': 'File Uploaded',
      'viewFile': 'View File',
      'fileName': 'File Name',
      'fileSize': 'Size',
      'fileType': 'Type',
      
      // Messages
      'success': 'Success',
      'error': 'Error',
      'warning': 'Warning',
      'info': 'Information',
      'loading': 'Loading...',
      'noData': 'No Data',
      'noOrders': 'No orders currently',
      'allDocumentsReady': 'All documents are ready',
      'completionLevel': 'Completion Level',
      'documentsUploaded': '@count out of @total documents uploaded',
      
      // Validation
      'requiredField': 'This field is required',
      'invalidEmail': 'Invalid email address',
      'invalidPhone': 'Invalid phone number',
      
      // Actions
      'continue': 'Continue',
      'back': 'Back',
      'submit': 'Submit',
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'close': 'Close',
      'login': 'Login',
      'logout': 'Logout',
      
      // Fuel Types
      'fuel91': 'Petrol 91',
      'fuel95': 'Petrol 95',
      'fuel98': 'Petrol 98',
      'diesel': 'Diesel',
      'premiumDiesel': 'Premium Diesel',
      'kerosene': 'Kerosene',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get welcomeMessage => _localizedValues[locale.languageCode]!['welcomeMessage']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get fuelOrder => _localizedValues[locale.languageCode]!['fuelOrder']!;
  String get myOrders => _localizedValues[locale.languageCode]!['myOrders']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get quickActions => _localizedValues[locale.languageCode]!['quickActions']!;
  String get recentOrders => _localizedValues[locale.languageCode]!['recentOrders']!;
  String get viewAll => _localizedValues[locale.languageCode]!['viewAll']!;
  String get newFuelOrder => _localizedValues[locale.languageCode]!['newFuelOrder']!;
  String get transportServices => _localizedValues[locale.languageCode]!['transportServices']!;
  String get stationOperation => _localizedValues[locale.languageCode]!['stationOperation']!;
  String get orderTracking => _localizedValues[locale.languageCode]!['orderTracking']!;
  String get chats => _localizedValues[locale.languageCode]!['chats']!;
  String get totalOrders => _localizedValues[locale.languageCode]!['totalOrders']!;
  String get pendingOrders => _localizedValues[locale.languageCode]!['pendingOrders']!;
  String get completedOrders => _localizedValues[locale.languageCode]!['completedOrders']!;
  String get totalFuel => _localizedValues[locale.languageCode]!['totalFuel']!;
  String get orderNumber => _localizedValues[locale.languageCode]!['orderNumber']!;
  String get fuelType => _localizedValues[locale.languageCode]!['fuelType']!;
  String get quantity => _localizedValues[locale.languageCode]!['quantity']!;
  String get status => _localizedValues[locale.languageCode]!['status']!;
  String get price => _localizedValues[locale.languageCode]!['price']!;
  String get pending => _localizedValues[locale.languageCode]!['pending']!;
  String get approved => _localizedValues[locale.languageCode]!['approved']!;
  String get inProgress => _localizedValues[locale.languageCode]!['inProgress']!;
  String get completed => _localizedValues[locale.languageCode]!['completed']!;
  String get cancelled => _localizedValues[locale.languageCode]!['cancelled']!;
  String get completeProfile => _localizedValues[locale.languageCode]!['completeProfile']!;
  String get personalInfo => _localizedValues[locale.languageCode]!['personalInfo']!;
  String get documents => _localizedValues[locale.languageCode]!['documents']!;
  String get companyName => _localizedValues[locale.languageCode]!['companyName']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get contactPerson => _localizedValues[locale.languageCode]!['contactPerson']!;
  String get contactPhone => _localizedValues[locale.languageCode]!['contactPhone']!;
  String get position => _localizedValues[locale.languageCode]!['position']!;
  String get commercialLicense => _localizedValues[locale.languageCode]!['commercialLicense']!;
  String get energyLicense => _localizedValues[locale.languageCode]!['energyLicense']!;
  String get commercialRecord => _localizedValues[locale.languageCode]!['commercialRecord']!;
  String get taxNumber => _localizedValues[locale.languageCode]!['taxNumber']!;
  String get nationalAddress => _localizedValues[locale.languageCode]!['nationalAddress']!;
  String get civilDefense => _localizedValues[locale.languageCode]!['civilDefense']!;
  String get uploadFile => _localizedValues[locale.languageCode]!['uploadFile']!;
  String get changeFile => _localizedValues[locale.languageCode]!['changeFile']!;
  String get fileUploaded => _localizedValues[locale.languageCode]!['fileUploaded']!;
  String get viewFile => _localizedValues[locale.languageCode]!['viewFile']!;
  String get fileName => _localizedValues[locale.languageCode]!['fileName']!;
  String get fileSize => _localizedValues[locale.languageCode]!['fileSize']!;
  String get fileType => _localizedValues[locale.languageCode]!['fileType']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get warning => _localizedValues[locale.languageCode]!['warning']!;
  String get info => _localizedValues[locale.languageCode]!['info']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get noData => _localizedValues[locale.languageCode]!['noData']!;
  String get noOrders => _localizedValues[locale.languageCode]!['noOrders']!;
  String get allDocumentsReady => _localizedValues[locale.languageCode]!['allDocumentsReady']!;
  String get completionLevel => _localizedValues[locale.languageCode]!['completionLevel']!;
  String get requiredField => _localizedValues[locale.languageCode]!['requiredField']!;
  String get invalidEmail => _localizedValues[locale.languageCode]!['invalidEmail']!;
  String get invalidPhone => _localizedValues[locale.languageCode]!['invalidPhone']!;
  String get continueText => _localizedValues[locale.languageCode]!['continue']!;
  String get back => _localizedValues[locale.languageCode]!['back']!;
  String get submit => _localizedValues[locale.languageCode]!['submit']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get fuel91 => _localizedValues[locale.languageCode]!['fuel91']!;
  String get fuel95 => _localizedValues[locale.languageCode]!['fuel95']!;
  String get fuel98 => _localizedValues[locale.languageCode]!['fuel98']!;
  String get diesel => _localizedValues[locale.languageCode]!['diesel']!;
  String get premiumDiesel => _localizedValues[locale.languageCode]!['premiumDiesel']!;
  String get kerosene => _localizedValues[locale.languageCode]!['kerosene']!;

  String documentsUploaded(int count, int total) {
    return _localizedValues[locale.languageCode]!['documentsUploaded']!
        .replaceAll('@count', count.toString())
        .replaceAll('@total', total.toString());
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}