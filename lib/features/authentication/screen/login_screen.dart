// ignore_for_file: unused_field

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import '../../../common/functions/logger_utils.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_password_field.dart';
import '../../../common/widgets/email_text_field.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../../common/widgets/widget_style.dart';
import '../../../session/app_session.dart';
import '../../users/models/user_model.dart';
import '../services/use_service.dart';
import 'confirmation_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
  bool _loading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String appVersion = "";
  late String code = "";

  @override
  void initState() {
    super.initState();
    getReleaseDetails();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void getReleaseDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      code = packageInfo.buildNumber;
    });
  }

  Future<void> signIn() async {
    printTime("******************************************Inside signin");
    try {
      printTime(
          "******************************************Before Auth sign out ");
      var signOutResult = await Amplify.Auth.signOut(
          options: const SignOutOptions(globalSignOut: true));
      logger.d("signOutResult : $signOutResult");

      printTime(
          "******************************************After Auth sign out ");
    } catch (e) {}

    try {
      printTime("******************************************Before Auth login ");
      SignInResult user = await Amplify.Auth.signIn(
          username: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          options: const SignInOptions(
            pluginOptions: CognitoSignInPluginOptions(
              authFlowType: AuthenticationFlowType.userPasswordAuth,
            ),
          ));

      printTime("******************************************After Auth login ");
      logger.i(
          "******************************************Signed in successfully : $user");
      if (user.isSignedIn) {
        // FirebaseAnalytics.instance.logEvent(
        //     name: "liger_login_success",
        //     parameters: {"test": "my test at ${DateTime.now()}"});
        printTime(
            "******************************************Before fetchUserAttributes ");

        AuthUser authUser = await Amplify.Auth.getCurrentUser();
        printTime(
            "******************************************after authUser ${authUser.signInDetails} ");

        printTime(
            "******************************************after fetchUserAttributes ");

        UserModel userModel = UserModel();
        List<UserModel> userList =
            await UserApiService().getUserById(authUser.userId);
        userModel.mobileNumber = "";
        AppSessionModel().setLoggedInUser(userList[0]);
        //AppSessionModel().setLoggedInUserDetails(userModel);
        printTime(
            "******************************************userModel $userModel ");
        printTime(
            "******************************************Before authSession ");
        AuthSession authSession = await Amplify.Auth.fetchAuthSession();
        printTime(
            "******************************************after authSession $authSession");
        if (authSession.isSignedIn) {}
        Navigator.of(context).pushReplacementNamed('/home');

        setState(() {});
      } else {
        // FirebaseAnalytics.instance.logEvent(
        //     name: "liger_login_failure",
        //     parameters: {"test": "my test at ${DateTime.now()}"});
        if (user.nextStep.signInStep ==
            AuthSignInStep.confirmSignInWithNewPassword) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (c) => ConfirmationScreen(
          //               username: emailControler.text.trim(),
          //             )));
        }
        if (user.nextStep.signInStep ==
            AuthSignInStep.confirmSignInWithNewPassword) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ConfirmationScreen(
                        username: _emailController.text.trim(),
                      )));
        }
      }
    } on NotAuthorizedServiceException catch (e) {
      logger.e("ERROR ******* $e");
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Unable to login ${e.message}");
          });
      setState(() {
        // isLoading = false;
      });
    } on InvalidStateException catch (e) {
      logger.e("ERROR ******* $e");
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Unable to login ${e.message}");
          });
      setState(() {
        //isLoading = false;
      });
    } catch (error) {
      logger.e("ERROR ******* $error");
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Unable to login $error");
          });
      setState(() {
        //isLoading = false;
      });
    }

    setState(() {
      //isLoading = false;
    });
  }

  // Future<void> resetPassword() async {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (c) => const ResetPasswordScreen()));
  // }

  // void _onSignup() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (c) => const RegisterScreen()));
  // }

  Future<void> resetPassword() async {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (c) => const ResetPasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var listView = SingleChildScrollView(
      child: Stack(fit: StackFit.passthrough, children: [
        Image.asset(
          // repeat: ImageRepeat.repeat,
          fit: BoxFit.contain,
          "lib/assets/car-8.jpeg",
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          right: 10,
          left: 10,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width * 0.99,
            decoration: boxDecoration,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 80),
          child: Form(
            key: _formKeys,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  height: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // color: Colors.blue,
                  child: Image.asset(
                    "lib/assets/kbm_logo.png",
                  ),
                ),
                Column(
                  children: [
                    EmailTextField(
                      controller: _emailController,
                    ),
                    const SizedBox(height: 10),
                    PasswordToggleWidget(
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          //width: MediaQuery.of(context).size.width * 0.6,
                          child: CustomElevatedButton(
                            text: "Login",
                            onPressed: () async {
                              if (_formKeys.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                signIn();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () {
                            resetPassword();
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
    return Scaffold(
      body: listView,
    );
  }
}
