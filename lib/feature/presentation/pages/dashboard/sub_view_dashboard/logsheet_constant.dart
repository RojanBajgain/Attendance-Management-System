import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/model/timesheet_model.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/timesheet_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LogSheetConstant extends StatelessWidget {
  final Datum timesheetdata;

  LogSheetConstant({super.key, required this.timesheetdata});

  final TimesheetController timesheetcontroller =
      Get.put(TimesheetController(timesheetRepo: Get.find()));

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // color: isDarkMode ? Colors.black : Colors.grey,
      height: 90.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            isDarkMode ? Colors.grey : Colors.black,
            isDarkMode ? Colors.grey : Colors.black,
            isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
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
          left: 30.0,
          top: 15.0,
          right: 20.0,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sunday, 01 Nov 2024',
              style: TextStyle(
                fontFamily: 'Mukta',
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.history,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                // SizedBox(width: 5.0),
                Text(
                  '9:30 AM',
                  style: smallStyle.copyWith(color: Colors.green),
                ),
                // const SizedBox(width: 25.0),
                Icon(
                  Icons.update,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                // SizedBox(width: 5.0),
                Text('5:30 AM',
                    style: smallStyle.copyWith(color: Colors.redAccent)),
                // const SizedBox(width: 25.0),
                Icon(
                  Icons.schedule,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                // SizedBox(width: 5.0),
                Text('8h 50min',
                    style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
