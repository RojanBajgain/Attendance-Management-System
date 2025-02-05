import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/widget/custom_textfield.dart';
import 'package:ams/feature/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final authcontroller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'Change Password',
            style: smallStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  label: "Old Password",
                  // hint: "Old Password",
                  textEditingController: oldPassword,
                  validator: (string) =>
                      Validator.validateIsEmpty(string: string ?? ""),
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: "New Password",
                  textEditingController: newPassword,
                  validator: (string) =>
                      Validator.validateIsEmpty(string: string ?? ""),
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: "Confirm Password",
                  textEditingController: confirmPassword,
                  validator: (string) =>
                      Validator.validateIsEmpty(string: string ?? ""),
                  isPassword: true,
                ),
                const SizedBox(height: 80.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          oldPassword.clear();
                          newPassword.clear();
                          confirmPassword.clear();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sort,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  "Clear",
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          authcontroller.changePasswordmethod(oldPassword.text,
                              newPassword.text, confirmPassword.text);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkMode ? Colors.white : Colors.black,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.rate_review,
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  "Update",
                                  style: smallStyle.copyWith(
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
                    )
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
