import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/timeoff_repo.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';
import 'package:get/get.dart';

class TimeoffController extends GetxController {
  var timeoff = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final TimeoffRepo timeoffRepo;

  TimeoffController({required this.timeoffRepo});

  @override
  void onInit() {
    getTimeoff();
    super.onInit();
  }

  Future<void> getTimeoff() async {
    try {
      ApiResponse response = await timeoffRepo.getTimeoff();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetch Timeoff data: ${response.response}");

        TimeoffModel timeoffdata = response.response;
        timeoff.value = timeoffdata.data;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching timeoff: $e");

      errorMessage.value = "An error occurred: $e";
    }
  }
}
