import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  EventType activeTabType = EventType.EVENT;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      EventType tabType;
      switch (_tabController.index) {
        case 0:
          tabType = EventType.EVENT;
          break;
        case 1:
          tabType = EventType.NOTICE;
          break;
        case 2:
          tabType = EventType.HOLIDAY;
          break;
        default:
          tabType = EventType.EVENT;
      }
      setState(() {
        activeTabType = tabType;
        filteredEvents = _filterEvents(tabType);
      });
    }
  }

  List<EventCalenderModel> _filterEvents(EventType type) {
    return _controller.eventCalenders
        .where((event) => event.type == type)
        .toList();
  }

  EventCalenderModel? getTodayEvent() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    try {
      return _controller.eventCalenders.firstWhere((event) {
        final eventDate = event.startDate;
        if (eventDate == null) return false;
        return eventDate.year == today.year &&
            eventDate.month == today.month &&
            eventDate.day == today.day;
      });
    } catch (e) {
      return null;
    }
  }

  String getTabName(EventType type) {
    switch (type) {
      case EventType.EVENT:
        return 'Events';
      case EventType.NOTICE:
        return 'Notices';
      case EventType.HOLIDAY:
        return 'Holidays';
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

        if (filteredEvents.isEmpty && _controller.eventCalenders.isNotEmpty) {
          filteredEvents = _filterEvents(activeTabType);
        }

        final todayEvent = getTodayEvent();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: isDarkMode ? Colors.black : Colors.white,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Events'),
                    Tab(text: 'Notices'),
                    Tab(text: 'Holidays'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Today's Event",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
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
                                todayEvent?.name ?? "No events today",
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
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 13, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    todayEvent?.startDate != null &&
                                            todayEvent?.endDate != null
                                        ? "${DateFormat('d MMM yyyy').format(todayEvent!.startDate!)} - ${DateFormat('d MMM yyyy').format(todayEvent.endDate!)}"
                                        : DateFormat('d MMM yyyy').format(now),
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey.shade400
                                            : Colors.black,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "All ${getTabName(activeTabType)}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    if (event.startDate == null) return const SizedBox.shrink();

                    final month = DateFormat('MMM')
                        .format(event.startDate!)
                        .substring(0, 3);
                    final day = DateFormat('d').format(event.startDate!);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey.shade800 : Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name ?? "",
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
                                        style: const TextStyle(fontSize: 13),
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
                                          event.endDate != null &&
                                                  event.startDate !=
                                                      event.endDate
                                              ? "${DateFormat('d MMM yyyy').format(event.startDate!)} - ${DateFormat('d MMM yyyy').format(event.endDate!)}"
                                              : "${DateFormat('d MMM yyyy').format(event.startDate!)} - ${DateFormat('d MMM yyyy').format(event.endDate!)}",
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
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.person,
                                                size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                "Created by: ${event.createdBy}",
                                                style: TextStyle(
                                                    color: isDarkMode
                                                        ? Colors.grey.shade400
                                                        : Colors.black,
                                                    fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
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
        );
      }),
    );
  }

  Color _getColorForEventType(EventType? type) {
    switch (type) {
      case EventType.EVENT:
        return Colors.blue;
      case EventType.HOLIDAY:
        return Colors.red;
      case EventType.NOTICE:
        return Colors.orange;
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

  Widget _buildEventTag(EventType type) {
    Color tagColor = _getColorForEventType(type);
    String tagText;

    switch (type) {
      case EventType.EVENT:
        tagText = "Event";
        break;
      case EventType.HOLIDAY:
        tagText = "Holiday";
        break;
      case EventType.NOTICE:
        tagText = "Notice";
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
