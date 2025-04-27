import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/calender_notification.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CalenderNotificationController extends GetxController {
  var eventCalenders = <EventCalenderModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final EventCalenderRepo eventCalenderrepo;

  CalenderNotificationController({required this.eventCalenderrepo});

  @override
  void onInit() {
    super.onInit();
    getEventCalenders();
  }

  Future<void> getEventCalenders() async {
    try {
      ApiResponse response = await eventCalenderrepo.getEventCalenders();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Event Calender data: ${response.response}");

        // Parse list of events
        List<dynamic> eventsJson = response.response;
        eventCalenders.assignAll(eventsJson
            .map((json) => EventCalenderModel.fromJson(json))
            .toList());
      } else {
        log("Error: ${response.message}");
        errorMessage.value = response.message ?? "Unknown error";
      }
    } catch (e) {
      log("Error fetching calendar events: $e");
      errorMessage.value = "An error occurred: $e";
    }
  }
}
