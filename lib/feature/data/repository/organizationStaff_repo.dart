import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';

class OrganizationStaffRepo {
  final ApiClient apiClient;

  OrganizationStaffRepo({required this.apiClient});

  Future<ApiResponse> getorganizationStaff() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.organizationStaff,
      token: token,
      apiKey: organization,
      fromJson: (json) => (json),
    );
    return response;
  }
}
