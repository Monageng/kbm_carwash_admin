import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextAreaField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  double? width;
  double? height;
  int maxLine;
  FormFieldValidator? validator;

  CustomTextAreaField(
      {super.key,
      this.controller,
      this.hintText,
      this.validator,
      this.width,
      this.height,
      required this.maxLine,
      this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 60,
      width: width ?? 250,
      decoration: const BoxDecoration(
        //color: Color(0x76AEABAB),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      //padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        validator: validator,
        maxLines: maxLine,
        style: const TextStyle(color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.grey),
          labelText: label, // Change background color
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Change border color
          ),
          // prefixIcon: data != null
          //     ? Icon(
          //         data,
          //         color: Colors.white,
          //       )
          //     : null,
          hintText: hintText,

          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          // suffixIcon: IconButton(
          //   icon: Icon(
          //     isObscre! ? Icons.visibility : Icons.visibility_off,
          //   ),
          //   onPressed: () {
          //     isObscre = false;
          //   },
          // ),
        ),
      ),
    );
  }
}
