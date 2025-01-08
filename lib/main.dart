import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'amplifyconfiguration.dart';
import 'common/enviroment/env_variable.dart';
import 'common/home_page.dart';
import 'common/widgets/error_dialog.dart';
import 'features/authentication/screen/login_screen.dart';
import 'features/franchise/screens/franchise_list_screen.dart';
import 'theme/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureAmplify();
  Supabase.initialize(
    url: "https://$supabaseUrlv2",
    anonKey: supabaseKeyv2,
  );
  runApp(const MyApp());
}

Future<void> configureAmplify() async {
  try {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    const ErrorDialog(message: 'Error configuring Amplify:');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KBM Carwash platform',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginForm(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FranchiseListScreen(),
    );
  }
}
