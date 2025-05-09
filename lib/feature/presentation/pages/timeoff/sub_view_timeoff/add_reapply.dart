import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/policy/controller/policy_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddReapplyPage extends StatefulWidget {
  final int id;

  const AddReapplyPage({
    super.key,
    required this.id,
  });

  @override
  _AddReapplyPageState createState() => _AddReapplyPageState();
}

class _AddReapplyPageState extends State<AddReapplyPage> {
  final authcontroller = Get.find<AuthController>();
  final TimeoffController timeoffcontroller = Get.put(TimeoffController());

  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(
      () {
        _reasonController.clear();

        if (_formKey.currentState != null) {
          _formKey.currentState!.reset();

          _formKey.currentState!.fields['leave']?.reset();
        }

        // Get.snackbar(
        //   'Form Cleared',
        //   'All fields have been reset.',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      },
    );
  }

  Future<void> _submitReapply() async {
    if (_reasonController.text.isEmpty) {
      SSnackbarUtil.showSnackbar(
        'Required',
        'Please fill in the reason field',
        SnackbarType.error,
      );

      return;
    }

    try {
      // Call the API via the controller
      await timeoffcontroller.reapply(
        id: widget.id, // Use the passed id
        reason: _reasonController.text,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
                InkWell(
                  onTap: () => Get.back(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_sharp,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        'Submit a new Reason',
                        style: smallNStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 105.0),
                      child: InkWell(
                        onTap: _clearForm,
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
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    InkWell(
                      onTap: _submitReapply,
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
                              "Re-Apply",
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
