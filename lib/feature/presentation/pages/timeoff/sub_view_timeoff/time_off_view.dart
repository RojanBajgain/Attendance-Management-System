import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class TimeOffSheet extends StatefulWidget {
  final String buttonText;
  final backColor;
  final foreColor;

  const TimeOffSheet({
    super.key,
    required this.buttonText,
    required this.backColor,
    required this.foreColor,
  });

  @override
  State<TimeOffSheet> createState() => _TimeOffSheetState();
}

class _TimeOffSheetState extends State<TimeOffSheet> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color: isDarkMode ? Colors.grey.shade800 : Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 15.0,
                    right: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Time off Details",
                          style: smallNStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
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
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 70.0),
                          Text(
                            'Sushma Tamrakar',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
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
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 30.0),
                          Text(
                            'UI/UX Designer',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
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
                                'Department:',
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(width: 30.0),
                          Text(
                            'Design',
                            overflow: TextOverflow.fade,
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
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
                                'Date:',
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '06 Feb, 2024 to Feb 10, 2024',
                            overflow: TextOverflow.fade,
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
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
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 80.0),
                          Text(
                            'Sick Leave',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Wrap(
                        spacing: 8.0, // Optional spacing between elements
                        children: [
                          Text(
                            'Reason:',
                            style: smallStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            'I am having diarrhea and I have to go toilet frequently.',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Message:',
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 150,
                            width: 270,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.0),
                              color: Colors.grey.shade50,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Accepted.',
                                    style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
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
            );
          },
        );
      },
      child: Container(
        height: 185.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 15.0,
            // right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Date:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 150.0),
                  Text(
                    '02/16/2024',
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
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
                        'Type:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 150.0),
                  Text(
                    'Sick Leave',
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
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
                        'Period:',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 140.0),
                  Text(
                    '3 Days',
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 95.0),
                  Text(
                    'Sampurna Mali',
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 140.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        widget.backColor,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        widget.foreColor,
                      ),
                      shape: MaterialStateProperty.all(
                        const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(widget.buttonText),
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
