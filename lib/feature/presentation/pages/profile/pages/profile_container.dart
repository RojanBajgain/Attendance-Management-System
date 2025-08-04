import 'dart:io';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePic extends StatefulWidget {
  final ProfileModel? profiledata;
  const ProfilePic({
    super.key,
    this.profiledata,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final authcontroller = Get.find<AuthController>();
  final profilecontroller = Get.put(ProfileController(profileRepo: Get.find()));

  // final ProfileController profilecontroller = Get.find();

  File? _profileImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (profilecontroller.profile.value == null) {
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
                  color: isDarkMode ? Colors.grey.shade700 : Colors.white,
                ),
              ],
            ),
            // padding: const EdgeInsets.only(left: 10.0),
            padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Obx(() {
              final profiledata = profilecontroller.profile.value;
              if (profiledata == null) return const SizedBox.shrink();

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
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : (profiledata.profileImage?.isNotEmpty ??
                                        false)
                                    ? Image.network(
                                        profiledata.profileImage!,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          debugPrint(
                                              "Image load failed: $error");
                                          return Image.asset(
                                            'assets/images/profile_image.png',
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/profile_image.png',
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode ? Colors.black : Colors.grey,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profiledata.username ?? '',
                    style: normalStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14.0,
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
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Container(
                        width: 55.0,
                        decoration: BoxDecoration(
                          color:
                              profiledata.isActive ? Colors.green : Colors.red,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          profiledata.isActive ? 'Online' : 'Offline',
                          textAlign: TextAlign.center,
                          style: smallStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          )
        ]));
  }
}
