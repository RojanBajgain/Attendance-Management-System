import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/profile_repo.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_detail_model.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var profile = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var profiledetail = ProfileDetailModel().obs;

  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  @override
  void onInit() {
    getProfile();
    super.onInit();
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
        Get.snackbar('Error', 'Failed to fetch Profile details.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('the error of Profile detail is $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
