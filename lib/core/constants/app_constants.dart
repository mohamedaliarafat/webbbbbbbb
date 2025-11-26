class AppConstants {
  // App Info
  static const String appName = 'تطبيق الوقود والمنتجات';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static const String baseUrl = 'http://192.168.8.26:6016/api'; // Change to your backend URL
  static const int apiTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String fcmTokenKey = 'fcm_token';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';

  // Pagination
  static const int defaultPageSize = 10;
  static const int productsPageSize = 12;
  static const int ordersPageSize = 10;
  static const int messagesPageSize = 20;

  // Order Statuses
  static const List<String> orderStatuses = [
    'pending',
    'approved', 
    'waiting_payment',
    'processing',
    'ready_for_delivery',
    'assigned_to_driver',
    'picked_up',
    'in_transit',
    'delivered',
    'completed',
    'cancelled'
  ];

  // Fuel Types
  static const List<String> fuelTypes = [
    '91',
    '95', 
    '98',
    'diesel',
    'premium_diesel'
  ];

  // Product Types
  static const List<String> productTypes = [
    'بنزين',
    'ديزل',
    'كيروسين', 
    'أخرى'
  ];

  // Address Types
  static const List<String> addressTypes = [
    'home',
    'work',
    'other'
  ];

  // User Roles
  static const List<String> userRoles = [
    'customer',
    'driver',
    'approval_supervisor', 
    'monitoring',
    'admin'
  ];

  // Profile Statuses
  static const List<String> profileStatuses = [
    'draft',
    'submitted',
    'under_review',
    'approved',
    'rejected',
    'needs_correction'
  ];

  // Payment Statuses
  static const List<String> paymentStatuses = [
    'hidden',
    'pending',
    'waiting_proof', 
    'under_review',
    'verified',
    'rejected',
    'failed'
  ];

  // Notification Types
  static const List<String> notificationTypes = [
    'system',
    'auth',
    'order_new',
    'order_status',
    'order_price',
    'order_assigned',
    'order_delivered', 
    'payment_pending',
    'payment_verified',
    'payment_failed',
    'driver_assignment',
    'driver_location',
    'chat_message',
    'incoming_call',
    'profile_approved',
    'profile_rejected',
    'admin_alert',
    'supervisor_alert'
  ];

  // Chat Message Types
  static const List<String> messageTypes = [
    'text',
    'image', 
    'voice',
    'video',
    'file',
    'call'
  ];

  // Company Types
  static const List<String> companyTypes = [
    'fuel_supplier',
    'logistics',
    'transportation',
    'maintenance',
    'trading',
    'services',
    'construction',
    'other'
  ];

  // Default Values
  static const double defaultServiceFee = 15.0;
  static const double defaultDeliveryFee = 10.0;
  static const int defaultFuelLiters = 20;
  static const int maxFuelLiters = 100;

  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double defaultLocationAccuracy = 50.0; // meters

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;

  // Date Formats
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ssZ';

  // Currency
  static const String defaultCurrency = 'SAR';
  static const String currencySymbol = 'ر.س';

  // Localization
  static const String defaultLanguage = 'ar';
  static const List<String> supportedLanguages = ['ar', 'en'];

  // Theme
  static const String defaultTheme = 'light';
  static const List<String> supportedThemes = ['light', 'dark'];

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Debounce Timers
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);
  static const Duration typingDebounceDuration = Duration(milliseconds: 300);

  // Retry Configuration
  static const int maxApiRetries = 3;
  static const Duration apiRetryDelay = Duration(seconds: 2);
}