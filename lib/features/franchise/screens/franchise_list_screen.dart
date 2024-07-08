import 'package:flutter/material.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/navigation_bar.dart';
import '../models/franchise_model.dart';
import '../services/franchise_service.dart';
import 'franchise_accodion_home.dart';
import 'franchise_form.dart';

class FranchiseListScreen extends StatefulWidget {
  const FranchiseListScreen({super.key});

  @override
  State<FranchiseListScreen> createState() => _FranchiseListScreenState();
}

class _FranchiseListScreenState extends State<FranchiseListScreen> {
  late Future<List<Franchise>> _futureList;
  late Future<List<Franchise>> _originalFutureList;

  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureList = fetchData();
    _originalFutureList = _futureList;
    _filterController.addListener(() {
      _filterData(_filterController.text);
    });
  }

  void _filterData(String filter) {
    _originalFutureList.then((result) {
      List<Franchise> filteredList = result.where((element) {
        return element.name.toUpperCase().contains(filter.toUpperCase());
      }).toList();

      setState(() {
        _futureList = Future.value(filteredList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizedBox = SizedBox(
      height: 500,
      child: FutureBuilder<List<Franchise>>(
        future: _futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight),
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
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.amber),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          // Set the desired width
                          child: PaginatedDataTable(
                            showFirstLastButtons: true,
                            arrowHeadColor: Colors.black,
                            sortAscending: true,
                            columnSpacing: 16.0,

                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text("Contact person")),
                              DataColumn(label: Text("Contact number")),
                              DataColumn(label: Text("Email")),
                              DataColumn(label: Text('Action')),
                            ],
                            source: MyDataTableSource(snapshot.data!, context),
                            rowsPerPage: snapshot.data!.length < 10
                                ? snapshot.data!.length
                                : 10, // Number of rows per page
                            availableRowsPerPage:
                                availableRowsPerPage2, // Customize available rows per page
                            onRowsPerPageChanged: (int? value) {
                              // Handle rows per page change
                            },
                            //dataRowHeight: 60.0, // Adjust row height as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
    return Scaffold(
      appBar: getTopNavigation(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: CustomElevatedButton(
                text: "Add New Franchise",
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return FranchiseForm(
                          franchise: Franchise(id: -1, name: ""));
                    },
                  );
                  if (result != null) {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const FranchiseListScreen()));
                    });
                  }
                }),
          ),
          sizedBox,
        ],
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Franchise> _list;
  final BuildContext context;
  MyDataTableSource(this._list, this.context);

  @override
  DataRow getRow(int index) {
    final item = _list[index];
    final rowColor = MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue; // Change to the color you want when selected
      }
      return const Color.fromARGB(255, 231, 225, 225); // Default color
    });
    return DataRow(color: MaterialStateProperty.all<Color>(rowColor), cells: [
      getDataCell(item.id.toString(), MediaQuery.of(context).size.width * 0.04),
      getDataCell(item.name, MediaQuery.of(context).size.width * 0.10),
      getDataCell(item.contactPerson, MediaQuery.of(context).size.width * 0.10),
      getDataCell(item.contactNumber, MediaQuery.of(context).size.width * 0.10),
      getDataCell(item.email, MediaQuery.of(context).size.width * 0.10),
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
                      return FranchiseAccordion(
                        franchise: item,
                      );
                    },
                  );
                },
                text: "Edit",
                buttonColor: Colors.blue,
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
                              'Are you sure you want to delete franchise?',
                              style: TextStyle(color: Colors.black)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                item.active = false;
                                CommonApiService().update(
                                    item.id, "franchise", item.toJson());
                                // Close the AlertDialog
                                _list.remove(item);
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
    ]);
  }

  DataCell getDataCell(String? dateValue, double width) {
    return DataCell(
      SizedBox(
        width: width,
        child: Text(
          style: const TextStyle(color: Colors.grey),
          dateValue!,
          softWrap: true,
        ),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _list.length;

  @override
  int get selectedRowCount => 0;
}

Future<List<Franchise>> fetchData() async {
  Future<List<Franchise>> response = FranchiseApiService().getAllFranchise();
  return response;
}
