// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:validation_pro/validate.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  double? width;
  double? height;
  bool? isMandatory;

  EmailTextField(
      {super.key, this.width, this.height, this.controller, this.isMandatory});

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
        validator: (value) {
          if (isMandatory == true) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email address';
            }
            if (!Validate.isEmail(value!)) {
              return 'Invalid email format';
            }
          } else {
            if (value!.isNotEmpty) {
              if (!Validate.isEmail(value!)) {
                return 'Invalid email format';
              }
            }
          }

          return null;
        },
        style: const TextStyle(color: Colors.black, fontSize: 12),
        controller: controller,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
          labelText: "Email address", // Change background color
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Change border color
          ),

          hintText: "Email address",
          hintStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
