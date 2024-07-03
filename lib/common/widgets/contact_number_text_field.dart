// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../functions/common_functions.dart';

class ContactNumberTextField extends StatelessWidget {
  final TextEditingController? controller;
  double? width;
  double? height;
  String label;

  ContactNumberTextField({
    super.key,
    this.width,
    this.height,
    required this.label,
    this.controller,
  });

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
          return getFieldMobileNumberValidationMessage(label, value!);
        },
        style: const TextStyle(color: Colors.black, fontSize: 12),
        controller: controller,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.grey),
          labelText: label, // Change background color
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Change border color
          ),

          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
