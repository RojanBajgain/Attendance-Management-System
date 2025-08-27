import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/forget_password/controller/reset_password_controller.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/widget/button_large.dart';
import 'package:ams/feature/presentation/widget/custom_textfield.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:ams/feature/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final ResetPasswordController resetpassword =
      Get.put(ResetPasswordController(resetpasswordrepo: Get.find()));

  final email = TextEditingController();

  Future<void> _submitresetpassword() async {
    if (email.text.isEmpty) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Please fill the required field.',
        SnackbarType.info,
      );
    }
    await resetpassword.resetpassword(email: email.text);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          titleSpacing: 0,
          elevation: 0,
          // leading: InkWell(
          //   onTap: () => Get.back(),
          //   child: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.grey,
          //   ),
          // ),
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Rest password',
              style: normalStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.0,
              ),
            ),
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
                      // const SizedBox(height: 50.0),
                      const SizedBox(height: 20),
                      SvgPicture.asset(
                        AppImages.appLogoHR,
                        height: 50,
                        // color: Colors.lightBlue,
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: Text(
                          "Forget Password",
                          style: mediumStyle.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Enter your valid Email address",
                          style: smallNStyle.copyWith(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      CustomTextField(
                        hint: "Email Address",
                        // icon: Icon(Icons.mail),
                        textEditingController: email,
                        validator: (string) =>
                            Validator.validateEmail(string: string ?? ""),
                      ),
                      const SizedBox(height: 15.0),
                      Material(
                        borderRadius: BorderRadius.circular(12.0),
                        color: isDarkMode ? Colors.grey.shade700 : Colors.black,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            _submitresetpassword();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: const LargeButton(title: "Confirm"),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remembered Your Password? ",
                            style: smallStyle.copyWith(
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () {
                              Get.off(() => const LoginPage());
                            },
                            child: Text(
                              "Login",
                              style: smallStyle.copyWith(
                                color: isDarkMode
                                    ? Colors.blue
                                    : AppColors.primary,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 500.0),
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
}
