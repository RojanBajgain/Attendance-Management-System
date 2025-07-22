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
          duration: const Duration(milliseconds: 150),
        );
      },
      child: Container(
        height: 80.0,
        width: double.infinity,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(8.0),
        //   color: Colors.grey[200],
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.2),
        //       blurRadius: 2,
        //       spreadRadius: 1,
        //       offset: const Offset(0, 1),
        //     ),
        //   ],
        //   gradient: LinearGradient(
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //     colors: [
        //       isDarkMode ? Colors.grey.shade400 : Colors.black,
        //       isDarkMode ? Colors.grey.shade400 : Colors.black,
        //       isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        //     ],
        //     stops: const [
        //       0.0,
        //       0.02,
        //       0.0,
        //     ],
        //   ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode ? Colors.white : Colors.black,

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
            ), //blur radius of shadow
          ],

          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     // Green if both entry and exit time exist, orange if only entry, red if neither
          //     widget.timesheetdata.exitTime != null
          //         ? Colors.green.shade600
          //         : widget.timesheetdata.entryTime != null
          //             ? Colors.orange.shade600
          //             : Colors.red.shade600,
          //     widget.timesheetdata.exitTime != null
          //         ? Colors.green.shade600
          //         : widget.timesheetdata.entryTime != null
          //             ? Colors.orange.shade600
          //             : Colors.red.shade600,
          //     isDarkMode ? Colors.grey.shade800 : Colors.white,
          //   ],
          //   stops: const [0.0, 0.02, 0.02],
          // ),
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
              ), //blur radius of shadow
            ],
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
                      ? DateFormat.yMMMMEEEEd('en_US')
                          .format(widget.timesheetdata.date!)
                      : "N/A",
                  style: smallStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 95,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.history,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.timesheetdata.entryTime != null
                                ? DateFormat('hh:mm a').format(
                                    widget.timesheetdata.entryTime!.toLocal())
                                : "--:--",
                            style: smallStyle.copyWith(
                              color: Colors.green,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 90,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.update,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.timesheetdata.exitTime != null
                                ? DateFormat('hh:mm a').format(
                                    widget.timesheetdata.exitTime!.toLocal())
                                : "--:--",
                            style: smallStyle.copyWith(
                              color: Colors.red,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 90,
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color:
                                isDarkMode ? Colors.grey : Colors.grey.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.timesheetdata.totalHour} hrs",
                            style: smallStyle.copyWith(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
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
