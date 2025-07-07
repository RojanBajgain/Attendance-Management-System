import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';
import 'package:ams/feature/presentation/pages/calender_notification/sub_view_event/event_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class HolidayEventNotification extends StatefulWidget {
  const HolidayEventNotification({super.key});

  @override
  _HolidayEventNotificationState createState() =>
      _HolidayEventNotificationState();
}

class _HolidayEventNotificationState extends State<HolidayEventNotification> {
  String selectedType = "HOLIDAY";
  final Map<String, bool> _expandedItems = {};
  late final CalenderNotificationController calenderController;

  @override
  void initState() {
    super.initState();
    // Initialize controller
    try {
      calenderController = Get.find<CalenderNotificationController>();
    } catch (e) {
      calenderController = Get.put(
        CalenderNotificationController(eventCalenderrepo: Get.find()),
        permanent: true,
      );
      log("Initialized new CalenderNotificationController: $e");
    }
    // Fetch data
    calenderController.getEventCalenders().then((_) {
      log("Fetched ${calenderController.eventCalenders.length} events");
    });
  }

  void selectType(String type) {
    setState(() {
      selectedType = type;
      log("Selected type: $selectedType");
    });
  }

  void navigateToEventPage() {
    Get.to(
      () => const EventPage(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rounded Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectType("HOLIDAY"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedType == "HOLIDAY"
                            ? (isDarkMode ? Colors.white : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selectedType == "HOLIDAY"
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration_outlined,
                            size: 18,
                            color: selectedType == "HOLIDAY"
                                ? (isDarkMode ? Colors.black : Colors.black)
                                : (isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Holiday',
                            style: smallNStyle.copyWith(
                              color: selectedType == "HOLIDAY"
                                  ? (isDarkMode ? Colors.black : Colors.black)
                                  : (isDarkMode
                                      ? Colors.white70
                                      : Colors.black54),
                              fontWeight: selectedType == "HOLIDAY"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectType("EVENT"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedType == "EVENT"
                            ? (isDarkMode ? Colors.white : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selectedType == "EVENT"
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_available_outlined,
                            size: 18,
                            color: selectedType == "EVENT"
                                ? (isDarkMode ? Colors.black : Colors.black)
                                : (isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Events',
                            style: smallNStyle.copyWith(
                              color: selectedType == "EVENT"
                                  ? (isDarkMode ? Colors.black : Colors.black)
                                  : (isDarkMode
                                      ? Colors.white70
                                      : Colors.black54),
                              fontWeight: selectedType == "EVENT"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectType("NOTICE"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedType == "NOTICE"
                            ? (isDarkMode ? Colors.white : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selectedType == "NOTICE"
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.announcement_outlined,
                            size: 18,
                            color: selectedType == "NOTICE"
                                ? (isDarkMode ? Colors.black : Colors.black)
                                : (isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Notice',
                            style: smallNStyle.copyWith(
                              color: selectedType == "NOTICE"
                                  ? (isDarkMode ? Colors.black : Colors.black)
                                  : (isDarkMode
                                      ? Colors.white70
                                      : Colors.black54),
                              fontWeight: selectedType == "NOTICE"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Obx(() {
            if (calenderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (calenderController.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   calenderController.errorMessage.value,
                    //   style: smallNStyle.copyWith(
                    //     color: isDarkMode ? Colors.white : Colors.black,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => calenderController.getEventCalenders(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (calenderController.eventCalenders.isEmpty) {
              return Center(
                child: Text(
                  'No data available',
                  style: miniStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              );
            }

            final filteredList =
                calenderController.eventCalenders.where((item) {
              return (item.type?.toUpperCase() ?? '') ==
                  selectedType.toUpperCase();
            }).toList();

            log("Filtered ${filteredList.length} items for type: $selectedType");

            if (filteredList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/no_data.png',
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        selectedType == "HOLIDAY"
                            ? 'No Holidays been found'
                            : selectedType == "EVENT"
                                ? 'No Events been found'
                                : 'No Notices been found',
                        style: smallNStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

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
                // if (filteredList.length > 3)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       InkWell(
                //         onTap: navigateToEventPage,
                //         child: Padding(
                //           padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                //           child: Container(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 8.0, horizontal: 16.0),
                //             decoration: BoxDecoration(
                //               color:
                //                   isDarkMode ? Colors.blueAccent : Colors.blue,
                //               borderRadius: BorderRadius.circular(8.0),
                //             ),
                //             child: Text(
                //               'View All',
                //               style: smallStyle.copyWith(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
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
    final isLongDescription = description.length > 100;
    final displayDescription = isLongDescription && !isExpanded
        ? "${description.substring(0, 100)}..."
        : description;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
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
                item.startDate != null ? "${item.startDate!.day}" : "N/A",
                style: smallNStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
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
                      fontSize: 11.0,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 5.0),
                Text(
                  item.title ?? item.name ?? "Untitled",
                  style: smallStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                if (item.type != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getEventTypeColor(item.type),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.type?.toUpperCase() == "EVENT"
                          ? "Event"
                          : item.type?.toUpperCase() == "HOLIDAY"
                              ? "Holiday"
                              : "Notice",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                const SizedBox(height: 5.0),
                Text(
                  displayDescription,
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                    fontSize: 11.0,
                  ),
                ),
                if (item.remarks != null && item.remarks!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Remarks: ${item.remarks}',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (item.createdBy != null && item.createdBy!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Created by: ${item.createdBy}',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (item.user != null && item.user!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Assigned to: ${item.user}',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                      ),
                    ),
                  ),
                if (isLongDescription)
                  InkWell(
                    onTap: () => setState(() {
                      _expandedItems[itemId] = !isExpanded;
                    }),
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

    if (endDate != null &&
        startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return DateFormat('MMM d, yyyy').format(startDate);
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

  Color _getEventTypeColor(String? type) {
    switch (type?.toUpperCase()) {
      case "HOLIDAY":
        return Colors.red;
      case "EVENT":
        return Colors.blue;
      case "NOTICE":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
