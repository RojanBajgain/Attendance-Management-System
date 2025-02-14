import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_detail_model.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_model.dart';

class TimesheetRepo {
  final ApiClient apiClient;

  TimesheetRepo({required this.apiClient});

  // Get TimeSheet
  Future<ApiResponse> getTimesheet() async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT Token is missing or invalid');
    }

    final response = await ApiClient.getApi(
      ApiUrls.timesheet,
      token: token,
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
      fromJson: (json) => TimesheetDetailModel.fromJson(json),
    );
    return response;
  }
}
