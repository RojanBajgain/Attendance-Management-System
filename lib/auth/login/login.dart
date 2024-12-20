import 'dart:convert';

import 'package:ams/auth/register/register.dart';
import 'package:ams/components/password_text_field.dart';
import 'package:ams/components/text_form_builder.dart';
import 'package:ams/landing/landing_page.dart';
import 'package:ams/screens/mainscreen.dart';
// import 'package:ams/utils/validation.dart';
import 'package:ams/view_models/auth/login_view_model.dart';
import 'package:ams/widgets/indicators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  final Map? valid;

  const Login({super.key, this.valid});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = storage.read('token');
    if (token != null) {
      // Token Exists
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TabScreen()));
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

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
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          key: viewModel.scaffoldKey1,
          body: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            children: [
              // SizedBox(height: MediaQuery.of(context).size.height / 9),
              // Container(
              //   height: 35.0,
              //   width: MediaQuery.of(context).size.width,
              //   child: Image.asset(
              //     'assets/images/logo.png',
              //   ),
              // ),
              const SizedBox(
                height: 100.0,
                width: 20.0,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome to ',
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
                width: 20.0,
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
              const SizedBox(height: 100.0),
              // Form field validations and other here
              buildForm(context, viewModel),
              // Form field validations and other here
              const SizedBox(height: 200.0),
              Container(
                height: 35.0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              const SizedBox(height: 30.0),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => Register(),
                        ),
                      );
                    },
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ), */
            ],
          ),
        ),
      ),
    );
  }

  /* buildForm(BuildContext context, LoginViewModel viewModel) {
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
            suffix: Ionicons.eye,
            hintText: "Password",
            textInputAction: TextInputAction.done,
            validateFunction: Validations.validatePassword,
            submitAction: () => viewModel.login(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  Checkbox(
                    value: viewModel.keepLoggedIn,
                    onChanged: (bool? value) {
                      viewModel.setKeepLoggedIn(value ?? false);
                    },
                  ),
                  const Text(
                    'Keep Me Logged in',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => viewModel.forgotPassword(context),
                    child: const Text(
                      'Forgot your Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
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
              // highlightElevation: 4.0,
              child: Text(
                'Log in'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => viewModel.login(context),
            ),
          ),
        ],
      ),
    );
  }
} */

  buildForm(BuildContext context, LoginViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          TextFormBuilder(
            controller: _emailController,
            enabled: !viewModel.loading,
            prefix: Ionicons.mail,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.passFN,
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            controller: _passwordController,
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed,
            suffix: Ionicons.eye_off_outline,
            hintText: "Password",
            validateFunction: (value) {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              }
              return null;
            },
            onSaved: (value) {
              print('Saved password: $value');
            },
            textInputAction: TextInputAction.done,
            obscureText: true,
            focusNode: viewModel.passFN,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  Checkbox(
                    value: viewModel.keepLoggedIn,
                    onChanged: (bool? value) {
                      viewModel.setKeepLoggedIn(value ?? false);
                    },
                  ),
                  const Text(
                    'Keep Me Logged in',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => viewModel.forgotPassword(context),
                    child: const Text(
                      'Forgot your Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text(
                'Log in'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                /* Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TabScreen(),
                  ),
                ); */
                loginWithToken();
              },
            ),
          ),
        ],
      ),
    );
  }

// Fetch data for logging in
  Future<void> loginWithToken() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMsg('Email and Password must not be empty');
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      showErrorMsg('Please enter a valid email address');
      return;
    }

    final body = {
      "email": email,
      "password": password,
    };

    const url = "http://192.168.254.15:8000/api/login/";
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("statu code is: ${response.statusCode}");
        final data = jsonDecode(response.body);

        final token = data['token'];
        storage.write('token', token);

        _emailController.clear();
        _passwordController.clear();

        showSuccessMsg('Login Successful');

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TabScreen()));
      } else {
        showErrorMsg("Login Failed: ppError Occurred");
      }
    } catch (e) {
      showErrorMsg('An error occurred: $e');
    }
  }

  void showSuccessMsg(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMsg(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
