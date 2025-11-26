import 'package:customer/core/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'app_config.dart';


class DioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConfig.apiTimeout),
        receiveTimeout: const Duration(milliseconds: AppConfig.apiTimeout),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': 'ar',
        },
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) => Logger().d(object),
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // إضافة التوكن للطلبات
          final token = await StorageService().getString('userToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await _handleTokenRefresh(error, handler);
          } else {
            return handler.next(error);
          }
        },
      ),
    ]);

    return dio;
  }

  static Future<void> _handleTokenRefresh(
      DioException error, ErrorInterceptorHandler handler) async {
    try {
      final refreshToken = await StorageService().getString('refreshToken');
      if (refreshToken != null) {
        final dio = Dio();
        final response = await dio.post(
          '${AppConfig.baseUrl}${ApiEndpoints.refreshToken}',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final newToken = response.data['token'];
          final newRefreshToken = response.data['refreshToken'];

          await StorageService().setString('userToken', newToken);
          await StorageService().setString('refreshToken', newRefreshToken);

          // إعادة الطلب الأصلي
          error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final cloneReq = await dio.fetch(error.requestOptions);
          return handler.resolve(cloneReq);
        }
      }
    } catch (e) {
      await StorageService().clear();
      return handler.next(error);
    }
  }
}
