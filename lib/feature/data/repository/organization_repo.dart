import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_model.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_profile_model.dart';
import 'package:flutter/foundation.dart';

class OrganizationRepo {
  final ApiClient apiClient;

  OrganizationRepo({required this.apiClient});

  Future<ApiResponse> getOrganization() async {
    final token = await apiClient.token;

    final response = await apiClient.getApi(
      ApiUrls.organization,
      token: token,
      fromJson: (json) => OrganizationModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> getOrganizationProfile() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.postApi(
      ApiUrls.organizationProfile,
      token: token,
      apiKey: organization,
      requestBody: {},
      fromJson: (json) => OrganizationProfileModel.fromJson(json),
    );
    return response;
  }
}
