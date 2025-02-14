import 'package:ams/config/resources/images.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/notification/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConstantAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ConstantAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Get.off(() => BottomNavPage());
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset(AppImages.ayataLogo),
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
              color: Colors.grey.shade500,
              size: 35.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.chat,
              size: 35.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
