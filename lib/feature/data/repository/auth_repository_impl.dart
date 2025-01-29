import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/domain/repository/auth_repository.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
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

  Future<ApiResponse> logOut(String refreshToken, String accessToken) async {
    final response = await ApiClient.postApi(
      ApiUrls.logout,
      requestBody: {'refresh_token': refreshToken},
      token: accessToken,
      fromJson: null,
    );
    return response;
  }

  // Future<ApiResponse> logOut(String refreshToken, String accessToken) async {
  //   return await ApiClient.postApi(
  //     ApiUrls.logout,
  //     requestBody: {
  //       'refresh_token': refreshToken, // Send refresh token in the body
  //     },
  //     token: accessToken, // Send access token as the Bearer token
  //     fromJson: null, // You can use this if you want to parse the response
  //   );
  // }
}
