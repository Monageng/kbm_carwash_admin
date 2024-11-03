import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/error_dialog.dart';
import 'login_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final String username;
  const ConfirmationScreen({super.key, required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmationScreenState createState() =>
      // ignore: no_logic_in_create_state
      _ConfirmationScreenState(username: username);
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();

  final String username;

  _ConfirmationScreenState({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Sign Up")),
      body: Form(
        key: _formKeys,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //color: Colors.white,
              child: CustomTextField(
                width: 350,
                height: 100,
                controller: codeController,
                hintText: "Confirmation code ",
                label: "Confirmation code ",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage(
                      "Confirmation code  ", value);
                },
              ),
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  //color: Colors.white,
                  child: CustomElevatedButton(
                    onPressed: () {
                      if (_formKeys.currentState?.validate() ?? false) {
                        confirmSignUp();
                      }
                    },
                    text: "Confirm Sign Up",
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  // color: Colors.white,
                  child: CustomElevatedButton(
                    onPressed: () {
                      resentOTP();
                    },
                    text: "Resent OTP",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void resentOTP() async {
    printTime("************Before Resent OTP ******* ");
    try {
      ResendResponse authResponse = await Supabase.instance.client.auth
          .resend(email: username, type: OtpType.signup);

      logger.i("ResendSignUpCodeResult Value $authResponse ");

      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
                message:
                    "Request for resend OTP initiated, please check the email for OTP");
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Unable to login $e");
          });
    }
  }

  void confirmSignUp() async {
    try {
      printTime("************Before Confirm Signup ******* ");
      String confirmationCode = codeController.text;
      logger.i("confirmationCode :$confirmationCode, username : $username ");
      AuthResponse authResponse = await Supabase.instance.client.auth.verifyOTP(
          token: confirmationCode, type: OtpType.email, email: username);

      printTime("************After Confirm Signup ******* $authResponse");
      printTime(
          "************After Confirm Signup ******* ${authResponse.user!.userMetadata!}");
      bool isEmailVerified =
          authResponse.user!.userMetadata!.containsKey("email_verified");
      if (isEmailVerified) {
        // ignore: use_build_context_synchronously

        await showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                  title: "Signup Confirmation ",
                  message: "Signup completed, please login");
            });
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const LoginForm()));
      }
    } on AuthException catch (e) {
      logger.e(e.message);
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
                title: "Signup Confirmation ",
                message: "Unable to confirm signup, ${e.message}");
          });
    } catch (e) {
      logger.e("$e");
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
                title: "Signup Confirmation ",
                message: "Unable to confirm signup $e");
          });
    }
  }
}
