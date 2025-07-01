import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/policy_repo.dart';
import 'package:ams/feature/presentation/pages/policy/model/policy_model.dart';
import 'package:get/get.dart';

class PolicyController extends GetxController {
  var policy = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedPolicy = RxnString();

  final PolicyRepo policyrepo;

  PolicyController({required this.policyrepo});

  // @override
  // void onInit() {
  //   getPolicydetail();
  //   super.onInit();
  // }

  // Get Policy details
  Future<void> getPolicydetail() async {
    try {
      ApiResponse response = await policyrepo.getPolicydetail();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetch Timeoff data: ${response.response}");

        PolicyModel policydetaildata = response.response;
        policy.value = policydetaildata.data;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching timeoff: $e");

      errorMessage.value = "An error occurred: $e";
    }
  }
}
