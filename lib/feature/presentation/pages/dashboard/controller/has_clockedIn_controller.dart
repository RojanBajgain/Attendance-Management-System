import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/has_clockedIn_repo.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/get_clock_model.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart'; // For date formatting

class HasClockedinController extends GetxController {
  var clockedInTime = Rx<DateTime?>(null); // Store clock-in time as DateTime
  var isLoading = false.obs;

  final HasClockRepo hasClockedIn;

  HasClockedinController({required this.hasClockedIn});

  Future<void> getClockData() async {
    try {
      isLoading(true);
      ApiResponse response = await hasClockedIn.getClock();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // Assuming response.response is an instance of GetClockModel
        GetClockModel clockData = response.response;

        // Check if clockedData exists and is not null
        if (clockData.clockedData != null) {
          // Parse the UTC time from the API response
          DateTime utcTime = DateTime.parse(clockData.clockedData!.toString());

          // Convert UTC time to Nepal Time (UTC+05:45)
          DateTime localTime = utcTime.add(Duration(hours: 5, minutes: 45));

          // Update the clockedInTime value
          clockedInTime.value = localTime;
        } else {
          clockedInTime.value = null; // No clock-in data
        }
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching clock data: $e");
    } finally {
      isLoading(false);
    }
  }
}
