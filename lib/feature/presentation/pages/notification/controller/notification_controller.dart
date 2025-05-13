import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/notification_repo.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notification = <Datum>[].obs;
  var notificationways = 1.obs;
  var tabValue = 0.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final NotificationRepo notificationrepo;

  NotificationController({required this.notificationrepo});

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  Future<void> getNotification() async {
    isLoading(true);
    try {
      ApiResponse response = await notificationrepo.getNotification();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Fetched Notification data: ${response.response}");

        NotificationModel notificationdata = response.response;
        notification.value = notificationdata.data;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching notification: $e");
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }
}
