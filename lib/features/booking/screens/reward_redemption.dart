import 'package:flutter/material.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../rewards/models/reward_running_total.dart';
import '../../rewards/services/reward_service.dart';
import '../models/appointment_model.dart';
import '../models/payment_transaction_model.dart';

class RewardRedemptionListScreen extends StatefulWidget {
  final Appointment? appointment;
  final VoidCallback? refreshData;
  const RewardRedemptionListScreen(
      {super.key, this.appointment, this.refreshData});

  @override
  State<RewardRedemptionListScreen> createState() =>
      _RewardRedemptionListScreenState();
}

class _RewardRedemptionListScreenState
    extends State<RewardRedemptionListScreen> {
  late Future<List<RewardRunningTotal>> _futureRewardRunningTotalList;

  final bool _sortAscending = true;
  final int _sortColumnIndex = 0;
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    _filterController.addListener(() {});
  }

  void getData() {
    _futureRewardRunningTotalList = RewardsApiService()
        .getAllRewardRunningTotal("${widget.appointment!.client!.id}");
  }

  void handleClose() async {
    Navigator.of(context).pop(widget.appointment);
  }

  void redeemRewards(RewardRunningTotal runningTotal) async {
    try {
      runningTotal.status = "REDEEMED";
      runningTotal.modifiedDate = DateTime.now();

      String responseMessage = await CommonApiService().update(
          runningTotal.id, "reward_running_total", runningTotal.toJson());
      if (responseMessage.contains("successfully")) {
        int key = await CommonApiService().getLatestID("payment_transaction");
        PaymentTransaction paymentTransaction = PaymentTransaction(
          id: key,
          clientId: widget.appointment!.clientId,
          franchiseId: widget.appointment!.franchiseId,
          createAt: DateTime.now(),
          date: DateTime.now(),
          amount: widget.appointment!.serviceFranchiseLink!.price,
          serviceId: widget.appointment!.serviceFranchiseLink!.serviceId,
        );
        String responseMessage = await CommonApiService()
            .save(paymentTransaction.toJson(), "payment_transaction");
        if (responseMessage.contains("successfully")) {
          widget.appointment!.status = "Completed";
          responseMessage = await CommonApiService().update(
              widget.appointment!.id,
              "appointment",
              widget.appointment!.toJson());
          if (responseMessage.contains("successfully")) {
            await showDialog(
                context: context,
                builder: (c) {
                  return const ErrorDialog(
                      title: "Redeem rewards",
                      message:
                          "Reward was redeemed successfully and booking is completed");
                });
            Navigator.of(context).pop(widget.appointment);
            widget.refreshData!();
          }
        } else {
          await showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(message: "Failed to redeem the rewards");
              });
        }
      }
    } catch (e) {
      await showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Error $e");
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var futureRunningTotal = FutureBuilder<List<RewardRunningTotal>>(
      future: _futureRewardRunningTotalList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<RewardRunningTotal>? list = snapshot.data;
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      child: PaginatedDataTable(
                        showFirstLastButtons: true,
                        arrowHeadColor: Colors.black,
                        sortAscending: _sortAscending,
                        sortColumnIndex: _sortColumnIndex,
                        onPageChanged: (value) {},
                        columnSpacing: 16.0,
                        source: RunningTotalDataTableSource(
                            list!, context, redeemRewards, handleClose),
                        rowsPerPage: list.length < 10 ? list.length : 10,
                        availableRowsPerPage: availableRowsPerPage2,
                        onRowsPerPageChanged: (int? value) {},
                        columns: const [
                          DataColumn(label: Text("Title")),
                          DataColumn(label: Text("Reward type")),
                          DataColumn(label: Text("Reward value")),
                          DataColumn(label: Text("Number")),
                          DataColumn(label: Text("Total")),
                          DataColumn(label: Text("Is Qualified ")),
                          DataColumn(label: Text("Status ")),
                          DataColumn(label: Text("From date")),
                          DataColumn(label: Text("To date")),
                          DataColumn(label: Text("Action")),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
    return AlertDialog(
      content: SizedBox(
        width: 1000,
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _filterController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Filter by name',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.search, color: Colors.blue),
                  ),
                ),
              ),
              futureRunningTotal,
            ],
          ),
        ),
      ),
    );
  }
}

class RunningTotalDataTableSource extends DataTableSource {
  final List<RewardRunningTotal> services;
  final BuildContext context;

  final Function(RewardRunningTotal) handleRedeemReward;

  final Function handleClose;

  RunningTotalDataTableSource(
      this.services, this.context, this.handleRedeemReward, this.handleClose);

  @override
  DataRow getRow(int index) {
    final service = services[index];
    final rowColor = WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue; // Change to the color you want when selected
      }
      return Colors.white; // Default color
    });

    return DataRow.byIndex(
      color: WidgetStateProperty.all<Color>(rowColor),
      index: index,
      cells: [
        DataCell(Text(service.rewardConfig!.description ?? '',
            style: const TextStyle(color: Colors.grey))),
        DataCell(Text(service.rewardConfig!.rewardType ?? '',
            style: const TextStyle(color: Colors.grey))),
        DataCell(Text("${service.rewardConfig!.rewardValue}",
            style: const TextStyle(color: Colors.grey))),
        DataCell(Text("${service.runningTotal} ",
            style: const TextStyle(color: Colors.grey))),
        DataCell(Text("${service.rewardConfig!.frequencyCount} ",
            style: const TextStyle(color: Colors.grey))),
        DataCell(Text("${service.qualify} ",
            style: const TextStyle(color: Colors.grey))),
        DataCell(Text(service.status ?? '',
            style: const TextStyle(color: Colors.grey))),
        DataCell(Text(
          formatDateTime(service.fromDate),
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          formatDateTime(service.toDate),
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(
          Row(
            children: [
              if (service.qualify == true && !(service.status == "REDEEMED"))
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      handleRedeemReward(service);
                    },
                    text: "Redeem",
                    textColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => services.length;

  @override
  int get selectedRowCount => 0;
}
