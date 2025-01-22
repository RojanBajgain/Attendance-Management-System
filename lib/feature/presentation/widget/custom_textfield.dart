import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final String hint;
  Icon? icon;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool isPassword;

  CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    required this.textEditingController,
    this.validator,
    this.focusNode,
    this.isPassword = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
        controller: widget.textEditingController,
        style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black),
        validator: widget.validator,
        focusNode: widget.focusNode,
        obscureText: widget.isPassword ? obscureText : false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Color(0xffCCCCCC)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(width: 1, color: Color(0xffCCCCCC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Color(0xffCCCCCC)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: widget.hint,
          hintStyle: smallStyle.copyWith(
              color: isDarkMode
                  ? AppColors.white.withOpacity(0.6)
                  : AppColors.grey),
          // prefixIcon: widget.icon,
          prefixIconColor: AppColors.grey,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
        ));
  }
}
