import 'package:ams/feature/presentation/pages/login/login.dart';
import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
import 'package:ams/feature/presentation/pages/password/change_password.dart';
import 'package:ams/feature/presentation/pages/profile/sub_view_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[400],
      //   elevation: 0,
      //   toolbarHeight: 40.0,
      // ),
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
            Container(
              width: double.infinity,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfile(),
                        ),
                      );
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
                                const SizedBox(
                                  height: 80.0,
                                ),
                                ProfileMenu(
                                  text: "Personal Info",
                                  icon: Icons.account_circle_outlined,
                                  showIcon: true,
                                  expandedContent: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.0),
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Full Name:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'Sushma Tamrakar',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Designation:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'UI/UX Designer',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Date of Birth:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2056-10-16',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Joined Date:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2023-05-16',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Contact:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '9808010602',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Address:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'Newroad, KTM',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Email:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'sushma@gmail.com',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
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
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Citizenship Number:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2018-056-0777-253',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Issued Date:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2075-02-25',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Issued District:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'Kathmandu',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'PAN Number:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '02225555535',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
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
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Bank Name:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'NMB Bank',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Branch Name:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'New Road',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Account Name:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'Sushma Tamrakar',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Account Numberr:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '01234567898745632',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
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
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Finager Print ID:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '985142',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Device ID:',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '2075-0512',
                                                style: TextStyle(
                                                  fontFamily: 'Mutka',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
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
                                      msg: 'Are You Sure? You want to Logout.',
                                      title: 'logout',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage(),
                                              ),
                                            );
                                          },
                                          text: 'Cancel',
                                          iconData: Icons.cancel_outlined,
                                          color: Colors.grey[300],
                                          textStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          iconColor: Colors.grey,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Login(),
                                              ),
                                            );
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

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            padding: const EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        const AssetImage("assets/images/profile_image.png"),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {},
                  child: Text('Edit Profile'),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sushma Tamrakar",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF_Pro',
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          fontFamily: 'Mutka',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Container(
                        width: 25.0,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'IN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mutka',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
    this.showIcon = true,
    this.expandedContent,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;
  final bool showIcon;
  final Widget? expandedContent; // Widget to show when expanded

  @override
  _ProfileMenuState createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  bool _isExpanded = false; // Tracks expanded state

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.grey[100],
            ),
            onPressed: () {
              _toggleExpand();
              if (widget.press != null) {
                widget.press!();
              }
            },
            child: Row(
              children: [
                Icon(widget.icon, size: 30),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Mutka',
                      fontSize: 18.0,
                    ),
                  ),
                ),
                if (widget.showIcon)
                  GestureDetector(
                    onTap: _toggleExpand,
                    child: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          // Expanded content shown conditionally
          if (_isExpanded && widget.expandedContent != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: widget.expandedContent,
            ),
        ],
      ),
    );
  }
}
