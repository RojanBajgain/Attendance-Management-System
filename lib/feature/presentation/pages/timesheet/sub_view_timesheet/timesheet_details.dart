import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
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
      Get.put(TimesheetController(timesheetRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    timesheetcontroller.getTimesheetDetailData(widget.timesheetId);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
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
                        child: ShrimmerEffect.rectangular(
                      height: 250,
                    ));
                  }
                  final timesheet = timesheetcontroller.timesheetDetail.value;
                  // if (timesheet == null) {
                  //   return const Center(child: Text("No data found!"));
                  // }

                  return Container(
                    height: 280.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 15.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow(
                            "Date",
                            timesheet.date != null
                                ? DateFormat.yMMMd('en_US')
                                    .format(timesheet.date!)
                                : "N/A",
                          ),
                          _buildRow(
                            "Entry Time:",
                            timesheet.entryTime != null
                                ? DateFormat('hh:mm:ss a')
                                    .format(timesheet.entryTime!.toLocal())
                                : "",
                          ),
                          _buildRow("Entry Remarks:",
                              timesheet.entryRemarks.toString()),
                          _buildRow(
                            "Exit Time:",
                            timesheet.exitTime != null
                                ? DateFormat('hh:mm:ss a')
                                    .format(timesheet.exitTime!.toLocal())
                                : "N/A",
                          ),
                          _buildRow(
                              "Exit Remarks:",
                              (timesheet.exitRemarks == null ||
                                      timesheet.exitRemarks == "null")
                                  ? "---"
                                  : timesheet.exitRemarks.toString()),
                          _buildRow(
                              "Break Time",
                              timesheet.breakTime != null
                                  ? _formatDuration(Duration(
                                      seconds: timesheet.breakTime!.toInt()))
                                  : "N/A"),
                          _buildRow(
                            "Overtime",
                            timesheet.overTime != null
                                ? _formatHoursOnly(
                                    double.tryParse(timesheet.overTime!) ?? 0)
                                : "N/A",
                          ),
                          _buildRow(
                            "Total Hours",
                            timesheet.totalHour != null
                                ? _formatHourMinute(
                                    double.tryParse(timesheet.totalHour!) ?? 0)
                                : "N/A",
                          ),
                          _buildRow(
                              "Designation:", timesheet.designation ?? "N/A"),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Builder(builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: smallStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                )),
            Text(value,
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                )),
          ],
        ),
      );
    });
  }

  String _formatHourMinute(double hours) {
    final int wholeHours = hours.floor();
    final int minutes = ((hours - wholeHours) * 60).round();
    return "${wholeHours}hrs ${minutes}min";
  }

  String _formatHoursOnly(double hours) {
    final int wholeHours = hours.floor();
    return "${wholeHours}hrs";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }
}
