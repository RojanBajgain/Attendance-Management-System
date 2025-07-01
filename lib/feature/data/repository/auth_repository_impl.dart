import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/domain/repository/auth_repository.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  // Login
  Future<ApiResponse<LoginModel>> login(
      String email, String pw, String role) async {
    final response = await apiClient.postApi<LoginModel>(
      ApiUrls.login,
      requestBody: {
        "email": email,
        "password": pw,
        "role": role,
      },
      token: '',
      fromJson: (json) => LoginModel.fromJson(json),
    );
    return response;
  }

  // Logout
  Future<ApiResponse> logOut(String refreshToken, String accessToken,
      String organizationApiKey) async {
    final response = await apiClient.postApi(
      ApiUrls.logout,
      requestBody: {
        'refresh_token': refreshToken,
        'organization': organizationApiKey,
      },
      token: accessToken,
      apiKey: organizationApiKey,
      fromJson: null,
    );
    return response;
  }

  // Change Password
  Future<ApiResponse> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.postApi(
      ApiUrls.changePassword,
      requestBody: {
        'old_password': oldPassword,
        'new_password1': newPassword,
        'new_password2': confirmPassword,
      },
      token: token,
      apiKey: organization,
      fromJson: null,
    );
    return response;
  }
}
