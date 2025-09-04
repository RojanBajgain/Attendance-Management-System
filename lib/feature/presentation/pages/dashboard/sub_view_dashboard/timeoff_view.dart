import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeoffView extends StatelessWidget {
  final Datum timeoffdata;
  void Function()? onTap;

  TimeoffView({super.key, this.onTap, required this.timeoffdata});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 155.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date',
              style: smallStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 12.0,
              ),
            ),
            // SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  timeoffdata.startDate != null && timeoffdata.endDate != null
                      ? (DateFormat.yMMMd('en_US')
                                  .format(timeoffdata.startDate!) ==
                              DateFormat.yMMMd('en_US')
                                  .format(timeoffdata.endDate!)
                          ? DateFormat.yMMMd('en_US')
                              .format(timeoffdata.startDate!)
                          : "${DateFormat.yMMMd('en_US').format(timeoffdata.startDate!)} to ${DateFormat.yMMMd('en_US').format(timeoffdata.endDate!)}")
                      : "",
                  style: smallStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12.0,
                  ),
                ),

                // const SizedBox(width: 20.0),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _getContainerColor(
                        timeoffdata.status), // Dynamic background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _getButtonText(timeoffdata.status),
                      style: smallStyle.copyWith(
                        color: _getStatusTextColor(timeoffdata.status),
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(width: 5.0),
                // const Spacer(),
                // Icon(
                //   Icons.more_vert,
                //   color: isDarkMode ? Colors.white : Colors.black,
                // )
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
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      // '${timeoffdata.days.toString()} days',
                      "${timeoffdata.days} ${timeoffdata.days == 1 ? 'day' : 'days'}",
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      timeoffdata.type?.name ?? 'N/A',
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12.0,
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
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      timeoffdata.approvedBy != null
                          ? timeoffdata.approvedBy!
                          : "---",
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12.0,
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

Color _getContainerColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'approved':
      return Colors.green.shade100;
    case 'pending':
      return Colors.orange.shade100;
    case 'rejected':
      return Colors.red.shade100;
    case 're-apply':
      return Colors.blue.shade100;
    default:
      return Colors.grey.shade100;
  }
}

Color _getStatusTextColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'approved':
      return Colors.green.shade800;
    case 'pending':
      return Colors.orange.shade800;
    case 'rejected':
      return Colors.red.shade800;
    case 're-apply':
      return Colors.blue.shade800;
    default:
      return Colors.grey.shade800;
  }
}

String _getButtonText(String? status) {
  switch (status?.toLowerCase()) {
    case 'approved':
      return 'Approved';
    case 'pending':
      return 'Pending';
    case 'rejected':
      return 'Rejected';
    case 're-apply':
      return 'Reapplied';
    default:
      return 'Unknown';
  }
}
