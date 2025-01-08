import 'package:flutter/material.dart';

import '../features/authentication/screen/logout.dart';
import '../features/booking/screens/appointment_list.dart';
import '../features/booking/screens/payment_transaction_report.dart';
import '../features/booking/screens/ranking_list.dart';
import '../features/dashboard/appointment_dash.dart';
import '../features/franchise/models/franchise_model.dart';
import '../features/franchise/screens/franchise_form.dart';
import '../features/reviews/screens/review_list.dart';
import '../features/rewards/screens/referal_list_screen.dart';
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
  double height = 500;
  double width = 1000;
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
  }

  void setPages(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _pages = <Widget>[
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
          width: width,
          height: height,
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
      const ReferralListScreen(),
      FranchiseForm(
          franchise: AppSessionModel().loggedOnUser != null
              ? AppSessionModel().loggedOnUser!.franchise!
              : Franchise(id: 1, name: "name")),
      const LoginOutForm(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  NavigationRailDestination getMenuTitle(String title, Icon icon) {
    return NavigationRailDestination(
      icon: icon,
      selectedIcon: const Icon(
        Icons.dashboard_outlined,
        color: Colors.blue,
      ),
      label: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    setPages(context);
    var destinations = [
      getMenuTitle(
          "Dashboard", const Icon(Icons.dashboard, color: Colors.white)),
      getMenuTitle(
          "Bookings", const Icon(Icons.calendar_month, color: Colors.white)),
      getMenuTitle("Transactions",
          const Icon(Icons.monetization_on, color: Colors.white)),
      getMenuTitle(
          "Leaderboard", const Icon(Icons.leaderboard, color: Colors.white)),
      getMenuTitle("Clients", const Icon(Icons.people, color: Colors.white)),
      getMenuTitle(
          "Services", const Icon(Icons.car_rental_sharp, color: Colors.white)),
      getMenuTitle("Rewards Configuration",
          const Icon(Icons.wallet_membership, color: Colors.white)),
      getMenuTitle(
          "Review", const Icon(Icons.reviews_outlined, color: Colors.white)),
      getMenuTitle("Referal List",
          const Icon(Icons.social_distance, color: Colors.white)),
      getMenuTitle("Franchise Settings",
          const Icon(Icons.home_work_rounded, color: Colors.white)),
      getMenuTitle("Logout", const Icon(Icons.logout, color: Colors.white)),
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
