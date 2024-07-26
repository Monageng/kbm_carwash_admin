import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  final String? title;

  const ErrorDialog({super.key, this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "", style: const TextStyle(color: Colors.black)),
      alignment: Alignment.center,
      key: key,
      content: Container(
        padding: const EdgeInsets.all(12),
        child: Text(message!,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center),
      ),
      actions: [
        Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
