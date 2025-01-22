import 'package:ams/feature/presentation/pages/notification/notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConstantAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ConstantAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        shadowColor: Colors.black,
        leading: Image.asset("assets/images/Ayata_logo.png"),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.play_circle,
              size: 35.0,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
            icon: Icon(
              Icons.notifications_none_outlined,
              color: Colors.grey.shade500,
              size: 35.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
