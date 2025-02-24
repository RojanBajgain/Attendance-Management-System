import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:flutter/foundation.dart';

class ResetPasswordRepo {
  final ApiClient apiClient;

  ResetPasswordRepo({required this.apiClient});

  Future<ApiResponse> resetpassword(String email) async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }
    const url = ApiUrls.passwordreset;
    if (kDebugMode) {
      print(url);
    }

    final response = await ApiClient.postApi(
      requestBody: {
        'email': email,
      },
      url,
      token: token,
      fromJson: null,
    );
    return response;
  }
}
