import 'package:flutter/material.dart';

import '../../../common/widgets/navigation_bar.dart';
import '../../booking/screens/appointment_list.dart';
import '../../rewards/screens/reward_config_list_screen.dart';
import '../../services/screens/car_wash_service_list_screen.dart';
import '../models/franchise_model.dart';
import 'franchise_form.dart';

class FranchiseAccordion extends StatefulWidget {
  final Franchise franchise;

  const FranchiseAccordion({super.key, required this.franchise});

  @override
  _FranchiseAccordionState createState() => _FranchiseAccordionState();
}

class _FranchiseAccordionState extends State<FranchiseAccordion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(" FranchiseAccordion ${widget.franchise.id}");
    return Scaffold(
      appBar: getTopNavigation(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.05;
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: <Widget>[
                buildAccordionItem(
                  title: 'Franchise Details',
                  child: FranchiseForm(franchise: widget.franchise!),
                ),
                buildAccordionItem(
                  title: 'Appointments',
                  child: AppointmentListScreen(franchise: widget.franchise!),
                ),
                buildAccordionItem(
                  title: 'Services',
                  child: ServiceListScreen(franchise: widget.franchise!),
                ),
                buildAccordionItem(
                  title: 'Reward Configurations',
                  child: RewardConfigListScreen(franchise: widget.franchise!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildAccordionItem({required String title, required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.blueAccent, // Set your divider color here
            width: 2.0, // Set your divider size here
          ),
        ),
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.blue,
        iconColor: Colors.blue,
        backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
        collapsedBackgroundColor: const Color.fromARGB(255, 227, 221, 221),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ],
      ),
    );
  }
}
