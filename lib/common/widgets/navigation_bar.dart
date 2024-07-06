import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/dashboard/appointment_dash.dart';
import 'package:kbm_carwash_admin/features/dashboard/booking_dashboard.dart';

import '../../features/booking/screens/appointment_list.dart';
import '../../features/dashboard/pie_chart.dart';
import '../../features/dashboard/restaurant_bookings_pie.dart';
import '../../features/rewards/screens/reward_config_list_screen.dart';
import '../../features/services/screens/car_wash_service_list_screen.dart';
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
          // Check the width of the screen
          if (constraints.maxWidth > 800) {
            // Wide screen: show all buttons

            return Row(
              children: [
                _buildTextButton(context, "Dashboard", const DashboardScreen()),
                _buildTextButton(context, "Clients", const UserListScreen()),
                _buildTextButton(
                    context, "Appointments", const AppointmentListScreen()),
                _buildTextButton(
                    context, "Car wash services", const ServiceListScreen()),
                _buildTextButton(context, "Reward Configurations",
                    const RewardConfigListScreen()),
              ],
            );
          } else if (constraints.maxWidth > 600) {
            // Medium screen: show fewer buttons
            return Row(
              children: [
                _buildTextButton(
                    context, "Appointments", const AppointmentListScreen()),
                _buildTextButton(
                    context, "Car wash services", const ServiceListScreen()),
                _buildTextButton(context, "Users", const UserListScreen()),
              ],
            );
          } else {
            // Small screen: show minimal buttons
            return Row(
              children: [
                _buildTextButton(
                    context, "Appointments", const AppointmentListScreen()),
                _buildTextButton(
                    context, "Car wash services", const ServiceListScreen()),
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
