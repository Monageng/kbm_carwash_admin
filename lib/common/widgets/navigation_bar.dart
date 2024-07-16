import 'package:flutter/material.dart';

import '../../features/dashboard/appointment_dash.dart';
import '../../features/franchise/models/franchise_model.dart';
import '../../features/franchise/screens/franchise_list_screen.dart';
import '../../features/users/screens/user_list_screen.dart';

AppBar getTopNavigation(BuildContext context) {
  return AppBar(
    bottomOpacity: 10,
    title: const Text("KBM Carwash platform"),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 61, 118, 242),
            Color.fromARGB(255, 61, 118, 242),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    actions: [
      LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                _buildTextButton(
                    context, "Franchise List", const FranchiseListScreen()),
                _buildTextButton(
                    context,
                    "Dashboard",
                    DashboardScreen(
                      franchise: Franchise(id: -1, name: "name"),
                    )),
                _buildTextButton(
                    context,
                    "Clients",
                    UserListScreen(
                      franchise: Franchise(id: -1, name: ""),
                    )),
              ],
            );
          } else {
            // Medium screen: show fewer buttons
            return Row(
              children: [
                _buildTextButton(
                    context,
                    "Users",
                    UserListScreen(
                      franchise: Franchise(id: -1, name: ""),
                    )),
              ],
            );
          }
        },
      ),
    ],
  );
}

TextButton _buildTextButton(BuildContext context, String label, Widget screen) {
  return TextButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => screen));
    },
    child: Text(
      label,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
