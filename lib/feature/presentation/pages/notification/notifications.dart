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

  @override
  void initState() {
    super.initState();
    if (notificationcontroller.notification.isEmpty) {
      notificationcontroller.getNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Notification',
          style: normalStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Obx(() {
                  if (notificationcontroller.isLoading.value) {
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
                        child: Text(
                          "No notification available",
                          style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notificationcontroller.notification.length,
                      itemBuilder: (context, index) {
                        final notification =
                            notificationcontroller.notification[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NotificationsContent(
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
                            contextTime: notification.timestamp != null
                                ? _getRelativeDate(notification.timestamp!)
                                : "---",
                          ),
                        );
                      },
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
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
