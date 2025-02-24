import 'package:ams/config/resources/images.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/notification/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          Get.off(() => const BottomNavPage());
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SvgPicture.asset(AppImages.ayata_ayata),
        ),
      ),
      actions: <Widget>[
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(
        //     Icons.play_circle,
        //     color: Colors.green,
        //     size: 35.0,
        //   ),
        // ),
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
        /* IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatsScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.chat,
              // FontAwesomeIcons.chat,
              size: 35.0,
              color: Colors.grey,
              // FontAwesomeIcons.chat,
            ),
          ), */
      ],
    );
  }
}

/* 
import 'package:ams/config/resources/images.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/notification/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ConstantAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ConstantAppBar({super.key});

  @override
  State<ConstantAppBar> createState() => _ConstantAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ConstantAppBarState extends State<ConstantAppBar> {
  bool _isIconsVisible = false; // Controls visibility of horizontal icons
  bool _isOnBreak = false; // Tracks break/resume state

  @override
  void initState() {
    super.initState();
    _loadPersistedState(); // Load saved state when the app starts
  }

  // Load persisted state from SharedPreferences
  Future<void> _loadPersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isIconsVisible = prefs.getBool('isIconsVisible') ?? false;
      _isOnBreak = prefs.getBool('isOnBreak') ?? false;
    });
  }

  // Save state to SharedPreferences
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIconsVisible', _isIconsVisible);
    await prefs.setBool('isOnBreak', _isOnBreak);
  }

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
          Get.off(() => const BottomNavPage());
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SvgPicture.asset(AppImages.ayata_ayata),
        ),
      ),
      actions: <Widget>[
        // Horizontal Icons (Break/Resume)
        if (_isIconsVisible)
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    _isOnBreak = !_isOnBreak; // Toggle break/resume
                  });
                  await _saveState(); // Save state after change
                },
                icon: Icon(
                  _isOnBreak ? Icons.play_arrow : Icons.pause,
                  color: _isOnBreak ? Colors.green : Colors.orange,
                  size: 35.0,
                ),
              ),
            ],
          ),

        // Play/Stop Icon (Toggle and persist state)
        IconButton(
          onPressed: () async {
            setState(() {
              _isIconsVisible = !_isIconsVisible;
              if (!_isIconsVisible) {
                _isOnBreak = false; // Reset break state when hiding icons
              }
            });
            await _saveState(); // Save state after change
          },
          icon: Icon(
            _isIconsVisible ? Icons.stop : Icons.play_circle,
            color: _isIconsVisible ? Colors.red : Colors.green,
            size: 35.0,
          ),
        ),

        // Notification Icon
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
      ],
    );
  }
}
*/
