import 'dart:developer';

import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/policy/controller/policy_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class AddTimeoff extends StatefulWidget {
  const AddTimeoff({super.key});

  @override
  _AddTimeoffState createState() => _AddTimeoffState();
}

class _AddTimeoffState extends State<AddTimeoff> {
  final authcontroller = Get.find<AuthController>();
  final PolicyController policycontroller =
      Get.put(PolicyController(policyrepo: Get.find()));
  final TimeoffController timeoffcontroller = Get.put(TimeoffController());
  final profilecontroller = Get.put(ProfileController(profileRepo: Get.find()));

  GetStorage box = GetStorage();

  // Form key for FormBuilder
  final _formKey = GlobalKey<FormBuilderState>();

  // Controllers and state variables
  final _reasonController = TextEditingController();
  final _selectedValue = Rxn<String>();
  final _startDate = Rxn<DateTime>();
  final _endDate = Rxn<DateTime>();
  final _userLeaveData = Rxn<Map<String, dynamic>>(); // Reactive userLeaveData

  @override
  void initState() {
    super.initState();
    policycontroller.getPolicydetail();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserLeaveData();
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  // Method to load user leave data
  Future<void> _loadUserLeaveData() async {
    try {
      final response = await timeoffcontroller.getUserLeaveByPolicy();
      if (response != null) {
        _userLeaveData.value = response;
        log('Loaded userLeaveData: ${_userLeaveData.value}');
      } else {
        _userLeaveData.value = null;
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Failed to load leave balance information',
          SnackbarType.error,
        );
      }
    } catch (e) {
      log('Error loading user leave data: $e');
      _userLeaveData.value = null;
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Failed to load leave balance information: $e',
        SnackbarType.error,
      );
    }
  }

  // Method to calculate requested leave days
  int _calculateLeaveDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  // Method to get remaining leave for selected policy
  double _getRemainingLeave(String policyName) {
    if (_userLeaveData.value == null ||
        _userLeaveData.value!['leave_policies'] == null) {
      log('userLeaveData or leave_policies is null: ${_userLeaveData.value}');
      return 0.0;
    }

    final leavePolicies = _userLeaveData.value!['leave_policies'] as List;
    log('Looking for policy: $policyName in $leavePolicies');

    try {
      final selectedPolicy = leavePolicies.firstWhere(
        (policy) => policy['policy_name']
            .toString()
            .trim()
            .equalsIgnoreCase(policyName.trim()),
        orElse: () => null,
      );

      if (selectedPolicy == null) {
        log('Policy not found for: $policyName');
        return 0.0;
      }

      double remaining = (selectedPolicy['remaining_leave'] ?? 0.0).toDouble();
      log('Remaining leave for $policyName: $remaining');
      return remaining;
    } catch (e) {
      log('Error finding policy: $e');
      return 0.0;
    }
  }

  // Method to validate leave request
  bool _validateLeaveRequest(
      String policyName, DateTime startDate, DateTime endDate) {
    final requestedDays = _calculateLeaveDays(startDate, endDate);
    final remainingLeave = _getRemainingLeave(policyName);
    log('Validating leave request - Policy: $policyName, Requested: $requestedDays, Remaining: $remainingLeave');

    if (remainingLeave <= 0) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'You have no remaining $policyName leave days available.',
        SnackbarType.error,
      );
      return false;
    }

    if (requestedDays > remainingLeave) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'You are requesting $requestedDays days but only have ${remainingLeave.toInt()} $policyName leave days remaining.',
        SnackbarType.warning,
      );
      return false;
    }

    return true;
  }

  // Method to clear the form
  void _clearForm() {
    _selectedValue.value = null;
    _startDate.value = null;
    _endDate.value = null;
    _reasonController.clear();
    _formKey.currentState?.reset();
    _formKey.currentState?.patchValue({
      'leave': null,
      'start_date': null,
      'end_date': null,
      'reason': '',
    });
  }

  Future<void> _submitTimeOff() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;
      final selectedValue = formData['leave'] as String?;
      final startDate = formData['start_date'] as DateTime?;
      final endDate = formData['end_date'] as DateTime?;
      final reason = formData['reason'] as String?;

      log('Submitting leave - Selected Value: $selectedValue, Start Date: $startDate, End Date: $endDate, Reason: $reason');

      if (selectedValue == null || selectedValue.isEmpty) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Please select a leave type',
          SnackbarType.error,
        );
        return;
      }

      if (startDate == null || endDate == null) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Please select both start and end dates',
          SnackbarType.error,
        );
        return;
      }

      if (reason == null || reason.isEmpty) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Please provide a reason for your time off',
          SnackbarType.error,
        );
        return;
      }

      if (!_validateLeaveRequest(selectedValue, startDate, endDate)) {
        return;
      }

      final profileId = profilecontroller.profile.first.id != 0
          ? profilecontroller.profile.first.id
          : box.read('profile_id');
      if (profileId == null || profileId == 0) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Profile information not found. Please select an organization first.',
          SnackbarType.error,
        );
        Get.toNamed('/select-organization');
        return;
      }

      try {
        if (policycontroller.policy.isEmpty) {
          SSnackbarUtil.showFadeSnackbar(
            Get.context!,
            'No leave policies available. Please try again later.',
            SnackbarType.error,
          );
          return;
        }
        final selectedPolicy = policycontroller.policy.firstWhere(
          (policy) => policy.name?.toLowerCase() == selectedValue.toLowerCase(),
        );

        // Convert dates to ISO format
        final startDateIso = DateFormat('yyyy-MM-dd').format(startDate);
        final endDateIso = DateFormat('yyyy-MM-dd').format(endDate);

        // Debug log the complete request data
        log('Submitting timeoff with:');
        log('Profile ID: $profileId');
        log('Type ID: ${selectedPolicy.id}');
        log('Start Date: $startDateIso');
        log('End Date: $endDateIso');
        log('Reason: $reason');

        // Call the API via the controller
        await timeoffcontroller.createtimeoff(
          profile: profileId,
          type: selectedPolicy.id,
          startdate: startDateIso,
          enddate: endDateIso,
          reason: reason,
        );

        // Reload user leave data after successful submission
        await _loadUserLeaveData();

        // Clear the form after submission
        _clearForm();

        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back();
      } catch (e) {
        log('Error submitting time off: $e');
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Failed to submit time off request. Please try again.',
          SnackbarType.error,
        );
      }
    } else {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Please correct the errors in the form',
        SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final ThemeData datePickerTheme = isDarkMode
        ? ThemeData.dark().copyWith(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 12.0, color: Colors.white),
              bodyMedium: TextStyle(fontSize: 12.0, color: Colors.white),
            ),
            dialogBackgroundColor: Colors.grey[900],
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Colors.white,
              background: Colors.black,
            ),
          )
        : ThemeData.light().copyWith(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 11.0, color: Colors.black),
              bodyMedium: TextStyle(fontSize: 11.0, color: Colors.black),
            ),
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              background: Colors.white,
            ),
          );

    return SafeArea(
      top: false,
      child: Scaffold(
        // appBar: const ConstantAppBar(),
        body: RefreshIndicator(
          color: Colors.cyan,
          onRefresh: () async {
            await _loadUserLeaveData();
          },
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button and title
                      InkWell(
                        onTap: () => Get.back(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.arrow_back_sharp,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            const SizedBox(width: 15.0),
                            Text(
                              'Add Time Off',
                              style: smallNStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Display user leave balance info
                      Obx(() {
                        if (_userLeaveData.value == null) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.cyan,
                          ));
                        }

                        final leavePolicies =
                            _userLeaveData.value!['leave_policies'] as List? ??
                                [];

                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: isDarkMode
                                ? Colors.grey.shade800
                                : Colors.blue.shade50,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.blue.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Leave Balance',
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              if (leavePolicies.isEmpty)
                                Text(
                                  'No leave policies available',
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontSize: 12.0,
                                  ),
                                )
                              else
                                ...leavePolicies.map((policy) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '${policy['policy_name']}: ${policy['remaining_leave'].toInt()} days remaining',
                                      style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black87,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20.0),

                      // Time Off Type Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Time Off Type  ',
                                  style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontFamily: 'Mukta',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Obx(() {
                            if (_userLeaveData.value == null) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.cyan,
                              ));
                            }
                            final leavePolicies = _userLeaveData
                                    .value!['leave_policies'] as List? ??
                                [];
                            log('Available policies in dropdown: ${leavePolicies.map((p) => p['policy_name']).toList()}');

                            return FormBuilderField(
                              name: 'leave',
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a leave type';
                                }
                                return null;
                              },
                              initialValue: _selectedValue.value,
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    errorText: field.errorText,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  child: DropdownButtonFormField2<String>(
                                    value: field.value ?? _selectedValue.value,
                                    onChanged: (value) {
                                      _selectedValue.value = value;
                                      field.didChange(value);
                                    },
                                    isExpanded: true,
                                    items: leavePolicies.map((policy) {
                                      final policyName =
                                          policy['policy_name'].toString();
                                      final remainingLeave =
                                          _getRemainingLeave(policyName);
                                      return DropdownMenuItem<String>(
                                        value: policyName,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              policyName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            Text(
                                              '(${remainingLeave.toInt()} days)',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: remainingLeave > 0
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    buttonStyleData: ButtonStyleData(
                                      height: 45.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(color: Colors.black),
                                        color: isDarkMode
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade50,
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 300,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: isDarkMode
                                            ? Colors.grey.shade800
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 12.0),

                      // Start Date Picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Start Date  ',
                                  style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontFamily: 'Mukta',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 50.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade50,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color:
                                        isDarkMode ? Colors.grey : Colors.black,
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Theme(
                                      data: datePickerTheme,
                                      child: FormBuilderDateTimePicker(
                                        name: 'start_date',
                                        initialValue: _startDate.value,
                                        decoration: InputDecoration(
                                          hintText: 'Start Date',
                                          hintStyle: smallStyle.copyWith(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        inputType: InputType.date,
                                        onChanged: (value) {
                                          setState(() {
                                            _startDate.value = value;
                                            // Immediately reset end date if it's before start date
                                            if (_endDate.value != null &&
                                                value != null &&
                                                _endDate.value!
                                                    .isBefore(value)) {
                                              _endDate.value = null;
                                              _formKey.currentState
                                                  ?.fields['end_date']
                                                  ?.didChange(null);
                                            }
                                            // Force rebuild to enable end date picker immediately
                                            _formKey.currentState
                                                ?.fields['end_date']
                                                ?.reset();
                                          });
                                        },
                                        firstDate: DateTime.now(),
                                        initialDate: DateTime.now(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),

                      // End Date Picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'End Date  ',
                                  style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontFamily: 'Mukta',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 50.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade50,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color:
                                        isDarkMode ? Colors.grey : Colors.black,
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Theme(
                                      data: datePickerTheme,
                                      child: FormBuilderDateTimePicker(
                                        name: 'end_date',
                                        initialValue: _endDate.value,
                                        decoration: InputDecoration(
                                          hintText: 'End Date',
                                          hintStyle: smallStyle.copyWith(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        inputType: InputType.date,
                                        enabled: _startDate.value != null,
                                        onChanged: (value) {
                                          _endDate.value = value;
                                        },
                                        firstDate:
                                            _startDate.value ?? DateTime.now(),
                                        initialDate: _startDate.value?.add(
                                                const Duration(days: 1)) ??
                                            DateTime.now(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Show requested days and remaining balance
                      Obx(() {
                        if (_startDate.value != null &&
                            _endDate.value != null &&
                            _selectedValue.value != null) {
                          return Column(
                            children: [
                              const SizedBox(height: 10.0),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade100,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Requested: ${_calculateLeaveDays(_startDate.value!, _endDate.value!)} days',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      'Available: ${_getRemainingLeave(_selectedValue.value!).toInt()} days',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: _calculateLeaveDays(
                                                    _startDate.value!,
                                                    _endDate.value!) <=
                                                _getRemainingLeave(
                                                    _selectedValue.value!)
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 12.0),

                      // Reason TextField
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Reason  ',
                                  style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontFamily: 'Mukta',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 140.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.0),
                              color: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade50,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FormBuilderTextField(
                                name: 'reason',
                                controller: _reasonController,
                                maxLines: 8,
                                style: smallStyle.copyWith(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: "Write Your Reason",
                                  hintStyle: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                },
                                onChanged: (value) {
                                  int lineCount =
                                      '\n'.allMatches(value ?? '').length + 1;
                                  const maxAllowedLines = 5;
                                  if (lineCount > maxAllowedLines) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),

                      // Clear and Save Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 8.0),
                              child: InkWell(
                                onTap: _clearForm,
                                child: Container(
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.grey.shade500,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sort,
                                        color: isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        "Clear",
                                        style: smallStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 16.0),
                              child: TapDebouncer(
                                cooldown: const Duration(seconds: 2),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  await _submitTimeOff();
                                },
                                builder: (BuildContext context,
                                    TapDebouncerFunc? onTap) {
                                  return InkWell(
                                    onTap: onTap,
                                    child: Container(
                                      height: 45.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: isDarkMode
                                            ? Colors.grey.shade600
                                            : Colors.black,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.save_outlined,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5.0),
                                          Text(
                                            "Request",
                                            style: smallStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
