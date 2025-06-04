import 'dart:developer';
import 'dart:convert';

import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/organization_repo.dart';
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
  WebSocketChannel? _webSocketChannel;
  var isWebSocketConnected = false.obs;

  final OrganizationRepo organizationRepo =
      OrganizationRepo(apiClient: Get.find<ApiClient>());
  final GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    handleOrganizations();
    // _restoreWebSocketConnection();
  }

/*   @override
  void onClose() {
    _disconnectWebSocket();
    super.onClose();
  }

  // Modified connectWebSocket to handle int userId
  Future<void> connectWebSocket(int userId, String organizationApiKey) async {
    try {
      final wsUrl =
          'ws://192.168.254.45:8000/ws/chat/${userId.toString()}_$organizationApiKey/';
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      isWebSocketConnected.value = true;
      log('WebSocket connected for user: $userId, organization: $organizationApiKey');

      _webSocketChannel!.stream.listen(
        (message) {
          log('WebSocket message received: $message');
          try {
            final data = json.decode(message);
            SSnackbarUtil.showSnackbar(
              'WebSocket Message',
              data.toString(),
              SnackbarType.info,
            );
          } catch (e) {
            log('Error parsing WebSocket message: $e');
            SSnackbarUtil.showSnackbar(
              'WebSocket Message',
              message.toString(),
              SnackbarType.info,
            );
          }
        },
        onError: (error) {
          log('WebSocket error: $error');
          isWebSocketConnected.value = false;
          SSnackbarUtil.showSnackbar(
            'WebSocket Error',
            'Failed to connect to WebSocket server.',
            SnackbarType.error,
          );
          _reconnectWebSocket(userId, organizationApiKey);
        },
        onDone: () {
          log('WebSocket connection closed');
          isWebSocketConnected.value = false;
          _reconnectWebSocket(userId, organizationApiKey);
        },
      );
    } catch (e) {
      log('WebSocket connection failed: $e');
      isWebSocketConnected.value = false;
      SSnackbarUtil.showSnackbar(
        'WebSocket Error',
        'Failed to connect to WebSocket server.',
        SnackbarType.error,
      );
    }
  }

  // Disconnect WebSocket
  void _disconnectWebSocket() {
    _webSocketChannel?.sink.close();
    isWebSocketConnected.value = false;
    log('WebSocket disconnected');
  }

  // Reconnect WebSocket with delay and retry limit
  void _reconnectWebSocket(int userId, String organizationApiKey) async {
    const maxRetries = 3;
    int retryCount = 0;
    while (!isWebSocketConnected.value && retryCount < maxRetries) {
      log('Attempting to reconnect WebSocket (attempt ${retryCount + 1})...');
      await Future.delayed(const Duration(seconds: 5));
      await connectWebSocket(userId, organizationApiKey);
      retryCount++;
    }
    if (!isWebSocketConnected.value) {
      SSnackbarUtil.showSnackbar(
        'WebSocket Error',
        'Failed to reconnect to WebSocket server after $maxRetries attempts.',
        SnackbarType.error,
      );
    }
  }

  // Send WebSocket message
  void sendWebSocketMessage(String message) {
    if (isWebSocketConnected.value && _webSocketChannel != null) {
      _webSocketChannel!.sink.add(message);
      log('WebSocket message sent: $message');
    } else {
      log('Cannot send message: WebSocket is not connected');
      SSnackbarUtil.showSnackbar(
        'WebSocket Error',
        'Not connected to WebSocket server.',
        SnackbarType.error,
      );
    }
  }

  // Restore WebSocket connection if organization is already selected
  void _restoreWebSocketConnection() async {
    final authController = Get.find<AuthController>();
    final userId = authController.alluserData.value.user;
    final selectedOrg = box.read('selectedOrganization');

    if (userId != null &&
        selectedOrg != null &&
        selectedOrg['api_key'] != null) {
      await connectWebSocket(userId, selectedOrg['api_key']);
    }
  } */

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
      // Save organization details
      box.write('selectedOrganization', {
        'title': organization.title,
        'api_key': organization.apiKey,
      });

      // Update API client with organization API key
      final apiClient = Get.find<ApiClient>();
      apiClient.saveTokens(
          apiClient.token, apiClient.refreshToken, organization.apiKey ?? '');

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
          SSnackbarUtil.showSnackbar(
            'WebSocket Error',
            'User ID or Organization API Key is missing.',
            SnackbarType.error,
          );
        }

        // Navigate to BottomNavPage
        Get.offAll(() => BottomNavPage(
              profileData: profile,
              apiKey: organization.apiKey,
            ));

        if (organizationList.length > 1) {
          SSnackbarUtil.showSnackbar(
            'Organization Selected',
            'Welcome to ${organization.title}',
            SnackbarType.success,
          );
        }
      } else {
        throw Exception(response.message ?? 'Failed to fetch profile');
      }
    } catch (e) {
      log("Error selecting organization: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
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
