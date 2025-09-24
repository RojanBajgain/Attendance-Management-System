import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/notification/controller/notification_controller.dart';
import 'package:ams/feature/presentation/pages/notification/sub_view_notification/notification_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationController notificationcontroller =
      Get.put(NotificationController(notificationrepo: Get.find()));
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (notificationcontroller.notification.isEmpty) {
      notificationcontroller.getNotification();
    }
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (notificationcontroller.hasMore.value) {
        notificationcontroller.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          'Notifications',
          style: normalStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14.0,
          ),
        ),
        actions: [
          // Mark All as Read button
          Obx(() {
            final hasUnread = notificationcontroller.unreadCount.value > 0;
            if (hasUnread) {
              return TextButton.icon(
                onPressed: () {
                  notificationcontroller.markAllAsRead();
                },
                icon: Icon(
                  Icons.done_all,
                  size: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                label: Text(
                  'Mark All Read',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Unread count indicator
              Obx(() {
                final unreadCount = notificationcontroller.unreadCount.value;
                if (unreadCount > 0) {
                  return Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              Obx(() {
                if (notificationcontroller.isLoading.value &&
                    notificationcontroller.notification.isEmpty) {
                  return Column(
                    children: List.generate(
                      6,
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: SkeletonItem(),
                      ),
                    ),
                  );
                } else if (notificationcontroller.notification.isEmpty) {
                  return SizedBox(
                    height: 650,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: isDarkMode
                                ? Colors.grey[600]
                                : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No notifications available",
                            style: smallStyle.copyWith(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "You're all caught up!",
                            style: smallStyle.copyWith(
                              color: isDarkMode
                                  ? Colors.grey[500]
                                  : Colors.grey[500],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: notificationcontroller.notification.length +
                          (notificationcontroller.isLoading.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index ==
                            notificationcontroller.notification.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final notification =
                            notificationcontroller.notification[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 0),
                          child: NotificationsContent(
                            onDelete: () {
                              // Show confirmation dialog before deleting
                              _showDeleteConfirmation(context, notification.id);
                            },
                            onMarkAsRead: () {
                              notificationcontroller
                                  .markAsRead(notification.id);
                            },
                            notificationdata: notification,
                            calenderTxt: notification.timestamp != null
                                ? DateFormat.MMM()
                                    .format(notification.timestamp!)
                                : "N/A",
                            calenderDate: notification.timestamp != null
                                ? DateFormat.d().format(notification.timestamp!)
                                : "N/A",
                            contextTxt: notification.title.toString(),
                            contextTxtDetail:
                                notification.description.toString(),
                            contextTime:
                                notification.timestamp ?? DateTime.now(),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int notificationId) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          title: Text(
            'Delete Notification',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this notification?',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                notificationcontroller.delelteNotification(notificationId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

String _getRelativeDate(DateTime timestamp) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final apiDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

  final difference = apiDate.difference(today).inDays;

  if (difference == 0) {
    return "Today";
  } else if (difference > 0) {
    return "Coming in $difference ${difference == 1 ? 'day' : 'days'}";
  } else {
    return "${difference.abs()} ${difference == -1 ? 'day' : 'days'} ago";
  }
}

class SkeletonItem extends StatelessWidget {
  const SkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: true,
      skeleton: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar-style box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            // Textual content placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: const SizedBox.shrink(),
    );
  }
}
