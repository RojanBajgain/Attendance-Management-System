import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/policy/model/policy_model.dart';

class PolicyRepo {
  final ApiClient apiClient;

  PolicyRepo({required this.apiClient});

  // Get Policy
  Future<ApiResponse> getPolicydetail() async {
    final token = apiClient.token;

    // if (token.isEmpty) {
    //   throw Exception('JWT Token is missing or invalid');
    // }

    final response = await ApiClient.getApi(
      ApiUrls.policydetail,
      token: token,
      fromJson: (json) => PolicyModel.fromJson(json),
    );
    return response;
  }
}
