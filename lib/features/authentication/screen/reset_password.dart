// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../common/functions/common_functions.dart';
// import '../../../common/functions/logger_utils.dart';
// import '../../../common/widgets/custom_password_field.dart';
// import '../../../common/widgets/custom_text_field.dart';
// import '../../../common/widgets/email_text_field.dart';
// import '../../../common/widgets/error_dialog.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordControler = TextEditingController();
//   TextEditingController confirmationCodeControler = TextEditingController();

//   final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
//   late bool showConfirmation = false;
//   late String message =
//       "Capture the username, email/sms will be sent with OTP ";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reset password")),
//       body: Form(
//         key: _formKeys,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               // height: 200,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               color: Colors.white,
//               child: Text(
//                 message,
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ),
//             if (!showConfirmation)
//               Container(
//                 color: Colors.white,
//                 child: EmailTextField(
//                   width: 350,
//                   height: 100,
//                   controller: usernameController,
//                 ),
//               ),
//             if (showConfirmation)
//               PasswordToggleWidget(
//                 controller: passwordControler,
//                 width: 350,
//                 height: 100,
//                 validator: (value) {
//                   return getFieldValidationMessage("Password ", value);
//                 },
//               ),
//             if (showConfirmation)
//               CustomTextField(
//                 width: 350,
//                 height: 100,
//                 controller: confirmationCodeControler,
//                 hintText: "Confirmation Code ",
//                 label: "Confirmation Code ",
//                 isObscre: false,
//                 validator: (value) {
//                   return getFieldValidationMessage("Confirmation Code ", value);
//                 },
//               ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (!showConfirmation)
//                   Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 20),
//                     color: Colors.white,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKeys.currentState?.validate() ?? false) {
//                           resetPassword();
//                         }
//                       },
//                       child: const Text("Reset password",
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//                 if (showConfirmation)
//                   Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 20),
//                     color: Colors.white,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKeys.currentState?.validate() ?? false) {
//                           confirmResetPassword();
//                         }
//                       },
//                       child: const Text("Save New Password",
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void confirmResetPassword() async {
//     printTime(
//         "******************************************Inside confirmResetPassword");
//     try {
//       await Supabase.instance.client.auth
//           .resetPasswordForEmail(usernameController.text.trim());

//       printTime(
//           "******************************************Complete confirmResetPassword");
//     } catch (e) {
//       showDialog(
//           context: context,
//           builder: (c) {
//             return ErrorDialog(
//                 title: "Rest password",
//                 message: "Unable to reset password : ${e}");
//           });
//     }
//   }

//   void resetPassword() async {
//     try {
//       await Supabase.instance.client.auth
//           .resetPasswordForEmail(usernameController.text.trim());

//       printTime(
//           "******************************************Complete resetPassword");
//     } on AuthException catch (e) {
//       showDialog(
//           context: context,
//           builder: (c) {
//             return ErrorDialog(
//                 title: "Reset password",
//                 message: "Unable to reset password : ${e.message}");
//           });
//     } catch (e) {
//       showDialog(
//           context: context,
//           builder: (c) {
//             return ErrorDialog(
//                 title: "Reset password",
//                 message: "Unable to reset password : ${e}");
//           });
//     }
//   }
// }
