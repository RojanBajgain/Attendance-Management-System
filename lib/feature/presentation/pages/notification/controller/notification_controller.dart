import 'dart:developer';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/notification_repo.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

class NotificationController extends GetxController {
  var notification = <Datum>[].obs;
  var notificationways = 1.obs;
  var tabValue = 0.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final NotificationRepo notificationrepo;

  NotificationController({required this.notificationrepo});

  // @override
  // void onInit() {
  //   getNotification();
  //   super.onInit();
  // }

  Future<void> getNotification() async {
    isLoading(true);
    try {
      ApiResponse response = await notificationrepo.getNotification();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Notification data: ${response.response}");
        NotificationModel notificationdata = response.response;

        // Preserve local isRead status
        var newData = notificationdata.data;
        for (var newNotif in newData) {
          var existing =
              notification.firstWhereOrNull((n) => n.id == newNotif.id);
          if (existing != null) {
            newNotif.isRead = existing.isRead;
          }
        }

        notification.value = newData;
        log("Notification list length: ${notification.length}, Unread: ${notification.where((n) => n.isRead == false).length}");
      } else {
        log("Error: ${response.message}");
        errorMessage.value =
            response.message ?? "Failed to fetch notifications";
      }
    } catch (e) {
      log("Error fetching notification: $e");
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      log("Before marking read: Unread count: ${notification.where((n) => n.isRead == false).length}");
      for (var notif in notification) {
        notif.isRead = true;
      }
      notification.refresh();
      log("After marking read: Unread count: ${notification.where((n) => n.isRead == false).length}");
    } catch (e) {
      log("Error marking notifications as read: $e");
      errorMessage.value = "An error occurred: $e";
    }
  }
}
