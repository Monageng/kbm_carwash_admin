import 'package:flutter/material.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../franchise/models/franchise_model.dart';
import '../../users/screens/user_list_screen.dart';
import '../models/appointment_model.dart';
import '../services/book_appointment_service.dart';
import '../models/payment_transaction_model.dart';
import 'appointment_form.dart';

class AppointmentListScreen extends StatefulWidget {
  Franchise franchise;

  AppointmentListScreen({super.key, required this.franchise});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  late Future<List<Appointment>> _futureList;
  late Future<List<Appointment>> _originalfutureList;

  final bool _sortAscending = true;
  final int _sortColumnIndex = 0;
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    _filterController.addListener(() {
      _filterData(_filterController.text);
    });
  }

  void _filterData(String filter) {
    _originalfutureList.then((result) {
      List<Appointment> filteredList = result.where((element) {
        return element.client!.firstName!
            .toUpperCase()
            .contains(filter.toUpperCase());
      }).toList();

      setState(() {
        _futureList = Future.value(filteredList);
      });
    });
  }

  void refreshData() {
    setState(() {
      getData();
    });
  }

  void getData() {
    _futureList = BookAppointmentApiService()
        .getAllActiveAppointmentsByFranchiseId(widget.franchise.id);
    _originalfutureList = _futureList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomElevatedButton(
                text: "Book appointment",
                onPressed: () async {
                  // Navigator.of(context).pushReplacementNamed('/userlist');

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UserListScreen(
                        franchise: widget.franchise,
                      );
                    },
                  );
                }),
          ),
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
          FutureBuilder<List<Appointment>>(
            future: _futureList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                List<Appointment>? list = snapshot.data;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: PaginatedDataTable(
                              showFirstLastButtons: true,
                              arrowHeadColor: Colors.black,
                              sortAscending: _sortAscending,
                              sortColumnIndex: _sortColumnIndex,
                              onPageChanged: (value) {},
                              columnSpacing: 16.0,
                              source: MyDataTableSource(list!, context,
                                  widget.franchise, refreshData),
                              rowsPerPage: list.length < 10 ? list.length : 10,
                              availableRowsPerPage: availableRowsPerPage2,
                              onRowsPerPageChanged: (int? value) {},
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Client Name')),
                                DataColumn(label: Text('Service Name')),
                                DataColumn(label: Text('Created Date')),
                                DataColumn(
                                  label: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Appointment'),
                                      Text('Date'),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Appointment'),
                                      Text('Time'),
                                    ],
                                  ),
                                ),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Action')),
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
          ),
        ],
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Appointment> list;
  final Franchise franchise;
  final BuildContext context;
  final VoidCallback refreshData;
  MyDataTableSource(this.list, this.context, this.franchise, this.refreshData);

  void createTransaction(Appointment appointment, BuildContext context) async {
    try {
      int key = await CommonApiService().getLatestID("payment_transaction");
      PaymentTransaction paymentTransaction = PaymentTransaction(
        id: key,
        clientId: appointment.clientId,
        franchiseId: appointment.franchiseId,
        createAt: DateTime.now(),
        date: DateTime.now(),
        amount: appointment.serviceFranchiseLink!.price,
        serviceId: appointment.serviceFranchiseLink!.serviceId,
      );

      String responseMessage = await CommonApiService()
          .save(paymentTransaction.toJson(), "payment_transaction");
      if (responseMessage.contains("successfully")) {
        appointment.active = true;
        appointment.client = null;
        appointment.status = "Completed";
        responseMessage = await CommonApiService()
            .update(appointment.id, "appointment", appointment.toJson());

        if (responseMessage.contains("successfully")) {
          Navigator.of(context).pop(appointment);
          list.remove(appointment);
          refreshData;
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
  DataRow getRow(int index) {
    final item = list[index];
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
        getDataCellWithWidth(item.id.toString(), 20),
        getDataCellWithWidth(
            '${item.client!.firstName} ${item.client!.lastName}', 180),
        getDataCellWithWidth('${item.serviceName}', 180),
        getDataCellWithWidth(formatDateTime(item.createAt), 80),
        getDataCellWithWidth(formatDateTime(item.date), 80),
        getDataCellWithWidth('${item.time}', 80),
        getDataCellWithWidth(item.status ?? '', 180),
        DataCell(
          Row(
            children: [
              if (!item.status!.contains("Completed") &&
                  !item.status!.contains("Expired") &&
                  !item.status!.contains("Cancelled"))
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AppointmentScreen(
                            appointment: item,
                            refreshData: refreshData,
                          );
                        },
                      );
                    },
                    text: "Edit",
                    textColor: Colors.white,
                  ),
                ),
              if (!item.status!.contains("Completed") &&
                  !item.status!.contains("Expired") &&
                  !item.status!.contains("Cancelled"))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: const Text(
                                  'Complete appointment',
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: const Text(
                                    'You sure you want to completed the appointment?',
                                    style: TextStyle(color: Colors.black)),
                                actions: <Widget>[
                                  CustomElevatedButton(
                                    onPressed: () {
                                      createTransaction(item, context);
                                    },
                                    text: 'Yes',
                                  ),
                                  CustomElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(item);
                                    },
                                    text: 'No',
                                  ),
                                ]);
                          });
                      refreshData();
                    },
                    text: "Complete",
                    buttonColor: Colors.blue,
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
  int get rowCount => list.length;

  @override
  int get selectedRowCount => 0;
}
