import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CalenderNotificationController _controller =
      Get.find<CalenderNotificationController>();
  List<EventCalenderModel> filteredEvents = [];
  String activeTabType = "EVENT";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    // Initialize filteredEvents
    filteredEvents = _filterEvents(activeTabType);
    // Check if data is already loaded; fetch only if empty
    if (_controller.eventCalenders.isEmpty &&
        _controller.errorMessage.value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.getEventCalenders().then((_) {
          if (mounted) {
            setState(() {
              filteredEvents = _filterEvents(activeTabType);
              log("Initial filtered events for $activeTabType: ${filteredEvents.length}");
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging ||
        _tabController.index != _tabController.previousIndex) {
      String tabType;
      switch (_tabController.index) {
        case 0:
          tabType = "EVENT";
          break;
        case 1:
          tabType = "NOTICE";
          break;
        case 2:
          tabType = "HOLIDAY";
          break;
        case 3:
          tabType = "REMINDER";
          break;
        default:
          tabType = "EVENT";
      }
      if (mounted) {
        setState(() {
          activeTabType = tabType;
          filteredEvents = _filterEvents(activeTabType);
        });
      }
    }
  }

  List<EventCalenderModel> _filterEvents(String type) {
    final filtered = _controller.eventCalenders
        .where(
            (event) => (event.type?.toUpperCase() ?? '') == type.toUpperCase())
        .toList();
    log("Filtering for $type, found ${filtered.length} events");
    return filtered;
  }

  EventCalenderModel? getTodayEvent() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    try {
      return _controller.eventCalenders.firstWhere(
        (event) {
          final eventDate = event.startDate;
          if (eventDate == null) return false;
          return eventDate.year == today.year &&
              eventDate.month == today.month &&
              eventDate.day == today.day;
        },
      );
    } catch (e) {
      log("Error finding today's event: $e");
      return null;
    }
  }

  String getTabName(String type) {
    switch (type.toUpperCase()) {
      case "EVENT":
        return 'Events';
      case "NOTICE":
        return 'Notices';
      case "HOLIDAY":
        return 'Holidays';
      case "REMINDER":
        return 'Reminders';
      default:
        return 'Events';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final todayFormatted = DateFormat('MMM').format(now).substring(0, 3);
    final dayFormatted = DateFormat('d').format(now);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Events & Holidays',
          style: normalStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        titleSpacing: 0,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _controller.errorMessage.value,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _controller.getEventCalenders().then((_) {
                      if (mounted) {
                        setState(() {
                          filteredEvents = _filterEvents(activeTabType);
                        });
                      }
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Update filteredEvents if controller data changes
        if (_controller.eventCalenders.isNotEmpty && filteredEvents.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                filteredEvents = _filterEvents(activeTabType);
              });
            }
          });
        }

        final todayEvent = getTodayEvent();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: isDarkMode ? Colors.black : Colors.white,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: isDarkMode ? Colors.white : Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: isDarkMode ? Colors.white : Colors.black,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Events'),
                    Tab(text: 'Notices'),
                    Tab(text: 'Holidays'),
                    Tab(text: 'Reminders'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Event",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            _buildDateCircle(
                              month: todayFormatted,
                              day: dayFormatted,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todayEvent?.title ??
                                        todayEvent?.name ??
                                        "No events today",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  if (todayEvent?.type != null)
                                    _buildEventTag(todayEvent!.type!),
                                  const SizedBox(height: 6),
                                  if (todayEvent?.description != null &&
                                      todayEvent!.description!.isNotEmpty)
                                    Text(
                                      todayEvent.description!,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 6),
                                  if (todayEvent?.remarks != null &&
                                      todayEvent!.remarks!.isNotEmpty)
                                    Text(
                                      'Remarks: ${todayEvent.remarks}',
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 13, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        todayEvent?.startDate != null
                                            ? (todayEvent?.endDate != null &&
                                                    todayEvent!
                                                            .startDate!.year ==
                                                        todayEvent
                                                            .endDate!.year &&
                                                    todayEvent
                                                            .startDate!.month ==
                                                        todayEvent
                                                            .endDate!.month &&
                                                    todayEvent.startDate!.day ==
                                                        todayEvent.endDate!.day
                                                ? DateFormat('d MMM yyyy')
                                                    .format(
                                                        todayEvent.startDate!)
                                                : "${DateFormat('d MMM yyyy').format(todayEvent!.startDate!)} - ${DateFormat('d MMM yyyy').format(todayEvent.endDate!)}")
                                            : DateFormat('d MMM yyyy')
                                                .format(now),
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.grey.shade400
                                              : Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (todayEvent?.createdBy != null &&
                                      todayEvent!.createdBy!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        'Created by: ${todayEvent.createdBy}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.grey.shade400
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  if (todayEvent?.user != null &&
                                      todayEvent!.user!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        'Created By: ${todayEvent.user}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.grey.shade400
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "All ${getTabName(activeTabType)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (filteredEvents.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                              "No ${getTabName(activeTabType).toLowerCase()} found"),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          final month = event.startDate != null
                              ? DateFormat('MMM')
                                  .format(event.startDate!)
                                  .substring(0, 3)
                              : 'N/A';
                          final day = event.startDate != null
                              ? DateFormat('d').format(event.startDate!)
                              : 'N/A';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDateCircle(
                                      month: month,
                                      day: day,
                                      color: _getColorForEventType(event.type),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.title ??
                                                event.name ??
                                                "Untitled",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          if (event.type != null)
                                            _buildEventTag(event.type!),
                                          const SizedBox(height: 6),
                                          if (event.description != null &&
                                              event.description!.isNotEmpty)
                                            Text(
                                              event.description!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDarkMode
                                                    ? Colors.grey.shade400
                                                    : Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          const SizedBox(height: 6),
                                          if (event.remarks != null &&
                                              event.remarks!.isNotEmpty)
                                            Text(
                                              'Remarks: ${event.remarks}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDarkMode
                                                    ? Colors.grey.shade400
                                                    : Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today,
                                                  size: 13, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                event.startDate != null
                                                    ? (event.endDate != null &&
                                                            event.startDate!
                                                                    .year ==
                                                                event.endDate!
                                                                    .year &&
                                                            event.startDate!
                                                                    .month ==
                                                                event.endDate!
                                                                    .month &&
                                                            event.startDate!
                                                                    .day ==
                                                                event.endDate!
                                                                    .day
                                                        ? DateFormat(
                                                                'd MMM yyyy')
                                                            .format(event
                                                                .startDate!)
                                                        : "${DateFormat('d MMM yyyy').format(event.startDate!)} - ${DateFormat('d MMM yyyy').format(event.endDate ?? event.startDate!)}")
                                                    : 'Date not specified',
                                                style: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.grey.shade400
                                                      : Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (event.createdBy != null &&
                                              event.createdBy!.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.person,
                                                      size: 14,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      "Created by: ${event.createdBy}",
                                                      style: TextStyle(
                                                        color: isDarkMode
                                                            ? Colors
                                                                .grey.shade400
                                                            : Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (event.user != null &&
                                              event.user!.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.person_outline,
                                                      size: 14,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      "Assigned to: ${event.user}",
                                                      style: TextStyle(
                                                        color: isDarkMode
                                                            ? Colors
                                                                .grey.shade400
                                                            : Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Color _getColorForEventType(String? type) {
    switch (type?.toUpperCase()) {
      case "EVENT":
        return Colors.blue;
      case "HOLIDAY":
        return Colors.red;
      case "NOTICE":
        return Colors.orange;
      case "REMINDER":
        return Colors.yellow.shade700;
      default:
        return Colors.purple;
    }
  }

  Widget _buildDateCircle(
      {required String month, required String day, required Color color}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              month,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              day,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTag(String type) {
    Color tagColor = _getColorForEventType(type);
    String tagText;

    switch (type.toUpperCase()) {
      case "EVENT":
        tagText = "Event";
        break;
      case "HOLIDAY":
        tagText = "Holiday";
        break;
      case "NOTICE":
        tagText = "Notice";
        break;
      case "REMINDER":
        tagText = "Reminder";
        break;
      default:
        tagText = "Event";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tagText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
