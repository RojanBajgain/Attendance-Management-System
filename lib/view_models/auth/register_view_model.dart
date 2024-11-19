import 'package:ams/screens/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String? email, password, cPassword;
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode cPassFN = FocusNode();

  // Mock registration function (replace with other logic if needed)
  Future<bool> createUser({
    required String email,
    required String password,
  }) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return true; // Return success or failure based on your logic
  }

  register(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      if (password == cPassword) {
        loading = true;
        notifyListeners();
        try {
          bool success = await createUser(
            email: email ?? '',
            password: password ?? '',
          );
          print(success);
          if (success) {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (_) => TabScreen(),
              ),
            );
          }
        } catch (e) {
          loading = false;
          notifyListeners();
          print(e);
          showInSnackBar('Registration failed: ${e.toString()}', context);
        }
        loading = false;
        notifyListeners();
      } else {
        showInSnackBar('The passwords do not match', context);
      }
    }
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  setConfirmPass(val) {
    cPassword = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
