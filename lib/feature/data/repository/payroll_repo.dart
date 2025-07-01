import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/payroll/model/payroll_detail_model.dart';
import 'package:ams/feature/presentation/pages/payroll/model/payroll_model.dart';

class PayrollRepo {
  final ApiClient apiClient;

  PayrollRepo({required this.apiClient});

  // Get Payrolls
  Future<ApiResponse> getPayroll() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.payroll,
      token: token,
      apiKey: organization,
      fromJson: (json) => PayRollModel.fromJson(json),
    );
    return response;
  }

  // Getting payroll details
  Future<ApiResponse> getPayrollDetail(String id) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      '${ApiUrls.payrolldetail}$id/',
      token: token,
      apiKey: organization,
      fromJson: (json) => PayrollDetailModel.fromJson(json),
    );
    return response;
  }
}
