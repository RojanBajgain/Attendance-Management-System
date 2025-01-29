import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/timesheet_details.dart';
import 'package:flutter/material.dart';

class TimeSheetWidget extends StatelessWidget {
  const TimeSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
        height: 90.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              isDarkMode ? Colors.grey.shade700 : Colors.black,
              isDarkMode ? Colors.grey.shade700 : Colors.black,
              isDarkMode ? Colors.black : Colors.white,
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
                'Monday, 26 Oct 2024',
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
                  Text(
                    '9:30 AM',
                    style: smallNStyle.copyWith(color: Colors.green),
                  ),
                  Icon(
                    Icons.update,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  Text('5:30 AM',
                      style: smallNStyle.copyWith(color: Colors.red)),
                  Icon(
                    Icons.schedule,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  Text(
                    '8h 50min',
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
