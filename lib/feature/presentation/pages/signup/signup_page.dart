import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/widget/button_large.dart';
import 'package:ams/feature/presentation/widget/custom_textfield.dart';
import 'package:ams/feature/utils/validator.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final email = TextEditingController();

  final pw = TextEditingController();

  final cPw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor: AppColors.onPrimary,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 366,
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
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Center(
                        //   child: SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.2,
                        //     width: MediaQuery.of(context).size.width * 0.8,
                        //     child: AspectRatio(
                        //       aspectRatio: 1,
                        //       // child: Image.asset(AppImages.appLogo),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 50.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Sign up to",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Tranquility Spa",
                              style: mediumStyle.copyWith(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Fill the credentials below to login into Tranquility Spa",
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const SizedBox(height: 80.0),
                        CustomTextField(
                          hint: "Email",
                          textEditingController: email,
                          validator: (string) =>
                              Validator.validateEmail(string: string ?? ""),
                        ),
                        const SizedBox(height: 16.0),
                        CustomTextField(
                          hint: "Password",
                          textEditingController: pw,
                          validator: (string) =>
                              Validator.validateIsEmpty(string: string ?? ""),
                          isPassword: true,
                        ),
                        const SizedBox(height: 16.0),

                        CustomTextField(
                          hint: "Confirm Password",
                          textEditingController: cPw,
                          validator: (string) =>
                              Validator.validateIsEmpty(string: string ?? ""),
                          isPassword: true,
                        ),
                        const SizedBox(height: 24.0),
                        Material(
                          borderRadius: BorderRadius.circular(8.0),
                          color:
                              isDarkMode ? Colors.grey.shade700 : Colors.black,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => BottomNavPage(),
                              //   ),
                              // );
                            },
                            child: const LargeButton(title: "Sign up"),
                          ),
                        ),
                        const SizedBox(height: 200.0),
                        Image.asset("assets/images/logo.png"),
                        const SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: smallStyle.copyWith(color: AppColors.grey),
                            ),
                            const SizedBox(width: 4.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: smallStyle.copyWith(
                                  color: isDarkMode
                                      ? Colors.blueAccent
                                      : AppColors.primary,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 350.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 370.0,
                bottom: 3.0,
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
