// import 'dart:developer';

// import 'package:ams/app.dart';
// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/repository/app_image_brand.dart';
// import 'package:ams/feature/presentation/pages/app_image_brand/model/app_image_brand.dart';
// import 'package:get/get.dart';

// class AppImageBrandController extends GetxController {
//   var imageBrands = <AppImage>[].obs;
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;

//   // final AppImageBrandRepo appImageBrandRepo =
//   //     AppImageBrandRepo(apiClient: Get.find<ApiClient>());

//   final AppImageBrandRepo appImageBrandRepo;

//   AppImageBrandController({required this.appImageBrandRepo});

//   @override
//   void onInit() {
//     super.onInit();
//     getImageBrands();
//   }

//   Future<void> getImageBrands() async {
//     isLoading.value = true;
//     try {
//       ApiResponse response = await appImageBrandRepo.getImageBrands();
//       if (response.status == ApiStatus.SUCCESS && response.response != null) {
//         AppImageBrand appImageBranddata = response.response;
//         imageBrands.value = appImageBranddata.data;
//       } else {
//         errorMessage.value = 'Failed to load image brands';
//       }
//     } catch (e) {
//       log('Error fetching image brands: $e');
//       errorMessage.value = 'An error occurred: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
