import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/time_off_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/add_timeoff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeOffPage extends StatelessWidget {
  const TimeOffPage({super.key});

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
                      "Time offs",
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
                        // Handle the selected date if needed
                      },
                      child: Container(
                        height: 45.0,
                        width: 45.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(70.0),
                          color: Colors.grey.shade400,
                        ),
                        child: const Icon(
                          Icons.date_range_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddTimeoff(),
                          ),
                        );
                      },
                      child: Container(
                        height: 45.0,
                        width: 140.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color:
                              isDarkMode ? Colors.grey.shade400 : Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              "Add Time off",
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                TimeOffSheet(
                  buttonText: 'Approved',
                  backColor: Colors.green[100],
                  foreColor: Colors.green[900],
                ),
                // const SizedBox(height: 20.0),
                // TimeOffSheet(
                //   buttonText: 'Rejected',
                //   backColor: Colors.red[100],
                //   foreColor: Colors.red[900],
                // ),
                // const SizedBox(height: 20.0),
                // TimeOffSheet(
                //   buttonText: 'Pending',
                //   backColor: Colors.yellow[100],
                //   foreColor: Colors.yellow[900],
                // ),
                // const SizedBox(height: 20.0),
                // TimeOffSheet(
                //   buttonText: 'Rejected',
                //   backColor: Colors.red[100],
                //   foreColor: Colors.red[900],
                // ),
                // const SizedBox(height: 20.0),
                // TimeOffSheet(
                //   buttonText: 'Approved',
                //   backColor: Colors.green[100],
                //   foreColor: Colors.green[900],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
