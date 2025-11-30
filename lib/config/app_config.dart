class AppConfig {
  static const String appName = "تطبيق الوقود";
  static const String appVersion = "1.0.0";
  static const String appDescription = "تطبيق طلبات الوقود والتوصيل";
  
  // البيئات
  static const String baseUrl = "https://back-end-2222222222222222222.onrender.com/api";
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  
  // إعدادات التطبيق
  static const int apiTimeout = 30000; // 30 ثانية
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int otpTimeout = 120; // ثانيتين
  
  // إعدادات الخريطة
  static const double defaultLatitude = 24.7136;
  static const double defaultLongitude = 46.6753;
  static const String mapApiKey = "";
  
  // إعدادات الإشعارات
  static const String fcmVapidKey = "your_fcm_key";
}

class ApiEndpoints {
  // Authentication
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String verifyPhone = "/auth/verify-phone";
  static const String logout = "/auth/logout";
  static const String refreshToken = "/auth/refresh-token";
  
  // User
  static const String getProfile = "/users/profile";
  static const String updateProfile = "/users/profile";
  static const String updateLocation = "/users/location";
  static const String uploadImage = "/users/upload-image";
  
  // Addresses
  static const String addresses = "/addresses";
  static const String setDefaultAddress = "/addresses/%s/set-default";
  
  // Products
  static const String products = "/products";
  static const String featuredProducts = "/products/featured";
  static const String searchProducts = "/products/search";
  
  // Orders
  static const String orders = "/orders";
  static const String orderDetails = "/orders/%s";
  static const String trackOrder = "/orders/%s/track";
  static const String cancelOrder = "/orders/%s/cancel";
  
  // Petrol Orders
  static const String petrolOrders = "/petrol-orders";
  static const String createPetrolOrder = "/petrol-orders";
  static const String petrolOrderDetails = "/petrol-orders/%s";
  
  // Payments
  static const String payments = "/payments";
  static const String submitPaymentProof = "/payments/%s/proof";
  static const String paymentHistory = "/payments/history";
  
  // Notifications
  static const String notifications = "/notifications";
  static const String markAsRead = "/notifications/%s/read";
  static const String fcmToken = "/notifications/fcm-token";
  
  // Chat
  static const String chats = "/chats";
  static const String chatMessages = "/chats/%s/messages";
  static const String sendMessage = "/chats/%s/messages";
}