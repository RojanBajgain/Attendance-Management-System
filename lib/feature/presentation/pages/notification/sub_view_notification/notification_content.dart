import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsContent extends StatefulWidget {
  final String calenderTxt;
  final String calenderDate;
  final String contextTxt;
  final String contextTxtDetail;
  final DateTime contextTime;
  final Datum notificationdata;
  final VoidCallback onDelete;
  final VoidCallback onMarkAsRead;

  NotificationsContent({
    super.key,
    required this.calenderTxt,
    required this.calenderDate,
    required this.contextTxt,
    required this.contextTxtDetail,
    required this.contextTime,
    required this.notificationdata,
    required this.onDelete,
    required this.onMarkAsRead,
  });

  @override
  State<NotificationsContent> createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isUnread = widget.notificationdata.isRead == false;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        // Add subtle border for unread notifications
        border: isUnread
            ? Border.all(color: Colors.transparent.withOpacity(0.3), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar widget with unread indicator
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red,
                            Colors.grey.shade200,
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
                            top: 4.0,
                            left: 19.0,
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
                            top: 32.0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                widget.calenderDate,
                                textAlign: TextAlign.center,
                                style: smallNStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Unread indicator dot
                    if (isUnread)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.contextTxt,
                                    style: smallStyle.copyWith(
                                      fontWeight: isUnread
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isUnread) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: Icon(
                              Icons.close,
                              size: 15,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contextTxtDetail,
                            overflow: _expanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            maxLines: _expanded ? null : 3,
                            softWrap: true,
                            style: miniStyle.copyWith(
                              color:
                                  isDarkMode ? Colors.grey[400] : Colors.black,
                              fontSize: 11.0,
                              fontWeight: isUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                          if (widget.contextTxtDetail.length > 100 &&
                              !_expanded)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _expanded = !_expanded;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _expanded ? "Show less" : "Show more",
                                  style: miniStyle.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        timeago.format(widget.contextTime),
                        style: miniStyle.copyWith(
                          color: isDarkMode ? Colors.grey[400] : Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Action buttons row
            if (isUnread) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: widget.onMarkAsRead,
                    icon: const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.blue,
                    ),
                    label: const Text(
                      'Mark as Read',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
