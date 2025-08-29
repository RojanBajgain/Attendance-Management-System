import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/repository/reminder_repo.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/add_remider_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/model/calender_model.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  final ProfileController profileController = Get.find<ProfileController>();
  final GetStorage box = GetStorage();
  List<EventCalenderModel> filteredEvents = [];
  String activeTabType = "EVENT";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
    filteredEvents = _filterEvents(activeTabType);
    if (_controller.eventCalenders.isEmpty &&
        _controller.errorMessage.value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.getEventCalenders().then((_) {
          if (mounted) {
            setState(() {
              filteredEvents = _filterEvents(activeTabType);
              // log("Initial filtered events for $activeTabType: ${filteredEvents.length}");
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
          tabType = "BIRTHDAY";
          break;
        case 2:
          tabType = "NOTICE";
          break;
        case 3:
          tabType = "HOLIDAY";
          break;
        case 4:
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

  final ScrollController horizontalScrollController = ScrollController();
  void scrollToItem(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = 100;
    double targetOffset =
        (index * tabWidth) - (screenWidth / 3) + (tabWidth / 2);
    if (targetOffset < 0) targetOffset = 0;
    horizontalScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<EventCalenderModel> _filterEvents(String type) {
    final filtered = _controller.eventCalenders.where((event) {
      final effectiveType = _getEffectiveEventType(event);
      return effectiveType == type.toUpperCase();
    }).toList();
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
      // log("Error finding today's event: $e");
      return null;
    }
  }

  String getTabName(String type) {
    switch (type.toUpperCase()) {
      case "EVENT":
        return 'Events';
      case "BIRTHDAY":
        return 'Birthday';
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

  void _handleBackNavigation() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Get.offAll(() => BottomNavPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final todayFormatted = DateFormat('MMM').format(now).substring(0, 3);
    final dayFormatted = DateFormat('d').format(now);

    return WillPopScope(
      onWillPop: () async {
        _handleBackNavigation();
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          title: Text(
            'Events & Holidays',
            style: normalStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14.0,
            ),
          ),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: _handleBackNavigation,
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showReminderDialog,
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text(
            'Reminder',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: horizontalScrollController,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //EVents
                        GestureDetector(
                          onTap: () {
                            scrollToItem(0);
                            _tabController.animateTo(0);
                            setState(() {
                              activeTabType = "EVENT";
                              filteredEvents = _filterEvents(activeTabType);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: activeTabType == "EVENT"
                                  ? (isDarkMode ? Colors.white : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: activeTabType == "EVENT"
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
                                  color: activeTabType == "EVENT"
                                      ? (isDarkMode
                                          ? Colors.black
                                          : Colors.black)
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Events',
                                  style: smallNStyle.copyWith(
                                    color: activeTabType == "EVENT"
                                        ? (isDarkMode
                                            ? Colors.black
                                            : Colors.black)
                                        : (isDarkMode
                                            ? Colors.white70
                                            : Colors.black54),
                                    fontWeight: activeTabType == "EVENT"
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
                        const SizedBox(width: 4),
                        //birthday
                        GestureDetector(
                          onTap: () {
                            _tabController.animateTo(1);
                            scrollToItem(1);
                            setState(() {
                              activeTabType = "BIRTHDAY";
                              filteredEvents = _filterEvents(activeTabType);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: activeTabType == "BIRTHDAY"
                                  ? (isDarkMode ? Colors.white : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: activeTabType == "BIRTHDAY"
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
                                  color: activeTabType == "BIRTHDAY"
                                      ? (isDarkMode
                                          ? Colors.black
                                          : Colors.black)
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Birthday',
                                  style: smallNStyle.copyWith(
                                    color: activeTabType == "Birthday"
                                        ? (isDarkMode
                                            ? Colors.black
                                            : Colors.black)
                                        : (isDarkMode
                                            ? Colors.white70
                                            : Colors.black54),
                                    fontWeight: activeTabType == "Birthday"
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
                        const SizedBox(width: 4),

                        //notice
                        GestureDetector(
                          onTap: () {
                            _tabController.animateTo(2);
                            scrollToItem(2);

                            setState(() {
                              activeTabType = "NOTICE";
                              filteredEvents = _filterEvents(activeTabType);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: activeTabType == "NOTICE"
                                  ? (isDarkMode ? Colors.white : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: activeTabType == "NOTICE"
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
                                  color: activeTabType == "NOTICE"
                                      ? (isDarkMode
                                          ? Colors.black
                                          : Colors.black)
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Notices',
                                  style: smallNStyle.copyWith(
                                    color: activeTabType == "NOTICE"
                                        ? (isDarkMode
                                            ? Colors.black
                                            : Colors.black)
                                        : (isDarkMode
                                            ? Colors.white70
                                            : Colors.black54),
                                    fontWeight: activeTabType == "NOTICE"
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

                        const SizedBox(width: 4),
                        //holiday
                        GestureDetector(
                          onTap: () {
                            _tabController.animateTo(3);
                            scrollToItem(3);

                            setState(() {
                              activeTabType = "HOLIDAY";
                              filteredEvents = _filterEvents(activeTabType);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: activeTabType == "HOLIDAY"
                                  ? (isDarkMode ? Colors.white : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: activeTabType == "HOLIDAY"
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
                                  color: activeTabType == "HOLIDAY"
                                      ? (isDarkMode
                                          ? Colors.black
                                          : Colors.black)
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Holidays',
                                  style: smallNStyle.copyWith(
                                    color: activeTabType == "HOLIDAY"
                                        ? (isDarkMode
                                            ? Colors.black
                                            : Colors.black)
                                        : (isDarkMode
                                            ? Colors.white70
                                            : Colors.black54),
                                    fontWeight: activeTabType == "HOLIDAY"
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
                        const SizedBox(width: 4),
                        //reminder
                        GestureDetector(
                          onTap: () {
                            _tabController.animateTo(4);
                            scrollToItem(4);

                            setState(() {
                              activeTabType = "REMINDER";
                              filteredEvents = _filterEvents(activeTabType);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: activeTabType == "REMINDER"
                                  ? (isDarkMode ? Colors.white : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: activeTabType == "REMINDER"
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
                                  Icons.alarm_outlined,
                                  size: 18,
                                  color: activeTabType == "REMINDER"
                                      ? (isDarkMode
                                          ? Colors.black
                                          : Colors.black)
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Reminder',
                                  style: smallNStyle.copyWith(
                                    color: activeTabType == "REMINDER"
                                        ? (isDarkMode
                                            ? Colors.black
                                            : Colors.black)
                                        : (isDarkMode
                                            ? Colors.white70
                                            : Colors.black54),
                                    fontWeight: activeTabType == "REMINDER"
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
                      ],
                    ),
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey.shade800 : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDateCircle(
                                month: todayFormatted,
                                day: dayFormatted,
                                color: Theme.of(context).colorScheme.surface,
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
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    if (todayEvent?.type != null)
                                      _buildEventTag(todayEvent!.type!,
                                          event: todayEvent),
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
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 13,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          todayEvent?.startDate != null
                                              ? (todayEvent?.endDate != null &&
                                                      todayEvent!.startDate!
                                                              .year ==
                                                          todayEvent
                                                              .endDate!.year &&
                                                      todayEvent.startDate!
                                                              .month ==
                                                          todayEvent
                                                              .endDate!.month &&
                                                      todayEvent
                                                              .startDate!.day ==
                                                          todayEvent
                                                              .endDate!.day
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
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Text(
                                          'Created by: ${todayEvent.createdBy}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                            color: isDarkMode
                                                ? Colors.grey.shade400
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    // if (todayEvent?.user != null &&
                                    //     todayEvent!.user!.isNotEmpty)
                                    //   Padding(
                                    //     padding:
                                    //         const EdgeInsets.only(top: 6.0),
                                    //     child: Text(
                                    //       'Created By: ${todayEvent.user}',
                                    //       style: TextStyle(
                                    //         fontSize: 11,
                                    //         fontStyle: FontStyle.italic,
                                    //         color: isDarkMode
                                    //             ? Colors.grey.shade400
                                    //             : Colors.black,
                                    //       ),
                                    //     ),
                                    //   ),
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
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (filteredEvents.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset("assets/images/noEvent.png"),
                                const SizedBox(height: 20),
                                Text(
                                  "No ${getTabName(activeTabType).toLowerCase()} found",
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDateCircle(
                                          month: month,
                                          day: day,
                                          color: _getColorForEventType(
                                              _getEffectiveEventType(event))),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  event.title ??
                                                      event.name ??
                                                      "Untitled",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (event.type?.toUpperCase() ==
                                                    "REMINDER")
                                                  Row(
                                                    children: [
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: InkWell(
                                                          onTap: () {
                                                            _showReminderDialog(
                                                                reminder:
                                                                    event);
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Icon(
                                                                Icons.edit,
                                                                size: 18,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: InkWell(
                                                          onTap: () {
                                                            _showDeleteConfirmation(
                                                                event.id);
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Icon(
                                                                Icons.delete,
                                                                size: 18,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            if (event.type != null)
                                              _buildEventTag(event.type!,
                                                  event: event),
                                            const SizedBox(height: 6),
                                            if (event.description != null &&
                                                event.description!.isNotEmpty)
                                              Text(
                                                event.description!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDarkMode
                                                      ? Colors.grey.shade400
                                                      : Colors.black,
                                                ),
                                                maxLines: 5,
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
                                                maxLines: 10,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            const SizedBox(height: 6),
                                            if (event.type == "REMINDER" ||
                                                _getEffectiveEventType(event) ==
                                                    "BIRTHDAY")
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      size: 13,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    event.startDate != null
                                                        ? (event.endDate !=
                                                                    null &&
                                                                event.startDate!
                                                                        .year ==
                                                                    event
                                                                        .endDate!
                                                                        .year &&
                                                                event.startDate!
                                                                        .month ==
                                                                    event
                                                                        .endDate!
                                                                        .month &&
                                                                event.startDate!
                                                                        .day ==
                                                                    event
                                                                        .endDate!
                                                                        .day
                                                            ? DateFormat(_getEffectiveEventType(
                                                                            event) ==
                                                                        "BIRTHDAY"
                                                                    ? 'd MMMM'
                                                                    : 'd MMMM')
                                                                .format(event
                                                                    .startDate!)
                                                            : "${DateFormat(_getEffectiveEventType(event) == "BIRTHDAY" ? 'd MMM' : 'd MMM yyyy').format(event.startDate!)}"
                                                                " - "
                                                                "${DateFormat(_getEffectiveEventType(event) == "BIRTHDAY" ? 'd MMM' : 'd MMM yyyy').format(event.endDate ?? event.startDate!)}")
                                                        : '',
                                                    style: TextStyle(
                                                      color: isDarkMode
                                                          ? Colors.grey.shade400
                                                          : Colors.black,
                                                      fontSize: 11,
                                                      fontStyle:
                                                          FontStyle.italic,
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
                                                          fontSize: 11,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                        Icons
                                                            .calendar_month_outlined,
                                                        size: 14,
                                                        color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        DateFormat(
                                                                'dd MMM yyyy')
                                                            .format(event
                                                                .startDate!),
                                                        style: TextStyle(
                                                          color: isDarkMode
                                                              ? Colors
                                                                  .grey.shade400
                                                              : Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
      ),
    );
  }

  Color _getColorForEventType(String? type) {
    switch (type?.toUpperCase()) {
      case "EVENT":
        return Colors.blue;
      case "BIRTHDAY":
        return Colors.orange; // Orange color for birthdays
      case "HOLIDAY":
        return Colors.red;
      case "NOTICE":
        return Colors.green;
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
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(month,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Text(day,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTag(String type, {EventCalenderModel? event}) {
    // Check if this event should be treated as a birthday
    String effectiveType = type;
    if (event != null) {
      effectiveType = _getEffectiveEventType(event);
    }

    Color tagColor = _getColorForEventType(effectiveType);
    String tagText;

    switch (effectiveType.toUpperCase()) {
      case "EVENT":
        tagText = "Event";
        break;
      case "BIRTHDAY":
        tagText = "Birthday"; // This will show "Birthday" instead of "Event"
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
          color: tagColor, borderRadius: BorderRadius.circular(16)),
      child: Text(
        tagText,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  String _getEffectiveEventType(EventCalenderModel event) {
    final name = event.name?.toLowerCase() ?? '';
    final title = event.title?.toLowerCase() ?? '';

    if (name.contains('birthday') || title.contains('birthday')) {
      return "BIRTHDAY";
    }

    return event.type?.toUpperCase() ?? "EVENT";
  }

  void _showReminderDialog({EventCalenderModel? reminder}) {
    final addReminderController = Get.put(
      AddReminderController(
        addReminderRepo: ReminderRepo(apiClient: Get.find<ApiClient>()),
      ),
    );

    final titleController = TextEditingController(
      text: reminder?.title ?? '',
    );
    final remarksController = TextEditingController(
      text: reminder?.remarks ?? '',
    );

    DateTime? startDate = reminder?.startDate;
    DateTime? endDate = reminder?.endDate;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      StatefulBuilder(
        builder: (context, dialogSetState) {
          return AlertDialog(
            backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Center(
              child: Text(
                reminder == null ? 'Add New Reminder' : 'Edit Reminder',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Title
                    TextField(
                      controller: titleController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          fontSize: 11,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Remarks
                    TextField(
                      controller: remarksController,
                      maxLines: 2,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Remarks',
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          fontSize: 11,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dates
                    Row(
                      children: [
                        // START DATE
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate:
                                    DateTime.now(), // ⬅️ only today and forward
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.black,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                      textTheme: Theme.of(context)
                                          .textTheme
                                          .copyWith(
                                            bodyLarge:
                                                const TextStyle(fontSize: 12),
                                            bodyMedium:
                                                const TextStyle(fontSize: 12),
                                            labelSmall:
                                                const TextStyle(fontSize: 11),
                                          ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (date != null) {
                                dialogSetState(
                                    () => startDate = date); // ✅ FIXED
                                // Reset endDate if it's before the new startDate
                                if (endDate != null &&
                                    endDate!.isBefore(date)) {
                                  dialogSetState(() => endDate = null);
                                }
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Start Date',
                                labelStyle: TextStyle(fontSize: 11),
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                startDate != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(startDate!)
                                    : 'Select Date',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // END DATE
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate:
                                    endDate ?? startDate ?? DateTime.now(),
                                firstDate: startDate ??
                                    DateTime.now(), // ⬅️ not before start date
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.black,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                      textTheme: Theme.of(context)
                                          .textTheme
                                          .copyWith(
                                            bodyLarge:
                                                const TextStyle(fontSize: 12),
                                            bodyMedium:
                                                const TextStyle(fontSize: 12),
                                            labelSmall:
                                                const TextStyle(fontSize: 11),
                                          ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (date != null) {
                                dialogSetState(() => endDate = date);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'End Date',
                                labelStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                endDate != null
                                    ? DateFormat('yyyy-MM-dd').format(endDate!)
                                    : 'Select Date',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: miniStyle,
                ),
              ),
              Obx(
                () => addReminderController.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (titleController.text.isEmpty) {
                            SSnackbarUtil.showFadeSnackbar(
                              Get.context!,
                              'Title is required',
                              SnackbarType.error,
                            );
                            return;
                          }
                          if (startDate == null) {
                            SSnackbarUtil.showFadeSnackbar(
                              Get.context!,
                              'Start date is required',
                              SnackbarType.error,
                            );
                            return;
                          }

                          final profileId = profileController.profile.value!.id;

                          if (reminder == null) {
                            // ADD
                            await addReminderController.createtimeoff(
                              profile: profileId,
                              title: titleController.text,
                              remarks: remarksController.text,
                              startdate:
                                  DateFormat('yyyy-MM-dd').format(startDate!),
                              enddate: endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(endDate!)
                                  : DateFormat('yyyy-MM-dd').format(startDate!),
                            );
                          } else {
                            // EDIT
                            await addReminderController.editReminder(
                              reminderEvent: reminder.id.toString(),
                              profile: profileId,
                              title: titleController.text,
                              remarks: remarksController.text,
                              startdate:
                                  DateFormat('yyyy-MM-dd').format(startDate!),
                              enddate: endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(endDate!)
                                  : DateFormat('yyyy-MM-dd').format(startDate!),
                            );
                          }

                          if (!addReminderController.isLoading.value) {
                            Get.back();
                            _controller.getEventCalenders().then((_) {
                              if (mounted) {
                                setState(() {
                                  filteredEvents = _filterEvents(activeTabType);
                                  if (activeTabType != 'REMINDER') {
                                    _tabController.animateTo(3);
                                  }
                                });
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          reminder == null ? 'Save' : 'Update',
                          style: miniStyle.copyWith(color: Colors.white),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(int reminderId) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final addReminderController = Get.put(
      AddReminderController(
        addReminderRepo: ReminderRepo(apiClient: Get.find<ApiClient>()),
      ),
    );
    Get.dialog(
      AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        title: Center(
          child: Text(
            "Delete Reminder",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: Text(
          "Are you sure you want to delete this reminder?",
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 12,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await addReminderController.deleteReminder(
                  id: reminderId.toString());
              Get.back();
              _controller.getEventCalenders().then((_) {
                if (mounted) {
                  setState(() {
                    filteredEvents = _filterEvents(activeTabType);
                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
