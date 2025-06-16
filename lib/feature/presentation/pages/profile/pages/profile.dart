import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_profile_model.dart';
import 'package:ams/feature/presentation/pages/password/change_password.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/profile_container.dart';
import 'package:ams/feature/presentation/pages/profile/pages/profile_menu.dart';
import 'package:ams/feature/presentation/pages/theme/change_theme.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Profile? profileData;
  final String? apiKey;

  const ProfilePage({super.key, this.profileData, this.apiKey});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authcontroller = Get.find<AuthController>();
  final ProfileController profilecontroller = Get.put(ProfileController());

  int? _currentlyExpandedIndex;

  void _handleTileExpansion(int index) {
    setState(() {
      if (_currentlyExpandedIndex == index) {
        _currentlyExpandedIndex = null;
      } else {
        _currentlyExpandedIndex = index;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    profilecontroller.getProfile();
  }

  // List of allowed document types
  List<String> allowedTypes = [
    'citizenship',
    'education',
    'pan',
    'license',
    'recommendation',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(isDarkMode),
            _buildProfileContent(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      height: 150.0,
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
    );
  }

  Widget _buildProfileContent(bool isDarkMode) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(
          top: -100.0,
          left: 30.0,
          child: ProfilePic(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: [
              const SizedBox(height: 80.0),
              _buildPersonalInfo(isDarkMode, 0),
              _buildDocuments(isDarkMode, 1),
              _buildBankDetails(isDarkMode, 2),
              // _buildDeviceDetails(isDarkMode, 3),
              _buildChangePassword(),
              _buildTheme(),
              // _buildBiometrics(isDarkMode),
              _buildLogout(isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(bool isDarkMode, int index) {
    return ProfileMenu(
      text: "Personal Info",
      icon: Icons.account_circle_outlined,
      showIcon: true,
      isExpanded: _currentlyExpandedIndex == index,
      onExpandToggle: () => _handleTileExpansion(index),
      expandedContent: _buildExpandedContent(
        isDarkMode,
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const ShrimmerEffect.rectangular(height: 230);
          }

          final profileData = profilecontroller.profile;

          if (profileData.isEmpty) {
            return Center(
              child: Text(
                "No profile data available. Please try refreshing.",
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          }

          return Column(
            children: profileData
                .map((profileData) =>
                    _buildProfileDetails(profileData, isDarkMode))
                .toList(),
          );
        }),
      ),
    );
  }

  Widget _buildProfileDetails(Datum profiledata, bool isDarkMode) {
    String currentAddress = 'N/A';
    String permanentAddress = 'N/A';

    if (profiledata.addresses.isNotEmpty) {
      for (var address in profiledata.addresses) {
        final addressType = address.addressType.toLowerCase();
        final city = address.city.isNotEmpty ? address.city : '';
        final country =
            address.country.name.isNotEmpty ? address.country.name : '';

        if (addressType == 'current') {
          currentAddress = '$city, $country'.trim();
          if (currentAddress.isEmpty || currentAddress == ',') {
            currentAddress = 'N/A';
          }
        } else if (addressType == 'permanent') {
          permanentAddress = '$city, $country'.trim();
          if (permanentAddress.isEmpty || permanentAddress == ',') {
            permanentAddress = 'N/A';
          }
        }
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
              'Full Name:',
              profiledata.user.fullName.isNotEmpty
                  ? profiledata.user.fullName
                  : 'N/A'),
          _buildRow(
              'Designation:',
              profiledata.designation.name.isNotEmpty
                  ? profiledata.designation.name
                  : 'N/A'),
          _buildRow(
            'Date of Birth:',
            profiledata.dob != null
                ? DateFormat('yyyy-MM-dd').format(profiledata.dob)
                : 'N/A',
          ),
          _buildRow(
            'Joined Date:',
            profiledata.joinedDate != null
                ? DateFormat('yyyy-MM-dd').format(profiledata.joinedDate)
                : 'N/A',
          ),
          _buildRow(
              'Contact:',
              profiledata.phoneNumber.isNotEmpty
                  ? profiledata.phoneNumber
                  : 'N/A'),
          _buildRow('Current Address:', currentAddress),
          _buildRow('Permanent Address:', permanentAddress),
          _buildRow('Email:',
              profiledata.email.isNotEmpty ? profiledata.email : 'N/A'),
          // _buildRow('Gender:',
          //     profiledata.gender.isNotEmpty ? profiledata.gender : 'N/A'),
          // _buildRow(
          //     'Role:', profiledata.role.isNotEmpty ? profiledata.role : 'N/A'),
          // _buildRow(
          //     'Employee Type:',
          //     profiledata.employeeType.isNotEmpty
          //         ? profiledata.employeeType
          //         : 'N/A'),
          _buildRow(
              'Gross Salary:',
              profiledata.grossSalary != null
                  ? "Rs. ${profiledata.grossSalary.toString()}"
                  : 'N/A'),
          _buildRow(
              'Organization:',
              profiledata.organization.title.isNotEmpty
                  ? profiledata.organization.title
                  : 'N/A'),
          _buildRow(
              'Employee ID:',
              profiledata.userRecords.first.employeeNo != null
                  ? profiledata.userRecords.first.employeeNo.toString()
                  : 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDocuments(bool isDarkMode, int index) {
    return ProfileMenu(
      text: "Documents",
      icon: Icons.card_travel_outlined,
      isExpanded: _currentlyExpandedIndex == index,
      onExpandToggle: () => _handleTileExpansion(index),
      expandedContent: _buildExpandedContent(
        isDarkMode,
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const ShrimmerEffect.rectangular(height: 230);
          }

          final profileData = profilecontroller.profile;

          if (profileData.isEmpty) {
            return Center(
                child: Text(
              "No documents available.",
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ));
          }

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: profileData.length,
            itemBuilder: (BuildContext context, int index) {
              final profiledata = profileData[index];
              return _buildDocumentDetails(profiledata, isDarkMode);
            },
          );
        }),
      ),
    );
  }

  Widget _buildDocumentDetails(Datum profiledata, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profiledata.documents.isNotEmpty)
            for (final doc in profiledata.documents)
              if (allowedTypes.contains(doc.type.toLowerCase()))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow(
                        'Title:', doc.title.isNotEmpty ? doc.title : 'N/A'),
                    if (doc.identifier.isNotEmpty)
                      _buildRow('Identifier (${doc.type}):', doc.identifier),
                    if (doc.issuedDate != null)
                      _buildRow(
                        'Issued Date (${doc.type}):',
                        DateFormat('yyyy-MM-dd').format(doc.issuedDate),
                      ),
                  ],
                ),
          if (profiledata.documents.isEmpty && profiledata.resume == null)
            Text(
              'No documents available.',
              style: normalStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          if (profiledata.resume != null) _buildRow('Resume:', 'Available'),
        ],
      ),
    );
  }

  Widget _buildBankDetails(bool isDarkMode, int index) {
    return ProfileMenu(
      text: "Banking Details",
      icon: Icons.account_balance_outlined,
      isExpanded: _currentlyExpandedIndex == index,
      onExpandToggle: () => _handleTileExpansion(index),
      expandedContent: _buildExpandedContent(
        isDarkMode,
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const ShrimmerEffect.rectangular(height: 200);
          }

          final profileData = profilecontroller.profile;

          if (profileData.isEmpty) {
            return Center(
                child: Text(
              "No bank details available.",
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ));
          }

          return Column(
            children: profileData
                .map((datum) =>
                    _buildBankDetailList(datum.bankDetails, isDarkMode))
                .toList(),
          );
        }),
      ),
    );
  }

  Widget _buildBankDetailList(List<BankDetail> bankDetails, bool isDarkMode) {
    if (bankDetails.isEmpty) {
      return Text(
        'No bank details available.',
        style: normalStyle.copyWith(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bankDetails.map((bankDetail) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow('Bank Name:',
                  bankDetail.bankName.isNotEmpty ? bankDetail.bankName : 'N/A'),
              _buildRow(
                  'Bank Branch:',
                  bankDetail.bankBranch.isNotEmpty
                      ? bankDetail.bankBranch
                      : 'N/A'),
              _buildRow(
                  'Account Name:',
                  bankDetail.bankAccountName.isNotEmpty
                      ? bankDetail.bankAccountName
                      : 'N/A'),
              _buildRow(
                  'Account Number:',
                  bankDetail.bankAccount.isNotEmpty
                      ? bankDetail.bankAccount
                      : 'N/A'),
              // _buildRow('Payroll:', bankDetail.isPayroll ? 'Yes' : 'No'),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Widget _buildDeviceDetails(bool isDarkMode, int index) {
  //   return ProfileMenu(
  //     text: "Device Details",
  //     icon: Icons.tv_outlined,
  //     isExpanded: _currentlyExpandedIndex == index,
  //     onExpandToggle: () => _handleTileExpansion(index),
  //     expandedContent: _buildExpandedContent(
  //       isDarkMode,
  //       child: Obx(() {
  //         if (profilecontroller.isLoading.value) {
  //           return const ShrimmerEffect.rectangular(height: 200);
  //         }

  //         final profileData = profilecontroller.profile;
  //         return SizedBox(
  //           height: 70,
  //           width: MediaQuery.of(context).size.width,
  //           child: ListView.builder(
  //             padding: EdgeInsets.zero,
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: profileData.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               final profiledata = profileData[index];
  //               final device = profiledata.device;
  //               return _buildDeviceDetail(device, isDarkMode);
  //             },
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }

  // Widget _buildDeviceDetail(Device? device, bool isDarkMode) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     padding: const EdgeInsets.symmetric(vertical: 1.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildRow(
  //             'Finger Print ID:',
  //             device != null && device.fingerprintId.isNotEmpty
  //                 ? device.fingerprintId
  //                 : 'N/A'),
  //         _buildRow('Device ID:',
  //             device != null ? device.deviceUserId.toString() : 'N/A'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildChangePassword() {
    return ProfileMenu(
      text: "Change Password",
      icon: Icons.key_outlined,
      press: () {
        Get.to(
          () => const ChangePassword(),
          transition: Transition.rightToLeft,
        );
      },
      showIcon: false,
    );
  }

  Widget _buildTheme() {
    return ProfileMenu(
      text: "Change Theme",
      icon: Icons.color_lens,
      press: () {
        Get.to(
          () => const ChangeTheme(),
          transition: Transition.rightToLeft,
        );
      },
      showIcon: false,
    );
  }

//   Widget _buildBiometrics(bool isDarkMode) {
//     return Obx(() => ProfileMenu(
//           text: authcontroller.biometricsEnabled.value
//               ? "Disable Biometrics"
//               : "Enable Biometrics",
//           icon: Icons.fingerprint,
//           showIcon: false,
//           trailing: FlutterSwitch(
//             width: 55.0,
//             height: 30.0,
//             valueFontSize: 12.0,
//             toggleSize: 25.0,
//             value: authcontroller.biometricsEnabled.value,
//             borderRadius: 30.0,
//             padding: 4.0,
//             activeColor: Colors.green,
//             inactiveColor: Colors.grey.shade300,
//             toggleColor: Colors.white,
//             activeToggleColor: Colors.white,
//             onToggle: (value) async {
//               try {
//                 if (!value) {
//                   bool confirmed = await _showDisableConfirmation(
//                     context: Get.context!,
//                   );
//                   if (!confirmed) {
//                     return;
//                   }
//                   await authcontroller.toggleBiometrics(false);
//                   return;
//                 }

//                 bool canUseBiometrics = await authcontroller.canUseBiometrics();
//                 if (!canUseBiometrics) {
//                   SSnackbarUtil.showSnackbar(
//                     'Biometrics Unavailable',
//                     'Your device does not support biometrics or it is not enabled.',
//                     SnackbarType.error,
//                   );
//                   return;
//                 }

//                 String? storedEmail =
//                     await authcontroller.secureStorage.read(key: 'user_email');
//                 String? storedPassword = await authcontroller.secureStorage
//                     .read(key: 'user_password');

//                 if (storedEmail == null ||
//                     storedEmail.isEmpty ||
//                     storedPassword == null ||
//                     storedPassword.isEmpty) {
//                   SSnackbarUtil.showSnackbar(
//                     'Login Required',
//                     'Please log in with email and password first to enable biometric login.',
//                     SnackbarType.info,
//                   );
//                   return;
//                 }

//                 bool? isPasswordCorrect = await _showPasswordPrompt(
//                   context: Get.context!,
//                   storedPassword: storedPassword,
//                 );

//                 if (isPasswordCorrect == null) {
//                   return;
//                 }

//                 if (!isPasswordCorrect) {
//                   SSnackbarUtil.showSnackbar(
//                     'Incorrect Password',
//                     'The entered password is incorrect.',
//                     SnackbarType.error,
//                   );
//                   return;
//                 }

//                 await authcontroller.toggleBiometrics(true);
//               } catch (e) {
//                 SSnackbarUtil.showSnackbar(
//                   'Error',
//                   'Failed to toggle biometric settings.',
//                   SnackbarType.error,
//                 );
//               }
//             },
//           ),
//         ));
//   }

//   Future<bool?> _showPasswordPrompt({
//     required BuildContext context,
//     required String storedPassword,
//   }) async {
//     TextEditingController passwordController = TextEditingController();
//     bool obscureText = true;
//     bool? isPasswordCorrect;

//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//         return AlertDialog(
//           title: Center(
//             child: Text(
//               'Enter Password',
//               style: smallNStyle.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
//               ),
//             ),
//           ),
//           content: ConstrainedBox(
//             constraints: const BoxConstraints(
//               minWidth: 280,
//               maxWidth: 320,
//             ),
//             child: StatefulBuilder(
//               builder: (context, setState) {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 50,
//                       width: double.infinity,
//                       child: TextField(
//                         controller: passwordController,
//                         obscureText: obscureText,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: isDarkMode
//                               ? Colors.grey.shade300
//                               : Colors.black87,
//                         ),
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           labelStyle: smallStyle.copyWith(
//                             fontWeight: FontWeight.w500,
//                             color: isDarkMode
//                                 ? Colors.grey.shade300
//                                 : Colors.black87,
//                           ),
//                           filled: true,
//                           fillColor: isDarkMode
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade100,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                               color: isDarkMode
//                                   ? Colors.grey.shade600
//                                   : Colors.grey.shade400,
//                             ),
//                           ),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               obscureText
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: isDarkMode
//                                   ? Colors.grey.shade300
//                                   : Colors.black87,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 obscureText = !obscureText;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 isPasswordCorrect = null;
//                 Navigator.of(context).pop();
//               },
//               child: Text(
//                 'Cancel',
//                 style: smallStyle.copyWith(
//                   color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 isPasswordCorrect = passwordController.text == storedPassword;
//                 Navigator.of(context).pop();
//               },
//               child: Text(
//                 'Confirm',
//                 style: smallStyle.copyWith(
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
//         );
//       },
//     );

//     return isPasswordCorrect;
//   }

//   Future<bool> _showDisableConfirmation({
//     required BuildContext context,
//   }) async {
//     bool? confirmed;

//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//         return AlertDialog(
//           title: Center(
//             child: Text(
//               'Disable Biometrics',
//               style: smallNStyle.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
//               ),
//             ),
//           ),
//           content: ConstrainedBox(
//             constraints: const BoxConstraints(
//               minWidth: 280,
//               maxWidth: 320,
//             ),
//             child: Text(
//               'Are you sure you want to disable biometric authentication?',
//               style: smallStyle.copyWith(
//                 fontWeight: FontWeight.w500,
//                 color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 confirmed = false;
//               },
//               child: Text(
//                 'No',
//                 style: smallStyle.copyWith(
//                   color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
// //  SAY NO TO PIRACY
//                 Navigator.of(context).pop();
//                 confirmed = true;
//               },
//               child: Text(
//                 'Yes',
//                 style: smallStyle.copyWith(
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
//         );
//       },
//     );

//     return confirmed ?? false;
//   }

  Widget _buildLogout(bool isDarkMode) {
    return ProfileMenu(
      text: "Logout",
      icon: Icons.logout,
      press: () {
        Dialogs.bottomMaterialDialog(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          msg: 'Are You Sure? You want to Logout.',
          title: 'LOGOUT',
          context: context,
          msgStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.grey,
            fontSize: 15,
          ),
          actions: [
            IconsButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              iconData: Icons.cancel_outlined,
              color: Colors.grey[300],
              textStyle: TextStyle(color: Colors.grey.shade800),
              iconColor: Colors.grey.shade800,
            ),
            IconsButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final refreshToken = prefs.getString('refresh_token') ?? '';
                final accessToken = prefs.getString('access_token') ?? '';

                if (refreshToken.isEmpty || accessToken.isEmpty) {
                  SSnackbarUtil.showSnackbar(
                    'Logout Failed',
                    'Tokens are missing. Please try again.',
                    SnackbarType.info,
                  );
                  return;
                }

                await prefs.remove('refresh_token');
                await prefs.remove('access_token');
                authcontroller.logoutmethod(refreshToken, accessToken);
                Navigator.pop(context);
              },
              text: 'Logout',
              iconData: Icons.delete,
              color: Colors.red,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      },
      showIcon: false,
    );
  }

  Widget _buildExpandedContent(bool isDarkMode, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
