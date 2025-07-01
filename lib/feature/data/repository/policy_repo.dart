import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/policy/model/policy_model.dart';

class PolicyRepo {
  final ApiClient apiClient;

  PolicyRepo({required this.apiClient});

  // Get Policy
  Future<ApiResponse> getPolicydetail() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.policydetail,
      token: token,
      apiKey: organization,
      fromJson: (json) => PolicyModel.fromJson(json),
    );
    return response;
  }
}
