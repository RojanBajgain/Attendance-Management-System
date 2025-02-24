import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/dashboard_timesheet_repo.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/dashboard_timesheet_model.dart';
import 'package:get/get.dart';

class DashboardTimesheetController extends GetxController {
  var dashboardtimesheet = DashboardTimesheet().obs;
  var isLoading = false.obs;

  final DashboardTimesheetRepo dashboardtimesheetrepo;

  DashboardTimesheetController({required this.dashboardtimesheetrepo});

  @override
  void onInit() {
    getDashboardTimesheet();
    super.onInit();
  }

  Future<void> getDashboardTimesheet() async {
    isLoading(true);
    try {
      ApiResponse response =
          await dashboardtimesheetrepo.getDashboardtimesheet();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Dashboard Timesheet data: ${response.response}");
        dashboardtimesheet.value = response.response;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching dashboard timesheet: $e");
    } finally {
      isLoading(false);
    }
  }
}
