import 'package:flutter/material.dart';

import '../../../common/widgets/navigation_bar.dart';
import '../models/franchise_model.dart';

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
    return Scaffold(
      appBar: getTopNavigation(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          //double padding = constraints.maxWidth * 0.05;
          return const SingleChildScrollView(
            // padding: EdgeInsets.all(padding),
            child: Column(
              children: <Widget>[
                // [buildAccordionItem(
                //   title: 'Dashboard Details',
                //   child: DashboardScreen(franchise: widget.franchise),
                //   isExpanded: true,
                // ),
                // buildAccordionItem(
                //   title: 'Franchise Details',
                //   child: FranchiseForm(franchise: widget.franchise),
                //   isExpanded: false,
                // ),
                // buildAccordionItem(
                //   title: 'Appointments',
                //   child: AppointmentListScreen(franchise: widget.franchise),
                //   isExpanded: false,
                // ),
                // buildAccordionItem(
                //   title: 'Services',
                //   child: ServiceListScreen(franchise: widget.franchise),
                //   isExpanded: false,
                // ),
                // buildAccordionItem(
                //   title: 'Reward Configurations',
                //   child: RewardConfigListScreen(franchise: widget.franchise),
                //   isExpanded: false,
                // ),]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildAccordionItem(
      {required String title, required Widget child, required isExpanded}) {
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
        initiallyExpanded: isExpanded,
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
