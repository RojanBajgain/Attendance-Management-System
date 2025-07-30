import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/organizationStaff_repo.dart';
import 'package:ams/feature/presentation/pages/HR_Details/model/hr_detail_model.dart';
import 'package:get/get.dart';

class OrganizationStaffController extends GetxController {
  var organizationStaff = <OrganizationStaffModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final OrganizationStaffRepo organizationStaffRepo;

  OrganizationStaffController({required this.organizationStaffRepo});

  @override
  void onInit() {
    super.onInit();
    getOrganizationStaff();
  }

  Future<void> getOrganizationStaff() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      ApiResponse response = await organizationStaffRepo.getorganizationStaff();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Organization Staff data: ${response.response}");
        // Parse list of staff members
        List<dynamic> staffJson = response.response is List
            ? response.response
            : (response.response['data'] is List
                ? response.response['data']
                : []);
        organizationStaff.assignAll(staffJson
            .map((json) => OrganizationStaffModel.fromJson(json))
            .toList());
        log("Parsed ${organizationStaff.length} staff members: ${organizationStaff.map((e) => e.toJson())}");
      } else {
        log("Error: ${response.message}");
        // errorMessage.value = response.message ?? "Failed to load staff data";
      }
    } catch (e, stackTrace) {
      log("Error fetching organization staff: $e", stackTrace: stackTrace);
      // errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
