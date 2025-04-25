import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/time_sheet_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeSheetPage extends StatefulWidget {
  const TimeSheetPage({super.key});

  @override
  State<TimeSheetPage> createState() => _TimeSheetPageState();
}

class _TimeSheetPageState extends State<TimeSheetPage> {
  final authcontroller = Get.find<AuthController>();

  final TimesheetController timesheetcontroller =
      Get.put(TimesheetController(timesheetRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    timesheetcontroller.getTimesheet();
    timesheetcontroller.clearSelectedDate();
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
                Row(
                  children: [
                    Text(
                      "Timesheets",
                      style: smallNStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final ThemeData datePickerTheme =
                            Theme.of(context).copyWith(
                          textTheme: TextTheme(
                            bodyLarge: TextStyle(
                              fontSize: 14.0,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            bodyMedium: TextStyle(
                              fontSize: 12.0,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: datePickerTheme,
                              child: child!,
                            );
                          },
                        );

                        if (selectedDate != null) {
                          timesheetcontroller.selectedDate.value = selectedDate;
                          timesheetcontroller.filterByDate(selectedDate);
                        }
                      },
                      child: Obx(() {
                        return Container(
                          height: 45.0,
                          width: timesheetcontroller.selectedDate.value != null
                              ? 165.0
                              : 48.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(70.0),
                            color: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.date_range_outlined,
                                color: Colors.black,
                              ),
                              if (timesheetcontroller.selectedDate.value !=
                                  null) ...[
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('MMM d, yyyy').format(
                                      timesheetcontroller.selectedDate.value!),
                                  style:
                                      smallStyle.copyWith(color: Colors.black),
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
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  // height: 600,
                  child: Obx(
                    () {
                      if (timesheetcontroller.isLoading.value) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: ShrimmerEffect.rectangular(
                              height: 100,
                            ),
                          ),
                        );
                      } else if (timesheetcontroller.timesheet.isEmpty) {
                        return SizedBox(
                          height: 600,
                          child: Center(
                            child: Text(
                              "No available Timesheet data",
                              style: smallStyle.copyWith(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount:
                                timesheetcontroller.filteredTimesheet.length,
                            itemBuilder: (context, index) {
                              final timesheet =
                                  timesheetcontroller.filteredTimesheet[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    TimeSheetWidget(timesheetdata: timesheet),
                              );
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
