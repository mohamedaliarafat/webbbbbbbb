import 'package:customer/core/constants/app_constants.dart';

class ApiEndpoints {
  // Base URL
  static const String baseUrl = AppConstants.baseUrl;

  // Auth Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyPhone = '/auth/verify-phone';
  static const String resendVerification = '/auth/resend-verification';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';
  static const String verifyToken = '/auth/verify-token';

  // Profile Endpoints
  static const String completeProfile = '/profile-submit'; // POST /profile
  static const String getProfile = '/profile';      // GET /profile
  static const String updateProfile = '/update-profile';

  // 🔹 UPLOAD ENDPOINTS - ADDED THE MISSING ONES
static const String uploadDocument = '/upload-document';
static const String uploadFile = '/upload-file';
static const String uploadDocuments = '/upload-documents';
static const String uploadAndUpdate = '/upload-and-update';

  // 🔹 Routes للمسؤول فقط
  static const String adminProfiles = '/admin/profiles';
  static const String adminReviewProfile = '/admin/profiles';
  static const String adminUpdateDocuments = '/admin/profiles';
  static const String adminDeleteProfile = '/admin/profiles';
  static const String adminStats = '/admin/stats';

  // User Endpoints
  static const String getUsers = '/users';
  static const String getUser = '/users/'; // + userId
  static const String updateUser = '/users/'; // + userId
  static const String manageDrivers = '/users/drivers/manage';
  static const String approveProfile = '/users/'; // + userId + /approve-profile
  static const String getUserStats = '/users/stats';
  static const String getUserProducts = '/users/'; // + userId + /products

  // Order Endpoints
  static const String createOrder = '/orders';
  static const String createFuelOrder = '/orders/fuel';
  static const String createProductOrder = '/orders/product';
  static const String getOrders = '/orders';
  static const String getOrder = '/orders/'; // + orderId
  static const String updateOrderStatus = '/orders/'; // + orderId + /status
  static const String setOrderPrice = '/orders/'; // + orderId + /price
  static const String assignDriver = '/orders/'; // + orderId + /assign-driver
  static const String updateOrderTracking = '/orders/'; // + orderId + /tracking

  // Fuel Order Specific Endpoints
  static const String getFuelOrder = '/orders/fuel/'; // + orderId
  static const String updateFuelOrderStatus = '/orders/fuel/'; // + orderId + /status
  static const String setFuelOrderPrice = '/orders/fuel/'; // + orderId + /price
  static const String assignFuelOrderDriver = '/orders/fuel/'; // + orderId + /assign-driver
  static const String updateFuelOrderTracking = '/orders/fuel/'; // + orderId + /tracking

  // Product Order Specific Endpoints
  static const String getProductOrder = '/orders/product/'; // + orderId
  static const String updateProductOrderStatus = '/orders/product/'; // + orderId + /status
  static const String setProductOrderPrice = '/orders/product/'; // + orderId + /price
  static const String assignProductOrderDriver = '/orders/product/'; // + orderId + /assign-driver
  static const String updateProductOrderTracking = '/orders/product/'; // + orderId + /tracking

  // Product Endpoints
  static const String createProduct = '/products';
  static const String getProducts = '/products';
  static const String getProduct = '/products/'; // + productId
  static const String updateProduct = '/products/'; // + productId
  static const String deleteProduct = '/products/'; // + productId
  static const String updateStock = '/products/'; // + productId + /stock
  static const String getProductStats = '/products/stats/overview';
  static const String getCompanyProducts = '/products/company/'; // + companyId + /products

  // Payment Endpoints
  static const String uploadPaymentProof = '/payments/'; // + orderType + / + orderId + /upload-proof
  static const String verifyPayment = '/payments/'; // + paymentId + /verify
  static const String getPayments = '/payments';

  // Company Endpoints
  static const String createCompany = '/companies';
  static const String getCompanies = '/companies';
  static const String getCompany = '/companies/'; // + companyId
  static const String getUserCompanies = '/companies/my-companies';
  static const String updateCompany = '/companies/'; // + companyId
  static const String verifyCompany = '/companies/'; // + companyId + /verify
  static const String addService = '/companies/'; // + companyId + /services
  static const String getCompanyStats = '/companies/stats';

  static const String createAddress = '/addresses'; // أو '/api/addresses'
  static const String getUserAddresses = '/customer/addresses'; // أو '/api/addresses'
  static const String getAddress = '/customer/addresses/'; // + addressId
  static const String updateAddress = '/customer/addresses/'; // + addressId
  static const String deleteAddress = '/customer/addresses/'; // + addressId
  static const String setDefaultAddress = '/customer/addresses/'; // + addressId + /set-default
  
  // Chat Endpoints
  static const String getUserChats = '/chat';
  static const String createChat = '/chat';
  static const String deleteChat = '/chat/'; // + chatId
  static const String getMessages = '/chat/'; // + chatId + /messages
  static const String sendMessage = '/chat/'; // + chatId + /messages
  static const String startCall = '/chat/'; // + chatId + /call

  // WebRTC Endpoints
  static const String webRTCSignal = '/webrtc/signal';
  static const String getCallInfo = '/webrtc/call/'; // + callId
  static const String endCall = '/webrtc/call/'; // + callId + /end

  // Admin Endpoints
  static const String adminDashboard = '/admin/dashboard';
  static const String manageUsers = '/admin/users/manage';
  static const String managePricing = '/admin/pricing/manage';
  static const String systemSettings = '/admin/system-settings';

  // Driver Endpoints
  static const String driverDashboard = '/driver/dashboard';
  static const String acceptOrder = '/driver/accept-order';
  static const String updateDriverLocation = '/driver/location';
  static const String updateDriverOrderStatus = '/driver/order-status';

  // Supervisor Endpoints
  static const String supervisorDashboard = '/supervisor/dashboard';
  static const String approveOrder = '/supervisor/approve-order';
  static const String rejectOrder = '/supervisor/reject-order';
  static const String reviewProfile = '/supervisor/review-profile';

  // Utility Endpoints
  static const String healthCheck = '/health';
  static const String root = '/';

  // Helper methods for dynamic URLs
  static String buildUrl(String endpoint, [String? id]) {
    if (id != null) {
      return '$endpoint$id';
    }
    return endpoint;
  }

  static String buildUrlWithSuffix(String endpoint, String id, String suffix) {
    return '$endpoint$id$suffix';
  }

  // Chat URL builders
  static String getChatMessagesUrl(String chatId) {
    return '/chat/$chatId/messages';
  }

  static String getSendMessageUrl(String chatId) {
    return '/chat/$chatId/messages';
  }

  static String getStartCallUrl(String chatId) {
    return '/chat/$chatId/call';
  }

  static String getDeleteChatUrl(String chatId) {
    return '/chat/$chatId';
  }

  // Payment proof upload URL builder
  static String getPaymentProofUrl(String orderType, String orderId) {
    return '/payments/$orderType/$orderId/upload-proof';
  }

  // Order tracking URL builder
  static String getOrderTrackingUrl(String orderId, String orderType) {
    return '/orders/$orderType/$orderId/tracking';
  }

  // Chat creation URL
  static String getCreateChatUrl() {
    return '/chat';
  }

  // 🔹 NEW UPLOAD URL BUILDERS - ADDED
  static String getUploadFileUrl() {
    return uploadFile;
  }

  static String getUploadAndUpdateUrl() {
    return uploadAndUpdate;
  }

  static String getUploadDocumentUrl() {
    return uploadDocument;
  }

  static String getUploadDocumentsUrl() {
    return uploadDocuments;
  }

  // Auth Service specific URL builders
  static String getCompleteProfileUrl() {
    return completeProfile;
  }

  static String getUpdateProfileUrl() {
    return updateProfile;
  }

  static String getVerifyPhoneUrl() {
    return verifyPhone;
  }

  static String getResendVerificationUrl() {
    return resendVerification;
  }

  static String getForgotPasswordUrl() {
    return forgotPassword;
  }

  static String getResetPasswordUrl() {
    return resetPassword;
  }

  static String getVerifyTokenUrl() {
    return verifyToken;
  }

  static String getLogoutUrl() {
    return logout;
  }

  // User management URL builders
  static String getUserProfileUrl(String userId) {
    return '/users/$userId';
  }

  static String getUpdateUserUrl(String userId) {
    return '/users/$userId';
  }

  static String getApproveProfileUrl(String userId) {
    return '/users/$userId/approve-profile';
  }

  static String getUserProductsUrl(String userId) {
    return '/users/$userId/products';
  }

  // Order management URL builders
  static String getOrderUrl(String orderId) {
    return '/orders/$orderId';
  }

  static String getUpdateOrderStatusUrl(String orderId) {
    return '/orders/$orderId/status';
  }

  static String getSetOrderPriceUrl(String orderId) {
    return '/orders/$orderId/price';
  }

  static String getAssignDriverUrl(String orderId) {
    return '/orders/$orderId/assign-driver';
  }

  static String getUpdateOrderTrackingUrl(String orderId) {
    return '/orders/$orderId/tracking';
  }

  // Fuel order specific URL builders
  static String getFuelOrderUrl(String orderId) {
    return '/orders/fuel/$orderId';
  }

  static String getUpdateFuelOrderStatusUrl(String orderId) {
    return '/orders/fuel/$orderId/status';
  }

  // Product order specific URL builders
  static String getProductOrderUrl(String orderId) {
    return '/orders/product/$orderId';
  }

  static String getUpdateProductOrderStatusUrl(String orderId) {
    return '/orders/product/$orderId/status';
  }

  // Address management URL builders
  static String getAddressUrl(String addressId) {
    return '/addresses/$addressId';
  }

  static String getSetDefaultAddressUrl(String addressId) {
    return '/addresses/$addressId/set-default';
  }

  // Company management URL builders
  static String getCompanyUrl(String companyId) {
    return '/companies/$companyId';
  }

  static String getVerifyCompanyUrl(String companyId) {
    return '/companies/$companyId/verify';
  }

  static String getAddServiceUrl(String companyId) {
    return '/companies/$companyId/services';
  }

  // Product management URL builders
  static String getProductUrl(String productId) {
    return '/products/$productId';
  }

  static String getUpdateStockUrl(String productId) {
    return '/products/$productId/stock';
  }

  static String getCompanyProductsUrl(String companyId) {
    return '/products/company/$companyId/products';
  }
}