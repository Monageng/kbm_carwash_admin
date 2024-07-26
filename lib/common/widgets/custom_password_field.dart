import 'package:flutter/material.dart';
import 'package:validation_pro/validate.dart';

class PasswordToggleWidget extends StatefulWidget {
  final TextEditingController? controller;
  FormFieldValidator? validator;
  double? width;
  double? height;
  String? label;

  PasswordToggleWidget({
    super.key,
    this.controller,
    this.height,
    this.width,
    this.validator,
    this.label,
  });

  @override
  createState() => _PasswordToggleWidgetState();
}

class _PasswordToggleWidgetState extends State<PasswordToggleWidget> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 250,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${widget.label ?? "password"}';
          }

          /// Min 6 and Max 12 characters
          /// At least one uppercase character
          /// At least one lowercase character
          /// At least one number
          /// At least one special character [@#$!%?]
          if (!Validate.isPassword(value)) {
            return 'Invalid password. Password policy is \n Min 6 and Max 12 characters \n At least one uppercase character \n At least one lowercase character \n At least one number \n At least one special character [@#\$!%?]';
          }
          return null;
        },
        controller: widget.controller,
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.grey),
          labelText: ' ${widget.label ?? "Password"}',
          hintText: " ${widget.label ?? "Password"}",
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Change border color
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.blue,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
      ),
    );
  }
}
