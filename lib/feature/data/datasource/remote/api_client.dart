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
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';

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

  // Enhanced network error detection
  bool _isNetworkError(dynamic error) {
    if (error is SocketException) {
      final errorMessage = error.message.toLowerCase();
      return errorMessage.contains('failed host lookup') ||
          errorMessage.contains('no address associated with hostname') ||
          errorMessage.contains('network is unreachable') ||
          errorMessage.contains('connection timed out') ||
          errorMessage.contains('connection refused') ||
          errorMessage.contains('host unreachable');
    }

    if (error is TimeoutException) {
      return true;
    }

    // Handle HTTP client exceptions
    if (error.toString().contains('ClientException')) {
      final errorString = error.toString().toLowerCase();
      return errorString.contains('failed host lookup') ||
          errorString.contains('no address associated with hostname') ||
          errorString.contains('socketexception') ||
          errorString.contains('connection closed') ||
          errorString.contains('connection terminated');
    }

    // Handle other common network error patterns
    final errorString = error.toString().toLowerCase();
    return errorString.contains('no internet') ||
        errorString.contains('network error') ||
        errorString.contains('connection failed') ||
        errorString.contains('host lookup') ||
        errorString.contains('connection timeout');
  }

  // Get appropriate error message based on error type
  String _getErrorMessage(dynamic error) {
    if (_isNetworkError(error)) {
      return 'No internet connection. Please check your network settings and try again.';
    }
    return ApiExceptionMsg.getMessageForException(error);
  }

  // Show network error snackbar
  void _showNetworkErrorSnackbar() {
    if (Get.context != null) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'No internet connection. Please check your network settings and try again.',
        SnackbarType.internetConnection,
      );
    }
  }

  // Handle network errors consistently
  ApiResponse<T> _handleNetworkError<T>(dynamic error, String endpoint) {
    log('Network error in $endpoint: $error');

    if (_isNetworkError(error)) {
      _showNetworkErrorSnackbar();
      return ApiResponse.error(
          'No internet connection. Please check your network settings and try again.');
    }

    return ApiResponse.error(_getErrorMessage(error));
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
    bool showNetworkError = true, // Option to control snackbar display
  }) async {
    try {
      final headers = getHeader(token, apiKey: apiKey);
      log('Headers used for request: $headers');

      final response = await MyHttpClient.client
          .get(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: headers,
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timeout', const Duration(seconds: 5));
        },
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

      if (_isNetworkError(e)) {
        if (showNetworkError) {
          _showNetworkErrorSnackbar();
        }
        return ApiResponse.error(
            'No internet connection. Please check your network settings and try again.');
      }

      // For non-network errors that might still require session handling
      if (e is SocketException || e is TimeoutException) {
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
    bool showNetworkError = true, // Option to control snackbar display
  }) async {
    try {
      final response = await MyHttpClient.client
          .post(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        body: jsonEncode(requestBody),
        headers: getHeader(token, apiKey: apiKey),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timeout', const Duration(seconds: 5));
        },
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
      log("Error in postApi: $e");

      if (_isNetworkError(e)) {
        if (showNetworkError) {
          _showNetworkErrorSnackbar();
        }
        return ApiResponse.error(
            'No internet connection. Please check your network settings and try again.');
      }

      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }

  //PATCH
  Future<ApiResponse<T>> patchApi<T>(
    String endPoint, {
    required dynamic requestBody,
    required String token,
    String? apiKey,
    required T Function(dynamic json)? fromJson,
    bool showNetworkError = true,
  }) async {
    try {
      final response = await MyHttpClient.client
          .patch(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        body: jsonEncode(requestBody),
        headers: getHeader(token, apiKey: apiKey),
      )
          .timeout(
        const Duration(seconds: 5), // Add timeout
        onTimeout: () {
          throw TimeoutException('Request timeout', const Duration(seconds: 5));
        },
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
      log('Error in patchApi: $e');

      if (_isNetworkError(e)) {
        if (showNetworkError) {
          _showNetworkErrorSnackbar();
        }
        return ApiResponse.error(
            'No internet connection. Please check your network settings and try again.');
      }

      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }

  //DELETE
  Future<ApiResponse<T>> deleteApi<T>(
    String endPoint, {
    required String token,
    String? apiKey,
    required T Function(dynamic json)? fromJson,
    bool showNetworkError = true,
  }) async {
    try {
      final response = await MyHttpClient.client
          .delete(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: getHeader(token, apiKey: apiKey),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timeout', const Duration(seconds: 5));
        },
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
      log('Error in deleteApi: $e');

      if (_isNetworkError(e)) {
        if (showNetworkError) {
          _showNetworkErrorSnackbar();
        }
        return ApiResponse.error(
            'No internet connection. Please check your network settings and try again.');
      }

      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }

  // PUT method (if needed)
  Future<ApiResponse<T>> putApi<T>(
    String endPoint, {
    required dynamic requestBody,
    required String token,
    String? apiKey,
    required T Function(dynamic json)? fromJson,
    bool showNetworkError = true,
  }) async {
    try {
      final response = await MyHttpClient.client
          .put(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        body: jsonEncode(requestBody),
        headers: getHeader(token, apiKey: apiKey),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timeout', const Duration(seconds: 5));
        },
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
      log('Error in putApi: $e');

      if (_isNetworkError(e)) {
        if (showNetworkError) {
          _showNetworkErrorSnackbar();
        }
        return ApiResponse.error(
            'No internet connection. Please check your network settings and try again.');
      }

      return ApiResponse.error(ApiExceptionMsg.getMessageForException(e));
    }
  }

  // Utility method to check network connectivity without making actual API call
  // Future<bool> checkNetworkConnectivity() async {
  //   try {
  //     final response = await MyHttpClient.client.get(
  //       Uri.parse(ApiUrls.baseUrl +
  //           '/health'), // Assuming you have a health check endpoint
  //       headers: {'Content-Type': 'application/json'},
  //     ).timeout(const Duration(seconds: 5));

  //     return response.statusCode == 200;
  //   } catch (e) {
  //     return !_isNetworkError(e);
  //   }
  // }

  // Retry mechanism for failed requests
  Future<ApiResponse<T>> retryRequest<T>(
    Future<ApiResponse<T>> Function() apiCall, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        final response = await apiCall();
        if (response.status == ApiStatus.SUCCESS) {
          return response;
        }

        // If it's not a network error, don't retry
        if (!_isNetworkError(response.message)) {
          return response;
        }
      } catch (e) {
        if (!_isNetworkError(e) || attempts == maxRetries - 1) {
          return ApiResponse.error(_getErrorMessage(e));
        }
      }

      attempts++;
      if (attempts < maxRetries) {
        log('Retrying request... Attempt $attempts/$maxRetries');
        await Future.delayed(retryDelay);
      }
    }

    return ApiResponse.error(
        'Request failed after $maxRetries attempts. Please check your internet connection.');
  }
}
