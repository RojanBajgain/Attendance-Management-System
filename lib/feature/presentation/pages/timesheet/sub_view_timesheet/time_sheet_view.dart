import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
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
  // final TimesheetController timesheetcontroller =
  //     Get.put(TimesheetController(timesheetRepo: Get.find()));

  // @override
  // void initState() {
  //   timesheetcontroller.timesheet();
  //   super.initState();
  // }

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
        );
      },
      child: Container(
        height: 90.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              isDarkMode ? Colors.grey.shade700 : Colors.black,
              isDarkMode ? Colors.grey.shade700 : Colors.black,
              isDarkMode ? Colors.grey.shade800 : Colors.white,
            ],
            stops: const [
              0.0,
              0.04,
              0.0,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            top: 15.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.timesheetdata.date != null
                    ? DateFormat.yMMMd('en_US')
                        .format(widget.timesheetdata.date!)
                    : "N/A",
                style: smallStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.history,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    widget.timesheetdata.entryTime != null
                        ? DateFormat('hh:mm a')
                            .format(widget.timesheetdata.entryTime!.toLocal())
                        : "",
                    style: smallNStyle.copyWith(color: Colors.green),
                  ),
                  Spacer(),
                  Icon(
                    Icons.update,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    widget.timesheetdata.exitTime != null
                        ? DateFormat('hh:mm a')
                            .format(widget.timesheetdata.exitTime!.toLocal())
                        : "---",
                    style: smallNStyle.copyWith(color: Colors.red),
                  ),
                  Spacer(),
                  Icon(
                    Icons.schedule,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    "${widget.timesheetdata.totalHour.toString()} hrs",
                    style: smallNStyle.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
