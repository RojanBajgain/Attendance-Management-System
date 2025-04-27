import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/sub_view_event/event_page.dart';
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

  final Map<String, bool> _expandedItems = {};

  final CalenderNotificationController calenderController =
      Get.put(CalenderNotificationController(eventCalenderrepo: Get.find()));

  @override
  void initState() {
    super.initState();
    calenderController.getEventCalenders();
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

  void navigateToEventPage() {
    EventType selectedType = isHolidaySelected
        ? EventType.HOLIDAY
        : isEventSelected
            ? EventType.EVENT
            : EventType.NOTICE;

    Get.to(() => EventPage());
  }

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
                        color: isDarkMode ? Colors.grey[300] : Colors.black,
                      ),
                    ),
                    if (isHolidaySelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 4.0,
                        width: 60.0,
                        color: isDarkMode ? Colors.grey[300] : Colors.black,
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
                        color: isDarkMode ? Colors.grey[300] : Colors.black,
                      ),
                    ),
                    if (isEventSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 4.0,
                        width: 60.0,
                        color: isDarkMode ? Colors.grey[300] : Colors.black,
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
                        color: isDarkMode ? Colors.grey[300] : Colors.black,
                      ),
                    ),
                    if (isNoticeSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 4.0,
                        width: 60.0,
                        color: isDarkMode ? Colors.grey[300] : Colors.black,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Obx(() {
            if (calenderController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // if (calenderController.errorMessage.value.isNotEmpty) {
            //   return Center(
            //     child: Text(
            //       calenderController.errorMessage.value,
            //       style: smallNStyle.copyWith(
            //         color: isDarkMode ? Colors.white : Colors.black,
            //       ),
            //     ),
            //   );
            // }

            if (calenderController.eventCalenders.isEmpty) {
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
                calenderController.eventCalenders.where((item) {
              if (isHolidaySelected) {
                return item.type == EventType.HOLIDAY;
              } else if (isEventSelected) {
                return item.type == EventType.EVENT;
              } else if (isNoticeSelected) {
                return item.type == EventType.NOTICE;
              }
              return false;
            }).toList();

            if (filteredList.isEmpty) {
              return Center(
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
              );
            }

            // Limit to 3 items for display
            final displayList = filteredList.length > 3
                ? filteredList.sublist(0, 3)
                : filteredList;

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final item = displayList[index];
                    return _buildCalendarItem(item, isDarkMode);
                  },
                ),
                if (filteredList.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 270.0),
                    child: InkWell(
                      onTap: navigateToEventPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.blueAccent : Colors.blue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'View All',
                          style: smallStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalendarItem(EventCalenderModel item, bool isDarkMode) {
    final itemId = item.id.toString();
    final isExpanded = _expandedItems[itemId] ?? false;
    final description = item.description ?? "No Description Available";

    // Handle description length
    final isLongDescription = description.length > 100;
    final displayDescription = isLongDescription && !isExpanded
        ? "${description.substring(0, 100)}..."
        : description;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      child: Row(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: _getEventTypeColor(item.type),
            ),
            child: Center(
              child: Text(
                item.startDate != null ? "${item.startDate!.day}" : "--",
                style: normalStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.white,
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
                Text(
                  _getDateRangeText(item.startDate, item.endDate),
                  style: smallStyle.copyWith(
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  item.name ?? "",
                  style: smallStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  displayDescription,
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                  ),
                ),
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

  String _getDateRangeText(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return "Date not specified";
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    if (endDate != null && endDate != startDate) {
      final DateFormat formatter = DateFormat('MMM d');
      return "${formatter.format(startDate)} - ${formatter.format(endDate)}";
    }

    final difference = start.difference(today).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference > 0) {
      return "Coming in $difference ${difference == 1 ? 'day' : 'days'}";
    } else {
      return "${difference.abs()} ${difference == -1 ? 'day' : 'days'} ago";
    }
  }

  Color _getEventTypeColor(EventType? type) {
    switch (type) {
      case EventType.HOLIDAY:
        return Colors.red;
      case EventType.EVENT:
        return Colors.blue;
      case EventType.NOTICE:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
