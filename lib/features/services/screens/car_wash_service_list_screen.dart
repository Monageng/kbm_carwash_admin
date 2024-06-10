import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/services/service/car_wash_api_service.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../models/car_wash_service_model.dart';
import 'car_wash_service_form.dart';
import '../../../common/widgets/navigation_bar.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  late Future<List<CarWashService>> _futureList;
  late Future<List<CarWashService>> _originalfutureList;

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
    print("Filter text $filter ");

    _originalfutureList.then((result) {
      List<CarWashService> filteredList = result.where((element) {
        return element.name!.toUpperCase().contains(filter.toUpperCase());
      }).toList();

      for (var element in filteredList) {
        print("Filtered ${element.name}");
      }

      setState(() {
        _futureList = Future.value(filteredList);
      });
    });
  }

  void getData() {
    _futureList = CarWashApiService().getAllCarWashService();
    _originalfutureList = _futureList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTopNavigation(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                  text: "Add car service",
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ServiceCaptureScreen(
                          carWashService: new CarWashService(id: -1),
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
            FutureBuilder<List<CarWashService>>(
              future: _futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<CarWashService>? list = snapshot.data;
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
                                rowsPerPage:
                                    list.length < 10 ? list.length : 10,
                                availableRowsPerPage: availableRowsPerPage2,
                                onRowsPerPageChanged: (int? value) {},
                                columns: [
                                  const DataColumn(label: Text('ID')),
                                  DataColumn(
                                    label: const Text('Name'),
                                    onSort: (columnIndex, ascending) {
                                      setState(() {
                                        _sortColumnIndex = columnIndex;
                                        _sortAscending = ascending;

                                        list.sort((a, b) {
                                          final aValue = a.name;
                                          final bValue = b.name;

                                          if (_sortAscending) {
                                            return Comparable.compare(
                                                aValue!, bValue!);
                                          } else {
                                            return Comparable.compare(
                                                bValue!, aValue!);
                                          }
                                        });
                                      });
                                    },
                                  ),
                                  const DataColumn(label: Text("Description")),
                                  const DataColumn(label: Text("Price")),
                                  const DataColumn(label: Text("Status")),
                                  const DataColumn(label: Text("Code")),
                                  const DataColumn(label: Text('Action')),
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
  final List<CarWashService> services;
  final BuildContext context;

  MyDataTableSource(this.services, this.context);

  @override
  DataRow getRow(int index) {
    final service = services[index];
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
        DataCell(Text(
          service.id.toString(),
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.name ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.description ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.price?.toStringAsFixed(2) ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.active == true ? 'Active' : 'Inactive',
          style: const TextStyle(color: Colors.grey),
        )),
        // DataCell(Text(
        //   service.createdAt?.toLocal().toString() ?? '',
        //   style: TextStyle(color: Colors.grey),
        // )),
        DataCell(Text(
          service.code ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        // DataCell(Text(
        //   service.fromDate?.toLocal().toString() ?? '',
        //   style: const TextStyle(color: Colors.grey),
        // )),
        // DataCell(Text(
        //   service.toDate?.toLocal().toString() ?? '',
        //   style: const TextStyle(color: Colors.grey),
        // )),
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
                        return ServiceCaptureScreen(
                          carWashService: service,
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
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //           title: const Text(
                  //             'Delete confirmation',
                  //             style: TextStyle(color: Colors.black),
                  //           ),
                  //           content: const Text(
                  //               'Are you sure you want to delete restaurant?',
                  //               style: TextStyle(color: Colors.black)),
                  //           actions: <Widget>[
                  //             TextButton(
                  //               onPressed: () {
                  //                 restaurant.isActive = false;
                  //                 ApiServiceV2().updateById(restaurant.toJson(),
                  //                     "restaurants", restaurant.uuid);
                  //                 // Close the AlertDialog
                  //                 _restaurants.remove(restaurant);
                  //                 super.notifyListeners();

                  //                 Navigator.of(context).pop(restaurant);
                  //               },
                  //               child: const Text('Yes',
                  //                   style: TextStyle(color: Colors.black)),
                  //             ),
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop(restaurant);
                  //               },
                  //               child: const Text('No',
                  //                   style: TextStyle(color: Colors.black)),
                  //             ),
                  //           ]);
                  //     });
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
  int get rowCount => services.length;

  @override
  int get selectedRowCount => 0;
}
