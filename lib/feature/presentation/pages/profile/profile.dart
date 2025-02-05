import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
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
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// List of allowed types
const List<String> allowedTypes = ['citizenship', 'education', 'pan'];

class _ProfilePageState extends State<ProfilePage> {
  final authcontroller = Get.find<AuthController>();

  final ProfileController profilecontroller =
      Get.put(ProfileController(profileRepo: Get.find()));

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
                                // Personal Info
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
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () {
                                              if (profilecontroller
                                                  .isLoading.value) {
                                                return const ShrimmerEffect
                                                    .rectangular(height: 230);
                                                // return const Center(
                                                //   child:
                                                //       CircularProgressIndicator(),
                                                // );
                                              }

                                              // Show error message if there's an error
                                              if (profilecontroller
                                                  .errorMessage.isNotEmpty) {
                                                return Center(
                                                  child: Text(
                                                    profilecontroller
                                                        .errorMessage.value,
                                                    style: TextStyle(
                                                      color: isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }

                                              final profileData =
                                                  profilecontroller.profile;
                                              return SizedBox(
                                                height: 230,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: profileData.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final profiledata =
                                                        profileData[index];
                                                    return Container(
                                                      width: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width, // Constrain width
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 1.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Full Name
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Full Name:',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata
                                                                    .username,
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // Designation
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Designation:',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata
                                                                        .designation
                                                                        ?.name ??
                                                                    'N/A',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // Date of Birth
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Date of Birth:',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata.dob !=
                                                                        null
                                                                    ? DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            profiledata.dob!)
                                                                    : "N/A",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // Joined Date
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Joined Date:',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata.joinedDate !=
                                                                        null
                                                                    ? DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            profiledata.joinedDate!)
                                                                    : "N/A",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // Conatct Information
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Contact:',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata
                                                                        .phoneNumber
                                                                        .isNotEmpty
                                                                    ? profiledata
                                                                        .phoneNumber
                                                                    : 'N/A',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // Address Line
                                                          const SizedBox(
                                                              height: 10.0),
                                                          if (profiledata
                                                                      .addresses !=
                                                                  null &&
                                                              profiledata
                                                                  .addresses!
                                                                  .isNotEmpty)
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Permanent Address:',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  '${profiledata.addresses![0].city ?? ""}, ${profiledata.addresses![0].country?.name ?? ""}',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          else
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Address:',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  'N/A',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          const SizedBox(
                                                              height: 10.0),
                                                          if (profiledata
                                                                      .addresses !=
                                                                  null &&
                                                              profiledata
                                                                  .addresses!
                                                                  .isNotEmpty)
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Current Address:',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  profiledata.addresses !=
                                                                              null &&
                                                                          profiledata.addresses!.length >
                                                                              1
                                                                      ? '${profiledata.addresses![1].city ?? ""}, ${profiledata.addresses![1].country?.name ?? ""}'
                                                                      : 'N/A',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          else
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Address:',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  'N/A',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Email:',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata
                                                                        .email
                                                                        .isNotEmpty
                                                                    ? profiledata
                                                                        .email
                                                                    : 'N/A',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for My Account
                                  },
                                ),

                                // Documents
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
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(() {
                                            if (profilecontroller
                                                .isLoading.value) {
                                              return const ShrimmerEffect
                                                  .rectangular(height: 230);
                                            }
                                            if (profilecontroller
                                                .errorMessage.isNotEmpty) {
                                              return Center(
                                                child: Text(
                                                  profilecontroller
                                                      .errorMessage.value,
                                                  style: TextStyle(
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              );
                                            }
                                            final profileData =
                                                profilecontroller.profile;
                                            return SizedBox(
                                              height: 100,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: profileData.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final profiledata =
                                                        profileData[index];
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 1.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Document type
                                                          if (profiledata
                                                                  .documents !=
                                                              null)
                                                            for (final doc
                                                                in profiledata
                                                                    .documents!)
                                                              if (allowedTypes
                                                                  .contains(doc
                                                                      .type
                                                                      ?.toLowerCase()))
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "Type:",
                                                                      style: smallStyle
                                                                          .copyWith(
                                                                        color: isDarkMode
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    Text(
                                                                      doc.type ??
                                                                          'N/A',
                                                                      style: smallStyle
                                                                          .copyWith(
                                                                        color: isDarkMode
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Citizenship No:",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata
                                                                        .documents!
                                                                        .firstWhere(
                                                                          (doc) =>
                                                                              doc.type?.toLowerCase() ==
                                                                              'citizenship',
                                                                          orElse: () =>
                                                                              Document(identifier: 'N/A'),
                                                                        )
                                                                        .identifier ??
                                                                    'N/A',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Issued Date:",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                profiledata
                                                                            .documents!
                                                                            .firstWhere(
                                                                              (doc) => doc.type?.toLowerCase() == 'citizenship',
                                                                              orElse: () => Document(issuedDate: DateTime.now()),
                                                                            )
                                                                            .issuedDate !=
                                                                        null
                                                                    ? DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(profiledata
                                                                            .documents!
                                                                            .firstWhere(
                                                                              (doc) => doc.type?.toLowerCase() == 'citizenship',
                                                                              orElse: () => Document(issuedDate: DateTime.now()),
                                                                            )
                                                                            .issuedDate!)
                                                                    : 'N/A',
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for Documents
                                  },
                                ),

                                // Bank Details
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
                                          Obx(() {
                                            if (profilecontroller
                                                .isLoading.value) {
                                              return const ShrimmerEffect
                                                  .rectangular(height: 200);
                                            }

                                            final profileData = profilecontroller
                                                .profile; // Assuming this is List<Datum>

                                            // if (profileData.isEmpty) {
                                            //   return const SizedBox(
                                            //     height: 200,
                                            //     child: Center(
                                            //         child: Text(
                                            //             'No profile data found')),
                                            //   );
                                            // }

                                            return SizedBox(
                                              height: 150,
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: profileData.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final datum =
                                                      profileData[index];
                                                  final bankDetails =
                                                      datum.bankDetails;

                                                  if (bankDetails == null ||
                                                      bankDetails.isEmpty) {
                                                    // return const ListTile(
                                                    //   title: Text(
                                                    //       'No bank details available'),
                                                    // );
                                                  }
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: bankDetails!
                                                        .map((bankDetail) {
                                                      return Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Bank Name:",
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                SizedBox(
                                                                  width: 120,
                                                                  child: Text(
                                                                    bankDetail
                                                                            .bankName ??
                                                                        '', // Display the bank name
                                                                    style: smallStyle
                                                                        .copyWith(
                                                                      color: isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Bank Branch:",
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  bankDetail
                                                                          .bankBranch ??
                                                                      '',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Account Name:",
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  bankDetail
                                                                          .bankAccountName ??
                                                                      '',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Account Number:",
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  bankDetail
                                                                          .bankAccount ??
                                                                      '',
                                                                  style: smallStyle
                                                                      .copyWith(
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for Banking Details
                                  },
                                ),

                                // Device Details
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
                                          Obx(() {
                                            if (profilecontroller
                                                .isLoading.value) {
                                              return const ShrimmerEffect
                                                  .rectangular(height: 200);
                                            }

                                            final profileData =
                                                profilecontroller.profile;
                                            if (profileData.isEmpty) {
                                              return SizedBox(
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              );
                                            }
                                            return SizedBox(
                                              height: 90,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: profileData.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final profiledata =
                                                        profileData[index];
                                                    final device =
                                                        profiledata.device;

                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 1.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Finger Print ID:",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                device?.fingerprintId ??
                                                                    "N/A",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Device ID:",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                device?.portalPin ??
                                                                    "N/A",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "App Pin:",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                device?.appPin ??
                                                                    "N/A",
                                                                style: smallStyle
                                                                    .copyWith(
                                                                  color: isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    // Action for Device Details
                                  },
                                ),

                                // Change Password
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

                                // Logout
                                ProfileMenu(
                                  text: "Logout",
                                  icon: Icons.logout,
                                  press: () {
                                    // Action for Logout
                                    Dialogs.bottomMaterialDialog(
                                      color: isDarkMode
                                          ? Colors.grey.shade800
                                          : Colors.white,
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

                                            // Clear tokens from SharedPreferences
                                            await prefs.remove('refresh_token');
                                            await prefs.remove('access_token');

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
                                )
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
