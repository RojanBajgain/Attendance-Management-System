import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/dashboard_timesheet_model.dart';

class DashboardTimesheetRepo {
  final ApiClient apiClient;

  DashboardTimesheetRepo({required this.apiClient});

  Future<ApiResponse> getDashboardtimesheet() async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT Token is missing or invalid');
    }

    final response = await ApiClient.getApi(
      ApiUrls.dashboardtimesheet,
      token: token,
      fromJson: (json) => DashboardTimesheet.fromJson(json),
    );
    return response;
  }
}
