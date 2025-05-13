import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_document.dart';
import 'package:ams/feature/presentation/pages/profile/widget/country_dropdown.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
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
  final ProfileController profileController = Get.put(ProfileController());

  // Text controllers
  final TextEditingController countryNameController = TextEditingController();
  final TextEditingController countryIdController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressLineOneController =
      TextEditingController();
  final TextEditingController addressLineTwoController =
      TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final TextEditingController currentCountryNameController =
      TextEditingController();
  final TextEditingController currentCountryIdController =
      TextEditingController();
  final TextEditingController currentProvinceController =
      TextEditingController();
  final TextEditingController currentCityController = TextEditingController();
  final TextEditingController currentAddressLineOneController =
      TextEditingController();
  final TextEditingController currentAddressLineTwoController =
      TextEditingController();
  final TextEditingController currentZipController = TextEditingController();

  // Error state for each field
  final Map<String, String> _fieldErrors = {};

  String? _originalCurrentCountryName;
  String? _originalCurrentCountryId;
  String? _originalCurrentProvince;
  String? _originalCurrentCity;
  String? _originalCurrentAddressLineOne;
  String? _originalCurrentAddressLineTwo;
  String? _originalCurrentZip;

  int? permanentAddressId;
  int? currentAddressId;

  late final dynamic currentAddr;
  late final dynamic permanentAddr;

  @override
  void initState() {
    super.initState();
    _initializeAddress();
    profileController.getcountryList();

    currentAddr = profileController.profile.first.addresses
        ?.firstWhereOrNull((a) => a.addressType == "current");
    permanentAddr = profileController.profile.first.addresses
        ?.firstWhereOrNull((a) => a.addressType == "permanent");

    if (currentAddr != null && permanentAddr != null) {
      bool sameAddress = currentAddr.country?.id == permanentAddr.country?.id &&
          currentAddr.province == permanentAddr.province &&
          currentAddr.city == permanentAddr.city &&
          currentAddr.addressLineOne == permanentAddr.addressLineOne &&
          currentAddr.addressLineTwo == permanentAddr.addressLineTwo &&
          currentAddr.postalCode == permanentAddr.postalCode;

      profileController.isSameAsPermanent.value = sameAddress;
    } else {
      profileController.isSameAsPermanent.value = false;
    }
  }

  void _initializeAddress() {
    final profileData = profileController.profile;
    if (profileData.isNotEmpty) {
      final permanentAddress = profileData.first.addresses
          ?.firstWhereOrNull((a) => a.addressType == "permanent");
      final currentAddress = profileData.first.addresses
          ?.firstWhereOrNull((a) => a.addressType == "current");

      if (permanentAddress != null) {
        permanentAddressId = permanentAddress.id;
        countryNameController.text = permanentAddress.country?.name ?? "";
        countryIdController.text =
            permanentAddress.country?.id?.toString() ?? "";
        provinceController.text = permanentAddress.province ?? "";
        cityController.text = permanentAddress.city ?? "";
        addressLineOneController.text = permanentAddress.addressLineOne ?? "";
        addressLineTwoController.text = permanentAddress.addressLineTwo ?? "";
        zipController.text = permanentAddress.postalCode ?? "";
      }

      if (currentAddress != null) {
        currentAddressId = currentAddress.id;
        currentCountryNameController.text = currentAddress.country?.name ?? "";
        currentCountryIdController.text =
            currentAddress.country?.id?.toString() ?? "";
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
      _originalCurrentCountryName = currentCountryNameController.text;
      _originalCurrentCountryId = currentCountryIdController.text;
      _originalCurrentProvince = currentProvinceController.text;
      _originalCurrentCity = currentCityController.text;
      _originalCurrentAddressLineOne = currentAddressLineOneController.text;
      _originalCurrentAddressLineTwo = currentAddressLineTwoController.text;
      _originalCurrentZip = currentZipController.text;

      currentCountryNameController.text = countryNameController.text;
      currentCountryIdController.text = countryIdController.text;
      currentProvinceController.text = provinceController.text;
      currentCityController.text = cityController.text;
      currentAddressLineOneController.text = addressLineOneController.text;
      currentAddressLineTwoController.text = addressLineTwoController.text;
      currentZipController.text = zipController.text;

      setState(() {
        _fieldErrors.clear(); // Clear errors when copying
      });
    } else {
      currentCountryNameController.text = _originalCurrentCountryName ?? "";
      currentCountryIdController.text = _originalCurrentCountryId ?? "";
      currentProvinceController.text = _originalCurrentProvince ?? "";
      currentCityController.text = _originalCurrentCity ?? "";
      currentAddressLineOneController.text =
          _originalCurrentAddressLineOne ?? "";
      currentAddressLineTwoController.text =
          _originalCurrentAddressLineTwo ?? "";
      currentZipController.text = _originalCurrentZip ?? "";

      setState(() {
        _fieldErrors.clear(); // Clear errors when restoring
      });
    }
  }

  bool _validateInputs() {
    setState(() {
      _fieldErrors.clear();
    });

    bool isValid = true;

    // Validate permanent address fields
    if (countryIdController.text.isEmpty) {
      _fieldErrors['permanentCountry'] = 'Country is required';
      isValid = false;
    }
    if (provinceController.text.isEmpty) {
      _fieldErrors['permanentProvince'] = 'Province is required';
      isValid = false;
    }
    if (cityController.text.isEmpty) {
      _fieldErrors['permanentCity'] = 'City is required';
      isValid = false;
    }
    if (addressLineOneController.text.isEmpty) {
      _fieldErrors['permanentAddressLineOne'] = 'Address Line 1 is required';
      isValid = false;
    }
    if (zipController.text.isEmpty) {
      _fieldErrors['permanentZip'] = 'Zip Code is required';
      isValid = false;
    } else if (!_isValidZipCode(zipController.text)) {
      _fieldErrors['permanentZip'] = 'Enter a valid zip code';
      isValid = false;
    }

    // Validate current address fields if not same as permanent
    if (!profileController.isSameAsPermanent.value) {
      if (currentCountryIdController.text.isEmpty) {
        _fieldErrors['currentCountry'] = 'Country is required';
        isValid = false;
      }
      if (currentProvinceController.text.isEmpty) {
        _fieldErrors['currentProvince'] = 'Province is required';
        isValid = false;
      }
      if (currentCityController.text.isEmpty) {
        _fieldErrors['currentCity'] = 'City is required';
        isValid = false;
      }
      if (currentAddressLineOneController.text.isEmpty) {
        _fieldErrors['currentAddressLineOne'] = 'Address Line 1 is required';
        isValid = false;
      }
      if (currentZipController.text.isEmpty) {
        _fieldErrors['currentZip'] = 'Zip Code is required ';
        isValid = false;
      } else if (!_isValidZipCode(currentZipController.text)) {
        _fieldErrors['currentZip'] = 'Enter a valid zip code';
        isValid = false;
      }
    }

    if (!isValid) {
      // SSnackbarUtil.showSnackbar(
      //   'Error',
      //   'Please fill out all required fields correctly',
      //   SnackbarType.error,
      // );
    }

    return isValid;
  }

  bool _isValidZipCode(String zip) {
    // Basic zip code validation (e.g., at least 4 digits)
    return zip.length >= 4 && RegExp(r'^\d+$').hasMatch(zip);
  }

  Future<void> _submitUserAddress() async {
    try {
      final userId = profileController.profile.first.id;

      int permanentCountryId = int.tryParse(countryIdController.text) ?? 1;
      int currentCountryId = int.tryParse(currentCountryIdController.text) ?? 1;

      if (permanentAddressId != null) {
        await profileController.postuserAddress(
          id: userId,
          addressID: permanentAddressId!,
          country: permanentCountryId.toString(),
          province: provinceController.text,
          city: cityController.text,
          addressLineOne: addressLineOneController.text,
          addressLineTwo: addressLineTwoController.text,
          zipcode: zipController.text,
          addressType: "permanent",
        );
      } else {
        await profileController.postnewuserAddress(
          userID: userId,
          issuedCountry: permanentCountryId,
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
          country: currentCountryId.toString(),
          province: currentProvinceController.text,
          city: currentCityController.text,
          addressLineOne: currentAddressLineOneController.text,
          addressLineTwo: currentAddressLineTwoController.text,
          zipcode: currentZipController.text,
          addressType: "current",
        );
      } else {
        await profileController.postnewuserAddress(
          userID: userId,
          issuedCountry: currentCountryId,
          province: currentProvinceController.text,
          city: currentCityController.text,
          addressLineOne: currentAddressLineOneController.text,
          addressLineTwo: currentAddressLineTwoController.text,
          zipcode: currentZipController.text,
          addressType: "current",
        );
      }

      Get.back();
      Get.to(() => const EditUserDocument());
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print("Error submitting address: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
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
  }

  void _onPreviousPressed() {
    Get.back();
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
    required String fieldKey,
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

  Widget _buildAddressSection(String title, IconData icon, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: normalStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
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

  List<Widget> _buildPermanentAddressFields(bool isDarkMode) {
    return [
      CountryDropdown(
        valueId: countryIdController.text,
        valueName: countryNameController.text,
        onChanged: (CountryData? data) {
          if (data != null) {
            print(
                "Permanent country selected: ID=${data.id}, Name=${data.name}");
            setState(() {
              countryIdController.text = data.id.toString();
              countryNameController.text = data.name;
              _fieldErrors.remove('permanentCountry');
              if (profileController.isSameAsPermanent.value) {
                currentCountryIdController.text = data.id.toString();
                currentCountryNameController.text = data.name;
                _fieldErrors.remove('currentCountry');
              }
            });
          }
        },
        isDarkMode: isDarkMode,
      ),
      _buildTextField("Province", provinceController, isDarkMode,
          fieldKey: 'permanentProvince'),
      _buildTextField("City", cityController, isDarkMode,
          fieldKey: 'permanentCity'),
      _buildTextField("Address Line 1", addressLineOneController, isDarkMode,
          fieldKey: 'permanentAddressLineOne'),
      _buildTextField("Address Line 2", addressLineTwoController, isDarkMode,
          fieldKey: 'permanentAddressLineTwo'),
      _buildTextField(
        "Zip Code",
        zipController,
        isDarkMode,
        keyboardType: const TextInputType.numberWithOptions(),
        fieldKey: 'permanentZip',
      ),
    ];
  }

  List<Widget> _buildCurrentAddressFields(bool isDarkMode) {
    return [
      _buildAddressSection("Current Address", Icons.location_on, isDarkMode),
      const SizedBox(height: 15.0),
      CountryDropdown(
        valueId: currentCountryIdController.text,
        valueName: currentCountryNameController.text,
        onChanged: (CountryData? data) {
          if (data != null) {
            print("Current country selected: ID=${data.id}, Name=${data.name}");
            setState(() {
              currentCountryIdController.text = data.id.toString();
              currentCountryNameController.text = data.name;
              _fieldErrors.remove('currentCountry');
            });
          }
        },
        isDarkMode: isDarkMode,
      ),
      _buildTextField("Province", currentProvinceController, isDarkMode,
          fieldKey: 'currentProvince'),
      _buildTextField("City", currentCityController, isDarkMode,
          fieldKey: 'currentCity'),
      _buildTextField(
          "Address Line 1", currentAddressLineOneController, isDarkMode,
          fieldKey: 'currentAddressLineOne'),
      _buildTextField(
          "Address Line 2", currentAddressLineTwoController, isDarkMode,
          fieldKey: 'currentAddressLineTwo'),
      _buildTextField(
        "Zip Code",
        currentZipController,
        isDarkMode,
        keyboardType: const TextInputType.numberWithOptions(),
        fieldKey: 'currentZip',
      ),
    ];
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
                  _buildAddressSection(
                      "Permanent Address", Icons.location_on, isDarkMode),
                  const SizedBox(height: 16),
                  ..._buildPermanentAddressFields(isDarkMode),
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
}
