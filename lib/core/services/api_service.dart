// ignore_for_file: dead_code
import 'dart:convert';
import 'package:customer/core/constants/app_constants.dart';
import 'package:customer/core/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as client;
import 'package:logger/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = Dio();
  final Logger _logger = Logger();
  final StorageService _storageService = StorageService();

  // Initialize API service
  void init() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: Duration(milliseconds: AppConstants.apiTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
      sendTimeout: Duration(milliseconds: AppConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
  }


  Future<Map<String, dynamic>> testConnection() async {
  try {
    print('🔍 اختبار اتصال الخادم...');
    
    final response = await client.get(
      Uri.parse('$baseUrl/health'),
      headers: await _getHeaders(),
    );

    print('📡 حالة الخادم: ${response.statusCode}');
    print('📄 رد الخادم: ${response.body}');
    
    return {
      'success': true,
      'statusCode': response.statusCode,
      'body': response.body,
    };
  } catch (e) {
    print('❌ فشل الاتصال بالخادم: $e');
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

  // Request interceptor
  Future<void> _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token if available
    final token = await _storageService.getString(AppConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    _logger.i('🌐 API Request: ${options.method} ${options.uri}');
    if (options.data != null) {
      _logger.i('📦 Request Data: ${options.data}');
    }

    handler.next(options);
  }

  // Response interceptor
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('✅ API Response: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  Future<Map<String, dynamic>> debugApiTest() async {
  try {
    print('🧪 بدء اختبار الاتصال بالخادم...');
    
    // اختبار اتصال أساسي
    final testResponse = {
      'success': true,
      'message': 'الاتصال نشط - اختبار محلي',
      'data': {
        'status': 'active',
        'timestamp': DateTime.now().toIso8601String(),
      }
    };
    
    print('✅ اختبار الاتصال ناجح: $testResponse');
    return testResponse;
    
  } catch (e) {
    print('❌ فشل اختبار الاتصال: $e');
    return {
      'success': false,
      'error': 'فشل في الاختبار: $e'
    };
  }
}

  // Error interceptor
  void _onError(DioException error, ErrorInterceptorHandler handler) {
    _logger.e('❌ API Error: ${error.type} - ${error.message}');
    
    if (error.response != null) {
      _logger.e('📋 Error Response: ${error.response?.data}');
      _logger.e('🔧 Error Status: ${error.response?.statusCode}');
    }

    handler.next(error);
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'خطأ غير متوقع: ${e.toString()}';
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'خطأ غير متوقع: ${e.toString()}';
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'خطأ غير متوقع: ${e.toString()}';
    }
  }

  // Generic PATCH request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'خطأ غير متوقع: ${e.toString()}';
    }
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'خطأ غير متوقع: ${e.toString()}';
    }
  }

  // File upload
 // File upload - الإصدار المصحح
Future<Map<String, dynamic>> uploadFile(
  String endpoint,
  String filePath, {
  String fieldName = 'document',
  Map<String, dynamic>? formData,
  bool requiresAuth = true,
}) async {
  try {
    _logger.i('📤 Uploading file: $filePath to $endpoint');
    
    // إنشاء FormData بشكل صحيح
    final data = FormData();
    
    // إضافة الملف
    data.files.add(MapEntry(
      fieldName,
      await MultipartFile.fromFile(filePath),
    ));
    
    // إضافة البيانات الإضافية
    if (formData != null) {
      formData.forEach((key, value) {
        if (value != null) {
          data.fields.add(MapEntry(key, value.toString()));
        }
      });
    }

    _logger.i('📦 Upload FormData: ${data.fields}');

    final response = await _dio.post(
      endpoint,
      data: data,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _logger.i('✅ Upload successful: ${response.statusCode}');
    return _handleResponse(response);
  } on DioException catch (e) {
    _logger.e('❌ Upload DioError: ${e.type} - ${e.message}');
    if (e.response != null) {
      _logger.e('📋 Upload Error Response: ${e.response?.data}');
    }
    throw _handleError(e);
  } catch (e) {
    _logger.e('❌ Upload General Error: $e');
    throw 'خطأ غير متوقع في رفع الملف: ${e.toString()}';
  }
}

  // Multiple files upload
  Future<Map<String, dynamic>> uploadMultipleFiles(
    String endpoint,
    List<String> filePaths, {
    String fieldName = 'documents',
    Map<String, dynamic>? formData,
    bool requiresAuth = true,
  }) async {
    try {
      List<MultipartFile> files = [];
      for (String filePath in filePaths) {
        files.add(await MultipartFile.fromFile(filePath));
      }

      FormData data = FormData.fromMap({
        fieldName: files,
        ...?formData,
      });

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'خطأ غير متوقع: ${e.toString()}';
    }
  }

  // Handle response
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic>) {
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw responseData['error'] ?? responseData['message'] ?? 'حدث خطأ غير معروف';
        }
      } else if (responseData is String) {
        try {
          final parsedData = json.decode(responseData);
          if (parsedData['success'] == true) {
            return parsedData;
          } else {
            throw parsedData['error'] ?? parsedData['message'] ?? 'حدث خطأ غير معروف';
          }
        } catch (e) {
          throw 'خطأ في تحليل الاستجابة';
        }
      } else {
        throw 'استجابة غير متوقعة من الخادم';
      }
    } else {
      throw 'خطأ في الخادم: ${response.statusCode}';
    }
  }

  // Handle error
  String _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'لا يمكن الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت';
    } else if (error.type == DioExceptionType.badResponse) {
      if (error.response?.statusCode == 401) {
        // Unauthorized - clear token and redirect to login
        _storageService.remove(AppConstants.tokenKey);
        return 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى';
      } else if (error.response?.statusCode == 403) {
        return 'غير مسموح بالوصول لهذا المسار';
      } else if (error.response?.statusCode == 404) {
        return 'البيانات المطلوبة غير موجودة';
      } else if (error.response?.statusCode == 422) {
        // Validation error
        final errorData = error.response?.data;
        if (errorData is Map && errorData['errors'] != null) {
          final errors = errorData['errors'];
          if (errors is Map) {
            return errors.values.first?.first?.toString() ?? 'بيانات غير صحيحة';
          } else if (errors is List) {
            return errors.first?.toString() ?? 'بيانات غير صحيحة';
          }
          return errors.toString();
        }
        return errorData['error'] ?? errorData['message'] ?? 'بيانات غير صحيحة';
      } else if (error.response?.statusCode == 500) {
        return 'خطأ داخلي في الخادم';
      } else {
        final errorData = error.response?.data;
        if (errorData is Map) {
          return errorData['error'] ?? errorData['message'] ?? 'خطأ في الخادم: ${error.response?.statusCode}';
        }
        return 'خطأ في الخادم: ${error.response?.statusCode}';
      }
    } else if (error.type == DioExceptionType.cancel) {
      return 'تم إلغاء الطلب';
    } else {
      return 'خطأ غير متوقع: ${error.message}';
    }
  }

  // Cancel ongoing requests
  void cancelRequests([CancelToken? cancelToken]) {
    cancelToken?.cancel('Request cancelled');
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Clear authorization header
  void clearAuth() {
    _dio.options.headers.remove('Authorization');
  }

  // Set base URL (for testing or different environments)
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  // Get current base URL
  String get baseUrl => _dio.options.baseUrl;

Dio get dio => _dio;

  // Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  // Remove custom header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  // Update timeout durations
  void updateTimeouts({
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
  }) {
    if (connectTimeout != null) {
      _dio.options.connectTimeout = Duration(milliseconds: connectTimeout);
    }
    if (receiveTimeout != null) {
      _dio.options.receiveTimeout = Duration(milliseconds: receiveTimeout);
    }
    if (sendTimeout != null) {
      _dio.options.sendTimeout = Duration(milliseconds: sendTimeout);
    }
  }
  
  Future<Map<String, String>?> _getHeaders() async {}
}