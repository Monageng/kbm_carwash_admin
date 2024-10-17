import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 61, 118, 242),
  useMaterial3: true,
  // textTheme: const TextTheme(
  //   displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  //   bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  // ),
  dataTableTheme: DataTableThemeData(
    headingRowColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return const Color.fromARGB(255, 61, 118, 242).withOpacity(0.5);
        }
        return const Color.fromARGB(255, 61, 118, 242);
      },
    ),
    headingTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    dataRowColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return const Color.fromARGB(255, 61, 118, 242).withOpacity(0.1);
        }
        return Colors.white;
      },
    ),
    dataTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    headingRowHeight: 64.0, // Customize the height of the heading row
    columnSpacing: 16.0, // Customize spacing between columns
    horizontalMargin: 12.0, // Margin around the table's edges
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.blue,
    //primary: Colors.lime,
    onPrimary: Colors.pink, // Color.fromARGB(255, 61, 118, 242),
    secondary: Colors.brown,
    onSecondary: Colors.deepPurple,
    error: Colors.red,
    onError: Colors.redAccent,
    //surface: Color.fromARGB(255, 142, 163, 208),
    //onSurface: Colors.white,
    tertiary: Colors.grey,
    onTertiary: Colors.black,
  ),
);

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
    surface: Color.fromARGB(255, 61, 118, 242),
    onSurface: Colors.white,
    tertiary: Colors.grey,
    onTertiary: Colors.black,
  ),
);

// final customTheme = ThemeData(
//   useMaterial3: true,
//   colorScheme: const ColorScheme(
//     brightness: Brightness.light,
//     primary: Color.fromARGB(255, 61, 118, 242),
//     onPrimary: Colors.white,
//     secondary: Colors.white,
//     onSecondary: Color.fromARGB(255, 61, 118, 242),
//     error: Colors.red,
//     onError: Colors.white,
//     background: Colors.white,
//     onBackground: Color.fromARGB(255, 61, 118, 242),
//     surface: Color.fromARGB(255, 61, 118, 242),
//     onSurface: Colors.white,
//     tertiary: Colors.grey,
//     onTertiary: Colors.black,
//   ),
// );
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
