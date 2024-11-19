import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notification',
          style: TextStyle(
            fontFamily: 'Mukta',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.message_outlined,
              size: 30.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                NotificationsContent(
                  calenderTxt: 'DEC',
                  calenderDate: '25',
                  contextTxt: 'Holi',
                  contextTxtDetail: 'Falgun Purnima Holiday',
                  contextTime: '19 Days',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                NotificationsContent(
                  calenderTxt: 'JAN',
                  calenderDate: '29',
                  contextTxt: 'Tech Workshop',
                  contextTxtDetail: 'Knowledge Sharing for TECH',
                  contextTime: '8 Days',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                NotificationsContent(
                  calenderTxt: 'FEB',
                  calenderDate: '15',
                  contextTxt: 'Stand Up',
                  contextTxtDetail: 'Regular Stand Up',
                  contextTime: '2 Days',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                NotificationsContent(
                  calenderTxt: 'OCT',
                  calenderDate: '10',
                  contextTxt: 'Office Retreat',
                  contextTxtDetail: 'Annual Reatreat Holiday',
                  contextTime: '35 Days',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                NotificationsContent(
                  calenderTxt: 'FEB',
                  calenderDate: '15',
                  contextTxt: 'Stand Up',
                  contextTxtDetail: 'Regular Stand Up',
                  contextTime: '2 Days',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                NotificationsContent(
                  calenderTxt: 'FEB',
                  calenderDate: '15',
                  contextTxt: 'Stand Up',
                  contextTxtDetail: 'Regular Stand Up',
                  contextTime: '2 Days',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                NotificationsContent(
                  calenderTxt: 'FEB',
                  calenderDate: '15',
                  contextTxt: 'Stand Up',
                  contextTxtDetail: 'Regular Stand Up',
                  contextTime: '2 Days',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationsContent extends StatefulWidget {
  final String calenderTxt;
  final String calenderDate;
  final String contextTxt;
  final String contextTxtDetail;
  final String contextTime;
  const NotificationsContent({
    super.key,
    required this.calenderTxt,
    required this.calenderDate,
    required this.contextTxt,
    required this.contextTxtDetail,
    required this.contextTime,
  });

  @override
  State<NotificationsContent> createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0, top: 10.0, bottom: 10.0,
          // right: 20.0,
        ),
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
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
                  stops: const [
                    0.0,
                    0.4,
                    0.1,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 5.0,
                    left: 22.0,
                    child: Text(
                      widget.calenderTxt,
                      style: const TextStyle(
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
                      widget.calenderDate,
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
            SizedBox(width: MediaQuery.of(context).size.height * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contextTxt,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  widget.contextTxtDetail,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  widget.contextTime,
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
      ),
    );
  }
}
