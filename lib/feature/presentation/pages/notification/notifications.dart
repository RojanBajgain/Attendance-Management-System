import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/notification/controller/notification_controller.dart';
import 'package:ams/feature/presentation/pages/notification/sub_view_notification/notification_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    notificationcontroller.getNotification();
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
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.message_outlined,
        //       size: 30.0,
        //       color: isDarkMode ? Colors.white : Colors.black,
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  // height: 750,
                  child: Obx(() {
                    if (notificationcontroller.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ShrimmerEffect.rectangular(height: 600),
                      );
                    } else if (notificationcontroller.notification.isEmpty) {
                      return SizedBox(
                        child: Center(
                          child: Text(
                            "No notification availabale",
                            style: smallStyle.copyWith(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
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
                                    ? DateFormat.d()
                                        .format(notification.timestamp!)
                                    : "N/A",
                                contextTxt: notification.title.toString(),
                                contextTxtDetail:
                                    notification.description.toString(),
                                contextTime: notification.timestamp != null
                                    ? _getRelativeDate(notification.timestamp!)
                                    : "---",
                              ),
                            );
                          });
                    }
                  }),
                ) //
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
