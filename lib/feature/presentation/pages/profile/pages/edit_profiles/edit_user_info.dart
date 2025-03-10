import 'dart:developer';
import 'dart:io';

import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_address.dart';
import 'package:ams/feature/presentation/pages/profile/widget/file_uploader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EditUserInfo extends StatefulWidget {
  final String? profileId;

  const EditUserInfo({
    super.key,
    this.profileId,
  });

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  final authcontroller = Get.find<AuthController>();
  final ProfileController profilecontroller =
      Get.put(ProfileController(profileRepo: Get.find()));

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController joinedDateController = TextEditingController();

  File? _profileImage;

  File? _resume;

  bool _isLoading = false;

  Future<void> _submitUserInfo() async {
    // Validate required fields
    if (fullNameController.text.isEmpty ||
        dobController.text.isEmpty ||
        phoneController.text.isEmpty ||
        genderController.text.isEmpty ||
        skillsController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Failed to update profile,\nPlease fill the required fields',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );

      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final genderCode = _mapGenderToCode(genderController.text);

      await Future.delayed(const Duration(seconds: 1));

      await profilecontroller.postProfileUpdate(
        id: profilecontroller.profile.first.id,
        profileID: authcontroller.alluserData.value.user!.profileId,
        profileImage: _profileImage,
        username: fullNameController.text,
        dob: dobController.text,
        phonenumber: phoneController.text,
        gender: genderCode,
        joinedDate: joinedDateController.text,
        skills: skillsController.text.split(","),
        resume: _resume,
      );

      // Navigate to the next page after successful submission
      Get.to(() => const EditUserAddress());
    } catch (e) {
      print("Error in _submitUserInfo: $e");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Failed to update profile: $e")),
      // );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  String _mapGender(String? genderCode) {
    switch (genderCode?.toUpperCase()) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'O':
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  String _mapGenderToCode(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'male':
        return 'M';
      case 'female':
        return 'F';
      case 'other':
        return 'O';
      default:
        return 'M'; // Default to 'M' if the gender is unknown or null
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _resume = File(result.files.single.path!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final profile = profilecontroller.profile.first;

    // Initialize controllers with profile data
    fullNameController.text = profile.username;
    emailController.text = profile.email;
    genderController.text =
        _mapGender(profile.gender); // Map gender code to full name
    phoneController.text = profile.phoneNumber;
    designationController.text = profile.designation?.name ?? "";
    skillsController.text = profile.skills?.join(", ") ?? "";
    dobController.text = profile.dob != null
        ? DateFormat('yyyy-MM-dd').format(profile.dob!)
        : "";
    joinedDateController.text = profile.joinedDate != null
        ? DateFormat('yyyy-MM-dd').format(profile.joinedDate!)
        : "";
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Edit User Detail",
          style: smallStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () {
                    final profile = profilecontroller.profile;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: isDarkMode
                                        ? AppColors.white
                                        : AppColors.black,
                                    width: 2),
                                image: DecorationImage(
                                  image: _profileImage != null
                                      ? FileImage(
                                          _profileImage!) // Selected image
                                      : (profile.isNotEmpty &&
                                              profile
                                                  .first.profileImage.isNotEmpty
                                          ? NetworkImage(
                                                  profile.first.profileImage)
                                              as ImageProvider
                                          : const AssetImage(
                                              AppImages.profileImage)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? AppColors.white
                                          : AppColors.black,
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Edit Profile Picture",
                                          style: smallStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: isDarkMode
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        inputTextField(
                            title: "Full Name", controller: fullNameController),
                        const SizedBox(height: 16),
                        inputTextField(
                            title: "Email",
                            controller: emailController,
                            enabled: false),
                        const SizedBox(height: 16),
                        inputTextField(
                            title: "Gender", controller: genderController),
                        const SizedBox(height: 16),
                        inputTextField(
                            title: "Contact Number",
                            controller: phoneController),
                        const SizedBox(height: 16),
                        inputTextField(
                            title: "Designation",
                            controller: designationController,
                            enabled: false),
                        const SizedBox(height: 16),
                        inputTextField(
                            title: "Skills", controller: skillsController),
                        const SizedBox(height: 16),
                        inputTextField(
                            title: "Date of Birth", controller: dobController),
                        const SizedBox(height: 16),
                        inputTextField(
                            title: "Joined Date",
                            controller: joinedDateController,
                            enabled: false),
                        const SizedBox(height: 15),
                        if (profile.isNotEmpty &&
                            profile.first.resume != null &&
                            profile.first.resume.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Uploaded Resume",
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  launch(profile.first.resume!);
                                },
                                child: Text(
                                  profile.first.resume!,
                                  style: smallStyle.copyWith(
                                    color: Colors.blue,
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        if (profile.isEmpty ||
                            profile.first.resume == null ||
                            profile.first.resume.isEmpty)
                          FileUploadField(
                            title: "Add Resume",
                            hintText: "---",
                            onFilePicked: (FilePickerResult? result) {
                              if (result != null) {
                                setState(() {
                                  _resume = File(result.files.single.path!);
                                });
                                log("Picked file: ${result.files.single.name}");
                              } else {
                                log("No file picked");
                              }
                            },
                          ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 20, bottom: 20),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitUserInfo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? Colors.blueAccent
                                    : Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Next",
                                          style: smallStyle.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Space between text and icon
                                        const Icon(
                                          Icons.arrow_forward, // Arrow icon
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget inputTextField({
  required String title,
  required TextEditingController controller,
  bool enabled = true,
}) {
  return Builder(builder: (context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: smallStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: !enabled,
            fillColor: !enabled
                ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: isDarkMode ? Colors.white70 : const Color(0xffCCCCCC),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                width: 1,
                color: isDarkMode ? Colors.white70 : const Color(0xffCCCCCC),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: isDarkMode ? Colors.blueAccent : const Color(0xffCCCCCC),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.red.withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.red.withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  });
}
