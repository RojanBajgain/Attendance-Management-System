import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/time_sheet_view.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/timeoff_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimesheetTimeoffTabView extends StatefulWidget {
  final TimeoffController timeoffcontroller;
  final TimesheetController timesheetcontroller;

  const TimesheetTimeoffTabView(
      {Key? key,
      required this.timeoffcontroller,
      required this.timesheetcontroller})
      : super(key: key);

  @override
  _TimesheetTimeoffTabViewState createState() =>
      _TimesheetTimeoffTabViewState();
}

class _TimesheetTimeoffTabViewState extends State<TimesheetTimeoffTabView> {
  bool isTimesheetSelected = true;
  bool isTimeOffSelected = false;

  void selectTimesheet() {
    setState(() {
      isTimesheetSelected = true;
      isTimeOffSelected = false;
    });
  }

  void selectTimeOff() {
    setState(() {
      isTimesheetSelected = false;
      isTimeOffSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: selectTimesheet,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Timesheet",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isTimesheetSelected) _tabIndicator(isDarkMode),
                  ],
                ),
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: isDarkMode ? Colors.white30 : Colors.black26,
            ),
            Expanded(
              child: GestureDetector(
                onTap: selectTimeOff,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Time Off",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isTimeOffSelected) _tabIndicator(isDarkMode),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        // Content
        Obx(() {
          if (isTimesheetSelected) {
            if (widget.timesheetcontroller.isLoading.value) {
              return _shimmer(context);
            } else if (widget.timesheetcontroller.timesheet.isEmpty) {
              return _noDataText("No available Timesheet data.", isDarkMode);
            } else {
              final list = widget.timesheetcontroller.timesheet;
              return _buildTimesheetList(list, context, isDarkMode);
            }
          } else {
            if (widget.timeoffcontroller.isLoading.value) {
              return _shimmer(context);
            } else if (widget.timeoffcontroller.timeoff.isEmpty) {
              return _noDataText("No available Timeoff data.", isDarkMode);
            } else {
              final list = widget.timeoffcontroller.timeoff;
              return _buildTimeOffList(list, context, isDarkMode);
            }
          }
        }),
      ],
    );
  }

  Widget _tabIndicator(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      height: 3,
      width: 100,
      color: isDarkMode ? Colors.white : Colors.black,
    );
  }

  Widget _shimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: ShrimmerEffect.rectangular(
          height: 120,
          width: MediaQuery.sizeOf(context).width,
        ),
      ),
    );
  }

  Widget _noDataText(String text, bool isDarkMode) {
    return SizedBox(
      height: 150.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_data.png',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: miniStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimesheetList(
      List<dynamic> list, BuildContext context, bool isDarkMode) {
    const maxItems = 5;
    final showViewAll = list.length > maxItems;
    final displayList = showViewAll ? list.take(maxItems).toList() : list;

    return Column(
      children: [
        ListView.builder(
          itemCount: displayList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: TimeSheetWidget(timesheetdata: displayList[index]),
            );
          },
        ),
        // if (showViewAll)
        //   TextButton(
        //     onPressed: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (_) => const TimeSheetPage()));
        //     },
        //     child: const Text(
        //       "View All",
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 16,
        //         color: Colors.blue,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildTimeOffList(
      List<dynamic> list, BuildContext context, bool isDarkMode) {
    const maxItems = 3;
    final showViewAll = list.length > maxItems;
    final displayList = showViewAll ? list.take(maxItems).toList() : list;

    return Column(
      children: [
        ListView.builder(
          itemCount: displayList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: TimeoffView(timeoffdata: displayList[index]),
            );
          },
        ),
        if (showViewAll)
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TimeOffPage()));
            },
            child: const Text("View All",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                )),
          ),
      ],
    );
  }
}
