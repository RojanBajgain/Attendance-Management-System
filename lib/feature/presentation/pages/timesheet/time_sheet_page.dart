import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/time_sheet_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      timesheetcontroller.loadMoreTimesheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          color: isDarkMode ? Colors.white : Colors.black,
          onRefresh: () async {
            await timesheetcontroller.getTimesheet();
          },
          child: Obx(() {
            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
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
                          style: smallNStyle.copyWith(
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
                else if (timesheetcontroller.filteredTimesheet.isEmpty)
                  SliverFillRemaining(child: _buildEmptyState(isDarkMode))
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final timesheet =
                            timesheetcontroller.filteredTimesheet[index];

                        bool showWeekLabel = false;
                        String weekLabel = "";

                        if (timesheet.date != null) {
                          weekLabel = getWeekLabel(timesheet.date!);

                          if (index == 0 ||
                              (timesheetcontroller
                                          .filteredTimesheet[index - 1].date !=
                                      null &&
                                  getWeekLabel(timesheet.date!) !=
                                      getWeekLabel(timesheetcontroller
                                          .filteredTimesheet[index - 1]
                                          .date!))) {
                            showWeekLabel = true;
                          }
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
                                    style: smallStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              TimeSheetWidget(timesheetdata: timesheet),
                            ],
                          ),
                        );
                      },
                      childCount: timesheetcontroller.filteredTimesheet.length,
                    ),
                  ),

                // Load more indicator
                if (timesheetcontroller.isLoadMore.value)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.cyan),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// Date Filter Widget
  Widget _buildDateFilter(bool isDarkMode) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          final ThemeData datePickerTheme = isDarkMode
              ? ThemeData.dark().copyWith(
                  dialogBackgroundColor: Colors.grey[900],
                  colorScheme: const ColorScheme.dark(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                );

          DateTimeRange? dateRange = await showDateRangePicker(
            context: context,
            initialDateRange: timesheetcontroller.dateRange.value ??
                DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 7)),
                  end: DateTime.now(),
                ),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(data: datePickerTheme, child: child!);
            },
          );

          if (dateRange != null) {
            timesheetcontroller.dateRange.value = dateRange;
            timesheetcontroller.filterByDateRange(
                dateRange.start, dateRange.end);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDarkMode ? Colors.grey.shade600 : Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.date_range_outlined, size: 18),
              const SizedBox(width: 6),
              if (timesheetcontroller.dateRange.value != null)
                Row(
                  children: [
                    Text(
                      "${DateFormat('MMM d').format(timesheetcontroller.dateRange.value!.start)} - ${DateFormat('MMM d').format(timesheetcontroller.dateRange.value!.end)}",
                      style: smallStyle.copyWith(color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => timesheetcontroller.clearDateRange(),
                      child: const Icon(Icons.clear, size: 18),
                    ),
                  ],
                )
            ],
          ),
        ),
      );
    });
  }

  /// Loading placeholder
  Widget _buildLoadingIndicator() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
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
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime given = DateTime(date.year, date.month, date.day);

    DateTime startOfCurrentWeek =
        today.subtract(Duration(days: today.weekday - 1));
    DateTime startOfGivenWeek =
        given.subtract(Duration(days: given.weekday - 1));

    int differenceInDays =
        startOfCurrentWeek.difference(startOfGivenWeek).inDays;
    int weekDifference = (differenceInDays / 7).floor();

    if (weekDifference == 0) {
      return "This Week";
    } else if (weekDifference == 1) {
      return "Last Week";
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
