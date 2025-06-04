import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/calender_notification.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';
import 'package:get/get.dart';

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
      isLoading.value = true;
      errorMessage.value = '';
      ApiResponse response = await eventCalenderrepo.getEventCalenders();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Event Calendar data: ${response.response}");
        // Parse list of events
        List<dynamic> eventsJson = response.response is List
            ? response.response
            : (response.response['data'] is List
                ? response.response['data']
                : []);
        eventCalenders.assignAll(eventsJson
            .map((json) => EventCalenderModel.fromJson(json))
            .toList());
        log("Parsed ${eventCalenders.length} events: ${eventCalenders.map((e) => e.toJson())}");
      } else {
        log("Error: ${response.message}");
        errorMessage.value = response.message ?? "Unknown error";
      }
    } catch (e, stackTrace) {
      log("Error fetching calendar events: $e", stackTrace: stackTrace);
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
