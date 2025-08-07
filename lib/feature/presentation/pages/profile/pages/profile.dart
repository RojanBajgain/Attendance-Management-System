import 'dart:ui';

import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/HR_Details/pages/hr_details.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_profile_model.dart';
import 'package:ams/feature/presentation/pages/password/change_password.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/profile_container.dart';
import 'package:ams/feature/presentation/pages/theme/change_theme.dart';
import 'package:ams/services/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final Profile? profileData;
  final String? apiKey;

  const ProfilePage({super.key, this.profileData, this.apiKey});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authcontroller = Get.find<AuthController>();
  final profilecontroller = Get.put(ProfileController(profileRepo: Get.find()));

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
    profilecontroller.getProfile();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: () async {
          await profilecontroller.getProfile();
        },
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade300,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(isDarkMode),
                _buildProfileContent(isDarkMode),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 50,
                  child: Column(
                    children: [
                      Text(
                        '© 2025 iHRTrack. All Rights Reserved',
                        style: miniStyle.copyWith(
                            fontSize: 11, color: Colors.grey),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Product of ",
                            style: miniStyle.copyWith(
                                fontSize: 11, color: Colors.grey),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Helpers.launchWebsite();
                              },
                              splashColor: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                children: [
                                  Text(
                                    "Ayata Inc",
                                    style: miniStyle.copyWith(
                                      fontSize: 12,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_outward_rounded,
                                    size: 12,
                                    color: Colors.blueAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              _buildPersonalInfo(isDarkMode),
              _buildEmployeeDetail(isDarkMode),
              _buildDocuments(isDarkMode),
              _buildBankDetails(isDarkMode),
              _buildHRDetails(isDarkMode),
              _buildChangePassword(isDarkMode),
              // _buildTheme(isDarkMode),
              _buildLogout(isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 100),
          ),
          leading: Icon(
            Icons.account_circle_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            "Personal Info",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          iconColor: isDarkMode ? Colors.white : Colors.black,
          collapsedIconColor: isDarkMode ? Colors.white : Colors.black,
          children: [
            Divider(
              height: 1,
              thickness: 1,
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              indent: 14,
              endIndent: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (profilecontroller.isLoading.value) {
                  return const ShrimmerEffect.rectangular(height: 230);
                }

                final profileData = profilecontroller.profile.value;

                if (profileData == null) {
                  return Center(
                    child: Text(
                      "No profile data available. Please try login again.",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                return _buildProfileDetails(profileData, isDarkMode);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeDetail(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 100),
          ),
          leading: Icon(
            Icons.account_box_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            "Employee Detail",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          iconColor: isDarkMode ? Colors.white : Colors.black,
          collapsedIconColor: isDarkMode ? Colors.white : Colors.black,
          children: [
            Divider(
              height: 1,
              thickness: 1,
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              indent: 14,
              endIndent: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (profilecontroller.isLoading.value) {
                  return const ShrimmerEffect.rectangular(height: 230);
                }

                final profileData = profilecontroller.profile.value;

                if (profileData == null) {
                  return Center(
                    child: Text(
                      "No profile data available. Please try login again.",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                return _buildEmployeeDetails(profileData, isDarkMode);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocuments(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 100),
          ),
          leading: Icon(
            Icons.card_travel_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            "Documents",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          iconColor: isDarkMode ? Colors.white : Colors.black,
          collapsedIconColor: isDarkMode ? Colors.white : Colors.black,
          children: [
            Divider(
              height: 1,
              thickness: 1,
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              indent: 14,
              endIndent: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (profilecontroller.isLoading.value) {
                  return const ShrimmerEffect.rectangular(height: 230);
                }

                final profileData = profilecontroller.profile.value;

                if (profileData == null) {
                  return Center(
                    child: Text(
                      "No documents available.",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                return _buildDocumentDetails(profileData, isDarkMode);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetails(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 100),
          ),
          leading: Icon(
            Icons.account_balance_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            "Banking Details",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          iconColor: isDarkMode ? Colors.white : Colors.black,
          collapsedIconColor: isDarkMode ? Colors.white : Colors.black,
          children: [
            Divider(
              height: 1,
              thickness: 1,
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              indent: 14,
              endIndent: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (profilecontroller.isLoading.value) {
                  return const ShrimmerEffect.rectangular(height: 200);
                }

                final profileData = profilecontroller.profile.value;

                if (profileData == null) {
                  return Center(
                    child: Text(
                      "No bank details available.",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                return _buildBankDetailList(
                    profileData.bankDetails, isDarkMode);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHRDetails(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          // listTileTheme: ListTileTheme.of(context).copyWith(
          //   dense: true,
          // ),
        ),
        child: ListTile(
          leading: Icon(
            Icons.business_center_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            "HR Details",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 16,
          ),
          onTap: () {
            Get.to(
              () => const HRDetailsPage(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 100),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChangePassword(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          // listTileTheme: ListTileTheme.of(context).copyWith(
          //   dense: true,
          // ),
        ),
        child: ListTile(
          leading: Icon(
            Icons.key_outlined,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            "Change Password",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 16,
          ),
          onTap: () {
            Get.to(
              () => const ChangePassword(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 100),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTheme(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          // listTileTheme: ListTileTheme.of(context).copyWith(
          //   dense: true,
          // ),
        ),
        child: ListTile(
          leading: Icon(
            Icons.color_lens,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            "Change Theme",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 16,
          ),
          onTap: () {
            Get.to(
              () => const ChangeTheme(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 100),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogout(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          // listTileTheme: ListTileTheme.of(context).copyWith(
          //   dense: true,
          // ),
        ),
        child: ListTile(
          leading: const Icon(
            Icons.logout,
            // color: Colors.red,
          ),
          title: Text(
            "Logout",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 12.0,
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isDarkMode ? Colors.grey[850]! : Colors.white,
                        isDarkMode ? Colors.grey[800]! : Colors.grey[50]!,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.power_settings_new_rounded,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Are you sure you want to logout?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      'No',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [Colors.red, Colors.redAccent],
                                ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  _showLoadingAndLogout();
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLoadingAndLogout() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    authcontroller.localLogout(true);
  }

  Widget _buildProfileDetails(ProfileModel profiledata, bool isDarkMode) {
    String currentAddress = 'N/A';
    String permanentAddress = 'N/A';

    if (profiledata.addresses.isNotEmpty) {
      for (var address in profiledata.addresses) {
        final addressType = address.addressType.toLowerCase();
        final city = address.city.isNotEmpty ? address.city : '';
        final country =
            address.country!.name.isNotEmpty ? address.country!.name : '';

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
          _buildRow('Full Name:', profiledata.user?.fullName ?? 'N/A'),
          _buildRow('Designation:', profiledata.designation?.name ?? 'N/A'),
          _buildRow(
            'Date of Birth:',
            profiledata.dob != null
                ? DateFormat('yyyy-MM-dd').format(profiledata.dob!)
                : 'N/A',
          ),
          _buildRow(
            'Joined Date:',
            profiledata.joinedDate != null
                ? DateFormat('yyyy-MM-dd').format(profiledata.joinedDate!)
                : 'N/A',
          ),
          _buildRow('Contact:', profiledata.phoneNumber ?? 'N/A'),
          _buildRow('Current Address:', currentAddress),
          _buildRow('Permanent Address:', permanentAddress),
          _buildRow('Email:', profiledata.email ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildEmployeeDetails(ProfileModel profiledata, bool isDarkMode) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
              'Employee ID:',
              profiledata.userRecords.isNotEmpty
                  ? profiledata.userRecords.first.employeeNo.toString()
                  : 'N/A'),
          _buildRow('Department:', profiledata.organization?.title ?? 'N/A'),
          _buildRow(
            'Gross Salary:',
            profiledata.grossSalary != null &&
                    profiledata.grossSalary!.isNotEmpty
                ? "Rs. ${profiledata.grossSalary}"
                : "Rs. -",
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentDetails(ProfileModel profiledata, bool isDarkMode) {
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
                        DateFormat('yyyy-MM-dd').format(doc.issuedDate!),
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
            ],
          ),
        );
      }).toList(),
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
              fontSize: 12.0,
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
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
