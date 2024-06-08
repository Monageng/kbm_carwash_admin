import 'package:flutter/material.dart';

class CustomFutureDropbox extends StatelessWidget {
  const CustomFutureDropbox({
    super.key,
    required this.futureList,
    required TextEditingController controller,
    required this.hintText,
    required this.selectedValue,
    this.height,
    this.width,
  }) : _controller = controller;

  final Future<List<String>> futureList;
  final TextEditingController _controller;
  final String? hintText;
  final String? selectedValue;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    var container = Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<String>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No categories available.');
          } else {
            List<String> itemList = snapshot.data!;

            return Container(
              height: 40,
              width: width ?? 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(118, 216, 163, 31),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedValue!.isEmpty ? itemList.first : selectedValue,
                items: itemList
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (selectedItem) {
                  _controller.text = selectedItem!;
                },
                // ignore: unnecessary_null_comparison
                decoration: InputDecoration(hintText: hintText),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select $hintText';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
                iconEnabledColor: Colors.orange,
                elevation: 16, // Set the elevation of the dropdown
              ),
            );
          }
        },
      ),
    );
    return container;
  }
}
