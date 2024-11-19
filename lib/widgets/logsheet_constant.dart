import 'package:ams/pages/timesheet_details.dart';
import 'package:flutter/material.dart';

class LogSheetConstant extends StatelessWidget {
  const LogSheetConstant({super.key});

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
        height: 90.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
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
            left: 30.0,
            top: 15.0,
            right: 20.0,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sunday, 01 Nov 2024',
                style: TextStyle(
                  fontFamily: 'Mukta',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  const Text(
                    '9:30 AM',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  const Icon(
                    Icons.update,
                    color: Colors.black,
                  ),
                  const Text(
                    '5:30 AM',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  const Icon(
                    Icons.schedule,
                    color: Colors.black,
                  ),
                  Text(
                    '8h 50min',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
