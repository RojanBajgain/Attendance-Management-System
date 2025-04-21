import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';

class EventTooltip extends StatelessWidget {
  final bool isDarkMode;
  final CalenderNotificationController controller;
  final VoidCallback onViewAll;
  final BuildContext rootContext;

  EventTooltip({
    required this.isDarkMode,
    required this.controller,
    required this.onViewAll,
    required this.rootContext,
  });

  @override
  Widget build(BuildContext context) {
    // Filter for today event
    final todayEvents = controller.eventCalenders.where((event) {
      if (event.startDate == null) return false;
      final today = DateTime.now();
      return isSameDay(event.startDate!, today);
    }).toList();

    return Container(
      width: 300,
      constraints: BoxConstraints(maxHeight: 400),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Events",
                style: normalStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                )),
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
                  "No events for today",
                  style: smallNStyle.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
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
                  switch (event.type) {
                    case EventType.HOLIDAY:
                      typeName = "holiday";
                      typeColor = Colors.red;
                      break;
                    case EventType.NOTICE:
                      typeName = "notice";
                      typeColor = Colors.green;
                      break;
                    case EventType.EVENT:
                      typeName = "event";
                      typeColor = Colors.blue;
                      break;
                    default:
                      typeName = "event";
                      typeColor = Colors.grey;
                  }

                  // Get current date info for the circle
                  final now = DateTime.now();
                  final month = DateFormat('MMM').format(now);
                  final day = DateFormat('d').format(now);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
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

                        // Event details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                event.name ?? "Untitled Event",
                                style: smallStyle.copyWith(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                maxLines: 2,
                              ),

                              const SizedBox(height: 8),

                              // type badge
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

                              // Descriptions
                              if (event.description != null &&
                                  event.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    event.description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                    maxLines: 3,
                                  ),
                                ),

                              const SizedBox(height: 8),

                              // Date range with icon
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
                                      fontSize: 12,
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
      ),
    );
  }

  // Functioon to check if two days are the same days
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
