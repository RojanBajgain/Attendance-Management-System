import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/password/change_password.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/sub_view_profile/edit_profile_view.dart';
import 'package:ams/feature/presentation/pages/profile/sub_view_profile/profile_container.dart';
import 'package:ams/feature/presentation/pages/profile/sub_view_profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String? profileId;

  const ProfilePage({super.key, this.profileId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authcontroller = Get.find<AuthController>();
  final ProfileController profilecontroller =
      Get.put(ProfileController(profileRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    profilecontroller.getProfile();
    profilecontroller.getProfileDetailData(widget.profileId.toString());
  }

  // List of allowed types
  List<String> allowedTypes = ['citizenship', 'education', 'pan'];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
              _buildPersonalInfo(isDarkMode),
              _buildDocuments(isDarkMode),
              _buildBankDetails(isDarkMode),
              _buildDeviceDetails(isDarkMode),
              _buildChangePassword(),
              _buildLogout(isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(bool isDarkMode) {
    return ProfileMenu(
      text: "Personal Info",
      icon: Icons.account_circle_outlined,
      showIcon: true,
      expandedContent: _buildExpandedContent(
        isDarkMode,
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const ShrimmerEffect.rectangular(height: 230);
          }

          final profileData = profilecontroller.profile;
          return SizedBox(
            height: 235,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: profileData.length,
              itemBuilder: (BuildContext context, int index) {
                final profiledata = profileData[index];
                return _buildProfileDetails(profiledata, isDarkMode);
              },
            ),
          );
        }),
      ),
      press: () {},
    );
  }

  Widget _buildProfileDetails(Datum profiledata, bool isDarkMode) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Full Name:', profiledata.username),
          _buildRow('Designation:', profiledata.designation?.name ?? 'N/A'),
          _buildRow(
            'Date of Birth:',
            profiledata.dob != null
                ? DateFormat('yyyy-MM-dd').format(profiledata.dob!)
                : "N/A",
          ),
          _buildRow(
            'Joined Date:',
            profiledata.joinedDate != null
                ? DateFormat('yyyy-MM-dd').format(profiledata.joinedDate!)
                : "N/A",
          ),
          _buildRow(
              'Contact:',
              profiledata.phoneNumber.isNotEmpty
                  ? profiledata.phoneNumber
                  : 'N/A'),
          if (profiledata.addresses != null &&
              profiledata.addresses!.isNotEmpty)
            _buildRow(
              'Permanent Address:',
              '${profiledata.addresses![0].city ?? ""}, ${profiledata.addresses![0].country?.name ?? ""}',
            )
          else
            _buildRow('Address:', 'N/A'),
          if (profiledata.addresses != null &&
              profiledata.addresses!.isNotEmpty)
            _buildRow(
              'Current Address:',
              profiledata.addresses != null && profiledata.addresses!.length > 1
                  ? '${profiledata.addresses![1].city ?? ""}, ${profiledata.addresses![1].country?.name ?? ""}'
                  : 'N/A',
            )
          else
            _buildRow('Address:', 'N/A'),
          _buildRow('Email:',
              profiledata.email.isNotEmpty ? profiledata.email : 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDocuments(bool isDarkMode) {
    return ProfileMenu(
      text: "Documents",
      icon: Icons.card_travel_outlined,
      expandedContent: _buildExpandedContent(
        isDarkMode,
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const ShrimmerEffect.rectangular(height: 230);
          }

          final profileData = profilecontroller.profile;
          return SizedBox(
            height: 100,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profileData.length,
              itemBuilder: (BuildContext context, int index) {
                final profiledata = profileData[index];
                return _buildDocumentDetails(profiledata, isDarkMode);
              },
            ),
          );
        }),
      ),
      press: () {},
    );
  }

  Widget _buildDocumentDetails(Datum profiledata, bool isDarkMode) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profiledata.documents != null)
            for (final doc in profiledata.documents!)
              if (allowedTypes.contains(doc.type?.toLowerCase()))
                _buildRow("Type:", doc.type ?? 'N/A'),
          _buildRow(
            "Citizenship No:",
            profiledata.documents!
                    .firstWhere(
                      (doc) => doc.type?.toLowerCase() == 'citizenship',
                      orElse: () => Document(identifier: 'N/A'),
                    )
                    .identifier ??
                'N/A',
          ),
          _buildRow(
            "Issued Date:",
            profiledata.documents!
                        .firstWhere(
                          (doc) => doc.type?.toLowerCase() == 'citizenship',
                          orElse: () => Document(issuedDate: DateTime.now()),
                        )
                        .issuedDate !=
                    null
                ? DateFormat('yyyy-MM-dd').format(
                    profiledata.documents!
                        .firstWhere(
                          (doc) => doc.type?.toLowerCase() == 'citizenship',
                          orElse: () => Document(issuedDate: DateTime.now()),
                        )
                        .issuedDate!,
                  )
                : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetails(bool isDarkMode) {
    return ProfileMenu(
      text: "Banking Details",
      icon: Icons.account_balance_outlined,
      expandedContent: _buildExpandedContent(
        isDarkMode,
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const ShrimmerEffect.rectangular(height: 200);
          }

          final profileData = profilecontroller.profile;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profileData.length,
              itemBuilder: (BuildContext context, int index) {
                final datum = profileData[index];
                final bankDetails = datum.bankDetails;
                return _buildBankDetailList(bankDetails, isDarkMode);
              },
            ),
          );
        }),
      ),
      press: () {},
    );
  }

  Widget _buildBankDetailList(List<BankDetail>? bankDetails, bool isDarkMode) {
    if (bankDetails == null || bankDetails.isEmpty) {
      return const SizedBox();
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
              _buildRow("Bank Name:", bankDetail.bankName ?? ''),
              _buildRow("Bank Branch:", bankDetail.bankBranch ?? ''),
              _buildRow("Account Name:", bankDetail.bankAccountName ?? ''),
              _buildRow("Account Number:", bankDetail.bankAccount ?? ''),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeviceDetails(bool isDarkMode) {
    return ProfileMenu(
      text: "Device Details",
      icon: Icons.tv_outlined,
      expandedContent: _buildExpandedContent(
        isDarkMode,
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const ShrimmerEffect.rectangular(height: 200);
          }

          final profileData = profilecontroller.profile;
          return SizedBox(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profileData.length,
              itemBuilder: (BuildContext context, int index) {
                final profiledata = profileData[index];
                final device = profiledata.device;
                return _buildDeviceDetail(device, isDarkMode);
              },
            ),
          );
        }),
      ),
      press: () {},
    );
  }

  Widget _buildDeviceDetail(Device? device, bool isDarkMode) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow("Finger Print ID:", device?.fingerprintId ?? "N/A"),
          _buildRow("Device ID:", device?.portalPin ?? "N/A"),
          _buildRow("App Pin:", device?.appPin ?? "N/A"),
        ],
      ),
    );
  }

  Widget _buildChangePassword() {
    return ProfileMenu(
      text: "Change Password",
      icon: Icons.key_outlined,
      press: () {
        Get.to(() => const ChangePassword(),
            transition: Transition.rightToLeft);
      },
      showIcon: false,
    );
  }

  Widget _buildLogout(bool isDarkMode) {
    return ProfileMenu(
      text: "Logout",
      icon: Icons.logout,
      press: () {
        Dialogs.bottomMaterialDialog(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
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
              textStyle: const TextStyle(color: Colors.grey),
              iconColor: Colors.grey,
            ),
            IconsButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final refreshToken = prefs.getString('refresh_token') ?? '';
                final accessToken = prefs.getString('access_token') ?? '';

                if (refreshToken.isEmpty || accessToken.isEmpty) {
                  Get.snackbar(
                    'Logout Failed',
                    'Tokens are missing. Please try again.',
                    snackPosition: SnackPosition.BOTTOM,
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
        color: isDarkMode ? Colors.black : Colors.grey.shade50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
