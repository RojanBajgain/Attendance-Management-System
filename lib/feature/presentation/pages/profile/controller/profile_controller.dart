import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/profile_repo.dart';
import 'package:ams/feature/presentation/pages/profile/model/country_list_model.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_detail_model.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var profile = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var profiledetail = ProfileDetailModel().obs;
  final RxList<CountryListModel> countryList = <CountryListModel>[].obs;

  var isSameAsPermanent = false.obs;

  var isAddNewDocumentChecked = false.obs;

  void toggleAddNewDocument(bool value) {
    isAddNewDocumentChecked.value = value;
  }

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  Future<void> getProfile() async {
    isLoading(true);
    try {
      ApiResponse response = await profileRepo.getProfile();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetch profile data: ${response.response}");
        ProfileModel profiledata = response.response;
        profile.value = profiledata.data;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      // log('Error fetching profile: $e');
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> getcountryList() async {
    try {
      ApiResponse response = await profileRepo.getCountryList();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetch country data: ${response.response}");

        // If the response is a list of countries
        if (response.response is List) {
          List<dynamic> countryData = response.response;
          countryList.value = countryData
              .map((item) => CountryListModel.fromJson(item))
              .toList();
        }
        // If the response is encoded as a JSON string
        else if (response.response is String) {
          List<dynamic> countryData = jsonDecode(response.response);
          countryList.value = countryData
              .map((item) => CountryListModel.fromJson(item))
              .toList();
        }
        // If the response is already a CountryListModel
        else if (response.response is CountryListModel) {
          countryList.value = [response.response];
        }

        log("Country list loaded: ${countryList.length} countries");
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log('Error fetching country list: $e');
      errorMessage.value = 'An error occurred: $e';
    }
  }

  Future<void> getProfileDetailData(String id) async {
    ApiResponse response = await profileRepo.getProfileDetail(id);
    isLoading(true);
    try {
      if (response.status == ApiStatus.SUCCESS) {
        if (kDebugMode) {
          print(response.status);
        }

        log("fetched profile detail Data: ${response.response}");

        profiledetail.value = response.response;
      } else {
        if (kDebugMode) {
          print('its error is ${response.status}');
        }
        SSnackbarUtil.showSnackbar(
          'Error',
          'Failed to fetch Profile details.',
          SnackbarType.info,
        );
        // Get.snackbar('Error', 'Failed to fetch Profile details.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('the error of Profile detail is $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> postProfileUpdate({
    required int id,
    required int profileID,
    required File? profileImage,
    required String username,
    required String dob,
    required String phonenumber,
    required String gender,
    required String joinedDate,
    required List<String> skills,
    required File? resume,
  }) async {
    try {
      ApiResponse response = await profileRepo.postProfileUpdate(
        id,
        profileID,
        profileImage,
        username,
        dob,
        phonenumber,
        gender,
        joinedDate,
        skills,
        resume,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // print("Profile updated successfully: ${response.response}");
      } else {
        // print("Error: ${response.message}");

        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Failed to update profile. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      // print("Error updating profile: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  Future<void> postnewuserAddress({
    required int userID,
    required int issuedCountry,
    required String province,
    required String city,
    required String addressLineOne,
    required String addressLineTwo,
    required String zipcode,
    required String addressType,
  }) async {
    try {
      // Guard against any null values
      if (province.isEmpty ||
          city.isEmpty ||
          addressLineOne.isEmpty ||
          zipcode.isEmpty) {
        SSnackbarUtil.showSnackbar(
          'Validation Error',
          'All required fields must be filled',
          SnackbarType.error,
        );
        return;
      }

      ApiResponse response = await profileRepo.postnewuserAddress(
        userID,
        issuedCountry,
        province,
        city,
        addressLineOne,
        addressLineTwo,
        zipcode,
        addressType,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Created new user address: ${response.response}");

        // Refresh profile data to get updated addresses
        await getProfile();
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          response.message ??
              'Failed to create your address. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        // print("Error creating address: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  Future<void> postuserAddress({
    required int id,
    required int addressID,
    required String country,
    required String province,
    required String city,
    required String addressLineOne,
    required String addressLineTwo,
    required String zipcode,
    required String addressType,
  }) async {
    try {
      // Guard against any null values
      if (country.isEmpty ||
          province.isEmpty ||
          city.isEmpty ||
          addressLineOne.isEmpty ||
          zipcode.isEmpty) {
        SSnackbarUtil.showSnackbar(
          'Validation Error',
          'All required fields must be filled',
          SnackbarType.error,
        );
        return;
      }

      // Parse country to int for API
      int countryId = int.tryParse(country) ?? 1;

      ApiResponse response = await profileRepo.postuserAddress(
        id,
        addressID,
        countryId.toString(),
        province,
        city,
        addressLineOne,
        addressLineTwo,
        zipcode,
        addressType,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Updated user address: ${response.response}");

        // Refresh profile data to get updated addresses
        await getProfile();
      } else {
        // log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          response.message ??
              'Failed to update your address. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating address: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  Future<void> postuserBankDetails({
    required int bankdetailID,
    required int userID,
    required String bankname,
    required String bankaccount,
    required String bankaccountname,
    required String bankbranch,
    required String ispayroll,
  }) async {
    try {
      ApiResponse response = await profileRepo.postuserBankDetails(
        bankdetailID,
        userID,
        bankname,
        bankaccount,
        bankaccountname,
        bankbranch,
        ispayroll,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched updated user bankk details data: ${response.response}");

        Get.back();

        SSnackbarUtil.showSnackbar(
          'User Details has been updated',
          response.message ?? 'Your details has been successfully updated',
          SnackbarType.success,
        );
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Failed to update your address. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        // print("Error fetching sub address data: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  Future<void> postnewBankDetails({
    required int userID,
    required String bankName,
    required String bankAccount,
    required String bankaccountName,
    required String bankBranch,
    required String isPayroll,
  }) async {
    try {
      ApiResponse response = await profileRepo.postnewBankDetails(
        userID,
        bankName,
        bankAccount,
        bankaccountName,
        bankBranch,
        isPayroll,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Fetched created new bank detail data: ${response.response}");

        Get.back();
        SSnackbarUtil.showSnackbar(
          'User Details has been updated',
          response.message ?? 'Your details has been successfully updated',
          SnackbarType.success,
        );

        // await getTimeoff();
      } else {
        // log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Failed to post timeoff. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub timeoff data: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  Future<void> postuserDocuments({
    required int documentID,
    required int userID,
    required String type,
    required String title,
    required int? identifier,
    required DateTime? issuedDate,
    required int profileId,
    required List<int> filesToKeep,
    required File? documentImage,
    required File? documentFile,
  }) async {
    try {
      ApiResponse response = await profileRepo.postuserDocuments(
        documentID,
        userID,
        type,
        title,
        identifier,
        issuedDate,
        profileId,
        filesToKeep,
        documentImage,
        documentFile,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Fetched updated user documents details: ${response.response}");
      } else {
        // log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Failed to update your documents. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating document: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  Future<void> postNewUserDocument({
    required String type,
    required String title,
    required String? issuedDateStr,
    required String? identifier,
    required int profileId,
    required File? documentFile,
  }) async {
    try {
      ApiResponse response = await profileRepo.postNewUserDocument(
        userId: profileId,
        type: type,
        title: title,
        issuedDate: issuedDateStr,
        identifier: identifier,
        profileId: profileId,
        documentFile: documentFile,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Successfully added new user document: ${response.response}");

        // Get.back();
      } else {
        // log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Failed to add new document. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding new document: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  Future<void> deleteDocument({required int id}) async {
    try {
      ApiResponse response = await profileRepo.deleteuserDocument(id);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Fetched created timeoff data: ${response.response}");

        Get.back();
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'Server Error',
          'Something went wrong. Please try again later',
          SnackbarType.error,
        );
      }
    } catch (e) {
      log("Error fetching delete document: $e");

      errorMessage.value = "An error occurred: $e";
    }
  }

  Future<void> deleteuserBankDetails({required int id}) async {
    try {
      ApiResponse response = await profileRepo.deleteuserBankDetails(id);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // log("Fetched deleted bankdata data: ${response.response}");

        // Get.back();
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching delete bank data: $e");

      errorMessage.value = "An error occurred: $e";
    }
  }
}
