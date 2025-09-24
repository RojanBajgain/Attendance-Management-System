import 'dart:developer';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/notification_repo.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notification = <Datum>[].obs;
  var notificationways = 1.obs;
  var tabValue = 0.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasMore = true.obs;
  var page = 1;
  final int limit = 10;
  var unreadCount = 0.obs;

  final NotificationRepo notificationrepo;

  NotificationController({required this.notificationrepo});

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  Future<void> getNotification({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMore.value || isLoading.value) return;
      page++;
    } else {
      page = 1;
      hasMore.value = true;
    }
    isLoading(true);
    try {
      ApiResponse response =
          await notificationrepo.getNotification(page: page, limit: limit);

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
        if (loadMore) {
          notification.addAll(newData);
        } else {
          notification.value = newData;
        }

        hasMore.value =
            notificationdata.currentPage < notificationdata.totalPages;

        updateUnreadCount();
        log("Notification list length: ${notification.length}, Unread: ${unreadCount.value}");
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

  void loadMore() {
    getNotification(loadMore: true);
  }

  // Update unread count helper method
  void updateUnreadCount() {
    unreadCount.value = notification.where((n) => n.isRead == false).length;
  }

  // Mark a single notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      log("Marking notification $notificationId as read");

      // Find and update the notification locally
      final notificationIndex =
          notification.indexWhere((n) => n.id == notificationId);
      if (notificationIndex != -1) {
        notification[notificationIndex].isRead = true;
        notification.refresh(); // Trigger UI update
        updateUnreadCount();

        log("Notification $notificationId marked as read locally. Unread count: ${unreadCount.value}");

        // Optional: Show success message
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Notification marked as read.',
          SnackbarType.success,
        );
      }
    } catch (e) {
      log("Error marking notification as read: $e");
      errorMessage.value = "Failed to mark notification as read: $e";

      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Failed to mark notification as read.',
        SnackbarType.error,
      );
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      log("Before marking all read: Unread count: ${unreadCount.value}");

      for (var notif in notification) {
        notif.isRead = true;
      }
      notification.refresh();
      updateUnreadCount();

      log("After marking all read: Unread count: ${unreadCount.value}");

      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'All notifications marked as read.',
        SnackbarType.success,
      );
    } catch (e) {
      log("Error marking all notifications as read: $e");
      errorMessage.value = "An error occurred: $e";

      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Failed to mark all notifications as read.',
        SnackbarType.error,
      );
    }
  }

  Future<void> delelteNotification(int id) async {
    try {
      ApiResponse response = await notificationrepo.deleteNotification(id);
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Notification deleted.',
        SnackbarType.success,
      );
      getNotification(loadMore: false);
      print('Delete response: $response');
    } catch (e) {
      log("Error deleting notification: $e");
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Failed to delete notification.',
        SnackbarType.error,
      );
    }
  }

  //read notification (bulk read - from server)
  Future<void> readNotification() async {
    try {
      ApiResponse response = await notificationrepo.readNotification();
      await getNotification();
      log("Read notification response: $response");
    } catch (e) {
      log("Error reading notifications: $e");
    }
  }
}
