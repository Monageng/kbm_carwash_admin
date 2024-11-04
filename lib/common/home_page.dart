import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/booking/screens/payment_transaction_report.dart';
import 'package:kbm_carwash_admin/features/rewards/screens/referal_list_screen.dart';

import '../features/booking/screens/appointment_list.dart';
import '../features/booking/screens/ranking_list.dart';
import '../features/dashboard/appointment_dash.dart';
import '../features/franchise/models/franchise_model.dart';
import '../features/franchise/screens/franchise_form.dart';
import '../features/reviews/screens/review_list.dart';
import '../features/rewards/screens/reward_config_list_screen.dart';
import '../features/services/screens/car_wash_service_list_screen.dart';
import '../features/users/screens/user_list_screen.dart';
import '../session/app_session.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    DashboardScreen(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    AppointmentListScreen(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    // PaymentTransactionListScreen(
    //     franchise: AppSessionModel().loggedOnUser != null
    //         ? AppSessionModel().loggedOnUser!.franchise!
    //         : Franchise(id: 1, name: "name")),
    MonthlyFinancialDashboard(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    RankOverviewScreen(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    UserListScreen(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    ServiceListScreen(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    RewardConfigListScreen(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    ReviewListScreen(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
    ReferralListScreen(),
    FranchiseForm(
        franchise: AppSessionModel().loggedOnUser != null
            ? AppSessionModel().loggedOnUser!.franchise!
            : Franchise(id: 1, name: "name")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  NavigationRailDestination getMenuTitle(String title) {
    return NavigationRailDestination(
      icon: const Icon(
        Icons.dashboard,
        color: Colors.white,
      ),
      selectedIcon: const Icon(
        Icons.dashboard_outlined,
        color: Colors.blue,
      ),
      label: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    var destinations = [
      getMenuTitle("Dashboard"),
      getMenuTitle("Bookings"),
      getMenuTitle("Transactions"),
      getMenuTitle("Leaderboard"),
      getMenuTitle("Customers"),
      getMenuTitle("Services"),
      getMenuTitle("Rewards Configuration"),
      getMenuTitle("Review"),
      getMenuTitle("Referal List"),
      getMenuTitle("Franchise Settings"),
    ];
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            unselectedLabelTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 61, 118, 242),
            destinations: destinations,
          ),
          const VerticalDivider(thickness: 1, width: 10),
          Expanded(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: _pages.elementAt(_selectedIndex)),
          )
        ],
      ),
    );
  }
}
