import 'dart:developer';
import 'dart:convert';

import 'package:ams/config/routes/route_helper.dart';
import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/organization_repo.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_brand_controller.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_model.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_profile_model.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrganizationController extends GetxController {
  var organizationList = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  // WebSocketChannel? _webSocketChannel;
  var isWebSocketConnected = false.obs;
  final Rx<Datum?> selectedOrganization = Rx<Datum?>(null);

  final OrganizationRepo organizationRepo =
      OrganizationRepo(apiClient: Get.find<ApiClient>());
  final colorsController =
      Get.put(AppBrandController(appBrandRepo: Get.find()));
  final GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    handleOrganizations();
    // _restoreWebSocketConnection();
  }

  Future<void> handleOrganizations() async {
    isLoading(true);
    try {
      final List<dynamic>? organizations = Get.arguments;

      if (organizations != null && organizations.isNotEmpty) {
        organizationList.value = organizations
            .map((org) => Datum.fromJson(org as Map<String, dynamic>))
            .toList();

        log("Loaded organizations: ${organizationList.length}");

        // Auto-select if only one organization
        if (organizationList.length == 1) {
          await selectOrganization(organizationList.first);
        }
        colorsController.onInit();
      } else {
        errorMessage.value = "No organizations found";
        log("No organizations passed");
      }
    } catch (e) {
      log("Error loading organizations: $e");
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectOrganization(Datum organization) async {
    isLoading(true);
    try {
      // Store the selected organization
      selectedOrganization.value = organization;

      // Save organization details
      box.write('selectedOrganization', {
        'title': organization.title,
        'api_key': organization.apiKey,
        'mobile_enabled': organization.mobileEnabled,
      });

      // Update API client with organization API key
      final apiClient = Get.find<ApiClient>();
      // Await the asynchronous token and refreshToken
      final accessToken = await apiClient.token;
      final refreshToken = await apiClient.refreshToken;

      await apiClient.saveTokens(
        accessToken,
        refreshToken,
        organization.apiKey ?? '',
      );

      // Get organization profile
      ApiResponse response = await organizationRepo.getOrganizationProfile();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        final profileModel = response.response as OrganizationProfileModel;
        final profile = profileModel.profile;

        if (profile.profileId == 0) {
          throw Exception('Invalid profile data received');
        }

        // Store profile data
        box.write('profile_id', profile.profileId);
        box.write('organization_name', profile.organization);
        box.write('user_profile', {
          'full_name': profile.fullName,
          'email': profile.email,
          'role': profile.role,
          'profile_image': profile.profileImage,
          'designation': profile.designation,
          'designation_id': profile.designationId,
          'employee_type': profile.employeeType,
        });

        // Connect to WebSocket
        final authController = Get.find<AuthController>();
        final userId = authController.alluserData.value.user;
        if (userId != null && organization.apiKey != null) {
          // await connectWebSocket(userId, organization.apiKey!);
        } else {
          log('Cannot connect to WebSocket: userId or apiKey is null');
          SSnackbarUtil.showFadeSnackbar(
            Get.context!,
            'User ID or Organization API Key is missing.',
            SnackbarType.error,
          );
        }

        // Navigate to BottomNavPage
        /* Get.offAll(() => BottomNavPage(
            // profileData: profile,
            // apiKey: organization.apiKey,
            )); */

        Get.offAllNamed(RouteHelper.bottomnav);

        if (organizationList.length > 1) {
          SSnackbarUtil.showFadeSnackbar(
            Get.context!,
            'Welcome to ${organization.title}',
            SnackbarType.success,
          );
        }
      } else {
        throw Exception(response.message ?? 'Failed to fetch profile');
      }
    } catch (e) {
      log("Error selecting organization: $e");
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Failed to select organization: ${e.toString()}',
        SnackbarType.error,
      );
      box.remove('profile_id');
      box.remove('organization_name');
      box.remove('user_profile');
    } finally {
      isLoading(false);
    }
  }
}
