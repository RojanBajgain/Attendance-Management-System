// Fix for ClockInOutController
import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/clock_in_out_repo.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/check_access_point_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/clock_in_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/clock_out_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/location_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/clock_time.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ClockInOutController extends GetxController {
  var clockin = ClockInModel().obs;
  var clockout = ClockOutModel().obs;
  var officelocation = <Datum>[].obs;
  var isLoading = false.obs;

  var officeLocationError = ''.obs;

  final ClockInOutRepo clockinoutrepo;

  ClockInOutController({required this.clockinoutrepo});

  @override
  void onInit() {
    super.onInit();
    getOfficeLocation();
  }

  // Get Office Location
  Future<Location?> getOfficeLocation() async {
    try {
      ApiResponse response = await clockinoutrepo.getOfficeLocation();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        LocationModel locationModel = response.response as LocationModel;
        if (locationModel.data.isNotEmpty) {
          return Location(
            latitude: locationModel.data.first.latitude ?? 0.0,
            longitude: locationModel.data.first.longitude ?? 0.0,
          );
        } else {
          officeLocationError.value = "No office locations found.";
        }
      } else {
        officeLocationError.value = "Failed to fetch office location.";
      }
    } catch (e) {
      officeLocationError.value = "An error occurred: $e";
    }
    return null;
  }

  Future<String?> _getCurrentIpAddress() async {
    try {
      log("🔄 Starting to fetch IP address...");
      ApiResponse ipResponse = await clockinoutrepo.getCurrentIpAddress();

      if (ipResponse.status == ApiStatus.SUCCESS &&
          ipResponse.response != null) {
        final ip = ipResponse.response['ip'] as String?;
        log("📡 Successfully obtained public IP: $ip");
        return ip;
      }

      log("⚠️ Failed to get IP address from API response");
      return null;
    } catch (e) {
      log("⛔ Error getting IP address: $e");
      return null;
    }
  }

  // Post Clock In with improved error handling
  Future<void> postClockin({
    required int deviceId,
    required String latitude,
    required String longitude,
  }) async {
    try {
      ApiResponse response =
          await clockinoutrepo.postClockin(deviceId, latitude, longitude);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created clock in data: ${response.response}");

        // Update the clockedInTime in HasClockedinController
        final hasClockedinController = Get.find<HasClockedinController>();
        hasClockedinController.clockedInTime.value = DateTime.now();

        Get.back();
        SSnackbarUtil.showSnackbar(
          "Posted Clock in",
          response.message ?? 'Your Clock In time has been successfully posted',
          SnackbarType.success,
        );
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
            "Error",
            response.message ?? 'Failed to post CLock in time',
            SnackbarType.error);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub clock in data: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    }
  }

  // Post Clock out with IP
  Future<void> postClockout({
    required int deviceId,
    required String latitude,
    required String longitude,
  }) async {
    try {
      isLoading.value = true;
      log("⏱️ Starting clock-out process...");

      // FIXED: Check location and services before proceeding
      bool servicesEnabled = await Geolocator.isLocationServiceEnabled();
      if (!servicesEnabled) {
        SSnackbarUtil.showSnackbar(
          "Location Services Disabled",
          "Please enable location services on your device",
          SnackbarType.error,
        );
        return;
      }

      // Get current IP address
      String? ipAddress = await _getCurrentIpAddress();

      if (ipAddress == null) {
        log("❌ Aborting clock-out - no IP address available");
        SSnackbarUtil.showSnackbar(
            "Error", "Failed to get IP address", SnackbarType.error);
        return;
      }

      ApiResponse response = await clockinoutrepo.postClockout(
        deviceId,
        latitude,
        longitude,
        ipAddress, // Send the IP address
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created clock out data: ${response.response}");

        final hasClockedinController = Get.find<HasClockedinController>();
        hasClockedinController.clockedInTime.value = null;
        // ADDED: Make sure to refresh the clock data
        await hasClockedinController.getClockData();

        Get.back();
        SSnackbarUtil.showSnackbar(
            "Posted Clock out",
            "Your Clock out time has been successfully posted",
            SnackbarType.success);
      } else {
        log("Error: ${response.message}");
        // Check for feature not enabled error
        if (response.message != null &&
            response.message!.contains("feature is not enabled")) {
          SSnackbarUtil.showSnackbar(
            "Feature Not Enabled",
            "Clock-out feature is not enabled. Please contact your administrator.",
            SnackbarType.info,
          );
        } else {
          SSnackbarUtil.showSnackbar(
              "Error",
              response.message ?? "Already clocked out for today",
              SnackbarType.error);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub clock out data: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Post On-Break
  Future<void> postOnBreak({
    required int employeeId,
  }) async {
    try {
      isLoading.value = true;
      ApiResponse response = await clockinoutrepo.postOnBreak(employeeId);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created onBreak data: ${response.response}");

        final hasClockedinController = Get.find<HasClockedinController>();
        // FIXED: Don't set to null on break
        // hasClockedinController.clockedInTime.value = null;

        Get.back();
        SSnackbarUtil.showSnackbar(
            "Posted On Break",
            "Your Break time has been successfully posted",
            SnackbarType.success);
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
            "INFO", "Already clocked out for today", SnackbarType.info);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub Break time data: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Post Resume
  Future<void> postResume({
    required int employeeId,
    required String latitude,
    required String longitude,
  }) async {
    try {
      isLoading.value = true;

      // FIXED: Check location services before proceeding
      bool servicesEnabled = await Geolocator.isLocationServiceEnabled();
      if (!servicesEnabled) {
        SSnackbarUtil.showSnackbar(
          "Location Services Disabled",
          "Please enable location services on your device",
          SnackbarType.error,
        );
        return;
      }

      ApiResponse response =
          await clockinoutrepo.postResume(employeeId, latitude, longitude);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created resume data: ${response.response}");

        final hasClockedinController = Get.find<HasClockedinController>();
        // FIXED: Don't set to null on resume
        // hasClockedinController.clockedInTime.value = null;

        // Instead refresh the clock data
        await hasClockedinController.getClockData();

        Get.back();
        SSnackbarUtil.showSnackbar(
            "Posted Resume",
            response.message ?? 'Your Resume time has been successfully posted',
            SnackbarType.success);
      } else {
        log("Error: ${response.message}");
        SSnackbarUtil.showSnackbar(
          'INFO',
          response.message ?? 'No break time available',
          SnackbarType.info,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub Break time data: $e");
      }
      SSnackbarUtil.showSnackbar(
        'Error',
        'An unexpected error occurred: $e',
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
