import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/password/change_password.dart';
import 'package:ams/feature/presentation/pages/profile/sub_view_profile/edit_profile_view.dart';
import 'package:ams/feature/presentation/pages/profile/sub_view_profile/profile_container.dart';
import 'package:ams/feature/presentation/pages/profile/sub_view_profile/profile_menu.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authcontroller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150.0,
              // width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: [
                    Colors.grey.shade400,
                    Colors.black,
                    Colors.grey.shade400,
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const EditProfileView());
                    },
                    child: SingleChildScrollView(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Positioned(
                            top: -100.0,
                            left: 30.0,
                            child: ProfilePic(),
                          ),
                          SingleChildScrollView(
                            padding:
                                const EdgeInsets.symmetric(vertical: 100.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 80.0),
                                ProfileMenu(
                                  text: "Personal Info",
                                  icon: Icons.account_circle_outlined,
                                  showIcon: true,
                                  expandedContent: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.0),
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.grey.shade50,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Full Name:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                'Sushma Tamrakar',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Designation:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                'UI/UX Designer',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Date of Birth:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2056-10-16',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Joined Date:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2023-05-16',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Contact:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '9808010602',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Address:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'Newroad, KTM',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Email:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'sushma@gmail.com',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for My Account
                                  },
                                ),
                                ProfileMenu(
                                  text: "Documents",
                                  icon: Icons.card_travel_outlined,
                                  expandedContent: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.0),
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.grey.shade50,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Citizenship Number:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2018-056-0777-253',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Issued Date:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '2075-02-25',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Issued District:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                'Kathmandu',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'PAN Number:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '02225555535',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for Documents
                                  },
                                ),
                                ProfileMenu(
                                  text: "Banking Details",
                                  icon: Icons.account_balance_outlined,
                                  expandedContent: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.0),
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.grey.shade50,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Bank Name:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                'NMB Bank',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Branch Name:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                'New Road',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Account Name:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                'Sushma Tamrakar',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Account Numberr:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '01234567898745632',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for Banking Details
                                  },
                                ),
                                ProfileMenu(
                                  text: "Device Details",
                                  icon: Icons.tv_outlined,
                                  expandedContent: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.0),
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.grey.shade50,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Finager Print ID:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '985142',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Device ID:',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '2075-0512',
                                                style: smallStyle.copyWith(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for Device Details
                                  },
                                ),
                                ProfileMenu(
                                  text: "Change Password",
                                  icon: Icons.key_outlined,
                                  press: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePassword(),
                                      ),
                                    );
                                  },
                                  showIcon: false,
                                ),
                                ProfileMenu(
                                  text: "Logout",
                                  icon: Icons.logout,
                                  press: () {
                                    // Action for Logout
                                    Dialogs.bottomMaterialDialog(
                                      color: isDarkMode
                                          ? Colors.grey.shade800
                                          : Colors.black,
                                      msg: 'Are You Sure? You want to Logout.',
                                      title: 'LOGOUT',
                                      context: context,
                                      msgStyle: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 15,
                                      ),
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ProfilePage(),
                                              ),
                                            );
                                          },
                                          text: 'Cancel',
                                          iconData: Icons.cancel_outlined,
                                          color: Colors.grey[300],
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          iconColor: Colors.grey,
                                        ),
                                        IconsButton(
                                          onPressed: () async {
                                            // Retrieve tokens from SharedPreferences
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final refreshToken =
                                                prefs.getString(
                                                        'refresh_token') ??
                                                    '';
                                            final accessToken = prefs.getString(
                                                    'access_token') ??
                                                '';

                                            if (refreshToken.isEmpty ||
                                                accessToken.isEmpty) {
                                              // Handle missing tokens
                                              Get.snackbar(
                                                'Logout Failed',
                                                'Tokens are missing. Please try again.',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                              return;
                                            }

                                            // Call the logout method with tokens
                                            authcontroller.logoutmethod(
                                                refreshToken, accessToken);

                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          text: 'Logout',
                                          iconData: Icons.delete,
                                          color: Colors.red,
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          iconColor: Colors.white,
                                        )
                                      ],
                                    );
                                  },
                                  showIcon: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
