import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_detail_model.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_model.dart';

class TimesheetRepo {
  final ApiClient apiClient;

  TimesheetRepo({required this.apiClient});

  // Get TimeSheet with pagination support
  Future<ApiResponse> getTimesheet({
    int page = 1,
    int pageSize = 10,
    String? startDate,
    String? endDate,
  }) async {
    final token = apiClient.token;

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };

    if (startDate != null && startDate.isNotEmpty) {
      queryParams['start_date'] = startDate;
    }

    if (endDate != null && endDate.isNotEmpty) {
      queryParams['end_date'] = endDate;
    }

    final uri =
        Uri.parse(ApiUrls.timesheet).replace(queryParameters: queryParams);
    final url = uri.toString();

    final response = await ApiClient.getApi(
      url,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => TimesheetModel.fromJson(json),
    );
    return response;
  }

  // getting timesheet details
  Future<ApiResponse> getTimesheetDetail(String serialNo) async {
    final token = apiClient.token;
    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid token');
    }

    final response = await ApiClient.getApi(
      '${ApiUrls.timesheetdetail}$serialNo/',
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => TimesheetDetailModel.fromJson(json),
    );
    return response;
  }
}
