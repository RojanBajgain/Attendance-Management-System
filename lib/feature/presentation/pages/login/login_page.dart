import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_image_brand_controller.dart';
import 'package:ams/feature/presentation/pages/forget_password/forget_password.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/widget/button_large.dart';
import 'package:ams/feature/presentation/widget/custom_textfield.dart';
import 'package:ams/feature/presentation/widget/loading_animation_widget.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:ams/feature/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool keepMeLoggedIn = false;
  bool _showBiometricOption = false;

  final email = TextEditingController();
  final pw = TextEditingController();
  final String _defaultRole = 'Staff'; // Default role for login

  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
    // _checkBiometricAvailability();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email') ?? '';
    if (savedEmail.isNotEmpty) {
      setState(() {
        email.text = savedEmail;
      });
    }
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  // Future<void> _checkBiometricAvailability() async {
  //   try {
  //     bool deviceSupported = await authController.canUseBiometrics();
  //     if (!deviceSupported) {
  //       setState(() {
  //         _showBiometricOption = false;
  //       });
  //       return;
  //     }

  //     final prefs = await SharedPreferences.getInstance();
  //     final isBiometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;
  //     final secureBiometrics =
  //         await authController.secureStorage.read(key: 'biometrics_enabled');
  //     final isSecureBiometricsEnabled = secureBiometrics == 'true';

  //     final hasCredentials = await authController.hasSavedCredentials();

  //     setState(() {
  //       _showBiometricOption =
  //           (isBiometricsEnabled || isSecureBiometricsEnabled) &&
  //               hasCredentials;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _showBiometricOption = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: Stack(
          // overflow: Overflow.visible,
          alignment: const FractionalOffset(.5, 1.0),
          children: [
            Container(
              height: 10,
              // color: lightcolor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                '© 2025. All Rights Reserved \nProduct of Ayata Inc.',
                textAlign: TextAlign.center,
                style: miniStyle.copyWith(fontSize: 10, color: Colors.grey),
              ),
            )
          ],
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
                      Image.asset(
                        AppImages.logo,
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
                          Expanded(
                            child: Text(
                              "Fill the credentials below to login into AYATA",
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
                                width: 24.0,
                                child: Checkbox(
                                  value: keepMeLoggedIn,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      keepMeLoggedIn = value ?? false;
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
                          GestureDetector(
                            onTap: () {
                              Get.off(() => const ForgetPassword());
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
                                          FocusScope.of(context).unfocus();

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

                                          if (email.text.isNotEmpty) {
                                            _saveEmail(email.text);
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
                                            keepMeLoggedIn,
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
    );
  }

  @override
  void dispose() {
    email.dispose();
    pw.dispose();
    super.dispose();
  }
}
