import 'package:ams/feature/presentation/widget/components/custom_card.dart';
import 'package:flutter/material.dart';

class TextFormBuilder extends StatefulWidget {
  final String? initialValue;
  final bool? enabled;
  final String? hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final FocusNode? focusNode, nextFocusNode;
  final VoidCallback? submitAction;
  final void Function(String)? onSaved, onChange;
  final Key? key;
  final IconData? prefix;
  final IconData? suffix;

  TextFormBuilder({
    this.prefix,
    this.suffix,
    this.initialValue,
    this.enabled,
    this.hintText,
    this.textInputType,
    this.controller,
    this.textInputAction,
    this.nextFocusNode,
    this.focusNode,
    this.submitAction,
    this.obscureText = false,
    this.onSaved,
    this.onChange,
    this.key,
  });

  @override
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            onTap: () {
              print('clicked');
            },
            borderRadius: BorderRadius.circular(40.0),
            child: Container(
              child: Theme(
                data: ThemeData(
                  primaryColor: Theme.of(context).colorScheme.secondary,
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    secondary: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: TextFormField(
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  textCapitalization: TextCapitalization.none,
                  initialValue: widget.initialValue,
                  enabled: widget.enabled,
                  onChanged: (val) {
                    widget.onSaved!(val); // Store values without validation
                  },
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                  key: widget.key,
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.textInputType,
                  onSaved: (val) {
                    widget.onSaved!(val!); // Store values without validation
                  },
                  textInputAction: widget.textInputAction,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: (String term) {
                    if (widget.nextFocusNode != null) {
                      widget.focusNode!.unfocus();
                      FocusScope.of(context).requestFocus(widget.nextFocusNode);
                    } else {
                      widget.submitAction!();
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      widget.prefix,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 20,
                    ),
                    suffixIcon: Icon(
                      widget.suffix,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    filled: true,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
