import 'dart:developer';
import 'dart:io';

import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_address.dart';
import 'package:ams/feature/presentation/pages/profile/widget/file_uploader.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

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
  final ProfileController profilecontroller = Get.put(ProfileController());

  // Text controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController joinedDateController = TextEditingController();

  // Error state for each field
  final Map<String, String> _fieldErrors = {};

  File? _profileImage;
  File? _resume;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profile = profilecontroller.profile.isNotEmpty
        ? profilecontroller.profile.first
        : null;

    if (profile != null) {
      log('Raw profile gender from backend: ${profile.gender}');
      fullNameController.text = profile.user.fullName;
      emailController.text = profile.email;
      genderController.text = _mapGender(profile.gender);
      phoneController.text = profile.phoneNumber;
      designationController.text =
          profile.designation.name.isNotEmpty ? profile.designation.name : "";
      skillsController.text = profile.skills.join(", ");
      dobController.text = profile.dob != null
          ? DateFormat('yyyy-MM-dd').format(profile.dob)
          : "";
      joinedDateController.text = profile.joinedDate != null
          ? DateFormat('yyyy-MM-dd').format(profile.joinedDate)
          : "";
    }
  }

  String _mapGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      log('Gender is null or empty, defaulting to empty');
      return "";
    }
    switch (gender.toUpperCase()) {
      case "M":
      case "MALE":
        return "Male";
      case "F":
      case "FEMALE":
        return "Female";
      case "O":
      case "OTHER":
        return "Other";
      default:
        log('Unknown gender value: $gender, defaulting to empty');
        return "";
    }
  }

  String _mapGenderToBackend(String gender) {
    switch (gender) {
      case "Male":
        return "M";
      case "Female":
        return "F";
      case "Other":
        return "O";
      default:
        log('Invalid gender for backend: $gender, defaulting to empty');
        return "";
    }
  }

  bool _validateFields() {
    setState(() {
      _fieldErrors.clear();
    });

    bool isValid = true;

    if (fullNameController.text.isEmpty) {
      _fieldErrors['fullName'] = 'Full name is required';
      isValid = false;
    }

    if (dobController.text.isEmpty) {
      _fieldErrors['dob'] = 'Date of birth is required';
      isValid = false;
    }

    if (phoneController.text.isEmpty) {
      _fieldErrors['phone'] = 'Phone number is required';
      isValid = false;
    } else if (!_isValidPhoneNumber(phoneController.text)) {
      _fieldErrors['phone'] = 'Phone number must be exactly 10 digits';
      isValid = false;
    }

    if (genderController.text.isEmpty) {
      _fieldErrors['gender'] = 'Gender is required';
      isValid = false;
    } else if (!['Male', 'Female', 'Other'].contains(genderController.text)) {
      _fieldErrors['gender'] = 'Gender must be Male, Female, or Other';
      isValid = false;
    }

    if (skillsController.text.isEmpty) {
      _fieldErrors['skills'] = 'At least one skill is required';
      isValid = false;
    }

    return isValid;
  }

  bool _isValidPhoneNumber(String phone) {
    return phone.length == 10 && int.tryParse(phone) != null;
  }

  Future<void> _submitUserInfo() async {
    if (!_validateFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profile = profilecontroller.profile.first;
      final genderToSend = _mapGenderToBackend(genderController.text);
      log('Sending gender to backend: $genderToSend');
      final response = await profilecontroller.postProfileUpdate(
        id: profile.id,
        profileID: authcontroller.alluserData.value.user ?? profile.id,
        profileImage: _profileImage,
        username: fullNameController.text,
        dob: dobController.text,
        phonenumber: phoneController.text,
        gender: genderToSend,
        joinedDate: joinedDateController.text,
        skills: skillsController.text
            .split(",")
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        resume: _resume,
      );

      Get.to(() => const EditUserAddress());
    } catch (e) {
      log('Error submitting user info: $e');
      SSnackbarUtil.showSnackbar(
        'Error',
        'Failed to update profile: $e',
        SnackbarType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      log("Picked file: ${result.files.single.name}");
    } else {
      log("No file picked");
    }
  }

  Widget _buildDateField(
    String title,
    TextEditingController controller,
    bool isDarkMode, {
    String fieldKey = '',
  }) {
    final hasError = _fieldErrors.containsKey(fieldKey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.blueAccent : Colors.black),
                  width: 2.0,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              labelStyle: smallStyle.copyWith(
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
              suffixIcon: Icon(Icons.calendar_today,
                  color: hasError ? Colors.red : null),
            ),
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onTap: () => _selectDate(context, controller),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                _fieldErrors[fieldKey]!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
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
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        if (_fieldErrors.containsKey('dob')) {
          _fieldErrors.remove('dob');
        }
      });
    }
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: normalStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String title,
    TextEditingController controller,
    bool isDarkMode, {
    bool enabled = true,
    TextInputType? keyboardType,
    String fieldKey = '',
  }) {
    final hasError = _fieldErrors.containsKey(fieldKey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.blueAccent : Colors.black),
                  width: 2.0,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              labelStyle: smallStyle.copyWith(
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
              filled: !enabled,
              fillColor: !enabled
                  ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
                  : null,
            ),
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onChanged: (value) {
              if (hasError) {
                setState(() {
                  _fieldErrors.remove(fieldKey);
                });
              }
            },
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                _fieldErrors[fieldKey]!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderField(
    String title,
    TextEditingController controller,
    bool isDarkMode, {
    String fieldKey = '',
  }) {
    final hasError = _fieldErrors.containsKey(fieldKey);
    const genderOptions = ['Male', 'Female', 'Other'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: genderOptions.contains(controller.text)
                ? controller.text
                : null,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.blueAccent : Colors.black),
                  width: 2.0,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              labelStyle: smallStyle.copyWith(
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
            ),
            items: genderOptions
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.text = value;
                if (hasError) {
                  setState(() {
                    _fieldErrors.remove(fieldKey);
                  });
                }
              }
            },
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            hint: Text(
              'Select Gender',
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                _fieldErrors[fieldKey]!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    final profile = profilecontroller.profile.isNotEmpty
        ? profilecontroller.profile.first
        : null;

    return Row(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode ? AppColors.white : AppColors.black,
              width: 2,
            ),
            image: DecorationImage(
              image: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (profile != null && profile.profileImage.isNotEmpty
                      ? NetworkImage(profile.profileImage) as ImageProvider
                      : const AssetImage(AppImages.EditprofileImage)),
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
    final profile = profilecontroller.profile.isNotEmpty
        ? profilecontroller.profile.first
        : null;

    if (profile != null &&
        profile.resume != null &&
        profile.resume!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Uploaded Resume", isDarkMode),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _openResumeFile(profile.resume!),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.file_present),
                  color: isDarkMode ? Colors.white : Colors.blue.shade800,
                  onPressed: () => _openResumeFile(profile.resume!),
                ),
                Expanded(
                  child: Text(
                    profile.resume!.split('/').last.isNotEmpty
                        ? profile.resume!.split('/').last
                        : 'Resume',
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.blue.shade800,
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

  void _openResumeFile(String urlString) async {
    try {
      if (!urlString.startsWith('http://') &&
          !urlString.startsWith('https://')) {
        urlString = 'https://$urlString';
      }

      final Uri url = Uri.parse(urlString);
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
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
                  if (profilecontroller.profile.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: [
                      _buildProfileHeader(isDarkMode),
                      const SizedBox(height: 24),
                      _buildTextField(
                        "Full Name",
                        fullNameController,
                        isDarkMode,
                        fieldKey: 'fullName',
                      ),
                      _buildTextField(
                        "Email",
                        emailController,
                        isDarkMode,
                        enabled: false,
                      ),
                      _buildGenderField(
                        "Gender",
                        genderController,
                        isDarkMode,
                        fieldKey: 'gender',
                      ),
                      _buildTextField(
                        "Contact Number",
                        phoneController,
                        isDarkMode,
                        keyboardType: const TextInputType.numberWithOptions(),
                        fieldKey: 'phone',
                      ),
                      _buildTextField(
                        "Designation",
                        designationController,
                        isDarkMode,
                        enabled: false,
                      ),
                      _buildTextField(
                        "Skills",
                        skillsController,
                        isDarkMode,
                        fieldKey: 'skills',
                      ),
                      _buildDateField(
                        "Date of Birth",
                        dobController,
                        isDarkMode,
                        fieldKey: 'dob',
                      ),
                      _buildTextField(
                        "Joined Date",
                        joinedDateController,
                        isDarkMode,
                        enabled: false,
                      ),
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
