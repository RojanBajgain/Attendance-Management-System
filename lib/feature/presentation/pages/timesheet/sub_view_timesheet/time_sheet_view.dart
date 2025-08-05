import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_model.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/timesheet_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeSheetWidget extends StatefulWidget {
  final Datum timesheetdata;
  void Function()? onTap;

  TimeSheetWidget({
    super.key,
    required this.timesheetdata,
    this.onTap,
  });

  @override
  State<TimeSheetWidget> createState() => _TimeSheetWidgetState();
}

class _TimeSheetWidgetState extends State<TimeSheetWidget> {
  // Helper method to determine if entry is on time or late
  String getEntryStatus() {
    if (widget.timesheetdata.entryRemarks == null ||
        widget.timesheetdata.entryRemarks == "null" ||
        widget.timesheetdata.entryRemarks!.isEmpty) {
      return "N/A";
    }

    String remarks = widget.timesheetdata.entryRemarks!.toLowerCase();
    if (remarks.contains('on time') || remarks.contains('ontime')) {
      return "On Time";
    } else if (remarks.contains('late')) {
      return "Late";
    } else {
      return widget.timesheetdata.entryRemarks!;
    }
  }

  // Helper method to get color for entry status
  Color getEntryStatusColor() {
    String status = getEntryStatus().toLowerCase();
    if (status.contains('on time') || status.contains('ontime')) {
      return Colors.green;
    } else if (status.contains('late')) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Get.to(
          () => TimeSheetDetail(
            timesheetId: widget.timesheetdata.id.toString(),
          ),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 150),
        );
      },
      child: Container(
        height: 95.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              blurRadius: 6,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.02),
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              top: 10.0,
              right: 15.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Entry Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        widget.timesheetdata.date != null
                            ? DateFormat.yMMMMEEEEd('en_US')
                                .format(widget.timesheetdata.date!)
                            : "N/A",
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    // Entry Status Container
                    if (getEntryStatus() != "N/A")
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: getEntryStatusColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          getEntryStatus(),
                          style: smallStyle.copyWith(
                            color: getEntryStatusColor(),
                            fontSize: 8.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.014),

                // Time and Hours Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Clock-in Section
                    SizedBox(
                      width: 85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Entry Time",
                            style: smallStyle.copyWith(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.timesheetdata.entryTime != null
                                    ? DateFormat('hh:mm a').format(widget
                                        .timesheetdata.entryTime!
                                        .toLocal())
                                    : "--:--",
                                style: smallStyle.copyWith(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /* 
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                color: isDarkMode
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Entry Time",
                                style: smallStyle.copyWith(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.timesheetdata.entryTime != null
                                    ? DateFormat('hh:mm a').format(widget
                                        .timesheetdata.entryTime!
                                        .toLocal())
                                    : "--:--",
                                style: smallStyle.copyWith(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                       */
                    ),
                    Container(
                      height: 35,
                      width: 1,
                      color: isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    const SizedBox(width: 5),
                    // Clock-out Section
                    SizedBox(
                      width: 85,
                      child: Column(
                        children: [
                          Text(
                            "Exit Time",
                            style: smallStyle.copyWith(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.update,
                              //   color: isDarkMode
                              //       ? Colors.white60
                              //       : Colors.grey.shade600,
                              //   size: 20,
                              // ),
                              // const SizedBox(width: 4),
                              Text(
                                widget.timesheetdata.exitTime != null
                                    ? DateFormat('hh:mm a').format(widget
                                        .timesheetdata.exitTime!
                                        .toLocal())
                                    : "--:--",
                                style: smallStyle.copyWith(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 1,
                      color: isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            "Total Hours",
                            style: smallStyle.copyWith(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.schedule,
                              //   color: isDarkMode
                              //       ? Colors.grey
                              //       : Colors.grey.shade600,
                              //   size: 20,
                              // ),
                              // const SizedBox(width: 4),
                              Text(
                                "${widget.timesheetdata.totalHour} hrs",
                                style: smallStyle.copyWith(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).marginOnly(left: 10),
      ),
    );
  }
}
