import 'dart:convert';
import 'package:http/http.dart' as http;
import './local_datasource.dart';

class RemoteDataSource {
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String baseUrl = 'http://192.168.8.26:6016/api';

  var dio; // Change to your backend URL
  
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final token = await _localDataSource.getToken();
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }


  

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _localDataSource.getToken();
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _localDataSource.getToken();
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _localDataSource.getToken();
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final token = await _localDataSource.getToken();
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    } else if (statusCode == 401) {
      // Unauthorized - clear token
      _localDataSource.clearToken();
      throw Exception('Session expired. Please login again.');
    } else if (statusCode == 403) {
      throw Exception('Access denied: ${responseBody['error']}');
    } else if (statusCode == 404) {
      throw Exception('Resource not found: ${responseBody['error']}');
    } else if (statusCode >= 500) {
      throw Exception('Server error: ${responseBody['error']}');
    } else {
      throw Exception('Request failed: ${responseBody['error']}');
    }
  }

  Future<bool> hasToken() async {
    try {
      final token = await _localDataSource.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // الحصول على الـ token
  Future<String?> getToken() async {
    return await _localDataSource.getToken();
  }

  // حفظ الـ token
  Future<void> saveToken(String token) async {
    await _localDataSource.saveToken(token);
  }

  // مسح الـ token
  Future<void> clearToken() async {
    await _localDataSource.clearToken();
  }
  


  // File upload method
  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    List<int> fileBytes,
    String fileName, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final token = await _localDataSource.getToken();
      final uri = Uri.parse('$baseUrl$endpoint');

      var request = http.MultipartRequest('POST', uri);
      
      // Add file
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ));

      // Add additional data
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('File upload error: $e');
    }
  }
}