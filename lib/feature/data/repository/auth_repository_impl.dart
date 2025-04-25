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
  Future<ApiResponse<LoginModel>> login(String email, String pw) async {
    final response = await ApiClient.postApi<LoginModel>(
      ApiUrls.login,
      requestBody: {"email": email, "password": pw},
      token: '',
      fromJson: (json) => LoginModel.fromJson(json),
    );
    return response;
  }

  // Future<ApiResponse> register(String identity, String password,
  //     String confirmPassword, String collageName) async {
  //   final response = await ApiClient.postApi(
  //     ApiUrls.register,
  //     requestBody: {
  //       'identity': identity,
  //       'password': password,
  //       'confirmPassword': confirmPassword,
  //       'collegeName': collageName,
  //     },
  //     token: '',
  //     fromJson: null,
  //   );
  //   return response;
  // }

  // Logout
  Future<ApiResponse> logOut(String refreshToken, String accessToken) async {
    final response = await ApiClient.postApi(
      ApiUrls.logout,
      requestBody: {'refresh_token': refreshToken},
      token: accessToken,
      fromJson: null,
    );
    return response;
  }

  // Change Password
  Future<ApiResponse> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    final response = await ApiClient.postApi(
      ApiUrls.changePassword,
      requestBody: {
        'old_password': oldPassword,
        'new_password1': newPassword,
        'new_password2': confirmPassword,
      },
      token: apiClient.token,
      fromJson: null,
    );
    return response;
  }
}
