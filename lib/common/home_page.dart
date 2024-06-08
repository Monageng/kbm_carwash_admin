import 'package:flutter/material.dart';

import '../features/booking/services/book_appointment_service.dart';
import '../session/app_session.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  @override
  void initState() {
    super.initState();

    try {
      // CommonBusinessService().fetchProvinceLookup();
      // CommonBusinessService().fetchCityLookup();
      // MealBusinessService().fetchCategories();
    } catch (e) {
      print(e);
    }
  }

  void loadData() async {
    // AppSessionModel()
    //     .setCarwashServiceList(CarWashApiService().getAllCarWashService());
    // logger.d(
    //     "Loaded carwashServiceList:  ${AppSessionModel().carwashServiceList}");

    AppSessionModel().setAppointmentList(
        BookAppointmentApiService().getAllAppointments("1"));
    // logger.d("Loaded appointmentList:  ${AppSessionModel().appointmentList}");

    // AppSessionModel()
    //     .setRewardAllocation(RewardsApiService().getAllRewardAllocation("1"));
    // logger.d("Loaded appointmentList:  ${AppSessionModel().appointmentList}");

    // AppSessionModel().setRewardRunningTotal(
    //     RewardsApiService().getAllRewardRunningTotal("1"));
    // logger.d(
    //     "Loaded rewardRunningTotal:  ${AppSessionModel().rewardRunningTotal}");
  }

  @override
  Widget build(BuildContext context) {
    var scaffold3 = Scaffold(
      body: SizedBox(
        child: Container(
          color: Colors.red,
          height: 100,
        ), //RestaurantListScreen(),
      ),
    );
    return scaffold3;
  }
}
