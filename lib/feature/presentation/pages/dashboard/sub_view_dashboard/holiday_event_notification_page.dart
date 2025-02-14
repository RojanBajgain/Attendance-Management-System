import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/notification/controller/notification_controller.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HolidayEventNotification extends StatefulWidget {
  @override
  _HolidayEventNotificationState createState() =>
      _HolidayEventNotificationState();
}

class _HolidayEventNotificationState extends State<HolidayEventNotification> {
  bool isHolidaySelected = true;

  final NotificationController notificationcontroller =
      Get.put(NotificationController(notificationrepo: Get.find()));

  @override
  void initState() {
    super.initState();
    notificationcontroller.getNotification();
  }

  void selectHoliday() {
    setState(() {
      isHolidaySelected = true;
    });
  }

  void selectEvents() {
    setState(() {
      isHolidaySelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: selectHoliday,
                child: Column(
                  children: [
                    Text(
                      'Holiday',
                      style: smallNStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    if (isHolidaySelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 4.0,
                        width: 60.0,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 15.0),
              GestureDetector(
                onTap: selectEvents,
                child: Column(
                  children: [
                    Text(
                      'Events',
                      style: smallNStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    if (!isHolidaySelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 4.0,
                        width: 60.0,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),

          // Use Obx to reactively update the UI
          Obx(() {
            if (notificationcontroller.notification.isEmpty) {
              return Center(
                child: Text(
                  'No data available',
                  style: miniStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              );
            }

            // Filter the list based on the selected type
            final filteredList = notificationcontroller.notification
                .where((item) => isHolidaySelected
                    ? item.type!.toLowerCase() == "holiday"
                    : item.type!.toLowerCase() == "event")
                .toList();

            return filteredList.isEmpty
                ? Center(
                    child: Text(
                      'No ${isHolidaySelected ? 'Holidays' : 'Event'} found',
                      style: smallNStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _buildNotificationItem(item, isDarkMode);
                    },
                  );
          }),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Datum item, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.redAccent,
            ),
            child: Center(
              child: Text(
                item.timestamp != null ? "${item.timestamp!.day}" : "--",
                style: normalStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? "No Title",
                  style: smallNStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  item.description ?? "No Description",
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  item.timestamp != null
                      ? _getRelativeDate(item.timestamp!)
                      : "---",
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
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
