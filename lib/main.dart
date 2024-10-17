import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/authentication/screen/login_screen.dart';
import 'package:kbm_carwash_admin/features/users/screens/user_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'common/enviroment/env_variable.dart';
import 'common/home_page.dart';
import 'features/franchise/models/franchise_model.dart';
import 'features/franchise/screens/franchise_list_screen.dart';
import 'session/app_session.dart';
import 'theme/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: "https://$supabaseUrlv2",
    anonKey: supabaseKeyv2,
  );
  runApp(const MyApp());
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
        '/userlist': (context) => UserListScreen(
              franchise: AppSessionModel().loggedOnUser != null
                  ? AppSessionModel().loggedOnUser!.franchise!
                  : Franchise(id: 1, name: "name"),
            ),
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
    try {} catch (e) {
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

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   static const List<Widget> _pages = <Widget>[
//     Center(child: Text('Dashboard Page')),
//     Center(child: Text('Services Page')),
//     Center(child: Text('Bookings Page')),
//     Center(child: Text('Customers Page')),
//     Center(child: Text('Settings Page')),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Car Wash Platform'),
//       ),
//       body: Row(
//         children: <Widget>[
//           NavigationRail(
//             selectedIndex: _selectedIndex,
//             onDestinationSelected: _onItemTapped,
//             labelType: NavigationRailLabelType.all,
//             destinations: [
//               NavigationRailDestination(
//                 icon: Icon(Icons.dashboard),
//                 selectedIcon: Icon(Icons.dashboard_outlined),
//                 label: Text('Dashboard'),
//               ),
//               NavigationRailDestination(
//                 icon: Icon(Icons.car_repair),
//                 selectedIcon: Icon(Icons.car_repair_outlined),
//                 label: Text('Services'),
//               ),
//               NavigationRailDestination(
//                 icon: Icon(Icons.book_online),
//                 selectedIcon: Icon(Icons.book_online_outlined),
//                 label: Text('Bookings'),
//               ),
//               NavigationRailDestination(
//                 icon: Icon(Icons.people),
//                 selectedIcon: Icon(Icons.people_outline),
//                 label: Text('Customers'),
//               ),
//               NavigationRailDestination(
//                 icon: Icon(Icons.settings),
//                 selectedIcon: Icon(Icons.settings_outlined),
//                 label: Text('Settings'),
//               ),
//             ],
//           ),
//           const VerticalDivider(thickness: 1, width: 1),
//           // This is the main content.
//           Expanded(
//             child: _pages.elementAt(_selectedIndex),
//           )
//         ],
//       ),
//     );
//   }
// }
