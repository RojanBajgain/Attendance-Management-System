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
  bool isEventSelected = false;
  bool isNoticeSelected = false;

  // Map to track expanded state of each item
  final Map<String, bool> _expandedItems = {};

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
      isEventSelected = false;
      isNoticeSelected = false;
    });
  }

  void selectEvents() {
    setState(() {
      isHolidaySelected = false;
      isEventSelected = true;
      isNoticeSelected = false;
    });
  }

  void selectNotice() {
    setState(() {
      isHolidaySelected = false;
      isEventSelected = false;
      isNoticeSelected = true;
    });
  }

  // Toggle description expansion
  void _toggleExpanded(String itemId) {
    setState(() {
      _expandedItems[itemId] = !(_expandedItems[itemId] ?? false);
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
                    if (isEventSelected)
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
                onTap: selectNotice,
                child: Column(
                  children: [
                    Text(
                      'Notice',
                      style: smallNStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    if (isNoticeSelected)
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
            final filteredList =
                notificationcontroller.notification.where((item) {
              if (isHolidaySelected) {
                return item.type!.toLowerCase() == "holiday";
              } else if (isEventSelected) {
                return item.type!.toLowerCase() == "event";
              } else if (isNoticeSelected) {
                return item.type!.toLowerCase() == "notice";
              }
              return false;
            }).toList();

            return filteredList.isEmpty
                ? Center(
                    child: Text(
                      isHolidaySelected
                          ? 'No Holidays found'
                          : isEventSelected
                              ? 'No Events found'
                              : 'No Notices found',
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
    // Generate a unique ID for each item
    final itemId = item.id?.toString() ?? "${item.title}-${item.timestamp}";
    final isExpanded = _expandedItems[itemId] ?? false;
    final description = item.description ?? "No Description";

    // Handle description length
    final isLongDescription = description.length > 100;
    final displayDescription = isLongDescription && !isExpanded
        ? "${description.substring(0, 100)}..."
        : description;

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
                textAlign: TextAlign.start,
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timestamp at the top
                Text(
                  item.timestamp != null
                      ? _getRelativeDate(item.timestamp!)
                      : "---",
                  style: smallStyle.copyWith(
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5.0),

                // Title
                Text(
                  item.title ?? "No Title",
                  style: smallNStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5.0),

                // Description with show more/less
                Text(
                  displayDescription,
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),

                // Show more/less button if description is long
                if (isLongDescription)
                  InkWell(
                    onTap: () => _toggleExpanded(itemId),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        isExpanded ? "Show Less" : "Show More",
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.blueAccent : Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
