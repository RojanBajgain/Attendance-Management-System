import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/timesheet_repo.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_detail_model.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimesheetController extends GetxController {
  var timesheet = <Datum>[].obs;
  var filteredTimesheet = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var timesheetDetail = TimesheetDetailModel().obs;
  var selectedDate = Rxn<DateTime>();
  var dateRange = Rx<DateTimeRange?>(null);

  final TimesheetRepo timesheetRepo =
      TimesheetRepo(apiClient: Get.find<ApiClient>());

  TimesheetController();

  @override
  void onInit() {
    super.onInit();
    getTimesheet();
    clearDateRange();
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

  // Function to filter by selected single date
  void filterByDate(DateTime date) {
    selectedDate.value = date;
    dateRange.value = null;

    String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(date);
    filteredTimesheet.value = timesheet.where((timesheetdate) {
      String formattedEntryDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(timesheetdate.date.toString()));
      return formattedEntryDate == formattedSelectedDate;
    }).toList();
  }

  // New function to filter by date range
  void filterByDateRange(DateTime startDate, DateTime endDate) {
    if (timesheet.isEmpty) {
      filteredTimesheet.clear();
      return;
    }

    selectedDate.value = null;

    // Set the start date to the beginning of the day (00:00:00)
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    // Set the end date to the end of the day (23:59:59)
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    filteredTimesheet.value = timesheet.where((timesheetdate) {
      if (timesheetdate.date == null) return false;

      return (timesheetdate.date!.isAfter(start) ||
              timesheetdate.date!.isAtSameMomentAs(start)) &&
          (timesheetdate.date!.isBefore(end) ||
              timesheetdate.date!.isAtSameMomentAs(end));
    }).toList();
  }

  // Clear the selected date range and show all timesheet items
  void clearDateRange() {
    selectedDate.value = null;
    dateRange.value = null;
    filteredTimesheet.assignAll(timesheet);
  }

  void clearSelectedDate() {
    clearDateRange(); // For backward compatibility
  }
}
