import 'dart:developer';

import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';

class EventTooltip extends StatelessWidget {
  final bool isDarkMode;
  final CalenderNotificationController controller;
  final VoidCallback onViewAll;
  final BuildContext rootContext;

  EventTooltip({
    super.key,
    required this.isDarkMode,
    required this.controller,
    required this.onViewAll,
    required this.rootContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                controller.errorMessage.value,
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        final today = DateTime.now();

        // Filter today's data (all types: events, holidays, notices)
        final todayEvents = controller.eventCalenders.where((event) {
          if (event.startDate == null) return false;
          return isSameDay(event.startDate!, today);
        }).toList();

        log("Tooltip: Found ${todayEvents.length} items for today: ${todayEvents.map((e) => {
              'name': e.name,
              'type': e.type
            }).toList()}");

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "Today's Schedule (${DateFormat("d MMMM',' y").format(today)})",
                  style: smallNStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            ),
            if (todayEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "No events, holidays, or notices for today",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: todayEvents.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  ),
                  itemBuilder: (context, index) {
                    final event = todayEvents[index];

                    String dateText;
                    if (event.startDate != null && event.endDate != null) {
                      if (isSameDay(event.startDate!, event.endDate!)) {
                        dateText =
                            DateFormat('d MMM yyyy').format(event.startDate!);
                      } else {
                        dateText =
                            "${DateFormat('d MMM yyyy').format(event.startDate!)} - ${DateFormat('d MMM yyyy').format(event.endDate!)}";
                      }
                    } else if (event.startDate != null) {
                      dateText =
                          DateFormat('d MMM yyyy').format(event.startDate!);
                    } else {
                      dateText = "Date not specified";
                    }

                    String typeName;
                    Color typeColor;
                    switch (event.type?.toUpperCase()) {
                      case "HOLIDAY":
                        typeName = "Holiday";
                        typeColor = Colors.red;
                        break;
                      case "NOTICE":
                        typeName = "Notice";
                        typeColor = Colors.green;
                        break;
                      case "EVENT":
                        typeName = "Event";
                        typeColor = Colors.blue;
                        break;
                      case "REMINDER":
                        typeName = "Reminder";
                        typeColor = Colors.yellow.shade700;
                        break;
                      default:
                        typeName = "Unknown";
                        typeColor = Colors.grey;
                        log("Unknown type for event: ${event.name}, type: ${event.type}");
                    }

                    final now = DateTime.now();
                    final month = DateFormat('MMM').format(now);
                    final day = DateFormat('d').format(now);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: typeColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  month,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  day,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title ?? event.name ?? "Untitled",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: typeColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    typeName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (event.description != null &&
                                    event.description!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      event.description!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (event.remarks != null &&
                                    event.remarks!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Remarks: ${event.remarks}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (event.createdBy != null &&
                                    event.createdBy!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Created by: ${event.createdBy}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                if (event.user != null &&
                                    event.user!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Created By: ${event.user}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 14,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      dateText,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            Divider(
              height: 1,
              thickness: 1,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            ),
            InkWell(
              onTap: onViewAll,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    "View all",
                    style: smallStyle.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
