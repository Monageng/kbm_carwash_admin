import 'package:flutter/material.dart';

final customTheme = ThemeData(
  useMaterial3: true,
  primaryColor: const Color.fromARGB(255, 61, 118, 242),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 61, 118, 242),
    onPrimary: Color.fromARGB(255, 61, 118, 242),
    secondary: Colors.white,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.redAccent,
    background: Colors.white,
    onBackground: Color.fromARGB(255, 61, 118, 242),
    surface: Color.fromARGB(255, 61, 118, 242),
    onSurface: Colors.white,
  ),
);

// final customTheme = ThemeData(
//   useMaterial3: true,
//   primaryColor: const Color.fromARGB(255, 183, 87, 1),
//   colorScheme: const ColorScheme(
//     brightness: Brightness.light,
//     primary: Colors.orange,
//     onPrimary: Colors.orange,
//     secondary: Colors.white,
//     onSecondary: Colors.white,
//     error: Colors.red,
//     onError: Colors.redAccent,
//     background: Colors.white,
//     onBackground: Colors.orange,
//     surface: Colors.orange,
//     onSurface: Colors.white,
//   ),
// );
