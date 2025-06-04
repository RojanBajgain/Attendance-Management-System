import 'package:ams/config/resources/images.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/event_tooltip_page.dart';
import 'package:ams/feature/presentation/pages/calender_notification/sub_view_event/event_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/notification/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ConstantAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ConstantAppBar({super.key});

  @override
  State<ConstantAppBar> createState() => _ConstantAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ConstantAppBarState extends State<ConstantAppBar> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      shadowColor: Colors.black,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {
          // Get.off(() => const BottomNavPage());
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SvgPicture.asset(AppImages.ayata_ayata),
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          },
          icon: Icon(
            Icons.notifications_none_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 25.0,
          ),
        ),

        // Events
        IconButton(
          onPressed: () {
            final controller = Get.find<CalenderNotificationController>();

            if (controller.eventCalenders.isEmpty &&
                !controller.isLoading.value) {
              controller.getEventCalenders();
            }

            final RenderBox button = context.findRenderObject() as RenderBox;
            final position = button.localToGlobal(Offset.zero);
            final buttonCenter =
                position + Offset(button.size.width / 2, button.size.height);

            OverlayState? overlayState = Overlay.of(context);
            OverlayEntry? overlayEntry;

            // Store the original context
            final mainContext = context;

            overlayEntry = OverlayEntry(
              builder: (context) => Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        overlayEntry?.remove();
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Positioned(
                    top: buttonCenter.dy,
                    left: buttonCenter.dx - 150,
                    child: Material(
                      color: Colors.transparent,
                      child: EventTooltip(
                        isDarkMode: isDarkMode,
                        controller: controller,
                        onViewAll: () {
                          overlayEntry?.remove();
                          FocusScope.of(mainContext).unfocus();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            Get.to(() => const EventPage());
                          });
                        },
                        rootContext: context,
                      ),
                    ),
                  ),
                ],
              ),
            );
            overlayState.insert(overlayEntry);
          },
          icon: Icon(
            Icons.calendar_month_outlined,
            size: 25.0,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        // Chat Icon
        // IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const ChatsScreen(),
        //       ),
        //     );
        //   },
        //   icon: Icon(
        //     Icons.chat_bubble_outline,
        //     size: 25.0,
        //     color: isDarkMode ? Colors.white : Colors.black,
        //   ),
        // ),
      ],
    );
  }
}
