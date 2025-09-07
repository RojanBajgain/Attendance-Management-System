import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_document.dart';
import 'package:ams/feature/presentation/pages/profile/widget/country_dropdown.dart';
import 'package:ams/feature/presentation/pages/profile/widget/custom_textfield.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';

class EditUserAddress extends StatefulWidget {
  final String? profileId;

  const EditUserAddress({super.key, this.profileId});

  @override
  State<EditUserAddress> createState() => _EditUserAddressState();
}

class _EditUserAddressState extends State<EditUserAddress> {
  final authcontroller = Get.find<AuthController>();
  final profileController = Get.put(ProfileController(profileRepo: Get.find()));

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

  bool _isLoading = false;
  bool _hasChanges = false;
  Map<String, dynamic> _initialValues = {};

  @override
  void initState() {
    super.initState();
    _initializeAddress();
    profileController.getcountryList();

    final profileData = profileController.profile;
    if (profileData != null) {
      final currentAddr = profileData.value!.addresses!
          .firstWhereOrNull((a) => a.addressType == "current");
      final permanentAddr = profileData.value!.addresses!
          .firstWhereOrNull((a) => a.addressType == "permanent");

      if (currentAddr != null && permanentAddr != null) {
        bool sameAddress =
            currentAddr.country!.id == permanentAddr.country!.id &&
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _storeInitialValues();
    });
  }

  void _storeInitialValues() {
    setState(() {
      _initialValues = {
        'permanentCountry': countryIdController.text,
        'permanentProvince': provinceController.text,
        'permanentCity': cityController.text,
        'permanentAddressLineOne': addressLineOneController.text,
        'permanentAddressLineTwo': addressLineTwoController.text,
        'permanentZip': zipController.text,
        'currentCountry': currentCountryIdController.text,
        'currentProvince': currentProvinceController.text,
        'currentCity': currentCityController.text,
        'currentAddressLineOne': currentAddressLineOneController.text,
        'currentAddressLineTwo': currentAddressLineTwoController.text,
        'currentZip': currentZipController.text,
        'isSameAsPermanent': profileController.isSameAsPermanent.value,
      };
    });
  }

  void _checkForChanges() {
    final currentValues = {
      'permanentCountry': countryIdController.text,
      'permanentProvince': provinceController.text,
      'permanentCity': cityController.text,
      'permanentAddressLineOne': addressLineOneController.text,
      'permanentAddressLineTwo': addressLineTwoController.text,
      'permanentZip': zipController.text,
      'currentCountry': currentCountryIdController.text,
      'currentProvince': currentProvinceController.text,
      'currentCity': currentCityController.text,
      'currentAddressLineOne': currentAddressLineOneController.text,
      'currentAddressLineTwo': currentAddressLineTwoController.text,
      'currentZip': currentZipController.text,
      'isSameAsPermanent': profileController.isSameAsPermanent.value,
    };

    setState(() {
      _hasChanges = !mapEquals(_initialValues, currentValues);
    });
  }

  void _initializeAddress() {
    final profileData = profileController.profile;
    if (profileData.value!.addresses != null) {
      // Handle permanent address
      final permanentAddress = profileData.value!.addresses!
          .firstWhereOrNull((a) => a.addressType == "permanent");

      if (permanentAddress != null) {
        permanentAddressId = permanentAddress.id;
        countryNameController.text = permanentAddress.country!.name;
        countryIdController.text = permanentAddress.country!.id.toString();
        provinceController.text = permanentAddress.province;
        cityController.text = permanentAddress.city;
        addressLineOneController.text = permanentAddress.addressLineOne;
        addressLineTwoController.text = permanentAddress.addressLineTwo;
        zipController.text = permanentAddress.postalCode;
      }

      // Handle current address
      final currentAddress = profileData.value!.addresses!
          .firstWhereOrNull((a) => a.addressType == "current");

      if (currentAddress != null) {
        currentAddressId = currentAddress.id;
        currentCountryNameController.text = currentAddress.country!.name;
        currentCountryIdController.text = currentAddress.country!.id.toString();
        currentProvinceController.text = currentAddress.province;
        currentCityController.text = currentAddress.city;
        currentAddressLineOneController.text = currentAddress.addressLineOne;
        currentAddressLineTwoController.text = currentAddress.addressLineTwo;
        currentZipController.text = currentAddress.postalCode;
      }
    }
  }

  void _copyPermanentToCurrent(bool isChecked) {
    if (isChecked) {
      // Save original values
      _originalCurrentCountryName = currentCountryNameController.text;
      _originalCurrentCountryId = currentCountryIdController.text;
      _originalCurrentProvince = currentProvinceController.text;
      _originalCurrentCity = currentCityController.text;
      _originalCurrentAddressLineOne = currentAddressLineOneController.text;
      _originalCurrentAddressLineTwo = currentAddressLineTwoController.text;
      _originalCurrentZip = currentZipController.text;

      // Copy permanent values to current
      currentCountryNameController.text = countryNameController.text;
      currentCountryIdController.text = countryIdController.text;
      currentProvinceController.text = provinceController.text;
      currentCityController.text = cityController.text;
      currentAddressLineOneController.text = addressLineOneController.text;
      currentAddressLineTwoController.text = addressLineTwoController.text;
      currentZipController.text = zipController.text;
    } else {
      // Restore original values
      currentCountryNameController.text = _originalCurrentCountryName ?? "";
      currentCountryIdController.text = _originalCurrentCountryId ?? "";
      currentProvinceController.text = _originalCurrentProvince ?? "";
      currentCityController.text = _originalCurrentCity ?? "";
      currentAddressLineOneController.text =
          _originalCurrentAddressLineOne ?? "";
      currentAddressLineTwoController.text =
          _originalCurrentAddressLineTwo ?? "";
      currentZipController.text = _originalCurrentZip ?? "";
    }

    setState(() {
      _fieldErrors.clear();
    });

    _checkForChanges();
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
    // if (addressLineTwoController.text.isEmpty) {
    //   _fieldErrors['permanentAddressLineTwo'] = 'Address Line 2 is required';
    //   isValid = false;
    // }
    // if (zipController.text.isEmpty) {
    //   _fieldErrors['permanentZip'] = 'Zip Code is required';
    //   isValid = false;
    // }
    //else if (!_isValidZipCode(zipController.text)) {
    //   _fieldErrors['permanentZip'] = 'Enter a valid zip code';
    //   isValid = false;
    // }

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
      // if (currentAddressLineTwoController.text.isEmpty) {
      //   _fieldErrors['currentAddressLineTwo'] = 'Address Line 2 is required';
      //   isValid = false;
      // }
      // if (currentZipController.text.isEmpty) {
      //   _fieldErrors['currentZip'] = 'Zip Code is required ';
      //   isValid = false;
      // }
      // else if (!_isValidZipCode(currentZipController.text)) {
      //   _fieldErrors['currentZip'] = 'Enter a valid zip code';
      //   isValid = false;
      // }
    }

    return isValid;
  }

  bool _isValidZipCode(String zip) {
    // Basic zip code validation (e.g., at least 4 digits)
    return zip.length >= 4 && RegExp(r'^\d+$').hasMatch(zip);
  }

  // In EditUserAddress class - Update the _submitUserAddress method

  Future<void> _submitUserAddress({bool navigateToNext = false}) async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = profileController.profile.value!.id;
      int permanentCountryId = int.tryParse(countryIdController.text) ?? 1;

      // Helper function to handle empty strings
      String processOptionalField(String value) {
        return value.trim().isEmpty ? "" : value.trim();
      }

      // Update or create permanent address
      if (permanentAddressId != null) {
        await profileController.postuserAddress(
          id: userId,
          addressID: permanentAddressId!,
          country: permanentCountryId.toString(),
          province: provinceController.text.trim(),
          city: cityController.text.trim(),
          addressLineOne: addressLineOneController.text.trim(),
          addressLineTwo: processOptionalField(addressLineTwoController.text),
          zipcode: processOptionalField(zipController.text),
          addressType: "permanent",
        );
      } else {
        await profileController.postnewuserAddress(
          profileID: userId,
          issuedCountry: permanentCountryId,
          province: provinceController.text.trim(),
          city: cityController.text.trim(),
          addressLineOne: addressLineOneController.text.trim(),
          addressLineTwo: processOptionalField(addressLineTwoController.text),
          zipcode: processOptionalField(zipController.text),
          addressType: "permanent",
        );
      }

      // Handle current address based on checkbox state
      if (profileController.isSameAsPermanent.value) {
        // If "Same as Permanent" is checked, use permanent address values for current address
        if (currentAddressId != null) {
          await profileController.postuserAddress(
            id: userId,
            addressID: currentAddressId!,
            country: permanentCountryId.toString(),
            province: provinceController.text.trim(),
            city: cityController.text.trim(),
            addressLineOne: addressLineOneController.text.trim(),
            addressLineTwo: processOptionalField(addressLineTwoController.text),
            zipcode: processOptionalField(zipController.text),
            addressType: "current",
          );
        } else {
          await profileController.postnewuserAddress(
            profileID: userId,
            issuedCountry: permanentCountryId,
            province: provinceController.text.trim(),
            city: cityController.text.trim(),
            addressLineOne: addressLineOneController.text.trim(),
            addressLineTwo: processOptionalField(addressLineTwoController.text),
            zipcode: processOptionalField(zipController.text),
            addressType: "current",
          );
        }
      } else {
        // If not checked, use the current address values
        int currentCountryId =
            int.tryParse(currentCountryIdController.text) ?? 1;

        if (currentAddressId != null) {
          await profileController.postuserAddress(
            id: userId,
            addressID: currentAddressId!,
            country: currentCountryId.toString(),
            province: currentProvinceController.text.trim(),
            city: currentCityController.text.trim(),
            addressLineOne: currentAddressLineOneController.text.trim(),
            addressLineTwo:
                processOptionalField(currentAddressLineTwoController.text),
            zipcode: processOptionalField(currentZipController.text),
            addressType: "current",
          );
        } else {
          await profileController.postnewuserAddress(
            profileID: userId,
            issuedCountry: currentCountryId,
            province: currentProvinceController.text.trim(),
            city: currentCityController.text.trim(),
            addressLineOne: currentAddressLineOneController.text.trim(),
            addressLineTwo:
                processOptionalField(currentAddressLineTwoController.text),
            zipcode: processOptionalField(currentZipController.text),
            addressType: "current",
          );
        }
      }

      // Navigate based on the parameter
      if (navigateToNext) {
        Get.to(() => const EditUserDocument());
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Profile updated successfully. Please update your document.',
          SnackbarType.success,
        );
      } else {
        Get.offAll(() => BottomNavPage());
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Address updated successfully',
          SnackbarType.success,
        );
      }

      // Store new initial values after successful update
      _storeInitialValues();
      setState(() {
        _hasChanges = false;
      });
    } catch (e) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onNextPressed() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    await _submitUserAddress(navigateToNext: true);
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
            fontSize: 14,
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
            fontSize: 12,
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
          // Previous Button
          ElevatedButton(
            onPressed: _onPreviousPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Save Changes Button
          if (_hasChanges)
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _submitUserAddress(navigateToNext: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Save Changes",
                style: smallStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),

          // Next Button
          ElevatedButton(
            onPressed: _isLoading ? null : _onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
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
                    fontSize: 11,
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Country',
            style: TextStyle(
              fontSize: 11,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          CountryDropdown(
            errorText: _fieldErrors['currentCountry'],
            valueId: countryIdController.text,
            valueName: countryNameController.text,
            onChanged: (CountryData? data) {
              if (data != null) {
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
                _checkForChanges();
              }
            },
            isDarkMode: isDarkMode,
          ),
        ],
      ),
      CustomTextField(
        "Province",
        provinceController,
        isDarkMode,
        errorText: _fieldErrors['permanentProvince'],
        fieldKey: 'permanentProvince',
      ),
      CustomTextField("City", cityController, isDarkMode,
          fieldKey: 'permanentCity'),
      CustomTextField("Address Line 1", addressLineOneController, isDarkMode,
          errorText: _fieldErrors['permanentAddressLineOne'],
          fieldKey: 'permanentAddressLineOne'),
      CustomTextField("Address Line 2", addressLineTwoController, isDarkMode,
          errorText: _fieldErrors['permanentAddressLineTwo'],
          fieldKey: 'permanentAddressLineTwo'),
      CustomTextField(
        "Zip Code",
        zipController,
        isDarkMode,
        errorText: _fieldErrors['permanentZip'],
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
            setState(() {
              currentCountryIdController.text = data.id.toString();
              currentCountryNameController.text = data.name;
              _fieldErrors.remove('currentCountry');
            });
            _checkForChanges();
          }
        },
        isDarkMode: isDarkMode,
      ),
      CustomTextField("Province", currentProvinceController, isDarkMode,
          errorText: _fieldErrors['currentProvince'],
          fieldKey: 'currentProvince'),
      CustomTextField(
        "City",
        currentCityController,
        isDarkMode,
        errorText: _fieldErrors['currentCity'],
        fieldKey: 'currentCity',
      ),
      CustomTextField(
          "Address Line 1", currentAddressLineOneController, isDarkMode,
          errorText: _fieldErrors['currentAddressLineOne'],
          fieldKey: 'currentAddressLineOne'),
      CustomTextField(
          "Address Line 2", currentAddressLineTwoController, isDarkMode,
          errorText: _fieldErrors['currentAddressLineTwo'],
          fieldKey: 'currentAddressLineTwo'),
      CustomTextField(
        "Zip Code",
        currentZipController,
        errorText: _fieldErrors['currentZip'],
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
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 20.0,
        title: Text(
          "Edit User Address Detail",
          style: smallStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
