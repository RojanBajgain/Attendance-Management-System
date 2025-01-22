import 'package:ams/feature/presentation/pages/screens/mainscreen.dart';
import 'package:ams/utils/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  bool keepLoggedIn = false;
  String? email, password;
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();

  void setKeepLoggedIn(bool value) {
    keepLoggedIn = value;
    notifyListeners();
  }

  login(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      loading = true;
      notifyListeners();

      // Simulate authentication process
      await Future.delayed(const Duration(seconds: 2));
      bool success = _mockLogin();

      if (success) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (_) => TabScreen()),
        );
      } else {
        showInSnackBar('Invalid email or password.', context);
      }

      loading = false;
      notifyListeners();
    }
  }

  forgotPassword(BuildContext context) async {
    loading = true;
    notifyListeners();
    FormState form = formKey.currentState!;
    form.save();

    if (Validations.validateEmail(email) != null) {
      showInSnackBar(
          'Please input a valid email to reset your password.', context);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      showInSnackBar(
          'Password reset instructions have been sent to your email.', context);
    }

    loading = false;
    notifyListeners();
  }

  // Mock login function to simulate authentication
  bool _mockLogin() {
    return email == 'test@gmail.com' && password == 'password';
  }

  setEmail(String val) {
    email = val;
    notifyListeners();
  }

  setPassword(String val) {
    password = val;
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
