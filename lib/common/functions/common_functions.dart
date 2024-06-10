import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/booking/screens/appointment_list.dart';
import 'package:kbm_carwash_admin/features/users/screens/user_list_screen.dart';

import '../../features/rewards/screens/reward_config_list_screen.dart';
import '../../features/services/screens/car_wash_service_list_screen.dart';
import '../../features/rewards/screens/reward_allocation_list_screen.dart';

List<Widget> rattedStars({required int ratting}) {
  const filledColor = Color.fromRGBO(254, 192, 77, 1);
  const greyColor = Color.fromRGBO(196, 196, 196, 1);
  return List.generate(
    5,
    (index) => Icon(
      Icons.star,
      color: index < ratting ? filledColor : greyColor,
    ),
  );
}

// getTopNavigation(BuildContext context) {
//   var appBar2 = AppBar(
//     bottomOpacity: 10,
//     title: const Text("KBM Carwash platform"),
//     flexibleSpace: Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color.fromARGB(255, 61, 118, 242),
//             Color.fromARGB(255, 61, 118, 242)
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//     ),
//     actions: [
//       TextButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (ctx) => const AppointmentListScreen()));
//         },
//         child: const Text(
//           "Appointments",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       TextButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (ctx) => const ServiceListScreen()));
//         },
//         child: const Text(
//           "Car wash services",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       TextButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (ctx) => const UserListScreen()));
//         },
//         child: const Text(
//           "Users",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       TextButton(
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (ctx) => const RewardConfigListScreen()));
//         },
//         child: const Text(
//           "Reward Configurations",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       // TextButton(
//       //   onPressed: () {
//       //     Navigator.push(
//       //         context,
//       //         MaterialPageRoute(
//       //             builder: (ctx) => RewardAllocationListScreen()));
//       //   },
//       //   child: const Text(
//       //     "Reward Allocation",
//       //     style: TextStyle(color: Colors.white),
//       //   ),
//       // ),
//     ],
//   );
//   return appBar2;
// }

DataCell getDataCell(String cellValue) {
  return DataCell(Expanded(
    child: Text(
      cellValue,
      softWrap: true,
      style: const TextStyle(color: Colors.grey),
    ),
  ));
}

DataCell getDataCellWithWidth(String? dateValue, double width) {
  return DataCell(
    SizedBox(
      width: width,
      child: Text(
        style: const TextStyle(color: Colors.grey),
        dateValue ?? "",
        softWrap: true,
      ),
    ),
  );
}

DataColumn getColumnHeader(String title) {
  return DataColumn(
      label: Expanded(
    child: Text(
      title,
      softWrap: true,
      style: const TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    ),
  ));
}

DataColumn getDataColumnHeader(String title) {
  return DataColumn(
      label: Expanded(
    child: Text(
      title,
      softWrap: true,
      style: const TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    ),
  ));
}

String generateRandomString(int length) {
  const charset =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-';
  final random = Random();
  return String.fromCharCodes(
    List.generate(
        length, (index) => charset.codeUnitAt(random.nextInt(charset.length))),
  );
}

// Map<String, String> getHttpHeaders() {
//   Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     "apikey": supabaseKeyv2
//   };

//   return headers;
// }

// Future<int> getNextPrimaryKey(String table) async {
//   final dynamic keyResp = await ApiServiceV2().getNextSequenceNumber(table);

//   if (keyResp is List) {
//     int length = keyResp.length;
//     if (length > 0) {
//       return keyResp[0]['uuid'] + 1;
//     }
//   } else {
//     print('The variable is not a List.');
//   }
//   return 0;
// }

// List<String> convertMetadataListToStringList(List<Metadata?> metadataList) {
//   return metadataList.map((metadata) => metadata?.description ?? "").toList();
// }

// List<Metadata?> filterMetadataListByType(
//     List<Metadata?> metadataList, String type) {
//   return metadataList.where((metadata) => metadata!.type == type).toList();
// }

String? getFieldValidationMessage(String fieldName, String fieldValue) {
  if (fieldValue.isEmpty || fieldValue.trim().isEmpty) {
    return '$fieldName is mandatory';
  }
  return null;
}

String? getFieldMobileNumberValidationMessage(
    String fieldName, String fieldValue) {
  if (fieldValue.isEmpty || fieldValue.trim().isEmpty) {
    return '$fieldName is mandatory';
  }

  if (!RegExp(r'^\+27[0-9]{9}$|^0[0-9]{9}$|^27[0-9]{9}$')
      .hasMatch(fieldValue)) {
    return 'Invalid contact number format';
  }

  return null;
}

String? getFieldNumbericValidationMessage(String fieldName, String fieldValue) {
  if (fieldValue.isEmpty || fieldValue.trim().isEmpty) {
    return '$fieldName is mandatory';
  }

  try {
    double.parse(fieldValue);
  } catch (e) {
    return 'Invalid numder format';
  }

  return null;
}

String? getFieldPostalCodeValidationMessage(
    String fieldName, String fieldValue) {
  if (fieldValue.isEmpty) {
    return 'Please enter a postal code';
  }

  // Use a regular expression to validate if the entered value is numeric
  if (!RegExp(r'^[0-9]+$').hasMatch(fieldValue)) {
    return 'Postal code must be numeric and valid postal code';
  }

  return null;
}

String? getFieldValidationLatitude(String fieldName, String fieldValue) {
  // Regular expression for latitude validation
  final RegExp regex =
      RegExp(r'^(-?[1-8]?\d(?:\.\d{1,18})?|90(?:\.0{1,18})?)$');

  if (!regex.hasMatch(fieldValue)) {
    // Invalid latitude format
    return 'Invalid latidude';
  }
  return null;
}

String? getFieldValidationLongitude(String fieldName, String fieldValue) {
  final RegExp regex = RegExp(
      r'^(-?[1-9]?\d(?:\.\d{1,18})?|1[0-7]\d(?:\.\d{1,18})?|180(?:\.0{1,18})?)$');

  if (!regex.hasMatch(fieldValue)) {
    return 'Invalid longitude';
  }
  return null;
}

String? getFieldAmountValidationMessage(String fieldName, String fieldValue) {
  if (fieldValue.isEmpty) {
    return 'Please enter $fieldName';
  }

  try {
    double parsedValue = double.parse(fieldValue);
    if (parsedValue <= 0) {
      return '$fieldName must be greater than zero';
    }
  } catch (e) {
    return 'Invalid price format';
  }
  return null;
}

double getFomartedDouble(String input) {
  try {
    double? parsedValue = double.tryParse(input);
    return double.parse(parsedValue!.toStringAsFixed(2));
  } catch (e) {
    return 0;
  }
}

const availableRowsPerPage2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20];
