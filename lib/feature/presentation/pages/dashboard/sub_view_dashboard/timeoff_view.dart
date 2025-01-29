import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class TimeoffView extends StatefulWidget {
  const TimeoffView({super.key});

  @override
  State<TimeoffView> createState() => _TimeoffViewState();
}

class _TimeoffViewState extends State<TimeoffView> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 180.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date',
              style: TextStyle(
                fontFamily: 'SF_Pro',
                fontWeight: FontWeight.w400,
                fontSize: 15.0,
              ),
            ),
            // SizedBox(height: 5.0),
            Row(
              children: [
                const Text(
                  'Jan 5, 2024 to Jan 10, 2024',
                  style: TextStyle(
                    fontFamily: 'SF_Pro',
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
                // const SizedBox(width: 20.0),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.redAccent,
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Rejected'),
                ),
                // const SizedBox(width: 5.0),
                const Spacer(),
                Icon(
                  Icons.more_vert,
                  color: isDarkMode ? Colors.white : Colors.black,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Optional: for spacing
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Period',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text('5 Days',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Sick Leave',
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Approved By',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Sampurna',
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
