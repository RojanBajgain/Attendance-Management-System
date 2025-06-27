// import 'dart:developer';

// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/repository/privacy_repo.dart';
// import 'package:get/get.dart';

// class AboutController extends GetxController {
//   final PrivacyRepo aboutrepo;
//   AboutController({required this.aboutrepo, required});
//   var isloading = false.obs;

//   var aboutdata = <Privacy>[].obs;

//   Future<void> getaboutdata(String typeID) async {
//     isloading.value = true;

//     try {
//       ApiResponse response = await aboutrepo.getprivacydata(typeID);
//       if (response.status == ApiStatus.SUCCESS && response.response != null) {
//         PrivacyModel data = response.response;
//         aboutdata.value = data.data ?? [];
//       } else {
//         log("Error fetching privacy: ${response.message}");
//       }
//     } catch (e) {
//       log('Error fetching privacy : $e');
//     } finally {
//       isloading.value = false;
//     }
//   }
// }
