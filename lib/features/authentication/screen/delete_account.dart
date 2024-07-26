// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../common/functions/logger_utils.dart';
// import '../../../common/widgets/custom/custom_action_button.dart';
// import '../../../common/widgets/custom/error_dialog.dart';
// import '../../../session/app_session.dart';
// import 'login_screen.dart';

// class DeleteAccountPage extends StatefulWidget {
//   const DeleteAccountPage({super.key});

//   @override
//   createState() => _DeleteAccountPageState();
// }

// class _DeleteAccountPageState extends State<DeleteAccountPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> deleteAccount() async {
//     printTime("**************Delete Account **********************");
//     try {
//       final userId = AppSessionModel().loggedOnUser?.userId;

//       printTime("**************userId ${userId} **********************");
//       if (userId == null) {
//         throw Exception('User ID is null');
//       }

//       await Supabase.instance.client.auth.signOut();
//       printTime("**************account signout  **********************");

//       await Supabase.instance.client.auth.admin
//           .deleteUser(AppSessionModel().loggedOnUser!.userId!);
//       printTime("**************account deleted  **********************");
//     } catch (e) {
//       await showDialog(
//           context: context,
//           builder: (c) {
//             return const ErrorDialog(message: "Account deleted successfully");
//           });
//       Navigator.push(context, MaterialPageRoute(builder: (c) => LoginForm()));
//     }
//     // try {
//     //   printTime("**************Start deleting Account **********************");
//     //   //Amplify.Auth.deleteUser();
//     //   printTime("************** result **********************");
//     //   await showDialog(
//     //       context: context,
//     //       builder: (c) {
//     //         return const ErrorDialog(message: "Account deleted successfully");
//     //       });

//     //   Navigator.push(
//     //       context, MaterialPageRoute(builder: (c) => const LoginScreen()));
//     // } catch (e) {
//     //   showDialog(
//     //       context: context,
//     //       builder: (c) {
//     //         return ErrorDialog(message: "Unable to signout $e");
//     //       });

//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text('Failed to delete account')),
//     //   );
//     //   logger.e(e);
//     // }
//   }

//   void _showDeleteConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Delete Account',
//             style: TextStyle(color: Colors.black),
//           ),
//           content: const Text(
//             'Are you sure you want to delete your account?',
//             style: TextStyle(color: Colors.black),
//           ),
//           actions: <Widget>[
//             CustomElevatedButton(
//                 text: "Cancel",
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 buttonColor: Colors.orange,
//                 textColor: Colors.white),
//             CustomElevatedButton(
//                 text: "Delete",
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   deleteAccount();
//                 },
//                 buttonColor: Colors.orange,
//                 textColor: Colors.white),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> register() async {
//     logger.i("Start register**********");
//     // signUp();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Terms and Conditions'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Delete account',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'Deleting account will delete the online digital profile and any other data we may have collected for the purpose of the platform',
//                 style: TextStyle(color: Colors.grey, fontSize: 14.0),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             CustomElevatedButton(
//                 text: "Delete account",
//                 onPressed: () {
//                   _showDeleteConfirmationDialog(context);
//                 },
//                 buttonColor: Colors.orange,
//                 textColor: Colors.white)
//           ],
//         ),
//       ),
//     );
//   }
// }
