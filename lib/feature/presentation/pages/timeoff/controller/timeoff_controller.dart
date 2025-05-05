import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/timeoff_repo.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TimeoffController extends GetxController {
  var timeoff = <Datum>[].obs;
  var filteredTimeoff = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedFilter = 'All'.obs;

  bool _hasLoadedOnce = false;

  final TimeoffRepo timeoffRepo;

  TimeoffController({required this.timeoffRepo});

  @override
  void onInit() {
    super.onInit();
    getTimeoff();
  }

  // Get Time offs
  Future<void> getTimeoff({bool forceRefresh = false}) async {
    if (_hasLoadedOnce && !forceRefresh) return;

    isLoading(true);
    try {
      ApiResponse response = await timeoffRepo.getTimeoff();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Fetch Timeoff data: ${response.response}");

        TimeoffModel timeoffdata = response.response;

        timeoff.assignAll(timeoffdata.data);
        filterTimeoff(selectedFilter.value);

        _hasLoadedOnce = true;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching timeoff: $e");
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  // Post Timeoffs
  Future<void> createtimeoff({
    required int userID,
    required int typeID,
    required String startdate,
    required String enddate,
    required String reason,
  }) async {
    try {
      ApiResponse response = await timeoffRepo.createtimeoff(
          userID, typeID, startdate, enddate, reason);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created timeoff data: ${response.response}");

        Get.back();

        SSnackbarUtil.showSnackbar(
          'Posted Timeoff',
          response.message ?? 'Your Timeoff have been successfully posted',
          SnackbarType.success,
        );

        await getTimeoff();
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Failed to post timeoff. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub timeoff data: $e");
      }

      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  // Filtered the timeoff
  void filterTimeoff(String status) {
    selectedFilter.value = status;

    if (status == 'All') {
      filteredTimeoff.assignAll(timeoff);
    } else {
      filteredTimeoff.assignAll(
        timeoff
            .where((item) => item.status?.toLowerCase() == status.toLowerCase())
            .toList(),
      );
    }
  }

  // For reapply
  Future<void> reapply({
    required int id,
    required String reason,
  }) async {
    try {
      ApiResponse response = await timeoffRepo.postReapply(id, reason);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Fetched created reapply data: ${response.response}");

        Get.back();

        SSnackbarUtil.showSnackbar(
          'Posted Reapply',
          response.message ?? 'Your reapply has been successfully posted',
          SnackbarType.success,
        );
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Failed to post timeoff reapply. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      log("Error for re-apply of timeoff: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }
}
