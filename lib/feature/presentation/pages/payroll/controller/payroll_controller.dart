import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/payroll_repo.dart';
import 'package:ams/feature/presentation/pages/payroll/model/payroll_detail_model.dart';
import 'package:ams/feature/presentation/pages/payroll/model/payroll_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PayrollController extends GetxController {
  var payroll = <Datum>[].obs;
  var filteredPayroll = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var payrollDetail = PayrollDetailModel().obs;
  var selectedDate = Rxn<DateTime>();

  final PayrollRepo payrollRepo;

  PayrollController({required this.payrollRepo});

  // @override
  // void onInit() {
  //   super.onInit();
  //   getPayroll();
  // }

  Future<void> getPayroll() async {
    isLoading(true);
    try {
      ApiResponse response = await payrollRepo.getPayroll();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched Payroll data: ${response.response}");

        PayRollModel payrolldata = response.response;
        payroll.value = payrolldata.data;

        filteredPayroll.value = payroll;
      } else {
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching payroll: $e");

      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  Future<void> getPayrollDetailData(String id) async {
    ApiResponse response = await payrollRepo.getPayrollDetail(id);
    try {
      if (response.status == ApiStatus.SUCCESS) {
        if (kDebugMode) {
          print(response.status);
        }

        log("fetched payroll detail Data: ${response.response}");

        payrollDetail.value = response.response;
      } else {
        if (kDebugMode) {
          print('its error is ${response.status}');
        }
        Get.snackbar('Error', 'Failed to fetch Payroll details.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('the error of Payroll detail is $e');
      }
    }
  }

  // Function to filter by selected date
  void filterPayrollByDate(DateTime date) {
    selectedDate.value = date;

    String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(date);
    filteredPayroll.value = payroll.where((payrolldate) {
      String formattedEntryDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(payrolldate.dateOfPayment.toString()));
      return formattedEntryDate == formattedSelectedDate;
    }).toList();
  }

  void clearSelectedDate() {
    selectedDate.value = null;
    filteredPayroll.assignAll(payroll);
  }
}
