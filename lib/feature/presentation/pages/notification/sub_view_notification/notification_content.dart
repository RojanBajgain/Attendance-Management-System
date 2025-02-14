import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationsContent extends StatefulWidget {
  final String calenderTxt;
  final String calenderDate;
  final String contextTxt;
  final String contextTxtDetail;
  final String contextTime;
  final Datum notificationdata;

  const NotificationsContent({
    super.key,
    required this.calenderTxt,
    required this.calenderDate,
    required this.contextTxt,
    required this.contextTxtDetail,
    required this.contextTime,
    required this.notificationdata,
  });

  @override
  State<NotificationsContent> createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 105.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 1),
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
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.calenderDate,
                        textAlign: TextAlign.center,
                        style: normalStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.contextTxt,
                    style: smallStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: Text(
                      widget.contextTxtDetail,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                      style: miniStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.contextTime,
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
