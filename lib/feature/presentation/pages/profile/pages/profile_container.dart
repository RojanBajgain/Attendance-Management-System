import 'dart:io';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePic extends StatefulWidget {
  final Datum? profiledata;
  const ProfilePic({
    super.key,
    this.profiledata,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final authcontroller = Get.find<AuthController>();
  final ProfileController profilecontroller =
      Get.put(ProfileController(profileRepo: Get.find()));

  // final ProfileController profilecontroller = Get.find();

  File? _profileImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (profilecontroller.profile.isEmpty) {
      setState(() {
        isLoading = true;
      });
      await profilecontroller.getProfile();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                ),
              ],
            ),
            padding: const EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Obx(() {
              final profileData = profilecontroller.profile;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: profileData.length,
                itemBuilder: (BuildContext context, int index) {
                  final profiledata = profileData[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => EditUserInfo(
                                profileId: profiledata.id.toString(),
                              ));
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 75,
                              backgroundColor:
                                  isDarkMode ? Colors.black : Colors.grey[300],
                              backgroundImage: (_profileImage != null)
                                  ? FileImage(_profileImage!)
                                  : (profiledata.profileImage.isNotEmpty)
                                      ? NetworkImage(profiledata.profileImage)
                                      : const AssetImage(
                                          "assets/images/profile.png",
                                        ) as ImageProvider,
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isDarkMode ? Colors.black : Colors.grey,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profiledata.username,
                        style: normalStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Status',
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Container(
                            width: 40.0,
                            decoration: BoxDecoration(
                              color: profiledata.isActive
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              profiledata.isActive ? 'IN' : 'OUT',
                              textAlign: TextAlign.center,
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
