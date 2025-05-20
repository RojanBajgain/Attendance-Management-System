import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/dashboard.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_profile_model.dart';
import 'package:ams/feature/presentation/pages/payroll/payroll_page.dart';
import 'package:ams/feature/presentation/pages/profile/pages/profile.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class BottomNavPage extends StatefulWidget {
  final Profile? profileData;
  final String? apiKey;

  const BottomNavPage({
    super.key,
    this.profileData,
    this.apiKey,
  });

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedTab = 0;
  late Profile? _profileData;
  late String? _apiKey;

  @override
  void initState() {
    super.initState();
    _profileData = widget.profileData;
    _apiKey = widget.apiKey;

    // If data wasn't passed directly, try to get from storage
    if (_profileData == null) {
      final box = GetStorage();
      final storedProfile = box.read('user_profile');
      if (storedProfile != null) {
        _profileData = Profile(
          profileId: box.read('profile_id') ?? 0,
          fullName: storedProfile['full_name'] ?? '',
          email: storedProfile['email'] ?? '',
          role: storedProfile['role'] ?? '',
          profileImage: storedProfile['profile_image'],
          designation: storedProfile['designation'] ?? '',
          employeeType: storedProfile['employee_type'] ?? '',
          organization: box.read('organization_name') ?? '',
        );
      }
    }

    if (_apiKey == null) {
      _apiKey = GetStorage().read('selectedOrganization')?['api_key'];
    }
  }

  List<Widget> get _pages => [
        DashboardPage(
          profileData: _profileData,
          apiKey: _apiKey,
        ),
        TimeOffPage(
          profileId: _profileData?.profileId,
          apiKey: _apiKey,
        ),
        TimeSheetPage(
          profileId: _profileData?.profileId,
          apiKey: _apiKey,
        ),
        PayrollPage(
          profileId: _profileData?.profileId,
          apiKey: _apiKey,
        ),
        ProfilePage(
          profileData: _profileData,
          apiKey: _apiKey,
        ),
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
