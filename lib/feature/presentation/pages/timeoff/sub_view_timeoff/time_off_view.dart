import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/add_reapply.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeOffSheet extends StatelessWidget {
  final Datum timeoffdata;
  void Function()? onTap;

  TimeOffSheet({
    super.key,
    required this.timeoffdata,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<TimeoffController>();

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            bool _showFullReason = false;

            final messageHeight = timeoffdata.reason != null
                ? (timeoffdata.reason!.length / 30 * 20).clamp(50.0, 200.0)
                : 10.0;
            return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color:
                              isDarkMode ? Colors.grey.shade800 : Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 15.0,
                          right: 20.0,
                          bottom: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Time off Details",
                                style: smallNStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name:',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 70.0),
                                Text(
                                  timeoffdata.username.toString(),
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Designation:',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 30.0),
                                Text(
                                  timeoffdata.designation.toString(),
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Start Date:',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  timeoffdata.startDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(timeoffdata.startDate!)
                                      : "N/A",
                                  overflow: TextOverflow.fade,
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'End Date:',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  timeoffdata.endDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(timeoffdata.endDate!)
                                      : "N/A",
                                  overflow: TextOverflow.fade,
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Type:',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 80.0),
                                Text(
                                  timeoffdata.type?.name ?? 'N/A',
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Wrap(
                              spacing: 5.0,
                              children: [
                                Text(
                                  'Reason:',
                                  style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      timeoffdata.reason.toString(),
                                      maxLines: _showFullReason ? null : 5,
                                      overflow: _showFullReason
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                      style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    if ((timeoffdata.reason?.length ?? 0) > 100)
                                      Center(
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _showFullReason =
                                                  !_showFullReason;
                                            });
                                          },
                                          child: Text(
                                            _showFullReason
                                                ? 'Show Less'
                                                : 'Show More',
                                            style: miniStyle.copyWith(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Message',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  height: 100,
                                  width: 270,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.0),
                                    color: isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey[50],
                                    border: Border.all(
                                      color: isDarkMode
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade800,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          timeoffdata.comments != null
                                              ? timeoffdata.comments.toString()
                                              : "",
                                          style: smallStyle.copyWith(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Type:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    timeoffdata.type?.name ?? 'N/A',
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Start Date:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    timeoffdata.startDate != null
                        ? DateFormat('yyyy-MM-dd')
                            .format(timeoffdata.startDate!)
                        : "N/A",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'End Date:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    timeoffdata.endDate != null
                        ? DateFormat('yyyy-MM-dd').format(timeoffdata.endDate!)
                        : "N/A",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Days:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "${timeoffdata.days.toString()} days",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Approved By:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    timeoffdata.approvedBy != null
                        ? timeoffdata.approvedBy!
                        : "N/A",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Status:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: _getContainerColor(timeoffdata.status),
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
                  // Show Re-apply and Delete buttons for rejected or pending status
                  if (timeoffdata.status?.toLowerCase() == 'rejected' ||
                      timeoffdata.status?.toLowerCase() == 'pending')
                    Row(
                      children: [
                        if (timeoffdata.status?.toLowerCase() == 'rejected')
                          const SizedBox(width: 10.0),
                        if (timeoffdata.status?.toLowerCase() == 'rejected')
                          GestureDetector(
                            onTap: () {
                              Get.to(() => AddReapplyPage(
                                    id: timeoffdata.id,
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Re-apply',
                                  style: smallStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            // Show custom confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.0),
                                      color: isDarkMode
                                          ? Colors.grey.shade800
                                          : Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        top: 15.0,
                                        right: 20.0,
                                        bottom: 20.0,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Confirm Delete',
                                              style: smallNStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            height: 20,
                                          ),
                                          Text(
                                            'Are you sure you want to delete this time-off request?',
                                            style: smallStyle.copyWith(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text(
                                                  'Cancel',
                                                  style: smallStyle.copyWith(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              TextButton(
                                                onPressed: () {
                                                  Get.back(); // Close confirmation dialog
                                                  controller.deleteTimeoff(
                                                      timeoffdata.id);
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: smallStyle.copyWith(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 24.0,
                          ),
                        ),
                      ],
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
