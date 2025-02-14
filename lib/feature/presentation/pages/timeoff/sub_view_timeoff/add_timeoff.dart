import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/policy/controller/policy_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTimeoff extends StatefulWidget {
  const AddTimeoff({
    super.key,
  });

  @override
  _AddTimeoffState createState() => _AddTimeoffState();
}

class _AddTimeoffState extends State<AddTimeoff> {
  final authcontroller = Get.find<AuthController>();
  final PolicyController policycontroller =
      Get.put(PolicyController(policyrepo: Get.find()));
  final TimeoffController timeoffcontroller =
      Get.put(TimeoffController(timeoffRepo: Get.find()));
  final ProfileController profilecontroller =
      Get.put(ProfileController(profileRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    policycontroller.getPolicydetail();
  }

  String? _selectedValue;
  DateTime? _startDate;
  DateTime? _endDate;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitTimeOff() async {
    // Validate inputs
    if (_selectedValue == null ||
        _startDate == null ||
        _endDate == null ||
        _reasonController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Convert DateTime to ISO 8601 strings
    final startDateIso = DateFormat('yyyy-MM-dd').format(_startDate!);
    final endDateIso = DateFormat('yyyy-MM-dd').format(_endDate!);

    // Get the selected policy ID
    final selectedPolicy = policycontroller.policy.firstWhere(
      (policy) => policy.name == _selectedValue,
      orElse: () => throw Exception('Policy not found'),
    );

    // Call the API via the controller
    await timeoffcontroller.createtimeoff(
      // userID: profilecontroller.profiledetail.value.id,
      userID: authcontroller.alluserData.value.user!.profileId,
      typeID: selectedPolicy.id,
      startdate: startDateIso,
      enddate: endDateIso,
      reason: _reasonController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
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
                  ],
                ),
                const SizedBox(height: 10.0),
                Obx(() {
                  final policyData = policycontroller.policy;
                  return Container(
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
                      padding: const EdgeInsets.only(left: 10.0),
                      child: FormBuilderDropdown<String>(
                        name: 'leave',
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                        hint: Text(
                          'Select',
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: isDarkMode ? Colors.white : Colors.black),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        items: policyData.isNotEmpty
                            ? policyData
                                .map<DropdownMenuItem<String>>((policy) {
                                return DropdownMenuItem<String>(
                                  value: policy.name.toString(),
                                  child: Text(
                                    policy.name.toString(),
                                  ),
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12.0),

                // Start Date Picker
                Column(
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
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color:
                        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
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
                            data: Theme.of(context).copyWith(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                bodyMedium: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            child: FormBuilderDateTimePicker(
                              name: 'start_date',
                              decoration: InputDecoration(
                                hintText: 'Start Date',
                                hintStyle: smallStyle.copyWith(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),

                // End Date Picker
                Column(
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
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color:
                        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
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
                            data: Theme.of(context).copyWith(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                bodyMedium: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            child: FormBuilderDateTimePicker(
                              name: 'end_date',
                              decoration: InputDecoration(
                                hintText: 'End Date',
                                hintStyle: smallStyle.copyWith(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              inputType: InputType.date,
                              onChanged: (value) {
                                setState(() {
                                  _endDate = value;
                                });
                              },
                              firstDate: DateTime.now(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),

                // Reason TextField
                Column(
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
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color:
                        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
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
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),

                // Clear and Save Buttons
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 105.0),
                      child: Container(
                        height: 45.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sort,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "Clear",
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    InkWell(
                      onTap: _submitTimeOff,
                      child: Container(
                        height: 45.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color:
                              isDarkMode ? Colors.grey.shade600 : Colors.black,
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
                              "Save",
                              style: smallStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
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
    );
  }
}
