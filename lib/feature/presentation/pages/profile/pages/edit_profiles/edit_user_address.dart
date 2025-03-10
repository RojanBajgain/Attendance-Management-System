import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_document.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';

class EditUserAddress extends StatefulWidget {
  final String? profileId;

  const EditUserAddress({super.key, this.profileId});

  @override
  State<EditUserAddress> createState() => _EditUserAddressState();
}

class _EditUserAddressState extends State<EditUserAddress> {
  final authcontroller = Get.find<AuthController>();

  final ProfileController profileController =
      Get.put(ProfileController(profileRepo: Get.find()));

  final TextEditingController countryController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressLineOneController =
      TextEditingController();
  final TextEditingController addressLineTwoController =
      TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final TextEditingController currentCountryController =
      TextEditingController();
  final TextEditingController currentProvinceController =
      TextEditingController();
  final TextEditingController currentCityController = TextEditingController();
  final TextEditingController currentAddressLineOneController =
      TextEditingController();
  final TextEditingController currentAddressLineTwoController =
      TextEditingController();
  final TextEditingController currentZipController = TextEditingController();

  // Temporary variables to store original current address data
  String? _originalCurrentCountry;
  String? _originalCurrentProvince;
  String? _originalCurrentCity;
  String? _originalCurrentAddressLineOne;
  String? _originalCurrentAddressLineTwo;
  String? _originalCurrentZip;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAddress());
  }

  int? permanentAddressId;
  int? currentAddressId;

  void _initializeAddress() {
    final profileData = profileController.profile;
    if (profileData.isNotEmpty) {
      final permanentAddress = profileData.first.addresses
          ?.firstWhereOrNull((a) => a.addressType == "permanent");
      final currentAddress = profileData.first.addresses
          ?.firstWhereOrNull((a) => a.addressType == "current");

      if (permanentAddress != null) {
        permanentAddressId = permanentAddress.id;
        countryController.text = permanentAddress.country?.name ?? "";
        provinceController.text = permanentAddress.province ?? "";
        cityController.text = permanentAddress.city ?? "";
        addressLineOneController.text = permanentAddress.addressLineOne ?? "";
        addressLineTwoController.text = permanentAddress.addressLineTwo ?? "";
        zipController.text = permanentAddress.postalCode ?? "";
      }

      if (currentAddress != null) {
        currentAddressId = currentAddress.id;
        currentCountryController.text = currentAddress.country?.name ?? "";
        currentProvinceController.text = currentAddress.province ?? "";
        currentCityController.text = currentAddress.city ?? "";
        currentAddressLineOneController.text =
            currentAddress.addressLineOne ?? "";
        currentAddressLineTwoController.text =
            currentAddress.addressLineTwo ?? "";
        currentZipController.text = currentAddress.postalCode ?? "";
      }
    }
  }

  void _copyPermanentToCurrent(bool isChecked) {
    if (isChecked) {
      // Store the original current address data
      _originalCurrentCountry = currentCountryController.text;
      _originalCurrentProvince = currentProvinceController.text;
      _originalCurrentCity = currentCityController.text;
      _originalCurrentAddressLineOne = currentAddressLineOneController.text;
      _originalCurrentAddressLineTwo = currentAddressLineTwoController.text;
      _originalCurrentZip = currentZipController.text;

      // Copy permanent address data to current address fields
      currentCountryController.text = countryController.text;
      currentProvinceController.text = provinceController.text;
      currentCityController.text = cityController.text;
      currentAddressLineOneController.text = addressLineOneController.text;
      currentAddressLineTwoController.text = addressLineTwoController.text;
      currentZipController.text = zipController.text;
    } else {
      // Restore the original current address data
      currentCountryController.text = _originalCurrentCountry ?? "";
      currentProvinceController.text = _originalCurrentProvince ?? "";
      currentCityController.text = _originalCurrentCity ?? "";
      currentAddressLineOneController.text =
          _originalCurrentAddressLineOne ?? "";
      currentAddressLineTwoController.text =
          _originalCurrentAddressLineTwo ?? "";
      currentZipController.text = _originalCurrentZip ?? "";
    }
  }

  Future<void> _submitUserAddress() async {
    try {
      final userId = profileController.profile.first.id;

      // Submit Permanent Address
      if (permanentAddressId != null) {
        await profileController.postuserAddress(
          id: userId,
          addressID: permanentAddressId!,
          country: countryController.text,
          province: provinceController.text,
          city: cityController.text,
          addressLineOne: addressLineOneController.text,
          addressLineTwo: addressLineTwoController.text,
          zipcode: zipController.text,
          addressType: "permanent",
        );
      }

      if (currentAddressId != null) {
        await profileController.postuserAddress(
          id: userId,
          addressID: currentAddressId!,
          country: currentCountryController.text,
          province: currentProvinceController.text,
          city: currentCityController.text,
          addressLineOne: currentAddressLineOneController.text,
          addressLineTwo: currentAddressLineTwoController.text,
          zipcode: currentZipController.text,
          addressType: "current",
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  bool _validateInputs() {
    if (countryController.text.isEmpty ||
        provinceController.text.isEmpty ||
        cityController.text.isEmpty ||
        addressLineOneController.text.isEmpty ||
        zipController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill out all required fields',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }
    return true;
  }

  void _onNextPressed() async {
    if (!_validateInputs()) return;

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    await _submitUserAddress();

    // Get.back();
    Get.to(() => const EditUserDocument());
  }

  void _onPreviousPressed() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit User Address Detail",
          style: smallStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildAddressSection("Permanent Address", isDarkMode),
                  ..._buildTextFields(isDarkMode),
                  _buildSameAsPermanentCheckbox(isDarkMode),
                  Obx(() {
                    if (!profileController.isSameAsPermanent.value) {
                      return Column(
                        children: _buildCurrentAddressFields(isDarkMode),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
            _buildBottomButtons(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(String title, bool isDarkMode) {
    return Row(
      children: [
        const Icon(Icons.location_on),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: normalStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTextFields(bool isDarkMode) {
    return [
      const SizedBox(height: 24),
      _inputTextField("Country", countryController),
      _inputTextField("Province", provinceController),
      _inputTextField("City", cityController),
      _inputTextField("Address Line 1", addressLineOneController),
      _inputTextField("Address Line 2", addressLineTwoController),
      _inputTextField("Zip Code", zipController),
    ];
  }

  List<Widget> _buildCurrentAddressFields(bool isDarkMode) {
    return [
      _buildAddressSection("Current Address", isDarkMode),
      const SizedBox(height: 15.0),
      _inputTextField("Country", currentCountryController),
      _inputTextField("Province", currentProvinceController),
      _inputTextField("City", currentCityController),
      _inputTextField("Address Line 1", currentAddressLineOneController),
      _inputTextField("Address Line 2", currentAddressLineTwoController),
      _inputTextField("Zip Code", currentZipController),
    ];
  }

  Widget _buildSameAsPermanentCheckbox(bool isDarkMode) {
    return Obx(
      () => CheckboxListTile(
        value: profileController.isSameAsPermanent.value,
        onChanged: (value) {
          final isChecked = value!;
          profileController.isSameAsPermanent.value = isChecked;
          _copyPermanentToCurrent(isChecked);
        },
        title: Text(
          "Same as Permanent Address",
          style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _inputTextField(String title, TextEditingController controller) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
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
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 1,
                  color: isDarkMode ? Colors.white70 : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _onPreviousPressed,
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
                const Icon(Icons.arrow_back, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  "Previous",
                  style: smallStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _onNextPressed,
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
                const Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
