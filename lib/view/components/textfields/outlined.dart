import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';

class TextFieldOutlined extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool? isPasswordField;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final bool valid;
  final TextInputType? keyboard;
  final String errorMessage;

  TextFieldOutlined({
    required this.label,
    required this.controller,
    required this.valid,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.isPasswordField,
    this.keyboard = TextInputType.text,
    this.errorMessage = "Invalid Value",
  });

  @override
  _TextFieldOutlinedState createState() => _TextFieldOutlinedState();
}

class _TextFieldOutlinedState extends State<TextFieldOutlined> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboard,
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.normal,
        fontFamily: 'Manrope',
      ),
      controller: widget.controller,
      obscureText: widget.obscureText && !_passwordVisible,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        errorText: widget.valid ? null : widget.errorMessage,
        errorStyle: TextStyle(color: Colors.red),
        labelText: widget.label,
        floatingLabelStyle: TextStyle(color: AppColor.primary),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColor.primary,
            width: 2,
          ),
        ),
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColor.primary),
                onPressed: () {
                  // Update the state i.e. toggle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
        suffixIconColor: Colors.grey,
      ),
      autofocus: true,
    );
  }
}
