import 'package:ams/config/resources/images.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_brand_controller.dart';
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
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      automaticallyImplyLeading: false,
      title: Obx(() {
        // First check if brand controller is loading
        if (brandController.isLoading.value) {
          return _buildShimmerPlaceholder(isDarkMode);
        }

        // Then check if ThemeService has a logo URL
        if (themeService.logoUrl.isNotEmpty) {
          return _buildDynamicLogo(themeService.logoUrl, 50, isDarkMode);
        }

        // Finally, fallback to local asset
        return _buildDefaultLogo(isDarkMode);
      }),
      actions: <Widget>[
        Obx(() => IconButton(
              onPressed: () async {
                notificationcontroller.readNotification();
                Future.delayed(const Duration(milliseconds: 100), () {
                  Get.to(
                    () => const NotificationsPage(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 100),
                  );
                });
              },
              icon: badges.Badge(
                showBadge: notificationcontroller.notification
                    .where((e) => e.isRead == false)
                    .isNotEmpty,
                badgeContent: Text(
                  notificationcontroller.unreadCount.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(8),
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 25.0,
                ),
              ),
            )),

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
      ],
    );
  }

  Widget _buildShimmerPlaceholder(bool isDarkMode) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultLogo(bool isDarkMode) {
    return Image.asset(
      AppImages.appLogoHr,
      height: 50,
      width: 50,
      color: isDarkMode ? Colors.white : Colors.black,
    );
  }

  Widget _buildDynamicLogo(String url, double size, bool isDarkMode) {
    final extension = url.split('.').last.toLowerCase();

    Widget shimmerPlaceholder = Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    if (extension == 'svg') {
      // Handle SVG
      return SizedBox(
        height: size,
        width: size,
        child: SvgPicture.network(
          url,
          height: size,
          width: size,
          placeholderBuilder: (context) => shimmerPlaceholder,
          fit: BoxFit.contain,
          colorFilter: isDarkMode
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null, // Optional: tint SVG for dark mode
        ),
      );
    } else {
      // Handle PNG, JPG, WEBP
      return SizedBox(
        height: size,
        width: size,
        child: Image.network(
          url,
          height: size,
          width: size,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return shimmerPlaceholder;
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading network image: $error');
            // Fallback to local asset on error
            return _buildDefaultLogo(isDarkMode);
          },
        ),
      );
    }
  }
}
