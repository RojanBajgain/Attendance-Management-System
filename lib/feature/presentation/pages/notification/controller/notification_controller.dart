import 'dart:developer';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/notification_repo.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

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

        unreadCount.value = notification.where((n) => n.isRead == false).length;
        // notification.value = newData;
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

  void loadMore() {
    getNotification(loadMore: true);
  }

  Future<void> markAllAsRead() async {
    try {
      log("Before marking read: Unread count: ${notification.where((n) => n.isRead == false).length}");
      for (var notif in notification) {
        notif.isRead = true;
      }
      notification.refresh();
      unreadCount.value = 0;
      log("After marking read: Unread count: ${notification.where((n) => n.isRead == false).length}");
    } catch (e) {
      log("Error marking notifications as read: $e");
      errorMessage.value = "An error occurred: $e";
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

      print(' detelet $response');
    } catch (e) {
    } finally {}
  }

  //read notification
  Future<void> readNotification() async {
    ApiResponse response = await notificationrepo.readNotification();
    getNotification();
    print(response);
  }
}
