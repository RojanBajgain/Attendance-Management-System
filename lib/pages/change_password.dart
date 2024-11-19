import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const PasswordForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          TextFormField(
            obscureText: !_oldPasswordVisible,
            onSaved: (oldPassword) {},
            onChanged: (oldPassword) {},
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Old Password",
              labelText: "Old Password *",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _oldPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _oldPasswordVisible = !_oldPasswordVisible;
                  });
                },
              ),
              border: authOutlineInputBorder,
              enabledBorder: authOutlineInputBorder,
              focusedBorder: authOutlineInputBorder.copyWith(
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextFormField(
              obscureText: !_newPasswordVisible,
              onSaved: (newPassword) {},
              onChanged: (newPassword) {},
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "New Password",
                labelText: "New Password *",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: const TextStyle(color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _newPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _newPasswordVisible = !_newPasswordVisible;
                    });
                  },
                ),
                border: authOutlineInputBorder,
                enabledBorder: authOutlineInputBorder,
                focusedBorder: authOutlineInputBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          TextFormField(
            obscureText: !_confirmPasswordVisible,
            onSaved: (confirmPassword) {},
            onChanged: (confirmPassword) {},
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              labelText: "Confirm Password *",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
              border: authOutlineInputBorder,
              enabledBorder: authOutlineInputBorder,
              focusedBorder: authOutlineInputBorder.copyWith(
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Clear Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                child: const Text("Clear"),
              ),

              // Update Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                child: const Text(
                  "Update",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
