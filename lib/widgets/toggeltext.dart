import 'package:flutter/material.dart';

class ToggleTextWidget extends StatefulWidget {
  @override
  _ToggleTextWidgetState createState() => _ToggleTextWidgetState();
}

class _ToggleTextWidgetState extends State<ToggleTextWidget> {
  bool isHolidaySelected = true;

  void selectHoliday() {
    setState(() {
      isHolidaySelected = true;
    });
  }

  void selectEvents() {
    setState(() {
      isHolidaySelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: selectHoliday,
              child: Column(
                children: [
                  Text(
                    'Holiday',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isHolidaySelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      height: 4.0,
                      width: 60.0,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 30.0),
            GestureDetector(
              onTap: selectEvents,
              child: Column(
                children: [
                  Text(
                    'Events',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isHolidaySelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      height: 4.0,
                      width: 60.0,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30.0),

        // Display different containers based on selected option
        isHolidaySelected ? _buildHoliday() : _buildEvents(),
      ],
    );
  }

  Widget _buildHoliday() {
    return Container(
      height: 500.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 25.0,
          left: 15.0,
          right: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[200],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red,
                        Colors.red,
                        Colors.grey.shade100,
                      ],
                      stops: [
                        0.0,
                        0.4,
                        0.1,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: const [
                      Positioned(
                        top: 5.0,
                        left: 22.0,
                        child: Text(
                          'DEC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 33.0,
                        left: 22.0,
                        child: Text(
                          '30',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Maha ShivaRatri',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Maha Shivaratri Holiday',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'In 5 days',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red,
                            Colors.grey.shade100,
                          ],
                          stops: [
                            0.0,
                            0.4,
                            0.1,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 5.0,
                            left: 22.0,
                            child: Text(
                              'JAN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 33.0,
                            left: 22.0,
                            child: Text(
                              '30',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Holi',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Falgun Purnima Holiday',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'In 8 days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red,
                            Colors.grey.shade100,
                          ],
                          stops: [
                            0.0,
                            0.4,
                            0.1,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 5.0,
                            left: 22.0,
                            child: Text(
                              'FEB',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 33.0,
                            left: 22.0,
                            child: Text(
                              '25',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Office Retreat',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Annual Retreat Holiday',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'In 35 days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red,
                            Colors.grey.shade100,
                          ],
                          stops: [
                            0.0,
                            0.4,
                            0.1,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 5.0,
                            left: 22.0,
                            child: Text(
                              'OCT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 33.0,
                            left: 30.0,
                            child: Text(
                              '5',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Dashain',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Dashin Holiday',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'In 91 days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvents() {
    return Container(
      height: 500.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 25.0,
          left: 15.0,
          right: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[200],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red,
                        Colors.red,
                        Colors.grey.shade100,
                      ],
                      stops: [
                        0.0,
                        0.4,
                        0.1,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: const [
                      Positioned(
                        top: 5.0,
                        left: 22.0,
                        child: Text(
                          'DEC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 33.0,
                        left: 22.0,
                        child: Text(
                          '30',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Tech Workshop',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Knowledge Sharing for TECH',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'In 5 days',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red,
                            Colors.grey.shade100,
                          ],
                          stops: [
                            0.0,
                            0.4,
                            0.1,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 5.0,
                            left: 22.0,
                            child: Text(
                              'JAN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 33.0,
                            left: 22.0,
                            child: Text(
                              '30',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Company Anniversary',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Our 5TH Aniversary',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'In 8 days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red,
                            Colors.grey.shade100,
                          ],
                          stops: [
                            0.0,
                            0.4,
                            0.1,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 5.0,
                            left: 22.0,
                            child: Text(
                              'FEB',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 33.0,
                            left: 22.0,
                            child: Text(
                              '25',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Office Retreat',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Annual Retreat Holiday',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'In 15 days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red,
                            Colors.grey.shade100,
                          ],
                          stops: [
                            0.0,
                            0.4,
                            0.1,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 5.0,
                            left: 22.0,
                            child: Text(
                              'Nov',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 33.0,
                            left: 30.0,
                            child: Text(
                              '5',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Office Presentation',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Presntation on choosen topic',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'In 7 days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
