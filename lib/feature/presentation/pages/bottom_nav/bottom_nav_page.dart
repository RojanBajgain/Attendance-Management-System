import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/dashboard.dart';
import 'package:ams/feature/presentation/pages/payroll/payroll_page.dart';
import 'package:ams/feature/presentation/pages/profile/pages/profile.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
import 'package:flutter/material.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedTab = 0;

  List<Widget> get _pages => [
        DashboardPage(),
        TimeOffPage(),
        TimeSheetPage(),
        PayrollPage(),
        ProfilePage(),
      ];

  void _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void switchToTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        currentIndex: _selectedTab,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.primary
            : AppColors.tertiary,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[400]
            : Colors.grey,
        selectedLabelStyle: miniStyle.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.primary
              : Colors.black,
        ),
        unselectedLabelStyle: miniStyle.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[400]
              : Colors.grey,
        ),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: "Time Offs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sd_card_outlined), label: "TimeSheet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_num_outlined), label: "PayRoll"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
        ],
      ),
    );
  }
}
