import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/app_brand.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/model/app_brand.dart';
import 'package:get/get.dart';

class AppBrandController extends GetxController {
  static AppBrandController get instance => Get.find();

  final AppBrandRepo appBrandRepo;
  var appBrand = Rx<AppBrand?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var appLogo = ''.obs;
  var appColor = '';
  var authappLogo = ''.obs;
  var authappColor = ''.obs;
  var authappDate = ''.obs;

  Datum? get currentBrand => appBrand.value?.data.isNotEmpty ?? false
      ? appBrand.value!.data.first
      : null;

  AppBrandController({required this.appBrandRepo});

  @override
  void onInit() {
    super.onInit();
    fetchAppBrand();
  }

  Future<void> fetchAppBrand() async {
    isLoading.value = true;
    try {
      ApiResponse response = await appBrandRepo.getAppBrand();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        appBrand.value = response.response;

        // Debug current brand
        final brand = currentBrand;
        if (brand != null) {
          // print('Current brand logo: ${brand.logo}');
          // print('Current brand theme color: ${brand.themeColor}');
        } else {
          // print('No current brand available');
        }

        // Apply the branding immediately
        _applyBranding();
      } else {
        errorMessage.value = 'Failed to load app branding';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching app branding: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _applyBranding() {
    final brand = currentBrand;
    if (brand != null) {
      // print(
      // 'Applying branding - Logo: ${brand.logo}, Color: ${brand.themeColor}';
      // Here you can apply the branding to the app
      // For example, you might want to update theme colors
      // or store these values to be used throughout the app
    } else {
      // print('No brand data to apply');
    }
  }
}
