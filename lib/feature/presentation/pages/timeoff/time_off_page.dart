import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/add_timeoff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeOffPage extends StatelessWidget {
  const TimeOffPage({super.key});

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
                    const Text(
                      "Time offs",
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
                        height: 45.0,
                        width: 45.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(70.0),
                          color: Colors.grey[100],
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
                          color: Colors.black,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "Add Time off",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Mukta',
                                fontSize: 16.0,
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
                const SizedBox(height: 20.0),
                TimeOffSheet(
                  buttonText: 'Rejected',
                  backColor: Colors.red[100],
                  foreColor: Colors.red[900],
                ),
                const SizedBox(height: 20.0),
                TimeOffSheet(
                  buttonText: 'Pending',
                  backColor: Colors.yellow[100],
                  foreColor: Colors.yellow[900],
                ),
                const SizedBox(height: 20.0),
                TimeOffSheet(
                  buttonText: 'Rejected',
                  backColor: Colors.red[100],
                  foreColor: Colors.red[900],
                ),
                const SizedBox(height: 20.0),
                TimeOffSheet(
                  buttonText: 'Approved',
                  backColor: Colors.green[100],
                  foreColor: Colors.green[900],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
                  color: Colors.grey.shade50,
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
                      const Center(
                        child: Text(
                          "Time off Details",
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name:',
                                style: TextStyle(
                                  fontFamily: 'Mukta',
                                  // fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 70.0),
                          Text(
                            'Sushma Tamrakar',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Designation:',
                                style: TextStyle(
                                  fontFamily: 'Mukta',
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30.0),
                          Text(
                            'UI/UX Designer',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Department:',
                                style: TextStyle(
                                  fontFamily: 'Mukta',
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30.0),
                          Text(
                            'Design',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Date:',
                                style: TextStyle(
                                  fontFamily: 'Mukta',
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 50.0),
                          Text(
                            '06 Feb, 2024 to Feb 10, 2024',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Type:',
                                style: TextStyle(
                                  fontFamily: 'Mukta',
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 80.0),
                          Text(
                            'Sick Leave',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Reason:',
                                style: TextStyle(
                                  fontFamily: 'Mukta',
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 65.0),
                          Text(
                            'I am having diarrhea\nand I have to go tolilet\nfrequently.',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Message:',
                                style: TextStyle(
                                  fontFamily: 'Mukta',
                                  fontSize: 15.0,
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
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Accepted.',
                                    style: TextStyle(
                                      fontFamily: 'Mutka',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
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
            );
          },
        );
      },
      child: Container(
        height: 185.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          color: Colors.grey.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Date:',
                        style: TextStyle(
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 150.0),
                  Text(
                    '02/16/2024',
                    style: TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w100,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Type:',
                        style: TextStyle(
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 150.0),
                  Text(
                    'Sick Leave',
                    style: TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w100,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Period:',
                        style: TextStyle(
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 140.0),
                  Text(
                    '3 Days',
                    style: TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w100,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Approved By:',
                        style: TextStyle(
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 95.0),
                  Text(
                    'Sampurna Mali',
                    style: TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w100,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Status:',
                        style: TextStyle(
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
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
