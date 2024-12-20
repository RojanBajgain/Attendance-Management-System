import 'package:ams/pages/add_timeoff.dart';
import 'package:ams/pages/dashboard.dart';
import 'package:ams/pages/payroll_page.dart';
import 'package:ams/pages/profile.dart';
import 'package:ams/pages/time_off_page.dart';
import 'package:ams/pages/time_sheet_page.dart';
import 'package:animations/animations.dart';
import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;

  List<Map<String, dynamic>> pages = [
    {
      'title': 'Home',
      'page': DashboardPage(),
      'index': 0,
    },
    {
      'title': 'Time Off',
      'page': TimeOffPage(),
      'index': 1,
    },
    {
      'title': 'Time Sheet',
      'page': TimeSheetPage(),
      'index': 2,
    },
    {
      'title': 'Payroll',
      'page': PayrollPage(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'page': ProfilePage(),
      'index': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_page]['page'],
      ),
      bottomNavigationBar: BottomBarBubble(
        selectedIndex: _page,
        items: [
          BottomBarItem(iconData: Icons.home_outlined),
          BottomBarItem(iconData: Icons.update),
          BottomBarItem(iconData: Icons.sd_card_outlined),
          BottomBarItem(iconData: Icons.confirmation_number_outlined),
          BottomBarItem(iconData: Icons.settings),
        ],
        color: Colors.black,
        onSelect: (index) {
          // Use addPostFrameCallback to avoid calling setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigationTapped(index);
          });
        },
      ),
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
