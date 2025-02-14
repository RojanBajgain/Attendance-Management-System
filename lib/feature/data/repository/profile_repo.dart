import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_detail_model.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';

class ProfileRepo {
  final ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  // Get profile
  Future<ApiResponse> getProfile() async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT Token is missing or invalid');
    }

    final response = await ApiClient.getApi(
      ApiUrls.profile,
      token: token,
      fromJson: (json) => ProfileModel.fromJson(json),
    );
    return response;
  }

  // Getting profile details
  Future<ApiResponse> getProfileDetail(String id) async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT Token is missing or invalid');
    }

    final response = await ApiClient.getApi(
      ApiUrls.profiledetail,
      token: token,
      fromJson: (json) => ProfileDetailModel.fromJson(json),
    );
    return response;
  }
}
