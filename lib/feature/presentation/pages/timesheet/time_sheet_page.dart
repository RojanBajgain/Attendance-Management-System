import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/time_sheet_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/timesheet_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSheetPage extends StatelessWidget {
  const TimeSheetPage({super.key});

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
                      style: normalStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
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
                const SizedBox(height: 20.0),
                const TimeSheetWidget(),
                // const SizedBox(height: 20.0),
                // TimeSheetWidget(),
                // const SizedBox(height: 20.0),
                // TimeSheetWidget(),
                // const SizedBox(height: 20.0),
                // TimeSheetWidget(),
                // const SizedBox(height: 20.0),
                // TimeSheetWidget(),
                // const SizedBox(height: 20.0),
                // TimeSheetWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
