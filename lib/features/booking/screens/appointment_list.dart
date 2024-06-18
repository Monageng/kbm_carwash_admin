import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/booking/screens/appointment_form.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/navigation_bar.dart';
import '../models/appointment_model.dart';
import '../services/book_appointment_service.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  late Future<List<CarWashAppointment>> _futureList;
  late Future<List<CarWashAppointment>> _originalfutureList;

  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final String _filter = '';
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
      List<CarWashAppointment> filteredList = result.where((element) {
        return element.client!.firstName!
            .toUpperCase()
            .contains(filter.toUpperCase());
      }).toList();

      setState(() {
        _futureList = Future.value(filteredList);
      });
    });
  }

  void getData() {
    _futureList = BookAppointmentApiService().getAllActiveAppointments();
    _originalfutureList = _futureList;
  }

  @override
  Widget build(BuildContext context) {
    // final MyDataTableSource _data = MyDataTableSource(appointments);

    return Scaffold(
      appBar: getTopNavigation(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                  text: "Book appointment",
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AppointmentScreen(
                          appointment: CarWashAppointment(id: -1),
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
                  prefixIcon: Icon(Icons.search, color: Colors.amber),
                ),
              ),
            ),
            FutureBuilder<List<CarWashAppointment>>(
              future: _futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<CarWashAppointment>? list = snapshot.data;
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
                                source: MyDataTableSource(
                                  list!,
                                  context,
                                ),
                                rowsPerPage: list.length < 10 ? list.length : 5,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<CarWashAppointment> list;
  final BuildContext context;

  MyDataTableSource(this.list, this.context);

  @override
  DataRow getRow(int index) {
    final item = list[index];
    final rowColor = MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue; // Change to the color you want when selected
      }
      return Colors.white; // Default color
    });

    return DataRow.byIndex(
      color: MaterialStateProperty.all<Color>(rowColor),
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AppointmentScreen(
                          appointment: item,
                        );
                      },
                    );
                  },
                  text: "Edit",
                  textColor: Colors.white,
                ),
              ),
              CustomElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: const Text(
                              'Delete confirmation',
                              style: TextStyle(color: Colors.black),
                            ),
                            content: const Text(
                                'Are you sure you want to delete appointment?',
                                style: TextStyle(color: Colors.black)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  item.active = false;
                                  item.client = null;
                                  CommonApiService().update(
                                      item.id, "appointment", item.toJson());
                                  list.remove(item);
                                  super.notifyListeners();
                                  Navigator.of(context).pop(item);
                                },
                                child: const Text('Yes',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(item);
                                },
                                child: const Text('No',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ]);
                      });
                },
                text: "Delete",
                buttonColor: Colors.blue,
                textColor: Colors.white,
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
