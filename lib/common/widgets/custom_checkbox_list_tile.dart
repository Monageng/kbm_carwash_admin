// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class CustomCheckboxListTile extends StatelessWidget {
//   final TextEditingController? controller;
//   final Function(bool?)? onPressed;
//   final String? label;
//   double? width;
//   double? height;

//   CustomCheckboxListTile({
//     super.key,
//     this.width,
//     this.height,
//     this.controller,
//     this.label,
//     this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width != null ? width : 150,
//       child: CheckboxListTile(
//         activeColor: Colors.amberAccent,
//         title: Text(
//           label!,
//           style: TextStyle(color: Colors.orange),
//         ),
//         value: controller?.text == 'true',
//         onChanged: onPressed,
//       ),
//     );
//   }
// }


// // Container(
// //             // height: 200,
// //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //             color: Colors.white,
// //             child: TextField(
// //                 controller: codeController,
// //                 style: const TextStyle(
// //                     color: Colors.black), // Change the text color
// //                 decoration: const InputDecoration(
// //                   border: OutlineInputBorder(
// //                     borderSide:
// //                         BorderSide(color: Colors.red), // Change border color
// //                   ),
// //                   fillColor: Colors.yellow, // Change background color
// //                   labelText: "Confirmation Code",
// //                 )),
// //           ),