import 'dart:io';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profile_view.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_info.dart';
import 'package:ams/feature/utils/skeleton_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

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

  File? _profileImage;
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    await profilecontroller.getProfile();
    if (mounted) {
      setState(() {
        isLoading = false; // End loading
      });
    }
  }

  Future<void> _changeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _profileImage = File(croppedFile.path);
        });
        _showSaveDialog();
      }
    }
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Image'),
          content: const Text(
              'Do you want to save this image as your profile picture?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveImage();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveImage() {
    if (_profileImage != null) {
      setState(() {});
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
            child: isLoading
                ? _buildSkeletonUI(isDarkMode)
                : Obx(() {
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
                                    backgroundColor: isDarkMode
                                        ? Colors.black
                                        : Colors.grey[300],
                                    backgroundImage: (_profileImage != null)
                                        ? FileImage(_profileImage!)
                                        : (profiledata.profileImage.isNotEmpty)
                                            ? NetworkImage(
                                                profiledata.profileImage)
                                            : const AssetImage(
                                                    "assets/images/user_avatar.png")
                                                as ImageProvider,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDarkMode
                                            ? Colors.black
                                            : Colors.grey,
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
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
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

  Widget _buildSkeletonUI(bool isDarkMode) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circular Avatar Skeleton
        SkeletonBox(
          height: 150,
          width: 150,
          borderRadius: 75,
        ),
        SizedBox(height: 10),
        // Username Skeleton
        SkeletonBox(
          height: 20,
          width: 120,
          borderRadius: 4,
        ),
        SizedBox(height: 5),
        // Status Row Skeleton
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonBox(
              height: 16,
              width: 50,
              borderRadius: 4,
            ),
            SizedBox(width: 5),
            SkeletonBox(
              height: 20,
              width: 40,
              borderRadius: 20,
            ),
          ],
        ),
      ],
    );
  }
}
