import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_brand_controller.dart';
import 'package:ams/feature/presentation/pages/forget_password/forget_password.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/widget/button_large.dart';
import 'package:ams/feature/presentation/widget/custom_textfield.dart';
import 'package:ams/feature/presentation/widget/loading_animation_widget.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:ams/feature/utils/validator.dart';
import 'package:ams/services/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  // bool _showBiometricOption = false;

  final email = TextEditingController();
  final pw = TextEditingController();
  final String _defaultRole = 'Staff'; // Default role for login

  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email') ?? '';
    if (savedEmail.isNotEmpty) {
      setState(() {
        email.text = savedEmail;
        rememberMe = true;
      });
    }
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  Future<void> _removeEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          bottomNavigationBar: SizedBox(
            height: 40,
            // color: lightcolor,
            child: Column(
              children: [
                Text(
                  '© 2025 iHRTrack. All Rights Reserved',
                  style: miniStyle.copyWith(fontSize: 11, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Product of ",
                      style:
                          miniStyle.copyWith(fontSize: 11, color: Colors.grey),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Helpers.launchWebsite();
                        },
                        splashColor: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Text(
                              "Ayata Inc",
                              style: miniStyle.copyWith(
                                // decoration: TextDecoration.underline,
                                fontSize: 11,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 12,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                // Positioned(
                //   right: 366,
                //   child: Container(
                //     height: 275,
                //     width: 275,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: isDarkMode
                //           ? Colors.grey.shade700
                //           : Colors.grey.shade300,
                //     ),
                //   ),
                // ),
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SvgPicture.asset(
                          AppImages.appLogoHR,
                          height: 50,
                          // color: Colors.lightBlue,
                        ),
                        const SizedBox(height: 60.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to",
                              style: mediumStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "iHRTrack",
                              style: mediumStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Fill the credentials below to login into iHRTrack",
                                style: smallStyle.copyWith(
                                  fontSize: 13,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50.0),
                        CustomTextField(
                          hint: "Email",
                          textEditingController: email,
                          validator: (string) =>
                              Validator.validateEmail(string: string ?? ""),
                        ),
                        const SizedBox(height: 12.0),
                        CustomTextField(
                          hint: "Password",
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
                                  width: 28.0,
                                  child: Checkbox(
                                    activeColor: Colors.lightBlue,
                                    value: rememberMe,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  "Remember me",
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const ForgetPassword());
                              },
                              child: Text(
                                "Forget your password?",
                                style: smallStyle.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => Material(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.black,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.0),
                                    onTap: authController.authIsLoading.value
                                        ? null
                                        : () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());

                                            final emailError =
                                                Validator.validateEmail(
                                                    string: email.text);
                                            final passwordError =
                                                Validator.validateIsEmpty(
                                                    string: pw.text);
                                            if (emailError != null ||
                                                passwordError != null) {
                                              SSnackbarUtil.showFadeSnackbar(
                                                Get.context!,
                                                emailError ?? passwordError!,
                                                SnackbarType.error,
                                              );
                                              return;
                                            }

                                            // Handle remember me functionality
                                            if (rememberMe &&
                                                email.text.isNotEmpty) {
                                              _saveEmail(email.text);
                                            } else {
                                              _removeEmail();
                                            }

                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) =>
                                                  const CombinedAnimatedDialog(),
                                            );

                                            authController.loginMethod(
                                              email.text,
                                              pw.text,
                                              _defaultRole,
                                              false, // Pass false since we're not keeping user logged in
                                            );
                                          },
                                    child: const LargeButton(title: "Log in"),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(width: 16.0),
                            // Container(
                            //   height: 55,
                            //   width: 55,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(12.0),
                            //     color: isDarkMode
                            //         ? Colors.grey.shade700
                            //         : Colors.black,
                            //   ),
                            //   child: Obx(
                            //     () => authController.authIsLoading.value
                            //         ? const Center(
                            //             child: SizedBox(
                            //               width: 24,
                            //               height: 24,
                            //               child: CircularProgressIndicator(
                            //                 valueColor:
                            //                     AlwaysStoppedAnimation<Color>(
                            //                         Colors.white),
                            //                 strokeWidth: 2.0,
                            //               ),
                            //             ),
                            //           )
                            //         : IconButton(
                            //             icon: const Icon(
                            //               Icons.fingerprint,
                            //               size: 30,
                            //               color: Colors.white,
                            //             ),
                            //             onPressed: () {
                            //               authController.loginWithBiometrics();
                            //             },
                            //           ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   left: 370.0,
                //   bottom: 20.0,
                //   child: Container(
                //     height: 275,
                //     width: 275,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: isDarkMode
                //           ? Colors.grey.shade700
                //           : Colors.grey.shade300,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    pw.dispose();
    super.dispose();
  }
}
