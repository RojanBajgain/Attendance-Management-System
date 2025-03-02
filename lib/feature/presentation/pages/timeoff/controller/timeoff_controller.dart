import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/timeoff_repo.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeoffController extends GetxController {
  var timeoff = <Datum>[].obs;
  var filteredTimeoff = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedFilter = 'All'.obs;

  final TimeoffRepo timeoffRepo;

  TimeoffController({required this.timeoffRepo});

  @override
  void onInit() {
    super.onInit();
    getTimeoff();
  }

  // Get Time offs
  Future<void> getTimeoff() async {
    isLoading(true);
    try {
      ApiResponse response = await timeoffRepo.getTimeoff();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetch Timeoff data: ${response.response}");

        TimeoffModel timeoffdata = response.response;

        timeoff.assignAll(timeoffdata.data);

        filterTimeoff(selectedFilter.value);
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

        Get.snackbar(
          'Posted Timeoff',
          response.message ?? 'Your Timeoff have been successfully posted',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );

        await getTimeoff();
      } else {
        log("Error: ${response.message}");
        Get.snackbar(
          'Server Error',
          'Failed to post timeoff. Please try again later',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub timeoff data: $e");
      }
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  // Filtered the timeoff
  void filterTimeoff(String status) {
    selectedFilter.value = status; // Update the selected filter

    if (status == 'All') {
      filteredTimeoff.assignAll(timeoff); // Show all entries
    } else {
      // Filter entries based on the selected status
      filteredTimeoff.assignAll(
        timeoff
            .where((item) => item.status?.toLowerCase() == status.toLowerCase())
            .toList(),
      );
    }
  }

  Future<void> reapply({
    required int id,
    required String reason,
  }) async {
    try {
      ApiResponse response = await timeoffRepo.postReapply(id, reason);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created reapply data: ${response.response}");

        Get.back();

        Get.snackbar(
          'Posted Reapply',
          response.message ?? 'Your reapply has been successfully posted',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        log("Error: ${response.message}");
        Get.snackbar(
          'Server Error',
          'Failed to post timeoff reapply. Please try again later',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
        );
      }
    } catch (e) {
      log("Error for re-apply of timeoff: $e");
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
