import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/widget/button_large.dart';
import 'package:ams/feature/presentation/widget/custom_textfield.dart';
import 'package:ams/feature/utils/validator.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldpw = TextEditingController();
  final newpw = TextEditingController();
  final confirmpw = TextEditingController();

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
            padding: EdgeInsets.all(16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  label: "Old Password",
                  // hint: "Old Password",
                  textEditingController: oldpw,
                  validator: (string) =>
                      Validator.validateIsEmpty(string: string ?? ""),
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: "New Password",
                  textEditingController: newpw,
                  validator: (string) =>
                      Validator.validateIsEmpty(string: string ?? ""),
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: "Confirm Password",
                  textEditingController: confirmpw,
                  validator: (string) =>
                      Validator.validateIsEmpty(string: string ?? ""),
                  isPassword: true,
                ),
                const SizedBox(height: 80.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
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
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                "Clear",
                                style: smallStyle.copyWith(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
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
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "Update",
                                style: smallStyle.copyWith(
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                ),
                              ),
                            ],
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
