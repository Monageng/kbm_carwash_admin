// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTime extends StatelessWidget {
  final TextEditingController? controller;
  double? width;
  double? height;
  TimeOfDay? selectedTime = TimeOfDay.now();
  String? label;

  CustomTime({
    super.key,
    this.width,
    this.height,
    this.controller,
    this.selectedTime,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      //padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        enabled: true,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.access_time,
              color: Colors.blue,
            ),
            onPressed: () {
              _selectTime(context);
            }, //
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          labelText: label ?? "", // Change background color
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Change border color
          ),
          hintText: label ?? "",
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Change primary color for selected date
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      controller!.text = pickedTime.minute < 10
          ? "${pickedTime.hour}:0${pickedTime.minute} ${pickedTime.period.name.toUpperCase()}"
          : "${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.name.toUpperCase()}";
    }
  }
}
