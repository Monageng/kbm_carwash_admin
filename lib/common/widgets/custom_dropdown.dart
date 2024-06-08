import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.sizeOptions,
    required this.selected,
    this.width,
    required this.controller,
  });

  final List<String> sizeOptions;
  final String selected;
  final double? width;
  final TextEditingController controller;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.selected.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: widget.width ?? 200,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: DropdownButton<String>(
        value: selectedValue.trim(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
            widget.controller.text = newValue;
          });
        },
        items: widget.sizeOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value.trim(),
            child: Text(
              value.trim(),
              selectionColor: Colors.blue,
              // style: const TextStyle(
              //   color: Colors.grey,
              // ),
            ),
          );
        }).toList(),
        style: const TextStyle(color: Colors.black),
        icon: const Icon(Icons.arrow_drop_down), // Customize the dropdown icon
        iconSize: 24, // Set the size of the dropdown icon
        elevation: 16, // Set the elevation of the dropdown

        iconEnabledColor:
            Colors.orange, // Set the color of the enabled dropdown icon
        hint: const Text(
            'Select'), // Displayed when no option is selected // Text color of the selected value
      ),
    );
  }
}
