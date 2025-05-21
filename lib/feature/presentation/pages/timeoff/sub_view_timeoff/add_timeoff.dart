import 'dart:developer';

import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/policy/controller/policy_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
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
  final ProfileController profilecontroller = Get.put(ProfileController());
  GetStorage box = GetStorage();

  // Form key for FormBuilder
  final _formKey = GlobalKey<FormBuilderState>();

  // Controllers and state variables
  final _reasonController = TextEditingController();
  String? _selectedValue;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    policycontroller.getPolicydetail();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  // Method to clear the form
  void _clearForm() {
    setState(() {
      // Clear state variables
      _selectedValue = null;
      _startDate = null;
      _endDate = null;
      _reasonController.clear();

      // Reset FormBuilder state
      _formKey.currentState?.reset();

      // Explicitly clear form field values to ensure UI sync
      _formKey.currentState?.patchValue({
        'leave': null,
        'start_date': null,
        'end_date': null,
        'reason': '',
      });
    });
  }

  Future<void> _submitTimeOff() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;
      final selectedValue = formData['leave'] as String?;
      final startDate = formData['start_date'] as DateTime?;
      final endDate = formData['end_date'] as DateTime?;
      final reason = formData['reason'] as String?;

      // Debug logs
      log('Selected Value: $selectedValue');
      log('Start Date: $startDate');
      log('End Date: $endDate');
      log('Reason: $reason');

      // Validate all required fields
      if (selectedValue == null || selectedValue.isEmpty) {
        SSnackbarUtil.showSnackbar(
          'Missing Leave Type',
          'Please select a leave type',
          SnackbarType.error,
        );
        return;
      }

      if (startDate == null) {
        SSnackbarUtil.showSnackbar(
          'Missing Start Date',
          'Please select a start date',
          SnackbarType.error,
        );
        return;
      }

      if (endDate == null) {
        SSnackbarUtil.showSnackbar(
          'Missing End Date',
          'Please select an end date',
          SnackbarType.error,
        );
        return;
      }

      if (reason == null || reason.isEmpty) {
        SSnackbarUtil.showSnackbar(
          'Missing Reason',
          'Please provide a reason for your time off',
          SnackbarType.error,
        );
        return;
      }

      // Get profile ID directly from ProfileController
      final profileId = profilecontroller.profile.first.id != 0
          ? profilecontroller.profile.first.id
          : box.read('profile_id');
      if (profileId == null || profileId == 0) {
        SSnackbarUtil.showSnackbar(
          'Error',
          'Profile information not found. Please select an organization first.',
          SnackbarType.error,
        );
        Get.toNamed(
            '/select-organization'); // Redirect to organization selection
        return;
      }

      // Find selected policy with null check
      try {
        if (policycontroller.policy.isEmpty) {
          SSnackbarUtil.showSnackbar(
            'Error',
            'No leave policies available. Please try again later.',
            SnackbarType.error,
          );
          return;
        }
        final selectedPolicy = policycontroller.policy.firstWhere(
          (policy) => policy.name == selectedValue,
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
      } catch (e) {
        log('Error finding policy: $e');
        SSnackbarUtil.showSnackbar(
          'Error',
          'Failed to find leave policy. Please try again.',
          SnackbarType.error,
        );
      }
    } else {
      SSnackbarUtil.showSnackbar(
        'Validation Failed',
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

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: SingleChildScrollView(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),

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
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontFamily: 'Mukta',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Obx(() {
                        final policyData = policycontroller.policy.value;
                        return FormBuilderField(
                          name: 'leave',
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a leave type';
                            }
                            return null;
                          },
                          initialValue: _selectedValue,
                          builder: (FormFieldState<dynamic> field) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                errorText: field.errorText,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              child: DropdownButtonFormField2<String>(
                                value: field.value ?? _selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedValue = value;
                                  });
                                  field.didChange(value);
                                },
                                isExpanded: true,
                                items: policyData.map((policy) {
                                  return DropdownMenuItem<String>(
                                    value: policy.name.toString(),
                                    child: Text(
                                      policy.name.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.0),
                                    border: Border.all(color: Colors.black),
                                    color: isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade50,
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.0),
                                    color: isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })
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
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontFamily: 'Mukta',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
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
                          borderRadius: BorderRadius.circular(13.0),
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade50,
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: isDarkMode ? Colors.grey : Colors.black,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Theme(
                                  data: datePickerTheme,
                                  child: FormBuilderDateTimePicker(
                                    name: 'start_date',
                                    initialValue: _startDate,
                                    decoration: InputDecoration(
                                      hintText: 'Start Date',
                                      hintStyle: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    inputType: InputType.date,
                                    onChanged: (value) {
                                      setState(() {
                                        _startDate = value;
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
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontFamily: 'Mukta',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
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
                          borderRadius: BorderRadius.circular(13.0),
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade50,
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: isDarkMode ? Colors.grey : Colors.black,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Theme(
                                  data: datePickerTheme,
                                  child: FormBuilderDateTimePicker(
                                    name: 'end_date',
                                    initialValue: _endDate,
                                    decoration: InputDecoration(
                                      hintText: 'End Date',
                                      hintStyle: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    inputType: InputType.date,
                                    enabled: _startDate != null,
                                    onChanged: (value) {
                                      setState(() {
                                        _endDate = value;
                                      });
                                    },
                                    firstDate: _startDate ?? DateTime.now(),
                                    initialDate:
                                        _startDate?.add(Duration(days: 1)) ??
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
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontFamily: 'Mukta',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 180.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade50,
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FormBuilderTextField(
                            name: 'reason',
                            controller: _reasonController,
                            maxLines: 8,
                            style: smallStyle.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: "Write Your Reason",
                              hintStyle: smallStyle.copyWith(
                                color: isDarkMode ? Colors.white : Colors.black,
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
                  const SizedBox(height: 40.0),

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
                              _submitTimeOff();
                            },
                            builder: (BuildContext context,
                                TapDebouncerFunc? onTap) {
                              return InkWell(
                                onTap: onTap,
                                child: Container(
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.black,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
