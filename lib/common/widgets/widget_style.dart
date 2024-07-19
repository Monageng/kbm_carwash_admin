import 'package:flutter/material.dart';

TextStyle getStatusStyle(String status) {
  TextStyle statusStyle = TextStyle(
    color: status == "Completed"
        ? Colors.green
        : status == "Cancelled"
            ? Colors.red
            : status == "Awaiting confirmation"
                ? Colors.amber
                : Colors.blue,
    fontSize: 12,
  );
  return statusStyle;
}

var boxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  boxShadow: [
    BoxShadow(
      color: Colors.blue.withOpacity(0.2),
      spreadRadius: 3,
      blurRadius: 5,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
);
