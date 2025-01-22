import 'package:ams/feature/presentation/pages/login/login.dart';
import 'package:ams/feature/presentation/widget/components/password_text_field.dart';
import 'package:ams/feature/presentation/widget/components/text_form_builder.dart';
import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
import 'package:ams/feature/presentation/pages/screens/mainscreen.dart';
// import 'package:ams/utils/validation.dart';
import 'package:ams/view_models/auth/register_view_model.dart';
import 'package:ams/widgets/indicators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
        return false;
      },
      child: LoadingOverlay(
        progressIndicator: circularProgress(context),
        isLoading: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey2,
          backgroundColor: Colors.white,
          body: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              // Center(
              //   child: Image.asset(
              //     'assets/images/logo.png',
              //     height: 50.0,
              //   ),
              // ),
              // const SizedBox(height: 20.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Signup to ',
                      style: TextStyle(
                        fontFamily: 'Mukta',
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                        color: Colors.grey[500],
                      ),
                    ),
                    const TextSpan(
                      text: 'AYATA',
                      style: TextStyle(
                        fontFamily: 'Mukta',
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Fill the credentials below to login into ',
                      style: TextStyle(
                        fontFamily: 'Mukta',
                        fontWeight: FontWeight.w600,
                        // fontSize: 25.0,
                        color: Colors.grey[500],
                      ),
                    ),
                    TextSpan(
                      text: 'AYATA',
                      style: TextStyle(
                        fontFamily: 'Mukta',
                        fontWeight: FontWeight.w600,
                        // fontSize: 25.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70.0),
              buildForm(viewModel, context),
              const SizedBox(height: 200.0),
              Container(
                height: 35.0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Widget buildForm(RegisterViewModel viewModel, BuildContext context) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.mail,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateEmail,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.passFN,
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validatePassword,
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
            nextFocusNode: viewModel.cPassFN,
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed,
            hintText: "Confirm Password",
            textInputAction: TextInputAction.done,
            validateFunction: Validations.validatePassword,
            submitAction: () => viewModel.register(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setConfirmPass(val);
            },
            focusNode: viewModel.cPassFN,
          ),
          const SizedBox(height: 30.0),
          Container(
            height: 45.0,
            width: 350.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.black,
                ),
              ),
              child: Text(
                'sign up'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => viewModel.register(context),
            ),
          ),
        ],
      ),
    );
  }
}
 */

  Widget buildForm(RegisterViewModel viewModel, BuildContext context) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode:
          AutovalidateMode.disabled, // Disable automatic validation
      child: Column(
        children: [
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.mail,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            onSaved: (String val) {
              viewModel.setEmail(val); // Save value without validation
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.passFN,
          ),
          const SizedBox(height: 20.0),
          /* PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            textInputAction: TextInputAction.next,
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val); // Save value without validation
            },
            focusNode: viewModel.passFN,
            nextFocusNode: viewModel.cPassFN,
          ), */
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed,
            suffix: Ionicons.eye_off_outline,
            hintText: "Password",
            textInputAction: TextInputAction.next,
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
            nextFocusNode: viewModel.cPassFN,
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed,
            suffix: Ionicons.eye_off_outline,
            hintText: "Confirm Password",
            textInputAction: TextInputAction.done,
            submitAction: () => viewModel.register(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setConfirmPass(val); // Save value without validation
            },
            focusNode: viewModel.cPassFN,
          ),
          // PasswordFormBuilder(
          //   enabled: !viewModel.loading,
          //   prefix: Ionicons.lock_closed,
          //   suffix: Ionicons.eye_off_outline,
          //   hintText: "Confirm Password",
          //   textInputAction: TextInputAction.done,
          //   obscureText: true,
          //   onSaved: (String val) {
          //     viewModel.setPassword(val);
          //   },
          //   focusNode: viewModel.passFN,
          // ),
          const SizedBox(height: 30.0),
          Container(
            height: 45.0,
            width: 350.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.black,
                ),
              ),
              child: Text(
                'sign up'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // onPressed: () => viewModel.register(context),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TabScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
