import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_image_brand_controller.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/model/app_image_brand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  late final AppBrandController _brandController;

  // Reactive properties - only for images
  final RxString _logoUrl = ''.obs;
  final RxString _faviconUrl = ''.obs;

  ThemeService() {
    try {
      _brandController = Get.find<AppBrandController>();
      // print('ThemeService: Found AppBrandController');
    } catch (e) {
      print('ThemeService: Error finding AppBrandController: $e');
      rethrow;
    }
  }

  String get logoUrl => _logoUrl.value;
  String get faviconUrl => _faviconUrl.value;

  @override
  void onInit() {
    super.onInit();
    // print('ThemeService onInit called');

    // Listen for brand changes
    ever(_brandController.appBrand, (AppBrand? brand) {
      // print(
      //     'ThemeService: Brand data changed - ${brand?.data.length ?? 0} items');
      _updateBranding();
    });

    // Also listen for loading state changes
    ever(_brandController.isLoading, (bool loading) {
      print('ThemeService: Loading state changed: $loading');
      if (!loading) {
        // When loading is complete, try to update branding
        _updateBranding();
      }
    });

    // Initial update
    _updateBranding();
  }

  void _updateBranding() {
    print('ThemeService: _updateBranding called');
    final brand = _brandController.currentBrand;

    if (brand != null) {
      print('ThemeService: Found brand data');

      // Update logo if different
      if (brand.logo.isNotEmpty && brand.logo != _logoUrl.value) {
        print(
            'ThemeService: Updating logo from "${_logoUrl.value}" to "${brand.logo}"');
        _logoUrl.value = brand.logo;
      }

      // Update favicon if different
      if (brand.favicon != null &&
          brand.favicon!.isNotEmpty &&
          brand.favicon != _faviconUrl.value) {
        print(
            'ThemeService: Updating favicon from "${_faviconUrl.value}" to "${brand.favicon}"');
        _faviconUrl.value = brand.favicon!;
      } else if (brand.favicon == null && _faviconUrl.value.isNotEmpty) {
        print('ThemeService: Clearing favicon (null received)');
        _faviconUrl.value = '';
      }

      // Color handling removed - let backend handle colors directly
    } else {
      print('ThemeService: No brand data available yet');
    }
  }

  // Method to manually trigger branding update (for debugging)
  void forceUpdateBranding() {
    print('ThemeService: Force updating branding...');
    _updateBranding();
  }
}
