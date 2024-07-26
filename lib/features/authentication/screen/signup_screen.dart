// import 'package:flutter/material.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../common/functions/logger_utils.dart';
// import '../../../common/services/common_api_service.dart';
// import '../../../common/widgets/contact_number_text_field.dart';
// import '../../../common/widgets/custom_calendar.dart';
// import '../../../common/widgets/custom_dropdown.dart';
// import '../../../common/widgets/custom_password_field.dart';
// import '../../../common/widgets/custom_text_field.dart';
// import '../../../common/widgets/email_text_field.dart';
// import '../../../common/widgets/error_dialog.dart';
// import '../../users/models/user_model.dart';
// import 'confirmation_screen.dart';
// import 'login_screen.dart';

// class SignUpForm extends StatefulWidget {
//   const SignUpForm({Key? key}) : super(key: key);

//   @override
//   State<SignUpForm> createState() => _SignUpFormState();
// }

// class _SignUpFormState extends State<SignUpForm> {
//   final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
//   bool _loading = false;
//   final _emailController = TextEditingController();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _titleController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _dateController = TextEditingController();

//   final DateTime _selectedDate = DateTime.now();
//   List<String> titleOptions = ["Select title", "Mr", "Mrs", "Miss", "Dr"];
//   String selectedTitle = "Select title";

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void signUp() async {
//     try {
//       final email = _emailController.text;
//       final password = _passwordController.text;
//       AuthResponse authResponse = await Supabase.instance.client.auth.signUp(
//         email: email,
//         password: password,
//         data: {'email_verified': 'true', "phone_verified": "true"},
//       );

//       int key = await CommonApiService().getLatestID("client");

//       UserModel user = UserModel(
//           id: key,
//           userId: authResponse.user!.id,
//           firstName: _firstNameController.text,
//           lastName: _lastNameController.text,
//           email: _emailController.text,
//           mobileNumber: _phoneController.text,
//           active: true,
//           title: _titleController.text,
//           dateOfBirth: _selectedDate.toIso8601String());

//       await CommonApiService().save(user.toJson(), "client");
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (ctx) => ConfirmationScreen(
//                     username: email,
//                   )));
//     } on AuthException catch (e) {
//       logger.e("Signup Error : ${e.toString()}");
//       // ignore: use_build_context_synchronously
//       await showDialog(
//           context: context,
//           builder: (c) {
//             return ErrorDialog(title: "Signup ", message: "Error ${e.message}");
//           });
//     } catch (e) {
//       logger.e("Signup Error : ${e.toString()}");
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Signup failed', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.red,
//       ));
//       setState(() {
//         _loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var listView = SingleChildScrollView(
//       child: Form(
//         key: _formKeys,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               width: 200,
//               height: 200,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               // color: Colors.blue,
//               child: Image.asset(
//                 "lib/assets/car-16.jpeg",
//               ),
//             ),
//             const Center(
//               child: Text(
//                 "KBM Login",
//                 style: TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20),
//               ),
//             ),
//             CustomTextField(
//               controller: _firstNameController,
//               hintText: "First name",
//               label: "First Name",
//             ),
//             CustomTextField(
//               controller: _lastNameController,
//               hintText: "Surname",
//               label: "Surname",
//             ),
//             ContactNumberTextField(
//               controller: _phoneController,
//               label: "Cell number",
//             ),
//             CustomDropDown(
//                 sizeOptions: titleOptions,
//                 selected: selectedTitle,
//                 // height: 100,
//                 width: 250,
//                 controller: _titleController),
//             Container(
//               width: 250,
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(20),
//                 ),
//               ),
//               margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//               child: CustomCalender(
//                   controller: _dateController,
//                   firstDate:
//                       DateTime.now().add(const Duration(days: 36500) * -1)),
//             ),
//             EmailTextField(controller: _emailController),
//             const SizedBox(height: 16),
//             PasswordToggleWidget(
//               controller: _passwordController,
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formKeys.currentState!.validate()) {
//                         signUp();
//                       }
//                     },
//                     child: const Text(
//                       'Signup',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (ctx) => const LoginForm()));
//                   },
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//     return Scaffold(
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : listView,
//     );
//   }
// }
