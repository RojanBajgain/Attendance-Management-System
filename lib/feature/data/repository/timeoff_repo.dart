import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';

class TimeoffRepo {
  final ApiClient apiClient;

  TimeoffRepo({required this.apiClient});

  // Get timeoffs
  Future<ApiResponse> getTimeoff() async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT Token is missing or invalid');
    }

    final response = await ApiClient.getApi(
      ApiUrls.timeoff,
      token: token,
      fromJson: (json) => TimeoffModel.fromJson(json),
    );
    return response;
  }
}
