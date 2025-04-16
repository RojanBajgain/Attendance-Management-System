import 'dart:io';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profile_view.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_info.dart';
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

  @override
  void initState() {
    super.initState();
    profilecontroller.getProfile();
  }

  File? _profileImage;

  Future<void> _changeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9,
        // ],
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

        // Show a dialog to save the image
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the image logic
                _saveImage();
                Navigator.of(context).pop(); // Close the dialog
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
      // Save the image to your profile data or backend
      // For example, update the profile controller or state

      // profilecontroller.updateProfileImage(_profileImage!.path);
      setState(() {}); // Refresh the UI
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

                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return Dialog(
                          //       backgroundColor: Colors.transparent,
                          //       insetPadding: const EdgeInsets.all(10.0),
                          //       child: Stack(
                          //         children: [
                          //           // Full-screen image
                          //           GestureDetector(
                          //             onTap: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //             child: Container(
                          //               width:
                          //                   MediaQuery.of(context).size.width,
                          //               height:
                          //                   MediaQuery.of(context).size.height,
                          //               decoration: BoxDecoration(
                          //                 image: DecorationImage(
                          //                   image: (_profileImage != null)
                          //                       ? FileImage(_profileImage!)
                          //                       : (profiledata.profileImage
                          //                               .isNotEmpty)
                          //                           ? NetworkImage(profiledata
                          //                               .profileImage)
                          //                           : const AssetImage(
                          //                                   "assets/images/profile_image.png")
                          //                               as ImageProvider,
                          //                   fit: BoxFit.contain,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),

                          //           // "Change Image" button at the bottom
                          //           Positioned(
                          //             bottom: 20,
                          //             left: 0,
                          //             right: 0,
                          //             child: Center(
                          //               child: ElevatedButton(
                          //                 onPressed: () {
                          //                   _changeImage();
                          //                 },
                          //                 style: ElevatedButton.styleFrom(
                          //                   backgroundColor: isDarkMode
                          //                       ? Colors.white
                          //                       : Colors.blue,
                          //                   padding: const EdgeInsets.symmetric(
                          //                       horizontal: 20, vertical: 10),
                          //                 ),
                          //                 child: Text(
                          //                   "Change Image",
                          //                   style: TextStyle(
                          //                     fontSize: 16,
                          //                     color: isDarkMode
                          //                         ? Colors.black
                          //                         : Colors.white,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          // );
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
                                              "assets/images/user_avatar.png")
                                          as ImageProvider,
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
                              profiledata.isActive
                                  ? 'IN' // Active
                                  : 'OUT', // Inactive
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
