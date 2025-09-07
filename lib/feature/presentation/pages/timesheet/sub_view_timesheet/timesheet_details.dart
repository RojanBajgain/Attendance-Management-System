import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeSheetDetail extends StatefulWidget {
  final String timesheetId;

  const TimeSheetDetail({
    super.key,
    required this.timesheetId,
  });

  @override
  State<TimeSheetDetail> createState() => _TimeSheetDetailState();
}

class _TimeSheetDetailState extends State<TimeSheetDetail> {
  final TimesheetController timesheetcontroller =
      Get.put(TimesheetController());

  @override
  void initState() {
    super.initState();
    timesheetcontroller.getTimesheetDetailData(widget.timesheetId);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Scaffold(
        // appBar: const ConstantAppBar(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_sharp,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 15.0),
                        Text(
                          "Timesheets",
                          style: smallNStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Obx(() {
                    if (timesheetcontroller.isLoading.value) {
                      return const Center(
                        child: ShrimmerEffect.rectangular(height: 300),
                      );
                    }
                    final timesheet = timesheetcontroller.timesheetDetail.value;

                    return Card(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          children: [
                            _buildRow(
                                Icons.date_range,
                                "Date",
                                timesheet.date != null
                                    ? DateFormat.yMMMd('en_US')
                                        .format(timesheet.date!)
                                    : "N/A"),
                            // _buildDivider(),
                            _buildRow(
                                Icons.login,
                                "Entry Time",
                                timesheet.entryTime != null
                                    ? DateFormat('hh:mm:ss a')
                                        .format(timesheet.entryTime!.toLocal())
                                    : "N/A"),
                            // _buildDivider(),
                            _buildRow(
                                Icons.edit_note,
                                "Entry Remarks",
                                timesheet.entryRemarks == null ||
                                        timesheet.entryRemarks == "null"
                                    ? "---"
                                    : timesheet.entryRemarks.toString()),
                            // _buildDivider(),
                            _buildRow(
                                Icons.logout,
                                "Exit Time",
                                timesheet.exitTime != null
                                    ? DateFormat('hh:mm:ss a')
                                        .format(timesheet.exitTime!.toLocal())
                                    : "---"),
                            // _buildDivider(),
                            _buildRow(
                                Icons.comment,
                                "Exit Remarks",
                                timesheet.exitRemarks == null ||
                                        timesheet.exitRemarks == "null"
                                    ? "---"
                                    : timesheet.exitRemarks.toString()),
                            // _buildDivider(),
                            // _buildRow(
                            //   Icons.timer_off,
                            //   "Break Time",
                            //   timesheet.breakTime != null
                            //       ? _formatDuration(timesheet
                            //           .breakTime!) // Direct call, no Duration conversion
                            //       : "N/A",
                            // ),

                            // // _buildDivider(),
                            // _buildRow(
                            //   Icons.alarm,
                            //   "Overtime",
                            //   timesheet.overTime != null
                            //       ? _formatHoursOnly(timesheet.overTime!)
                            //       : "N/A",
                            // ),

                            // Break Time
                            _buildRow(
                              Icons.timer_off,
                              "Break Time",
                              timesheet.breakTime != null
                                  ? _formatTimeAsIs(timesheet.breakTime!)
                                  : "N/A",
                            ),

// Overtime
                            _buildRow(
                              Icons.alarm,
                              "Overtime",
                              timesheet.overTime != null
                                  ? _formatTimeAsIs(timesheet.overTime!)
                                  : "N/A",
                            ),

                            // _buildDivider(),
                            _buildRow(
                              Icons.access_time_filled,
                              "Total Hours",
                              timesheet.totalHour != null
                                  ? _formatHourMinute(timesheet.totalHour!)
                                  : "N/A",
                            ),

                            // _buildDivider(),
                            _buildRow(Icons.badge, "Designation",
                                timesheet.designation ?? "N/A"),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildDivider() {
  //   return Divider(
  //     color: Colors.grey.withOpacity(0.3),
  //     thickness: 1,
  //     height: 16,
  //   );
  // }

  Widget _buildRow(IconData icon, String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDarkMode ? Colors.white70 : Colors.grey[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: smallStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.end,
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.grey[800],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatHourMinute(double hours) {
    final int wholeHours = hours.floor();
    final int minutes = ((hours - wholeHours) * 60).round();
    return "${wholeHours}hrs ${minutes}min";
  }

  String _formatHoursOnly(double hours) {
    final int wholeHours = hours.floor();
    final int minutes = ((hours - wholeHours) * 60).round();

    if (wholeHours > 0 && minutes > 0) {
      return "${wholeHours}hrs ${minutes}min";
    } else if (wholeHours > 0) {
      return "${wholeHours}hrs";
    } else {
      return "${minutes}min";
    }
  }

  String _formatDuration(double hours) {
    final int wholeHours = hours.floor();
    final int minutes = ((hours - wholeHours) * 60).round();

    if (wholeHours > 0 && minutes > 0) {
      return "${wholeHours}hrs ${minutes}min";
    } else if (wholeHours > 0) {
      return "${wholeHours}hrs";
    } else {
      return "${minutes}min";
    }
  }

  String _formatTimeAsIs(double timeValue) {
    final int hours = timeValue.floor();
    final int minutes =
        ((timeValue - hours) * 100).round(); // Decimal part * 100 = minutes

    if (hours > 0 && minutes > 0) {
      return "${hours}hrs ${minutes}min";
    } else if (hours > 0) {
      return "${hours}hrs";
    } else {
      return "${minutes}min";
    }
  }
}
