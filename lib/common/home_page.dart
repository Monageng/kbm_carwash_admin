import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/booking/screens/appointment_list.dart';
import 'package:kbm_carwash_admin/features/franchise/models/franchise_model.dart';
import 'package:kbm_carwash_admin/features/franchise/screens/franchise_form.dart';
import 'package:kbm_carwash_admin/features/rewards/screens/reward_config_list_screen.dart';
import 'package:kbm_carwash_admin/features/services/screens/car_wash_service_list_screen.dart';
import 'package:kbm_carwash_admin/features/users/screens/user_list_screen.dart';
import 'package:kbm_carwash_admin/session/app_session.dart';

import '../features/dashboard/appointment_dash.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                selectedIcon: Icon(
                  Icons.dashboard_outlined,
                  color: Colors.blue,
                ),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book_online),
                selectedIcon: Icon(
                  Icons.book_online_outlined,
                  color: Colors.blue,
                ),
                label: Text('Bookings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                selectedIcon: Icon(
                  Icons.people_outline,
                  color: Colors.blue,
                ),
                label: Text('Customers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.car_repair),
                selectedIcon: Icon(
                  Icons.car_repair_outlined,
                  color: Colors.blue,
                ),
                label: Text('Services'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(
                  Icons.star_border,
                  color: Colors.blue,
                ),
                label: Text('Rewards Configuration'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(
                  Icons.settings_outlined,
                  color: Colors.blue,
                ),
                label: Text('Franchise Settings'),
              ),
            ],
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


// import '../features/booking/services/book_appointment_service.dart';
// import '../session/app_session.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   @override
//   void initState() {
//     super.initState();

//     try {
//       // CommonBusinessService().fetchProvinceLookup();
//       // CommonBusinessService().fetchCityLookup();
//       // MealBusinessService().fetchCategories();
//       // ignore: empty_catches
//     } catch (e) {}
//   }

//   void loadData() async {
//     // AppSessionModel()
//     //     .setCarwashServiceList(CarWashApiService().getAllCarWashService());
//     // logger.d(
//     //     "Loaded carwashServiceList:  ${AppSessionModel().carwashServiceList}");

//     AppSessionModel().setAppointmentList(
//         BookAppointmentApiService().getAllAppointments("1"));
//     // logger.d("Loaded appointmentList:  ${AppSessionModel().appointmentList}");

//     // AppSessionModel()
//     //     .setRewardAllocation(RewardsApiService().getAllRewardAllocation("1"));
//     // logger.d("Loaded appointmentList:  ${AppSessionModel().appointmentList}");

//     // AppSessionModel().setRewardRunningTotal(
//     //     RewardsApiService().getAllRewardRunningTotal("1"));
//     // logger.d(
//     //     "Loaded rewardRunningTotal:  ${AppSessionModel().rewardRunningTotal}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     var scaffold3 = Scaffold(
//       body: SizedBox(
//         child: Container(
//           color: Colors.red,
//           height: 100,
//         ),
//       ),
//     );
//     return scaffold3;
//   }
// }
