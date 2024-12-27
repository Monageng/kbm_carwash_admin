import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../../../common/functions/logger_utils.dart';

class LoginOutForm extends StatefulWidget {
  const LoginOutForm({Key? key}) : super(key: key);

  @override
  State<LoginOutForm> createState() => _LoginOutFormState();
}

class _LoginOutFormState extends State<LoginOutForm> {
  @override
  void initState() {
    logout();
    super.initState();
  }

  Future<void> logout() async {
    printTime("******************************************Inside signin");
    try {
      printTime(
          "******************************************Before Auth sign out ");
      var signOutResult = await Amplify.Auth.signOut(
          options: const SignOutOptions(globalSignOut: true));
      logger.d("signOutResult : $signOutResult");

      printTime(
          "******************************************After Auth sign out ");
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
