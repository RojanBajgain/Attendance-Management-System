import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ams/feature/data/datasource/remote/api_exception_msg.dart';
import 'package:ams/feature/data/datasource/remote/api_message.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/data/datasource/remote/http_client.dart';
import 'package:ams/feature/data/datasource/remote/session_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final FlutterSecureStorage secureStorage;

  ApiClient({required this.secureStorage});

  Future<String> get token async =>
      await secureStorage.read(key: 'access_token') ?? '';
  Future<String> get refreshToken async =>
      await secureStorage.read(key: 'refresh_token') ?? '';
  Future<String> get organization async =>
      await secureStorage.read(key: 'x-organization') ?? '';

  Future<void> saveTokens(
      String accessToken, String refreshToken, String apiKey) async {
    await secureStorage.write(key: 'access_token', value: accessToken);
    await secureStorage.write(key: 'refresh_token', value: refreshToken);
    await secureStorage.write(key: 'x-organization', value: apiKey);
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: 'access_token');
    await secureStorage.delete(key: 'refresh_token');
    await secureStorage.delete(key: 'x-organization');
  }

//GETHEADER
  static Map<String, String> getHeader(String token, {String? apiKey}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (apiKey != null) 'x-organization': apiKey,
    };
    return headers;
  }

  //GET
  Future<ApiResponse<T>> getApi<T>(
    String endPoint, {
    required String token,
    required T Function(dynamic json)? fromJson,
    String? apiKey,
  }) async {
    try {
      final headers = getHeader(token, apiKey: apiKey);
      log('Headers used for request: $headers');
      final response = await MyHttpClient.client.get(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = utf8.decode(response.bodyBytes);
        final json = jsonDecode(responseBody);
        final data = fromJson != null ? fromJson(json) : json as T;
        return ApiResponse.completed(data);
      } else if (response.statusCode == 401) {
        await ApiMessage.getMessage(response.statusCode, response);
        await SessionManager.handleSessionExpired();
        return ApiResponse.error('Session expired. Please log in again.');
      } else {
        final message = ApiMessage.getMessage(response.statusCode, response);
        log('Error: $message');
        return ApiResponse.error(message);
      }
    } catch (e) {
      log('Error in getApi: $e');
      if (e is SocketException || e is TimeoutException) {
        // Treat network errors as session-critical
        await SessionManager.handleSessionExpired();
        return ApiResponse.error(
            'Unable to connect to the server. Please log in again.');
      }
      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }

//POST
  Future<ApiResponse<T>> postApi<T>(
    String endPoint, {
    required dynamic requestBody,
    required String token,
    String? apiKey,
    required T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await MyHttpClient.client.post(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        body: jsonEncode(requestBody),
        headers: getHeader(token, apiKey: apiKey),
      );

      // Handle response
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 205) {
        if (response.body.isNotEmpty) {
          final json = jsonDecode(response.body);
          final data = fromJson != null ? fromJson(json) : json as T;
          return ApiResponse.completed(data);
        } else {
          return ApiResponse.completed(null as T);
        }
      } else {
        final message = ApiMessage.getMessage(response.statusCode, response);
        log('Api Client:$endPoint:$message');
        return ApiResponse.error(message);
      }
    } catch (e) {
      log("Error: $e");
      return ApiResponse.error(e.toString());
    }
  }

//PATCH
  Future<ApiResponse<T>> patchApi<T>(
    String endPoint, {
    required dynamic requestBody,
    required String token,
    String? apiKey,
    required T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await MyHttpClient.client.patch(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        body: jsonEncode(requestBody),
        headers: getHeader(token, apiKey: apiKey),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final data = fromJson != null ? fromJson(json) : json as T;
        return ApiResponse.completed(data);
      } else {
        final message = ApiMessage.getMessage(response.statusCode, response);
        log('Api Client:$endPoint:$message');
        return ApiResponse.error(message);
      }
    } catch (e) {
      log('Error: $e');
      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }

  //DELETE
  Future<ApiResponse<T>> deleteApi<T>(
    String endPoint, {
    required String token,
    String? apiKey,
    required T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await MyHttpClient.client.delete(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: getHeader(token, apiKey: apiKey),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isNotEmpty) {
          final json = jsonDecode(response.body);
          final data = fromJson != null ? fromJson(json) : json as T;
          return ApiResponse.completed(data);
        } else {
          // Handle empty response body for DELETE requests
          return ApiResponse.completed(null as T);
        }
      } else {
        final message = ApiMessage.getMessage(response.statusCode, response);
        log('Api Client:$endPoint:$message');
        return ApiResponse.error(message);
      }
    } catch (e) {
      log('Error: $e');
      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }
}
