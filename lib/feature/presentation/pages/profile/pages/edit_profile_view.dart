import 'dart:developer';
import 'dart:io';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/widget/file_uploader.dart';
import 'package:ams/feature/presentation/pages/profile/widget/image_uploader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../config/resources/colors.dart';
import '../../../../../config/resources/images.dart';
import '../../../../../config/resources/styles.dart';

class EditProfileView extends StatefulWidget {
  final String? profileId;

  const EditProfileView({
    super.key,
    required this.profileId,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final authcontroller = Get.find<AuthController>();
  final profilecontroller = Get.put(ProfileController(profileRepo: Get.find()));

  bool _isAddNewDocumentChecked = false;

  bool _isAddNewBankDetail = false;

  bool _isPayRoll = false;

  bool _isNewBankPayRoll = false;

  File? _profileImage;

  File? _resume;

  final PageController _pageController = PageController();
  int _currentPage = 0;

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

  void _nextPage() async {
    if (_currentPage == 0) {
      try {
        // Show loading indicator
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        // Call the update method and just assume it works unless an error occurs
        await profilecontroller.postProfileUpdate(
          dob: profilecontroller.profile.first.dob != null
              ? DateFormat('yyyy-MM-dd')
                  .format(profilecontroller.profile.first.dob!)
              : "",
          gender: profilecontroller.profile.first.gender ?? "",
          phonenumber: profilecontroller.profile.first.phoneNumber ?? "",
          joinedDate: profilecontroller.profile.first.joinedDate != null
              ? DateFormat('yyyy-MM-dd')
                  .format(profilecontroller.profile.first.joinedDate!)
              : "",
          profileImage: _profileImage, // Pass the File object
          resume: _resume, // Pass the File object
          skills: List.from(profilecontroller.profile.first.skills ?? []),
          username: profilecontroller.profile.first.username ?? "",
          id: profilecontroller.profile.first.id,
          // profileID: authcontroller.alluserData.value.user!.profileId,
          profileID: authcontroller.alluserData.value.user ??
              profilecontroller.profile.first.id,
        );

        // Hide loading indicator
        Get.back();

        // If no exception occurred, proceed to the next page
        _goToNextPage();
      } catch (e) {
        // Hide loading if an error occurs
        Get.back();
        _showError("An unexpected error occurred: $e");
      }
    } else if (_currentPage < 3) {
      _goToNextPage();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    setState(() {
      _currentPage++;
    });
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profilecontroller.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          title: Text(
            "Edit Profile",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildUserInfoPage(isDarkMode),
            _buildAddressPage(isDarkMode),
            _buildDocumentsPage(isDarkMode),
            _buildBankDetailsPage(isDarkMode),
          ],
        ),
        bottomNavigationBar: _buildNavigationButtons(),
      ),
    );
  }

  Widget _buildUserInfoPage(bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
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
                            color:
                                isDarkMode ? AppColors.white : AppColors.black,
                            width: 2),
                        image: DecorationImage(
                          image: _profileImage != null
                              ? FileImage(_profileImage!) // Selected image
                              : (profile.isNotEmpty &&
                                      profile.first.profileImage.isNotEmpty
                                  ? NetworkImage(profile.first.profileImage)
                                      as ImageProvider
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
                              color: isDarkMode
                                  ? AppColors.white
                                  : AppColors.black,
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
                    title: "Full Name", subTitle: profile.first.username),
                const SizedBox(height: 16),
                inputTextField(
                  title: "Email",
                  subTitle: profile.first.email,
                  enabled: false,
                ),
                const SizedBox(height: 16),
                inputTextField(
                  title: "Gender",
                  subTitle: _mapGender(profile
                      .first.gender), // Map the backend value to display value
                ),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Contact Number",
                    subTitle: profile.first.phoneNumber),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Designation",
                    subTitle: profile.first.designation!.name.toString(),
                    enabled: false),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Skills",
                    subTitle: profile.first.skills?.join(", ") ?? ""),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Date of Birth",
                    subTitle: profile.first.dob != null
                        ? DateFormat('yyyy-MM-dd').format(profile.first.dob!)
                        : ""),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Joined Date",
                    subTitle: profile.first.joinedDate != null
                        ? DateFormat('yyyy-MM-dd')
                            .format(profile.first.joinedDate!)
                        : "",
                    enabled: false),
                const SizedBox(height: 16),
                FileUploadField(
                  title: "Add Resume",
                  hintText: "---",
                  onFilePicked: (FilePickerResult? result) {
                    if (result != null) {
                      log("Picked file: ${result.files.single.name}");
                    } else {
                      log("No file picked");
                    }
                  },
                ),
              ],
            );
          })),
    );
  }

  Widget _buildAddressPage(bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final profileData = profilecontroller.profile;

          final permanentAddress = profileData.first.addresses!
              .firstWhere((address) => address.addressType == "permanent");
          final currentAddress = profileData.first.addresses!
              .firstWhere((address) => address.addressType == "current");

          return Column(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10.0),
                  Text(
                    "Permanent Address",
                    style: normalStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              inputTextField(
                title: "Country",
                subTitle: permanentAddress.country!.name.toString(),
              ),
              const SizedBox(height: 16),
              inputTextField(
                title: "Province",
                subTitle: permanentAddress.province.toString(),
              ),
              const SizedBox(height: 16),
              inputTextField(
                title: "City",
                subTitle: permanentAddress.city.toString(),
              ),
              const SizedBox(height: 16),
              inputTextField(
                title: "Address Line 1",
                subTitle: permanentAddress.addressLineOne.toString(),
              ),
              const SizedBox(height: 16),
              inputTextField(
                title: "Address Line 2",
                subTitle: permanentAddress.addressLineTwo.toString(),
              ),
              const SizedBox(height: 16),
              inputTextField(
                title: "Zip Code",
                subTitle: permanentAddress.postalCode.toString(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: profilecontroller.isSameAsPermanent.value,
                        onChanged: (value) {
                          profilecontroller.isSameAsPermanent.value = value!;
                        },
                      )),
                  Text(
                    "Same as Permanent Address",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!profilecontroller.isSameAsPermanent.value) ...[
                Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 10.0),
                    Text(
                      "Current Address",
                      style: normalStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                inputTextField(
                  title: "Country",
                  subTitle: currentAddress.country!.name.toString(),
                  enabled: true,
                ),
                const SizedBox(height: 16),
                inputTextField(
                  title: "Province",
                  subTitle: currentAddress.province.toString(),
                  enabled: true,
                ),
                const SizedBox(height: 16),
                inputTextField(
                  title: "City",
                  subTitle: currentAddress.city.toString(),
                  enabled: true,
                ),
                const SizedBox(height: 16),
                inputTextField(
                  title: "Address Line 1",
                  subTitle: currentAddress.addressLineOne.toString(),
                  enabled: true,
                ),
                const SizedBox(height: 16),
                inputTextField(
                  title: "Address Line 2",
                  subTitle: currentAddress.addressLineTwo.toString(),
                  enabled: true,
                ),
                const SizedBox(height: 16),
                inputTextField(
                  title: "Zip Code",
                  subTitle: currentAddress.postalCode.toString(),
                  enabled: true,
                ),
                const SizedBox(height: 24),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDocumentsPage(bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final profileData = profilecontroller.profile;

          // Predefined document types
          final predefinedDocumentTypes = [
            "PAN",
            "Citizenship",
            "Education",
            "Recommendation",
            "Others"
          ];

          // Extract user document types if available
          final documentTypes =
              profileData.isNotEmpty && profileData.first.documents != null
                  ? profileData.first.documents!
                      .map((document) => document.type ?? "N/A")
                      .toList()
                  : [];
          final finalDocumentTypes = documentTypes.isNotEmpty
              ? {...predefinedDocumentTypes, ...documentTypes}.toList()
              : predefinedDocumentTypes;

          return Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_calendar_outlined),
                  const SizedBox(width: 10.0),
                  Text(
                    "Edit Document",
                    style: normalStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type",
                    style: smallStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.0),
                      color: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: FormBuilderDropdown<String>(
                        name: 'document_type',
                        onChanged: (value) {
                          setState(() {});
                        },
                        hint: Text(
                          "Select",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        items: finalDocumentTypes
                            .map<DropdownMenuItem<String>>((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: smallStyle.copyWith(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              inputTextField(
                  title: "Title",
                  subTitle:
                      profileData.first.documents!.first.title.toString()),
              const SizedBox(height: 16),
              inputTextField(
                  title: "Issued Date",
                  subTitle:
                      profileData.first.documents!.first.issuedDate != null
                          ? DateFormat('yyyy-MM-dd').format(
                              profileData.first.documents!.first.issuedDate!)
                          : ""),
              const SizedBox(height: 16),
              ImageUploadField(
                title: "Upload Document Image",
                hintText: "Choose an image to upload",
                // currentImagePath: _currentImagePath, // If there's an existing image path
                onFilePicked: (FilePickerResult? result) {
                  if (result != null) {
                    setState(() {});
                  } else {
                    log("No file picked");
                  }
                },
              ),
              const SizedBox(height: 16),
              FileUploadField(
                title: "Add Document",
                hintText: "Choose a Document to Upload",
                onFilePicked: (FilePickerResult? result) {
                  if (result != null) {
                    setState(() {
// Store the picked file
                    });
                    log("Picked file: ${result.files.single.name}");
                  } else {
                    log("No file picked");
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isAddNewDocumentChecked,
                    onChanged: (value) {
                      setState(() {
                        _isAddNewDocumentChecked = value ?? false;
                      });
                    },
                  ),
                  Text(
                    "Add new Document",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              if (_isAddNewDocumentChecked) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type",
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade50,
                        border: Border.all(color: Colors.black, width: 1.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: FormBuilderDropdown<String>(
                          name: 'document_type',
                          onChanged: (value) {
                            setState(() {});
                          },
                          hint: Text(
                            "Select",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          items: finalDocumentTypes
                              .map<DropdownMenuItem<String>>((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: smallStyle.copyWith(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                inputTextField(title: "New Document Title", subTitle: ""),
                const SizedBox(height: 16),
                inputTextField(title: "New Document Issued Date", subTitle: ""),
                const SizedBox(height: 16),
                ImageUploadField(
                  title: "Upload Document Image",
                  hintText: "Choose an image to upload",
                  // currentImagePath: _currentImagePath, // If there's an existing image path
                  onFilePicked: (FilePickerResult? result) {
                    if (result != null) {
                      print("Picked file: ${result.files.single.name}");
                    } else {
                      print("No file picked");
                    }
                  },
                ),
                const SizedBox(height: 16),
                FileUploadField(
                  title: "Add Document",
                  hintText: "Choose a Document to Upload",
                  onFilePicked: (FilePickerResult? result) {
                    if (result != null) {
                      setState(() {});
                      log("Picked file: ${result.files.single.name}");
                    } else {
                      log("No file picked");
                    }
                  },
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBankDetailsPage(bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            final profiledata = profilecontroller.profile;

            return Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.edit_calendar_outlined),
                    SizedBox(width: 10.0),
                    Text(
                      "Edit Bank Details",
                      style: normalStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                inputTextField(
                    title: "Bank Name",
                    subTitle: profiledata.first.bankDetails!.first.bankName
                        .toString()),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Branch Name",
                    subTitle: profiledata.first.bankDetails!.first.bankBranch
                        .toString()),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Account Name",
                    subTitle: profiledata
                        .first.bankDetails!.first.bankAccountName
                        .toString()),
                const SizedBox(height: 16),
                inputTextField(
                    title: "Bank Account Number",
                    subTitle: profiledata.first.bankDetails!.first.bankAccount
                        .toString()),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isPayRoll,
                      onChanged: (value) {
                        setState(() {
                          _isPayRoll = value ?? false;
                        });
                      },
                    ),
                    Text(
                      "Is payroll",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isAddNewBankDetail,
                      onChanged: (value) {
                        setState(() {
                          _isAddNewBankDetail = value ?? false;
                        });
                      },
                    ),
                    Text(
                      "Add new Bank Account",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                if (_isAddNewBankDetail) ...[
                  inputTextField(title: "Bank Name", subTitle: ""),
                  const SizedBox(height: 16),
                  inputTextField(title: "Branch Name", subTitle: ""),
                  const SizedBox(height: 16),
                  inputTextField(title: "Account Name", subTitle: ""),
                  const SizedBox(height: 16),
                  inputTextField(title: "Bank Account Number", subTitle: ""),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _isNewBankPayRoll,
                        onChanged: (value) {
                          setState(() {
                            _isNewBankPayRoll = value ?? false;
                          });
                        },
                      ),
                      Text(
                        "Is payroll",
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Builder(builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1.5,
              color: isDarkMode ? Colors.black : Colors.grey.shade200,
            ),
          ),
          color: isDarkMode ? Colors.black : Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Previous",
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _currentPage < 3 ? _nextPage : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? Colors.grey.shade200 : Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentPage < 3 ? "Next" : "Save Changes",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget inputTextField({
    required String title,
    required String subTitle,
    bool enabled = true, // Add this parameter
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
            enabled: enabled, // Use the enabled parameter
            autofocus: false,
            obscureText: false,
            maxLines: 1,
            style: smallStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            initialValue: subTitle,
            decoration: InputDecoration(
              isDense: true,
              filled: !enabled,
              fillColor: !enabled
                  ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : const Color(0xffCCCCCC),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : const Color(0xffCCCCCC),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blueAccent
                      : const Color(0xffCCCCCC),
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
            onChanged: (newValue) {},
          ),
        ],
      );
    });
  }
}
