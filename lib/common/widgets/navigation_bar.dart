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
            // Large screen: show all buttons
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
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      franchise: Franchise(id: -1, name: ""),
                    )),
              ],
            );
          } else if (constraints.maxWidth > 600) {
            // Medium screen: show fewer buttons
            return Row(
              children: [
                _buildTextButton(
                    context,
                    "Users",
                    UserListScreen(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      franchise: Franchise(id: -1, name: ""),
                    )),
              ],
            );
          } else {
            // Small screen: use PopupMenuButton or Drawer for all options
            return PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) {
                switch (value) {
                  case 'Franchise List':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const FranchiseListScreen()),
                    );
                    break;
                  case 'Dashboard':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => DashboardScreen(
                                franchise: Franchise(id: -1, name: "name"),
                              )),
                    );
                    break;
                  case 'Clients':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => UserListScreen(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                franchise: Franchise(id: -1, name: ""),
                              )),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Franchise List',
                  child: Text('Franchise List'),
                ),
                const PopupMenuItem(
                  value: 'Dashboard',
                  child: Text('Dashboard'),
                ),
                const PopupMenuItem(
                  value: 'Clients',
                  child: Text('Clients'),
                ),
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
