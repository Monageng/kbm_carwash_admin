// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:kbm_carwash_admin/features/users/models/user_model.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final List<UserModel> users = [
//     UserModel(
//       id: 5,
//       firstName: "Neo",
//       lastName: "Motsabi",
//       title: "Mr",
//       dateOfBirth: ("2024-03-27"),
//       active: true,
//       email: "motsabi.monageng@multiply.co.za",
//       mobileNumber: "0723800176",
//       userId: "af59bea2-c710-4ba6-a3be-93a040a19cc5",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     Map<String, int> titleCounts = countUsersByTitle(users);

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('User Details & Bar Chart'),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   return ListTile(
//                     title: Text(
//                         '${user.title} ${user.firstName} ${user.lastName}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Email: ${user.email}'),
//                         Text('Mobile: ${user.mobileNumber}'),
//                         Text(
//                             'Date of Birth: ${user.dateOfBirth.toString().split(' ')[0]}'),
//                         Text('User ID: ${user.userId}'),
//                       ],
//                     ),
//                     trailing: user.active!
//                         ? Icon(Icons.check_circle, color: Colors.green)
//                         : Icon(Icons.cancel, color: Colors.red),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.center,
//                   barTouchData: BarTouchData(enabled: false),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: SideTitles(
//                       showTitles: true,
//                       getTextStyles: (context, value) => const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                       margin: 16,
//                       showTitles: (double value) {
//                         switch (value.toInt()) {
//                           case 0:
//                             return 'Mr';
//                           case 1:
//                             return 'Ms';
//                           // Add more titles as needed based on your data
//                           default:
//                             return '';
//                         }
//                       },
//                     ),
//                     leftTitles: SideTitles(
//                       showTitles: true,
//                       getTextStyles: (context, value) => const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                       margin: 16,
//                       interval: 1,
//                     ),
//                   ),
//                   gridData: FlGridData(show: false),
//                   borderData: FlBorderData(show: false),
//                   barGroups: titleCounts.entries
//                       .map((entry) => BarChartGroupData(
//                             x: titleCounts.keys.toList().indexOf(entry.key),
//                             barRods: [
//                               BarChartRodData(
//                                 toY: entry.value.toDouble(),
//                               ),
//                             ],
//                           ))
//                       .toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// List<UserModel> parseUsers(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<UserModel>((json) => UserModel.fromJson(json)).toList();
// }

// Map<String, int> countUsersByTitle(List<UserModel> users) {
//   Map<String, int> titleCounts = {};
//   users.forEach((user) {
//     if (titleCounts.containsKey(user.title)) {
//       titleCounts[user.title!] = 1 + titleCounts[user.title!]!;
//     } else {
//       titleCounts[user.title!] = 1;
//     }
//   });
//   return titleCounts;
// }
