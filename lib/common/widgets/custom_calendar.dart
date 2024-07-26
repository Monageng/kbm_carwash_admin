import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/functions/common_functions.dart';

// ignore: must_be_immutable
class CustomCalender extends StatelessWidget {
  final TextEditingController? controller;
  double? width;
  double? height;
  DateTime? selectedDate;
  DateTime? firstDate;
  DateTime? lastDate;
  String? label;
  bool? isMandatory;

  CustomCalender({
    super.key,
    this.width,
    this.height,
    this.controller,
    this.selectedDate,
    this.label,
    this.lastDate,
    this.firstDate,
    this.isMandatory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
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
        validator: (value) {
          if (isMandatory! == true) {
            return getFieldValidationMessage(label!, value!);
          }
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.blue,
            ),
            onPressed: () {
              _selectDate(context);
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

  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:
          firstDate ?? DateTime.now().add(const Duration(days: 50000) * -1),
      lastDate: lastDate ?? DateTime.now(),
      // Customize selected date text style here
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
    if (pickedDate != null && pickedDate != selectedDate) {
      String formattedDate = formatDate(pickedDate, [yyyy, '-', mm, '-', dd]);
      controller!.text = formattedDate;
    }
  }
}
