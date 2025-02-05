import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/profile_repo.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var profile = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  Future<void> getProfile() async {
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
    }
  }
}
