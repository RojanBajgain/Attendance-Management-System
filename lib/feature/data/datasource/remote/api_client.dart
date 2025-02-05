import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_exception_msg.dart';
import 'package:ams/feature/data/datasource/remote/api_message.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/data/datasource/remote/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  late SharedPreferences sharedPreferences;

  ApiClient({required this.sharedPreferences});

  String get token => sharedPreferences.getString('access_token') ?? '';
  String get refreshToken => sharedPreferences.getString('refresh_token') ?? '';

  void saveTokens(String accessToken, String refreshToken) {
    sharedPreferences.setString('access_token', accessToken);
    sharedPreferences.setString('refresh_token', refreshToken);
    // log("Saved Access Token: $accessToken");
    // log("Saved Refresh Token: $refreshToken");
  }

  void clearTokens() {
    sharedPreferences.remove('access_token');
    sharedPreferences.remove('refresh_token');
  }

//GETHEADER
  static Map<String, String> getHeader(String token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return headers;
  }

  static Map<String, String> getHeaders(String token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    };

    return headers;
  }

//GET
  static Future<ApiResponse<T>> getApi<T>(
    String endPoint, {
    required String token,
    required T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await MyHttpClient.client.get(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: getHeader(token),
      );
      log('Token being used for request: $token');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = utf8.decode(response.bodyBytes);
        final json = jsonDecode(responseBody);
        final data = fromJson != null ? fromJson(json) : json as T;
        return ApiResponse.completed(data);
      } else {
        final message = ApiMessage.getMessage(response.statusCode, response);
        log('Error: $message');
        return ApiResponse.error(message);
      }
    } catch (e) {
      log('Error: $e');
      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }

//POST
  static Future<ApiResponse<T>> postApi<T>(
    String endPoint, {
    required dynamic requestBody,
    required String token,
    required T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await MyHttpClient.client.post(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        body: jsonEncode(requestBody),
        headers: getHeader(token),
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
  static Future<ApiResponse<T>> patchApi<T>(
    String endPoint, {
    required dynamic requestBody,
    required String token,
    required T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await MyHttpClient.client.patch(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        body: jsonEncode(requestBody),
        headers: getHeader(token),
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
  static Future<ApiResponse<T>> deleteApi<T>(
    String endPoint, {
    required String token,
    required T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await MyHttpClient.client.delete(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: getHeader(token),
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
