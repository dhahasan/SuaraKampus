import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;

  const ApiResponse({required this.isSuccess, this.data, this.message});

  factory ApiResponse.success(T data, {String? message}) =>
      ApiResponse(isSuccess: true, data: data, message: message);

  factory ApiResponse.error(String message) =>
      ApiResponse(isSuccess: false, message: message);
}

class ApiService {
  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<ApiResponse<dynamic>> get(
    String url, {
    Map<String, String>? queryParams,
  }) async {
    try {
      var uri = Uri.parse(url);
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await _client
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiService GET Error ($url): $e');
      return ApiResponse.error('Koneksi database/API gagal: $e');
    }
  }

  Future<ApiResponse<dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiService POST Error ($url): $e');
      return ApiResponse.error('Koneksi database/API gagal: $e');
    }
  }

  Future<ApiResponse<String>> uploadFile(
    String url, {
    required String filePath,
    required String fieldName,
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 25),
      );
      final response = await http.Response.fromStream(streamedResponse);

      final result = _handleResponse(response);
      if (result.isSuccess && result.data is Map) {
        return ApiResponse.success(result.data['url'] as String);
      }
      return ApiResponse.error(result.message ?? 'Gagal mengunggah file.');
    } catch (e) {
      debugPrint('ApiService Upload Error: $e');
      return ApiResponse.error('Gagal mengunggah file: $e');
    }
  }

  ApiResponse<dynamic> _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final bool isSuccess = decoded['success'] == true;
        final message = decoded['message'] as String?;
        final data = decoded['data'];

        if (isSuccess ||
            (response.statusCode >= 200 && response.statusCode < 300)) {
          return ApiResponse.success(data, message: message);
        } else {
          return ApiResponse.error(
            message ?? 'Terjadi kesalahan pada server (${response.statusCode})',
          );
        }
      }
      return ApiResponse.success(decoded);
    } catch (e) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(response.body);
      }
      return ApiResponse.error(
        'Gagal memproses respon server: ${response.body}',
      );
    }
  }
}
