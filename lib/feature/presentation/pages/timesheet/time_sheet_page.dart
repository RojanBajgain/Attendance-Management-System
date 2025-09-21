import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/time_sheet_view.dart';
import 'package:ams/feature/presentation/pages/timesheet/widget/absentday_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class TimeSheetPage extends StatefulWidget {
  final int? profileId;
  final String? apiKey;
  const TimeSheetPage({super.key, this.profileId, this.apiKey});

  @override
  State<TimeSheetPage> createState() => _TimeSheetPageState();
}

class _TimeSheetPageState extends State<TimeSheetPage> {
  final authcontroller = Get.find<AuthController>();
  final TimesheetController timesheetcontroller =
      Get.put(TimesheetController());
  final ScrollController _scrollController = ScrollController();

  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Load more content when reaching bottom
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      timesheetcontroller.loadMoreTimesheet();
    }

    // Show/hide scroll to top button based on scroll position
    const double showButtonOffset = 225.0;
    if (_scrollController.offset > showButtonOffset && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset <= showButtonOffset &&
        _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }
  }

  // Method to scroll to top
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> getAbsentDays() {
    List<DateTime> absentDays = [];

    // Get date range - if no range selected, use a more conservative approach
    DateTimeRange? dateRange = timesheetcontroller.dateRange.value;

    DateTime startDate;
    DateTime endDate;

    if (dateRange != null) {
      startDate = dateRange.start;
      endDate = dateRange.end;
    } else {
      if (timesheetcontroller.filteredTimesheet.isEmpty) {
        return absentDays;
      }

      List<DateTime> allDates = timesheetcontroller.filteredTimesheet
          .where((ts) => ts.date != null)
          .map((ts) => ts.date!)
          .toList();

      if (allDates.isEmpty) return absentDays;

      allDates.sort();
      startDate = allDates.first;
      endDate = allDates.last;

      DateTime now = DateTime.now();
      DateTime maxStartDate = DateTime(
        now.subtract(const Duration(days: 60)).year,
        now.subtract(const Duration(days: 60)).month,
        now.subtract(const Duration(days: 60)).day,
      );

      if (startDate.isBefore(maxStartDate)) {
        startDate = maxStartDate;
      }

      endDate = DateTime(now.year, now.month, now.day);
    }

    Set<DateTime> timesheetDates = timesheetcontroller.filteredTimesheet
        .where((ts) => ts.date != null)
        .map((ts) => DateTime(ts.date!.year, ts.date!.month, ts.date!.day))
        .toSet();

    DateTime currentDate =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endDateNormalized =
        DateTime(endDate.year, endDate.month, endDate.day);
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    while (
        currentDate.isBefore(endDateNormalized.add(const Duration(days: 1)))) {
      bool isWorkingDay = currentDate.weekday != DateTime.saturday;

      // If you want to exclude both Saturday and Sunday, use this instead:
      // bool isWorkingDay = currentDate.weekday >= DateTime.monday && currentDate.weekday <= DateTime.friday;

      if (isWorkingDay) {
        // If this date is not in timesheet data and is not today or future, it's absent
        if (!timesheetDates.contains(currentDate) &&
            currentDate.isBefore(today)) {
          absentDays.add(currentDate);
        }
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return absentDays;
  }

  // Combined list of timesheet entries and absent days
  List<dynamic> getCombinedEntries() {
    List<dynamic> combined = [];

    // Add existing timesheet entries
    combined.addAll(timesheetcontroller.filteredTimesheet);

    // Add absent days
    List<DateTime> absentDays = getAbsentDays();
    combined.addAll(absentDays);

    // Sort by date
    combined.sort((a, b) {
      DateTime dateA = a is DateTime ? a : (a.date ?? DateTime.now());
      DateTime dateB = b is DateTime ? b : (b.date ?? DateTime.now());
      return dateB.compareTo(dateA);
    });

    return combined;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
          onRefresh: () async {
            await timesheetcontroller.getTimesheet();
          },
          child: Obx(() {
            final combinedEntries = getCombinedEntries();

            return CustomScrollView(
              controller: _scrollController,
              // BOUNCY SCROLL PHYSICS
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          "Timesheets",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        _buildDateFilter(isDarkMode),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // Content
                if (timesheetcontroller.isLoading.value &&
                    timesheetcontroller.currentPage.value == 1)
                  SliverFillRemaining(child: _buildLoadingIndicator())
                else if (combinedEntries.isEmpty)
                  SliverFillRemaining(child: _buildEmptyState(isDarkMode))
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = combinedEntries[index];
                        bool isAbsent = entry is DateTime;

                        DateTime entryDate =
                            isAbsent ? entry : entry.date ?? DateTime.now();
                        bool showWeekLabel = false;
                        String weekLabel = "";

                        weekLabel = getWeekLabel(entryDate);

                        if (index == 0 ||
                            getWeekLabel(entryDate) !=
                                getWeekLabel(
                                    combinedEntries[index - 1] is DateTime
                                        ? combinedEntries[index - 1]
                                        : (combinedEntries[index - 1].date ??
                                            DateTime.now()))) {
                          showWeekLabel = true;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showWeekLabel)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    weekLabel,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              // Show either absent day widget or regular timesheet widget
                              isAbsent
                                  ? AbsentDayWidget(absentDate: entry)
                                  : TimeSheetWidget(timesheetdata: entry),
                            ],
                          ),
                        );
                      },
                      childCount: combinedEntries.length,
                    ),
                  ),

                // Load more indicator
                if (timesheetcontroller.isLoadMore.value)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
        // Floating Action Button for Scroll to Top
        floatingActionButton: AnimatedOpacity(
          opacity: _showScrollToTop ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: _showScrollToTop
              ? SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: FloatingActionButton(
                    onPressed: _scrollToTop,
                    backgroundColor:
                        isDarkMode ? Colors.grey.shade700 : Colors.white,
                    elevation: 4,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 30.0,
                    ),
                  ),
                )
              : null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  /// Date Filter Widget with Calendar Date Picker 2
  Widget _buildDateFilter(bool isDarkMode) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          await _showCalendarDatePicker(isDarkMode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 6),
              const Icon(
                Icons.date_range_outlined,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              if (timesheetcontroller.dateRange.value != null)
                Row(
                  children: [
                    Text(
                      "${DateFormat('MMM d').format(timesheetcontroller.dateRange.value!.start)} - ${DateFormat('MMM d').format(timesheetcontroller.dateRange.value!.end)}",
                      style: smallStyle.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => timesheetcontroller.clearDateRange(),
                      child: const Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      );
    });
  }

  /// Show Calendar Date Picker 2
  Future<void> _showCalendarDatePicker(bool isDarkMode) async {
    // Get current date range or set default
    List<DateTime?> initialDates = [];

    if (timesheetcontroller.dateRange.value != null) {
      initialDates = [
        timesheetcontroller.dateRange.value!.start,
        timesheetcontroller.dateRange.value!.end,
      ];
    } else {
      // Default to last 7 days
      initialDates = [
        DateTime.now().subtract(const Duration(days: 7)),
        DateTime.now(),
      ];
    }

    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor:
            isDarkMode ? Colors.blueAccent : Colors.black,
        weekdayLabelTextStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        controlsTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        dayTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        selectedDayTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        selectedRangeDayTextStyle: TextStyle(
          color: isDarkMode ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        yearTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        selectedYearTextStyle: TextStyle(
          color: isDarkMode ? Colors.blueAccent : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        okButtonTextStyle: TextStyle(
          color: isDarkMode ? Colors.blueAccent : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        cancelButtonTextStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        // Custom styling for dark/light mode
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        currentDate: DateTime.now(),
        // Range selection styling
        selectedRangeHighlightColor: isDarkMode
            ? Colors.blueAccent.withOpacity(0.3)
            : Colors.black.withOpacity(0.1),
        // Dialog styling
        centerAlignModePicker: true,
        customModePickerIcon: const SizedBox(),
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      // Apply theme based on dark mode
      dialogBackgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      value: initialDates,
    );

    // Handle the result
    if (results != null && results.length == 2) {
      final startDate = results[0];
      final endDate = results[1];

      if (startDate != null && endDate != null) {
        final dateRange = DateTimeRange(start: startDate, end: endDate);
        timesheetcontroller.dateRange.value = dateRange;
        timesheetcontroller.filterByDateRange(startDate, endDate);
      }
    }
  }

  /// Loading placeholder
  Widget _buildLoadingIndicator() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) {
        return const TimesheetSkeleton();
      },
    );
  }

  /// Empty State
  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pay.png',
            height: 150,
            width: 250,
          ),
          const SizedBox(height: 20),
          Text(
            "No Data Available",
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Week Label Helper
  String getWeekLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final givenDate = DateTime(date.year, date.month, date.day);

    // Calculate start of current week (Sunday = 0, Monday = 1, etc.)
    // For Sunday-based weeks: Sunday weekday is 7, so,
    int todayWeekday =
        today.weekday == 7 ? 0 : today.weekday; // Convert Sunday from 7 to 0
    int givenWeekday = givenDate.weekday == 7 ? 0 : givenDate.weekday;

    final currentWeekStart = today.subtract(Duration(days: todayWeekday));
    final givenWeekStart = givenDate.subtract(Duration(days: givenWeekday));

    final weekDifference =
        currentWeekStart.difference(givenWeekStart).inDays ~/ 7;

    if (weekDifference == 0) {
      return "This Week";
    } else if (weekDifference == 1) {
      return "1 week ago";
    } else {
      return "$weekDifference weeks ago";
    }
  }
}

/// Skeleton for loading
class TimesheetSkeleton extends StatelessWidget {
  const TimesheetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SkeletonBox(height: 80, width: double.infinity, borderRadius: 8),
    );
  }
}
