import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/timeoff_repo.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';

class TimeoffController extends GetxController {
  var timeoff = <Datum>[].obs;
  var filteredTimeoff = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedFilter = 'All'.obs;

  bool _hasLoadedOnce = false;

  final TimeoffRepo timeoffRepo = TimeoffRepo(apiClient: Get.find<ApiClient>());

  TimeoffController();

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
        TimeoffModel timeoffdata = response.response;

        // Ensure we're processing the data correctly
        if (timeoffdata.data != null) {
          timeoff.assignAll(timeoffdata.data!);
          filterTimeoff(selectedFilter.value);
          _hasLoadedOnce = true;
        } else {
          log("Timeoff data is null in response");
        }
      } else {
        log("Error fetching timeoff: ${response.message}");
      }
    } catch (e) {
      log("Error in getTimeoff: $e");
    } finally {
      isLoading(false);
    }
  }

  // Post Timeoffs
  Future<void> createtimeoff({
    required int profile,
    required int type,
    required String startdate,
    required String enddate,
    required String reason,
  }) async {
    try {
      isLoading(true);

      // Debug log the parameters
      log('Creating timeoff with:');
      log('profileID: $profile');
      log('typeID: $type');
      log('startdate: $startdate');
      log('enddate: $enddate');
      log('reason: $reason');

      ApiResponse response = await timeoffRepo.createtimeoff(
        profile,
        type,
        startdate,
        enddate,
        reason,
      );

      if (response.status == ApiStatus.SUCCESS) {
        // Force refresh the timeoff list
        await getTimeoff(forceRefresh: true);

        Get.back();
        SSnackbarUtil.showSnackbar(
          'Success',
          'Timeoff request submitted successfully',
          SnackbarType.success,
        );
      } else {
        SSnackbarUtil.showSnackbar(
          'Error',
          response.message ?? 'Failed to submit timeoff request',
          SnackbarType.error,
        );
      }
    } catch (e) {
      log("Error creating timeoff: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        SnackbarType.error,
      );
    } finally {
      isLoading(false);
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

  Future<void> deleteTimeoff(int id) async {
    try {
      ApiResponse response = await timeoffRepo.deleteTimeoff(id);

      if (response.status == ApiStatus.SUCCESS || response.status == 204) {
        log("Timeoff deleted successfully: ID $id");
        SSnackbarUtil.showSnackbar(
          'Deleted Timeoff',
          'Your timeoff has been successfully deleted',
          SnackbarType.success,
        );
        // Delay navigation to allow snackbar to display
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
        await getTimeoff(forceRefresh: true);
      } else {
        log("Error deleting timeoff: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          response.message ??
              'Failed to delete timeoff. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      log("Exception in deleteTimeoff: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }
}
