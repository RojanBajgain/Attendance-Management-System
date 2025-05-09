import 'dart:developer';
import 'dart:io';

import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_address.dart';
import 'package:ams/feature/presentation/pages/profile/widget/file_uploader.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // Text controllers
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

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profile = profilecontroller.profile.first;

    // Initialize controllers with profile data
    fullNameController.text = profile.username;
    emailController.text = profile.email;
    genderController.text = _mapGender(profile.gender);
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

  Future<void> _submitUserInfo() async {
    // Validate required fields
    if (fullNameController.text.isEmpty ||
        dobController.text.isEmpty ||
        phoneController.text.isEmpty ||
        genderController.text.isEmpty ||
        skillsController.text.isEmpty) {
      SSnackbarUtil.showSnackbar(
        'Validation Error',
        'Failed to update profile,\nPlease fill the required fields',
        SnackbarType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final genderCode = _mapGenderToCode(genderController.text);
      await Future.delayed(const Duration(seconds: 1));

      await profilecontroller.postProfileUpdate(
        id: profilecontroller.profile.first.id,
        profileID: authcontroller.alluserData.value.user?.profileId ??
            profilecontroller.profile.first.id,
        profileImage: _profileImage,
        username: fullNameController.text,
        dob: dobController.text,
        phonenumber: phoneController.text,
        gender: genderCode,
        joinedDate: joinedDateController.text,
        // skills: skillsController.text.split(",").map((s) => s.trim()).toList(),

        skills: skillsController.text
            .split(",")
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        resume: _resume,
      );

      Get.to(() => const EditUserAddress());
    } catch (e) {
      print("Error in _submitUserInfo: $e");
    } finally {
      setState(() {
        _isLoading = false;
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

  Widget _buildDateField(
      String title, TextEditingController controller, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: true, // Make the field read-only
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          labelStyle: smallStyle.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black54),
          suffixIcon: const Icon(Icons.calendar_today), // Add calendar icon
        ),
        style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black),
        onTap: () =>
            _selectDate(context, controller), // Show date picker on tap
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(controller.text)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // This adds theming to the date picker
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontSize: 14),
              bodyLarge: TextStyle(fontSize: 12),
              bodyMedium: TextStyle(fontSize: 10),
            ),
            colorScheme: Theme.of(context).brightness == Brightness.dark
                ? ColorScheme.dark(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    surface: Colors.grey[800]!,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: normalStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          )),
    );
  }

  Widget _buildTextField(
      String title, TextEditingController controller, bool isDarkMode,
      {bool enabled = true, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          labelStyle: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black),
          filled: !enabled,
          fillColor: !enabled
              ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
              : null,
        ),
        style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    final profile = profilecontroller.profile.first;

    return Row(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: isDarkMode ? AppColors.white : AppColors.black,
                width: 2),
            image: DecorationImage(
              image: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (profile.profileImage.isNotEmpty
                      ? NetworkImage(profile.profileImage) as ImageProvider
                      : const AssetImage(AppImages.profileImage)),
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
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Profile Picture",
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResumeSection(bool isDarkMode) {
    final profile = profilecontroller.profile.first;

    if (profile.resume != null && profile.resume.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Uploaded Resume", isDarkMode),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _openResumeFile(profile.resume),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.file_present),
                  color: isDarkMode ? Colors.white : Colors.blue.shade800,
                  onPressed: () => _openResumeFile(profile.resume),
                ),
                Expanded(
                  child: Text(
                    profile.resume,
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.blue.shade800,
                      // decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else {
      return Column(
        children: [
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
          const SizedBox(height: 16),
        ],
      );
    }
  }

// Add this method to your class to handle file opening
  void _openResumeFile(String urlString) async {
    try {
      // Ensure URL has proper formatting
      if (!urlString.startsWith('http://') &&
          !urlString.startsWith('https://')) {
        urlString = 'https://$urlString';
      }

      final Uri url = Uri.parse(urlString);

      // Attempt to open URL
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      print("Error opening resume: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'Could not open the document',
        SnackbarType.error,
      );
    }
  }

  Widget _buildNextButton(bool isDarkMode) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitUserInfo,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.blueAccent : Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Next",
                style: smallStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
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
                child: Obx(() {
                  return Column(
                    children: [
                      _buildProfileHeader(isDarkMode),
                      const SizedBox(height: 24),
                      _buildTextField(
                          "Full Name", fullNameController, isDarkMode),
                      _buildTextField("Email", emailController, isDarkMode,
                          enabled: false),
                      _buildTextField("Gender", genderController, isDarkMode),
                      _buildTextField(
                        "Contact Number",
                        phoneController,
                        isDarkMode,
                        keyboardType: const TextInputType.numberWithOptions(),
                      ),
                      _buildTextField(
                          "Designation", designationController, isDarkMode,
                          enabled: false),
                      _buildTextField("Skills", skillsController, isDarkMode),
                      _buildDateField(
                          "Date of Birth", dobController, isDarkMode),
                      _buildTextField(
                          "Joined Date", joinedDateController, isDarkMode,
                          enabled: false),
                      const SizedBox(height: 15),
                      _buildResumeSection(isDarkMode),
                      const SizedBox(height: 16),
                      _buildNextButton(isDarkMode),
                    ],
                  );
                }),
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
