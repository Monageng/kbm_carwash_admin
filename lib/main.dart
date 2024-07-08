import 'package:flutter/material.dart';

import 'common/services/common_api_service.dart';
import 'features/franchise/screens/franchise_list_screen.dart';
import 'session/app_session.dart';
import 'theme/custom_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KBM Carwash platform',
      theme: customTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyHomePage(), // LoginScreen(),
        '/home': (context) => const MyHomePage(),
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
    try {
      AppSessionModel().setProvince(CommonApiService().fetchProvince());
      AppSessionModel().setCity(CommonApiService().fetchCity());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FranchiseListScreen(),
    );
  }
}
