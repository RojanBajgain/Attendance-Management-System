import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class HolidayEventNotification extends StatefulWidget {
  @override
  _HolidayEventNotificationState createState() =>
      _HolidayEventNotificationState();
}

class _HolidayEventNotificationState extends State<HolidayEventNotification> {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                    style: smallStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (isHolidaySelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      height: 4.0,
                      width: 60.0,
                      color: isDarkMode ? Colors.white : Colors.black,
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
                    style: smallStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (!isHolidaySelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      height: 4.0,
                      width: 60.0,
                      color: isDarkMode ? Colors.white : Colors.black,
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
    return Builder(builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Container(
        height: 500.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
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
                          isDarkMode ? Colors.white : Colors.grey.shade100,
                        ],
                        stops: [
                          0.0,
                          0.4,
                          0.1,
                        ],
                      ),
                    ),
                    child: const Stack(
                      children: [
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
                    children: [
                      Text(
                        'Maha ShivaRatri',
                        style: normalStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Maha Shivaratri Holiday',
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'In 5 days',
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Divider(
                thickness: 1,
                color: isDarkMode ? Colors.white : Colors.grey,
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
                        child: const Stack(
                          children: [
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
                        children: [
                          Text(
                            'Holi',
                            style: normalStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Falgun Purnima Holiday',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'In 8 days',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Divider(
                    thickness: 1,
                    color: isDarkMode ? Colors.white : Colors.grey,
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
                        child: const Stack(
                          children: [
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
                        children: [
                          Text(
                            'Office Retreat',
                            style: normalStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Annual Retreat Holiday',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'In 35 days',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Divider(
                    thickness: 1,
                    color: isDarkMode ? Colors.white : Colors.grey,
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
                        child: const Stack(
                          children: [
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
                        children: [
                          Text(
                            'Dashain',
                            style: normalStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Dashin Holiday',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'In 91 days',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Divider(
                    thickness: 1,
                    color: isDarkMode ? Colors.white : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEvents() {
    return Builder(builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Container(
        height: 500.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
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
                    child: const Stack(
                      children: [
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
                    children: [
                      Text(
                        'Tech Workshop',
                        style: smallNStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Knowledge Sharing for TECH',
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'In 5 days',
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Divider(
                thickness: 1,
                color: isDarkMode ? Colors.white : Colors.grey,
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
                        child: const Stack(
                          children: [
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
                        children: [
                          Text(
                            'Company Anniversary',
                            style: smallNStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Our 5TH Aniversary',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'In 8 days',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Divider(
                    thickness: 1,
                    color: isDarkMode ? Colors.white : Colors.grey,
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
                        child: const Stack(
                          children: [
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
                        children: [
                          Text(
                            'Office Retreat',
                            style: smallNStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Annual Retreat Holiday',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'In 15 days',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Divider(
                    thickness: 1,
                    color: isDarkMode ? Colors.white : Colors.grey,
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
                        child: const Stack(
                          children: [
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
                        children: [
                          Text(
                            'Office Presentation',
                            style: smallNStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Presntation on choosen topic',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'In 7 days',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Divider(
                    thickness: 1,
                    color: isDarkMode ? Colors.white : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
