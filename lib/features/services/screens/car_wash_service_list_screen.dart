import 'package:flutter/material.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../franchise/models/franchise_model.dart';
import '../models/car_models_model.dart';
import '../models/car_wash_service_model.dart';
import '../models/service_franchise_link_model.dart';
import '../service/car_wash_api_service.dart';
import 'car_wash_service_form.dart';

class ServiceListScreen extends StatefulWidget {
  Franchise franchise;
  ServiceListScreen({super.key, required this.franchise});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  late Future<List<ServiceFranchiseLink>> _futureList;
  late Future<List<ServiceFranchiseLink>> _originalfutureList;

  bool _sortAscending = true;
  int _sortColumnIndex = 0;
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
      List<ServiceFranchiseLink> filteredList = result.where((element) {
        return element.service!.name!
            .toUpperCase()
            .contains(filter.toUpperCase());
      }).toList();

      setState(() {
        _futureList = Future.value(filteredList);
      });
    });
  }

  void getData() {
    _futureList =
        CarWashApiService().getServiceByFranchiseId(widget.franchise.id);
    _originalfutureList = _futureList;
  }

  void refreshData() {
    setState(() {
      getData();
    });
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
                text: "Add service",
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ServiceCaptureScreen(
                        carWashService: ServiceFranchiseLink(
                            id: -1,
                            franchiseId: widget.franchise.id,
                            franchise: widget.franchise,
                            service: CarWashService(
                              id: -1,
                            ),
                            carModel: CarModel(id: -1)),
                      );
                    },
                  );
                  setState(() {
                    getData();
                  });
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
          FutureBuilder<List<ServiceFranchiseLink>>(
            future: _futureList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                List<ServiceFranchiseLink>? list = snapshot.data;
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
                                  list!, context, refreshData),
                              rowsPerPage: list.length < 10 ? list.length : 10,
                              availableRowsPerPage: availableRowsPerPage2,
                              onRowsPerPageChanged: (int? value) {},
                              columns: [
                                DataColumn(
                                  label: const Text('Name'),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      _sortColumnIndex = columnIndex;
                                      _sortAscending = ascending;

                                      list.sort((a, b) {
                                        final aValue = a.service!.name;
                                        final bValue = b.service!.name;

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
                                const DataColumn(label: Text("Car Model")),
                                const DataColumn(label: Text("Price")),
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
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<ServiceFranchiseLink> services;
  final BuildContext context;
  final VoidCallback refreshData;
  MyDataTableSource(this.services, this.context, this.refreshData);

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
        DataCell(Text(
          service.service!.name ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.service!.description ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.carModel!.carType ?? "",
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.price?.toStringAsFixed(2) ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
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
                    refreshData();
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
                                'Are you sure you want to delete car wash service name?',
                                style: TextStyle(color: Colors.black)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  service.active = false;
                                  CommonApiService().update(service.id,
                                      "car_wash_services", service.toJson());
                                  // Close the AlertDialog
                                  services.remove(service);
                                  super.notifyListeners();

                                  Navigator.of(context).pop(service);
                                },
                                child: const Text('Yes',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(service);
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
  int get rowCount => services.length;

  @override
  int get selectedRowCount => 0;
}
