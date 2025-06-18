import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/get_clock_model.dart';

class HasClockRepo {
  final ApiClient apiClient;

  HasClockRepo({required this.apiClient});

  // Get Payrolls
  Future<ApiResponse> getClock() async {
    final token = apiClient.token;

    final response = await ApiClient.getApi(
      ApiUrls.hasClockedIn,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => GetClockModel.fromJson(json),
    );
    return response;
  }
}
