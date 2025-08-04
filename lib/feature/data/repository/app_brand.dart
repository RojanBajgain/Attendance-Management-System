import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/model/app_brand.dart';

class AppBrandRepo {
  final ApiClient apiClient;

  AppBrandRepo({required this.apiClient});

  Future<ApiResponse> getAppBrand() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.imageBrand,
      token: token,
      apiKey: organization,
      fromJson: (json) => AppBrand.fromJson(json),
    );
    return response;
  }
}
