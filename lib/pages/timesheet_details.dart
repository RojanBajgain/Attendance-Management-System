import 'package:ams/components/app_bar.dart';
import 'package:ams/pages/time_sheet_page.dart';
import 'package:flutter/material.dart';

class TimeSheetDetail extends StatelessWidget {
  const TimeSheetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      const Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.black,
                        // weight: 50.0,
                      ),
                      const SizedBox(width: 15.0),
                      const Text(
                        "Timesheets",
                        style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
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
                          height: 55.0,
                          width: 55.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(15.0),
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
                const SizedBox(height: 20.0),
                ReuseTimeSheet(),
                const SizedBox(height: 20.0),
                ReuseTimeSheet(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReuseTimeSheet extends StatelessWidget {
  const ReuseTimeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 5), // vertical offset
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.only(
          left: 25.0,
          top: 15.0,
          right: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  '02/16/2024',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entry Time',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  '10:15:02 AM',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exit Time',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  '06:45:02 AM',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entry Remarks',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  'On Time',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exit Remarks',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  'Late',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shift',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  'Day',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Hour',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  '8 Hrs',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overtime',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  '2 Hrs',
                  style: TextStyle(
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
