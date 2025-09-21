import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_brand_controller.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/model/app_brand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  late final AppBrandController _brandController;

  // Reactive properties - these are now properly observable
  final RxString _logoUrl = ''.obs;
  final RxString _faviconUrl = ''.obs;
  final Rx<Color> _themeColor = Colors.blue.obs;

  ThemeService() {
    try {
      _brandController = Get.find<AppBrandController>();
      print('ThemeService: Found AppBrandController');
    } catch (e) {
      print('ThemeService: Error finding AppBrandController: $e');
      rethrow;
    }
  }

  // Getters that return the observable values directly for Obx to work
  RxString get logoUrlRx => _logoUrl;
  RxString get faviconUrlRx => _faviconUrl;
  Rx<Color> get themeColorRx => _themeColor;

  // Regular getters for direct access
  String get logoUrl => _logoUrl.value;
  String get faviconUrl => _faviconUrl.value;
  Color get themeColor => _themeColor.value;

  @override
  void onInit() {
    super.onInit();
    print('ThemeService onInit called');

    // Listen for brand changes
    ever(_brandController.appBrand, (AppBrand? brand) {
      print(
          'ThemeService: Brand data changed - ${brand?.data.length ?? 0} items');
      _updateBranding();
    });

    // Also listen for loading state changes
    ever(_brandController.isLoading, (bool loading) {
      print('ThemeService: Loading state changed: $loading');
      if (!loading) {
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

      // Update theme color if different and valid
      if (brand.themeColor.isNotEmpty) {
        try {
          // Convert hex color to Color object
          final color = _parseColor(brand.themeColor);
          if (color != _themeColor.value) {
            print(
                'ThemeService: Updating theme color from "${_themeColor.value}" to "$color"');
            _themeColor.value = color;
          }
        } catch (e) {
          print(
              'ThemeService: Invalid theme color format: ${brand.themeColor}');
          _themeColor.value = Colors.blue; // Fallback to default
        }
      } else {
        print('ThemeService: No theme color provided, using default');
        _themeColor.value = Colors.blue; // Fallback to default
      }
    } else {
      print('ThemeService: No brand data available, using default theme color');
      // Reset to defaults when no brand data
      _logoUrl.value = '';
      _faviconUrl.value = '';
      _themeColor.value = Colors.blue;
    }
  }

  // Helper method to parse hex color
  Color _parseColor(String hexColor) {
    String cleanHex = hexColor.replaceAll('#', '');

    // Handle 3-character hex colors (e.g., #F1B -> #FF11BB)
    if (cleanHex.length == 3) {
      cleanHex = cleanHex.split('').map((c) => c + c).join('');
    }

    // Add alpha channel if not present
    if (cleanHex.length == 6) {
      cleanHex = 'FF' + cleanHex;
    }

    return Color(int.parse(cleanHex, radix: 16));
  }

  // Method to manually trigger branding update (for debugging)
  void forceUpdateBranding() {
    print('ThemeService: Force updating branding...');
    _updateBranding();
  }

  // Debug method to check current state
  void debugPrint() {
    print('ThemeService Debug:');
    print('  Logo URL: ${_logoUrl.value}');
    print('  Favicon URL: ${_faviconUrl.value}');
    print('  Theme Color: ${_themeColor.value}');
    print('  Brand Controller Loading: ${_brandController.isLoading.value}');
    print('  Current Brand: ${_brandController.currentBrand}');
  }
}
