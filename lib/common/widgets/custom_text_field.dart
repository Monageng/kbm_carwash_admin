// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final String? label;
  double? width;
  double? height;
  bool? isObscre = true;
  bool? isEnabled = true;
  TextInputType? keyboardType;
  int? maxLines = 1;
  FormFieldValidator? validator;
  String? textType;

  CustomTextField(
      {super.key,
      this.keyboardType,
      this.width,
      this.height,
      this.controller,
      this.data,
      this.hintText,
      this.isEnabled,
      this.isObscre,
      this.validator,
      this.label,
      this.maxLines,
      this.textType});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: height ?? 48,
      width: width ?? 250,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        validator: validator,
        maxLines: maxLines != null ? 1 : maxLines,
        style: const TextStyle(color: Colors.black, fontSize: 12),
        enabled: isEnabled,
        controller: controller,
        obscureText: isObscre!,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.grey),
          labelText: label, // Change background color
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Change border color
          ),

          prefixIcon: data != null
              ? Icon(
                  data,
                  color: Colors.white,
                )
              : null,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          suffixIcon: Visibility(
            visible: data != null ? true : false,
            child: IconButton(
              icon: Icon(
                isObscre! ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                isObscre = false;
              },
            ),
          ),
        ),
      ),
    );
  }
}
