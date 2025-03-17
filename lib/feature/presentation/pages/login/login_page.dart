import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/forget_password/forget_password.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/signup/signup_page.dart';
import 'package:ams/feature/presentation/widget/button_large.dart';
import 'package:ams/feature/presentation/widget/custom_textfield.dart';
import 'package:ams/feature/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool keepMeLoggedIn = false;

  final email = TextEditingController();
  final pw = TextEditingController();

  final authcontroller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: 366,
                child: Container(
                  height: 275,
                  width: 275,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "AYATA",
                            style: mediumStyle.copyWith(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Fill the credentials below to login into AYATA",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 100.0),
                      CustomTextField(
                        hint: "Email",
                        // icon: Icon(Icons.mail),
                        textEditingController: email,
                        validator: (string) =>
                            Validator.validateEmail(string: string ?? ""),
                      ),
                      const SizedBox(height: 12.0),
                      CustomTextField(
                        hint: "Password",
                        // icon: Icon(Icons.key),
                        textEditingController: pw,
                        validator: (string) =>
                            Validator.validateIsEmpty(string: string ?? ""),
                        isPassword: true,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 24.0,
                                width: 24.0,
                                child: Checkbox(
                                  value: keepMeLoggedIn,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      keepMeLoggedIn = value ?? true;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                "Keep me logged in",
                                style: smallStyle.copyWith(
                                  color: isDarkMode
                                      ? Colors.blue
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 35.0),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ForgetPassword());
                            },
                            child: Text(
                              "Forget your password?",
                              style: smallStyle.copyWith(
                                color: Colors.redAccent,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Material(
                        borderRadius: BorderRadius.circular(12.0),
                        color: isDarkMode ? Colors.grey.shade700 : Colors.black,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            authcontroller.loginMethod(
                                email.text, pw.text, keepMeLoggedIn);
                          },
                          child: const LargeButton(title: "Log in"),
                        ),
                      ),
                      const SizedBox(height: 250),
                      Image.asset("assets/images/logo.png"),
                      // const SizedBox(height: 50.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Don’t have an account? ",
                      //       style: smallStyle.copyWith(
                      //         color: isDarkMode ? Colors.white : AppColors.grey,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 4.0),
                      //     GestureDetector(
                      //       onTap: () {
                      //         Get.to(() => SignupPage());
                      //       },
                      //       child: Text(
                      //         "Sign Up",
                      //         style: smallStyle.copyWith(
                      //           color: isDarkMode
                      //               ? Colors.blue
                      //               : AppColors.primary,
                      //           // decoration: TextDecoration.underline,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 300.0),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 370.0,
                bottom: 20.0,
                child: Container(
                  height: 275,
                  width: 275,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
