import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/reminder_repo.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddReminderController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final ReminderRepo addReminderRepo;

  AddReminderController({required this.addReminderRepo});

  Future<void> createtimeoff({
    required int profile,
    required String title,
    required String remarks,
    required String startdate,
    required String enddate,
  }) async {
    try {
      isLoading(true);

      ApiResponse response = await addReminderRepo.addReminder(
        profile,
        title,
        remarks,
        startdate,
        enddate,
      );

      if (response.status == ApiStatus.SUCCESS) {
        SSnackbarUtil.showSnackbar(
          'Success',
          'Reminder Posted successfully',
          SnackbarType.success,
        );
      } else {
        SSnackbarUtil.showSnackbar(
          'Error',
          'Failed to post reminder',
          SnackbarType.error,
        );
      }
    } catch (e) {
      log("Error creating reminder: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        SnackbarType.error,
      );
    } finally {
      isLoading(false);
    }
  }
}
