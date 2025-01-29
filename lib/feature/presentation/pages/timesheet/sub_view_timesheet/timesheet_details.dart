import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/time_sheet_details_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
import 'package:flutter/material.dart';

class TimeSheetDetail extends StatelessWidget {
  const TimeSheetDetail({super.key});

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
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimeSheetPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_sharp,
                        color: isDarkMode ? Colors.white : Colors.black,
                        // weight: 50.0,
                      ),
                      const SizedBox(width: 15.0),
                      Text("Timesheets",
                          style: normalStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          )),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          // Handle the selected date if needed
                        },
                        child: Container(
                          height: 55.0,
                          width: 55.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.grey[100],
                          ),
                          child: const Icon(
                            Icons.date_range_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                ReuseTimeSheet(),
                // const SizedBox(height: 20.0),
                // ReuseTimeSheet(),
                // const SizedBox(height: 20.0),
                // ReuseTimeSheet(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
