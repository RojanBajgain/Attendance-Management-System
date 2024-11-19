import 'package:ams/components/app_bar.dart';
import 'package:ams/pages/timesheet_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSheetPage extends StatelessWidget {
  const TimeSheetPage({super.key});

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
                Row(
                  children: [
                    Text(
                      "Timesheets",
                      style: TextStyle(
                        fontFamily: 'Mukta',
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
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
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey[100],
                        ),
                        child: Icon(
                          Icons.date_range_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                TimeSheetWidget(),
                const SizedBox(height: 20.0),
                TimeSheetWidget(),
                const SizedBox(height: 20.0),
                TimeSheetWidget(),
                const SizedBox(height: 20.0),
                TimeSheetWidget(),
                const SizedBox(height: 20.0),
                TimeSheetWidget(),
                const SizedBox(height: 20.0),
                TimeSheetWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeSheetWidget extends StatelessWidget {
  const TimeSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimeSheetDetail(),
          ),
        );
      },
      child: Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.grey[200],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              Colors.black,
              Colors.grey.shade200,
            ],
            stops: [
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
              const Text(
                'Monday, 26 Oct 2024',
                style: TextStyle(
                  fontFamily: 'Mukta',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 15.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.black),
                    const SizedBox(width: 5.0),
                    const Text(
                      '9:30 AM \nOn Time',
                      style: TextStyle(color: Colors.green),
                    ),
                    const SizedBox(width: 10.0),
                    Icon(Icons.update, color: Colors.black),
                    const SizedBox(width: 5.0),
                    const Text(
                      '5:30 AM \nLate',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(width: 10.0),
                    Icon(
                      Icons.schedule,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      '8h 50min \n2h OT',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 10.0),
                    Icon(
                      Icons.playlist_play,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      'Morning \nShift',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
