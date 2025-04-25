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
        GetClockModel clockData = response.response;

        if (clockData.clockedData != null) {
          DateTime utcTime = DateTime.parse(clockData.clockedData!.toString());

          DateTime localTime = utcTime.add(Duration(hours: 5, minutes: 45));

          clockedInTime.value = localTime;
        } else {
          clockedInTime.value = null;
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
