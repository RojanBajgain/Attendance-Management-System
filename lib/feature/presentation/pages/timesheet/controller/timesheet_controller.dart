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
  var isLoading = false.obs;
  var isLoadingMore = false.obs; // For pagination loading
  var errorMessage = ''.obs;
  var timesheetDetail = TimesheetDetailModel().obs;
  var selectedDate = Rxn<DateTime>();
  var dateRange = Rx<DateTimeRange?>(null);

  // Pagination variables
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalCount = 0.obs;
  var pageSize = 10.obs;
  var hasMoreData = true.obs;

  final TimesheetRepo timesheetRepo =
      TimesheetRepo(apiClient: Get.find<ApiClient>());

  ScrollController? _scrollController;
  bool _isDisposed = false;

  // Getter for scroll controller
  ScrollController? get scrollController => _scrollController;

  TimesheetController();

  @override
  void onInit() {
    super.onInit();
    _initializeScrollController();
    getTimesheet(isInitialLoad: true);
  }

  void _initializeScrollController() {
    if (!_isDisposed) {
      _scrollController = ScrollController();
      _setupScrollListener();
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    _scrollController?.dispose();
    _scrollController = null;
    super.onClose();
  }

  void _setupScrollListener() {
    _scrollController?.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isDisposed ||
        _scrollController == null ||
        !_scrollController!.hasClients) {
      return;
    }

    final scrollController = _scrollController!;
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreTimesheet();
    }
  }

  Future<void> getTimesheet({
    bool isInitialLoad = false,
    int? page,
    String? startDate,
    String? endDate,
  }) async {
    if (_isDisposed) return;

    if (isInitialLoad) {
      isLoading(true);
      currentPage.value = 1;
      timesheet.clear();
    } else {
      isLoadingMore(true);
    }

    try {
      final pageToLoad = page ?? currentPage.value;

      ApiResponse response = await timesheetRepo.getTimesheet(
        page: pageToLoad,
        pageSize: pageSize.value,
        startDate: startDate,
        endDate: endDate,
      );

      if (_isDisposed) return;

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Timesheet data: ${response.response}");

        TimesheetModel timesheetData = response.response;

        // Update pagination info
        totalPages.value = timesheetData.totalPages;
        totalCount.value = timesheetData.count;
        currentPage.value = timesheetData.currentPage;

        // Check if there's more data to load
        hasMoreData.value = currentPage.value < totalPages.value;

        if (isInitialLoad) {
          timesheet.value = timesheetData.data;
        } else {
          // Append new data for pagination
          timesheet.addAll(timesheetData.data);
        }
      } else {
        log("Error: ${response.message}");
        errorMessage.value = response.message ?? "Unknown error occurred";
      }
    } catch (e) {
      if (!_isDisposed) {
        log("Error fetching timesheet: $e");
        errorMessage.value = "An error occurred: $e";
      }
    } finally {
      if (!_isDisposed) {
        isLoading(false);
        isLoadingMore(false);
      }
    }
  }

  Future<void> loadMoreTimesheet() async {
    if (_isDisposed || !hasMoreData.value || isLoadingMore.value) {
      return;
    }

    String? startDate;
    String? endDate;

    // Include date filters if active
    if (dateRange.value != null) {
      startDate = DateFormat('yyyy-MM-dd').format(dateRange.value!.start);
      endDate = DateFormat('yyyy-MM-dd').format(dateRange.value!.end);
    } else if (selectedDate.value != null) {
      startDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
      endDate = startDate;
    }

    await getTimesheet(
      page: currentPage.value + 1,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> refreshTimesheet() async {
    if (_isDisposed) return;

    String? startDate;
    String? endDate;

    // Include current filters in refresh
    if (dateRange.value != null) {
      startDate = DateFormat('yyyy-MM-dd').format(dateRange.value!.start);
      endDate = DateFormat('yyyy-MM-dd').format(dateRange.value!.end);
    } else if (selectedDate.value != null) {
      startDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
      endDate = startDate;
    }

    await getTimesheet(
      isInitialLoad: true,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> getTimesheetDetailData(String serialNo) async {
    if (_isDisposed) return;

    ApiResponse response = await timesheetRepo.getTimesheetDetail(serialNo);
    try {
      if (_isDisposed) return;

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
        if (!_isDisposed) {
          Get.snackbar('Error', 'Failed to fetch Timesheet details.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('the error of Timesheet detail is $e');
      }
    }
  }

  // Function to filter by selected single date
  void filterByDate(DateTime date) {
    if (_isDisposed) return;

    selectedDate.value = date;
    dateRange.value = null;

    String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(date);

    // Reset pagination and fetch filtered data
    getTimesheet(
      isInitialLoad: true,
      startDate: formattedSelectedDate,
      endDate: formattedSelectedDate,
    );
  }

  // Function to filter by date range
  void filterByDateRange(DateTime startDate, DateTime endDate) {
    if (_isDisposed) return;

    selectedDate.value = null;
    dateRange.value = DateTimeRange(start: startDate, end: endDate);

    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    // Reset pagination and fetch filtered data
    getTimesheet(
      isInitialLoad: true,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
    );
  }

  // Clear the selected date range and show all timesheet items
  void clearDateRange() {
    if (_isDisposed) return;

    selectedDate.value = null;
    dateRange.value = null;

    // Reset pagination and fetch all data
    getTimesheet(isInitialLoad: true);
  }

  void clearSelectedDate() {
    clearDateRange(); // For backward compatibility
  }

  // Method to reinitialize scroll controller if needed
  void reinitializeScrollController() {
    if (!_isDisposed && _scrollController == null) {
      _initializeScrollController();
    }
  }
}
