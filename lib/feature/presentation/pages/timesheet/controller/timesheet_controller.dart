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
  var isLoadMore = false.obs;
  var errorMessage = ''.obs;
  var timesheetDetail = TimesheetDetailModel().obs;
  var selectedDate = Rxn<DateTime>();
  var dateRange = Rx<DateTimeRange?>(null);

  // Pagination variables
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasMoreData = true.obs;
  final pageSize = 10.obs;

  final TimesheetRepo timesheetRepo =
      TimesheetRepo(apiClient: Get.find<ApiClient>());

  @override
  void onInit() {
    super.onInit();
    getTimesheet();
    clearDateRange();
  }

  Future<void> getTimesheet({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMoreData.value || isLoadMore.value) return;
      isLoadMore(true);
    } else {
      if (isLoading.value) return;
      isLoading(true);
      currentPage.value = 1;
      hasMoreData.value = true;
      timesheet.clear();
      filteredTimesheet.clear();
    }

    try {
      ApiResponse response = await timesheetRepo.getTimesheet(
        page: currentPage.value,
        pageSize: pageSize.value,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        TimesheetModel timesheetdata = response.response;

        // Update pagination info
        totalPages.value = timesheetdata.totalPages;
        currentPage.value = timesheetdata.currentPage;
        hasMoreData.value = currentPage.value < totalPages.value;

        // Add new data to existing list if loadMore
        if (loadMore) {
          timesheet.addAll(timesheetdata.data);
        } else {
          timesheet.value = timesheetdata.data;
        }

        filteredTimesheet.value = timesheet;

        // Increment page for next load
        if (hasMoreData.value) {
          currentPage.value++;
        }
      } else {
        errorMessage.value = response.message ?? "Failed to load timesheet";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      if (loadMore) {
        isLoadMore(false);
      } else {
        isLoading(false);
      }
    }
  }

  Future<void> loadMoreTimesheet() async {
    if (hasMoreData.value && !isLoadMore.value) {
      await getTimesheet(loadMore: true);
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
    currentPage.value = 1;
    hasMoreData.value = true;

    String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(date);
    filteredTimesheet.value = timesheet.where((timesheetdate) {
      if (timesheetdate.date == null) return false;
      String formattedEntryDate =
          DateFormat('yyyy-MM-dd').format(timesheetdate.date!);
      return formattedEntryDate == formattedSelectedDate;
    }).toList();
  }

  // New function to filter by date range
  void filterByDateRange(DateTime startDate, DateTime endDate) {
    selectedDate.value = null;
    currentPage.value = 1;
    hasMoreData.value = true;

    final start = DateTime(startDate.year, startDate.month, startDate.day);
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
    currentPage.value = 1;
    hasMoreData.value = true;
    filteredTimesheet.assignAll(timesheet);
  }

  void clearSelectedDate() {
    clearDateRange();
  }
}
