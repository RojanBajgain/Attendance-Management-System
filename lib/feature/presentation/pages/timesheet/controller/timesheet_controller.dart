import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/timesheet_repo.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_detail_model.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_model.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/timesheet_details.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimesheetController extends GetxController {
  var timesheet = <Datum>[].obs;
  var filteredTimesheet = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var timesheetDetail = TimesheetDetailModel().obs;
  var selectedDate = Rxn<DateTime>();

  final TimesheetRepo timesheetRepo;

  TimesheetController({required this.timesheetRepo});

  @override
  void onInit() {
    super.onInit();
    getTimesheet();
    clearSelectedDate();
  }

  Future<void> getTimesheet() async {
    isLoading(true);
    try {
      ApiResponse response = await timesheetRepo.getTimesheet();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Timesheet data: ${response.response}");

        TimesheetModel timesheetdata = response.response;
        timesheet.value = timesheetdata.data;

        filteredTimesheet.value = timesheet;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching timesheet: $e");

      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  Future<void> getTimesheetDetailData(String serialNo) async {
    ApiResponse response = await timesheetRepo.getTimesheetDetail(serialNo);
    try {
      if (response.status == ApiStatus.SUCCESS) {
        if (kDebugMode) {
          print(response.status);
        }

        log("fetched Timesheet detail Data: ${response.response}");

        timesheetDetail.value = response.response;
      } else {
        if (kDebugMode) {
          print('its error is ${response.status}');
        }
        Get.snackbar('Error', 'Failed to fetch Timesheet details.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('the error of Timesheet detail is $e');
      }
    }
  }

  // Function to filter by selected date
  void filterByDate(DateTime date) {
    selectedDate.value = date;

    String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(date);
    filteredTimesheet.value = timesheet.where((timesheetdate) {
      String formattedEntryDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(timesheetdate.date.toString()));
      return formattedEntryDate == formattedSelectedDate;
    }).toList();
  }

  void clearSelectedDate() {
    selectedDate.value = null;
    filteredTimesheet.assignAll(timesheet);
  }
}
