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
  TimeSheetPage({super.key, this.profileId, this.apiKey});

  @override
  State<TimeSheetPage> createState() => _TimeSheetPageState();
}

class _TimeSheetPageState extends State<TimeSheetPage> {
  final authcontroller = Get.find<AuthController>();
  late final TimesheetController timesheetcontroller;

  @override
  void initState() {
    super.initState();
    timesheetcontroller = Get.put(TimesheetController());
  }

  @override
  void dispose() {
    // Remove the controller when the page is disposed
    Get.delete<TimesheetController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: RefreshIndicator(
        color: Colors.cyan,
        onRefresh: () async {
          await timesheetcontroller.refreshTimesheet();
        },
        child: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
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
                        _buildDateRangePicker(isDarkMode),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  // Pagination info
                  Obx(() {
                    if (timesheetcontroller.totalCount.value > 0) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Showing ${timesheetcontroller.timesheet.length} of ${timesheetcontroller.totalCount.value} records",
                              style: smallStyle.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              "Page ${timesheetcontroller.currentPage.value} of ${timesheetcontroller.totalPages.value}",
                              style: smallStyle.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),

            // Content section
            Expanded(
              child: Obx(() {
                if (timesheetcontroller.isLoading.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return const TimesheetSkeleton();
                    },
                  );
                } else if (timesheetcontroller.timesheet.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/pay.png',
                          height: 150,
                          width: 250,
                          fit: BoxFit.cover,
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
                } else {
                  return ListView.builder(
                    controller: timesheetcontroller.scrollController,
                    padding: const EdgeInsets.all(8.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: timesheetcontroller.timesheet.length +
                        (timesheetcontroller.hasMoreData.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < timesheetcontroller.timesheet.length) {
                        final timesheet = timesheetcontroller.timesheet[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 15.0,
                            left: 4.0,
                            right: 6.0,
                          ),
                          child: TimeSheetWidget(timesheetdata: timesheet),
                        );
                      } else {
                        // Loading indicator for pagination
                        return Obx(() {
                          if (timesheetcontroller.isLoadingMore.value) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    const CircularProgressIndicator(
                                      color: Colors.cyan,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      "Loading more...",
                                      style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 11.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (timesheetcontroller.hasMoreData.value) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    timesheetcontroller.loadMoreTimesheet();
                                  },
                                  child: Text(
                                    "Load More",
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  "No more data to load",
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            );
                          }
                        });
                      }
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker(bool isDarkMode) {
    return GestureDetector(
      onTap: () async {
        final ThemeData datePickerTheme = isDarkMode
            ? ThemeData.dark().copyWith(
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    fontSize: 11.0,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 11.0,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                dialogBackgroundColor: Colors.grey[900],
                colorScheme: const ColorScheme.dark(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  onSurface: Colors.white,
                  background: Colors.black,
                ),
              )
            : ThemeData.light().copyWith(
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    fontSize: 11.0,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 11.0,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                dialogBackgroundColor: Colors.white,
                colorScheme: const ColorScheme.light(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                  background: Colors.white,
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
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: datePickerTheme,
              child: child!,
            );
          },
        );

        if (dateRange != null) {
          timesheetcontroller.filterByDateRange(dateRange.start, dateRange.end);
        }
      },
      child: Obx(() {
        return Container(
          height: 35.0,
          width: timesheetcontroller.dateRange.value != null
              ? 200.0
              : (timesheetcontroller.selectedDate.value != null ? 165.0 : 48.0),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(70.0),
            color: isDarkMode ? Colors.grey.shade500 : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.date_range_outlined,
                color: Colors.black,
              ),
              if (timesheetcontroller.dateRange.value != null) ...[
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "${DateFormat('MMM d').format(timesheetcontroller.dateRange.value!.start)} - ${DateFormat('MMM d').format(timesheetcontroller.dateRange.value!.end)}",
                    style: smallStyle.copyWith(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    timesheetcontroller.clearDateRange();
                  },
                  child: const Icon(
                    Icons.clear,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ),
              ] else if (timesheetcontroller.selectedDate.value != null) ...[
                const SizedBox(width: 5),
                Text(
                  DateFormat('MMM d, yyyy')
                      .format(timesheetcontroller.selectedDate.value!),
                  style: smallStyle.copyWith(color: Colors.black),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    timesheetcontroller.clearSelectedDate();
                  },
                  child: const Icon(
                    Icons.clear,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class TimesheetSkeleton extends StatelessWidget {
  const TimesheetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 80, width: double.infinity, borderRadius: 8),
        ],
      ),
    );
  }
}
