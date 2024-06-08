// import 'dart:html';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// class FileUploadWidget extends StatefulWidget {
//   @override
//   _FileUploadWidgetState createState() => _FileUploadWidgetState();
// }



// class _FileUploadWidgetState extends State<FileUploadWidget> {
//   String _filePath = '';

//   Future<void> _pickFile() async {
//     // FilePickerResult? result = await FilePicker.platform.pickFiles();

//     // if (result != null) {
//     //   if (result.files.single.bytes != null) {
//     //     // File bytes are available
//     //     // Perform your file upload or processing logic here
//     //     // Example: await _uploadToSupabase(result.files.single.bytes!);
//     //    // print("result.files.single.bytes ${result.files.single.bytes }");
//     //     RestaurantApiService().uploadToSupabase(result.files.single.bytes!, result.names.first.toString());
//     //   } else if (result.files.single.path != null) {
//     //     print("for non-web platforms ${result.files.single.bytes }");
//     //     // File path is available (for non-web platforms)
//     //     // Perform your file upload or processing logic here
//     //     // Example: await _uploadToSupabase(File(result.files.single.path!));
//     //     //RestaurantApiService().uploadToSupabase(File(result.files.single.path! as List<Object>).toString().codeUnits, result.names.first.toString());

//     //   } else {
//     //     print("for non-web platforms ${result.files.single.bytes }");
//     //     // Handle unsupported case
//     //     print('Unsupported case: Neither bytes nor path is available.');
//     //   }
//     }


//     if (result != null) {
//       setState(() {
//         _filePath = result.files.single.path!;
//       });

//       // Upload the file to Supabase
//       await _uploadToSupabase(result.files.single.bytes!, result.names.first.toString());
//     }
//   }

//   Future<void> _uploadToSupabase(Uint8List file, String fileName) async {
//     // Get the file name

//     // RestaurantApiService().uploadFileToSupabase(file, fileName);

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // ElevatedButton(
//         //   onPressed: _pickFile,
//         //   child: Text('Pick a File'),
//         // ),
//         // SizedBox(height: 20),
//         // Text('Selected File: $_filePath'),
//       ],
//     );
//   }
