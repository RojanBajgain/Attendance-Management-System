import 'package:ams/config/resources/images.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_image_brand_controller.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/event_tooltip_page.dart';
import 'package:ams/feature/presentation/pages/calender_notification/sub_view_event/event_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/notification/controller/notification_controller.dart';
import 'package:ams/feature/presentation/pages/notification/notifications.dart';
import 'package:ams/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shimmer/shimmer.dart';

class ConstantAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ConstantAppBar({super.key});

  @override
  State<ConstantAppBar> createState() => _ConstantAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ConstantAppBarState extends State<ConstantAppBar> {
  final notificationcontroller = Get.find<NotificationController>();

  final AppBrandController brandController = Get.find<AppBrandController>();

  final ThemeService themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      // shadowColor: Colors.black,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      automaticallyImplyLeading: false,
      title: Obx(() {
        if (brandController.isLoading.value) {
          // Show shimmer while loading
          return SizedBox(
            height: 90,
            width: 90,
            child: Shimmer.fromColors(
              baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor:
                  isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        } else if (themeService.logoUrl.isNotEmpty) {
          // Show network image if available
          return Column(
            children: [
              Image.network(
                themeService.logoUrl,
                height: 90,
                width: 90,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 90,
                    width: 90,
                    child: Shimmer.fromColors(
                      baseColor:
                          isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      highlightColor:
                          isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AppImages.logo,
                    height: 90,
                    width: 90,
                    color: isDarkMode ? Colors.white : Colors.black,
                  );
                },
              ),
            ],
          );
        } else {
          // Fallback to local asset
          return Column(
            children: [
              Image.asset(
                AppImages.logo,
                height: 90,
                width: 90,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ],
          );
        }
      }),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            await notificationcontroller.markAllAsRead();
            Future.delayed(const Duration(milliseconds: 100), () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const NotificationsPage(),
              //   ),
              // );
              Get.to(
                () => const NotificationsPage(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 100),
              );
            });
          },
          icon: badges.Badge(
            showBadge: notificationcontroller.notification
                .any((notif) => notif.isRead == false),
            badgeContent: Text(
              notificationcontroller.notification
                  .where((notif) => notif.isRead == false)
                  .length
                  .toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.all(6),
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 25.0,
            ),
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
                            Get.to(
                              () => const EventPage(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 100),
                            );
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
