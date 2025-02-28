import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/clock_in_out_repo.dart';
import 'package:ams/feature/data/repository/has_clockedIn_repo.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/clock_in_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/clock_out_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/get_clock_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/location_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/clock_time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClockInOutController extends GetxController {
  var clockin = ClockInModel().obs;
  var clockout = ClockOutModel().obs;
  var officelocation = <Datum>[].obs;
  var isLoading = false.obs;

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
        log("Fetched Dashboard office location: $response.response");

        LocationModel locationModel = response.response as LocationModel;

        if (locationModel.data.isNotEmpty) {
          double latitude = locationModel.data.first.latitude ?? 0.0;
          double longitude = locationModel.data.first.longitude ?? 0.0;

          log("Office Location - Latitude: $latitude, Longitude: $longitude");

          return Location(latitude: latitude, longitude: longitude);
        } else {
          log("No office locations found.");
        }
      }
      // else {
      //   log("Error: ${response.message}");
      //   Get.snackbar("Error", "Failed to fetch office location.",
      //       backgroundColor: Colors.red, colorText: Colors.white);
      // }
    } catch (e) {
      log("Error fetching office location: $e");
      Get.snackbar("Error", "An error occurred while fetching office location.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    return null;
  }

  // Post Clock In
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

        Get.snackbar(
          'Posted Clock in',
          response.message ?? 'Your CLock In time has been successfully posted',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        log("Error: ${response.message}");
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to post CLock in time',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub clock in data: $e");
      }
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  // Post Clock out
  Future<void> postClockout({
    required int deviceId,
    required String latitude,
    required String longitude,
  }) async {
    try {
      ApiResponse response =
          await clockinoutrepo.postClockout(deviceId, latitude, longitude);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created clock out data: ${response.response}");

        // Update the clockedInTime in HasClockedinController to null after clock-out
        final hasClockedinController = Get.find<HasClockedinController>();
        hasClockedinController.clockedInTime.value = null;

        Get.back();

        Get.snackbar(
          'Posted Clock out',
          response.message ??
              'Your CLock out time has been successfully posted',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        log("Error: ${response.message}");
        Get.snackbar(
          'INFO',
          'Already clocked out for today',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.blue,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub clock out data: $e");
      }
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  // Post On-Break
  Future<void> postOnBreak({
    required int employeeId,
  }) async {
    try {
      ApiResponse response = await clockinoutrepo.postOnBreak(employeeId);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created onBreak data: ${response.response}");

        final hasClockedinController = Get.find<HasClockedinController>();
        hasClockedinController.clockedInTime.value = null;

        Get.back();

        Get.snackbar(
          'Posted On Break',
          response.message ?? 'Your Break time has been successfully posted',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        log("Error: ${response.message}");
        Get.snackbar(
          'INFO',
          response.message ?? 'Already clocked out for today',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.blue,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub Break time data: $e");
      }
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  // Post Resume
  Future<void> postResume({
    required int employeeId,
    required String latitude,
    required String longitude,
  }) async {
    try {
      ApiResponse response =
          await clockinoutrepo.postResume(employeeId, latitude, longitude);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched created resume data: ${response.response}");

        final hasClockedinController = Get.find<HasClockedinController>();
        hasClockedinController.clockedInTime.value = null;

        Get.back();

        Get.snackbar(
          'Posted Resume',
          response.message ?? 'Your Resume time has been successfully posted',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        log("Error: ${response.message}");
        Get.snackbar(
          'INFO',
          response.message ?? 'No break time available',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.blue,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sub Break time data: $e");
      }
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
