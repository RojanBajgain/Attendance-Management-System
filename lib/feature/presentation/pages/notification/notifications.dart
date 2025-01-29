import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/notification/sub_view_notification/notification_content.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Notification',
          style: normalStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.message_outlined,
              size: 30.0,
              color: isDarkMode ? Colors.white : Colors.black,
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
                const NotificationsContent(
                  calenderTxt: 'DEC',
                  calenderDate: '25',
                  contextTxt: 'Holi',
                  contextTxtDetail: 'Falgun Purnima Holiday',
                  contextTime: '19 Days',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                /*   NotificationsContent(
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
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
