import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/rewards/screens/reward_allocation_list_screen.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../models/user_model.dart';
import '../services/car_wash_api_service.dart';
import 'user_form.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<UserModel>> _futureList;
  late Future<List<UserModel>> _originalfutureList;

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
      List<UserModel> filteredList = result.where((element) {
        return element.firstName!.toUpperCase().contains(filter.toUpperCase());
      }).toList();

      for (var element in filteredList) {
        print("Filtered ${element.firstName}");
      }

      setState(() {
        _futureList = Future.value(filteredList);
      });
    });
  }

  void getData() {
    _futureList = UserApiService().getAllUsers();
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
                  text: "Add new user",
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UserScreen(
                          user: UserModel(id: -1),
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
            FutureBuilder<List<UserModel>>(
              future: _futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<UserModel>? list = snapshot.data;
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
                                columns: [
                                  const DataColumn(label: Text('ID')),
                                  const DataColumn(label: Text('User ID')),
                                  const DataColumn(label: Text("Title")),
                                  DataColumn(
                                    label: const Text('First Name'),
                                    onSort: (columnIndex, ascending) {
                                      setState(() {
                                        _sortColumnIndex = columnIndex;
                                        _sortAscending = ascending;

                                        list.sort((a, b) {
                                          final aValue = a.firstName;
                                          final bValue = b.firstName;

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
                                  DataColumn(
                                    label: const Text('Surname'),
                                    onSort: (columnIndex, ascending) {
                                      setState(() {
                                        _sortColumnIndex = columnIndex;
                                        _sortAscending = ascending;

                                        list.sort((a, b) {
                                          final aValue = a.lastName;
                                          final bValue = b.lastName;

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
                                  const DataColumn(
                                      label: Text("Mobile Number")),
                                  const DataColumn(label: Text("Email")),
                                  const DataColumn(
                                      label: Text("Date Of Birth")),
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
  final List<UserModel> list;
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
        getDataCellWithWidth(item.id.toString(), 10),
        getDataCellWithWidth(item.userId ?? '', 180),
        getDataCellWithWidth(item.title ?? '', 20),
        getDataCellWithWidth(item.firstName ?? '', 100),
        getDataCellWithWidth(item.lastName ?? '', 100),
        getDataCellWithWidth(item.mobileNumber ?? '', 100),
        getDataCellWithWidth(item.email ?? '', 250),
        getDataCellWithWidth(item.dateOfBirth ?? '', 80),
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
                        return UserScreen(
                          user: item,
                        );
                      },
                    );
                  },
                  text: "Edit",
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomElevatedButton(
                  onPressed: () async {
                    print("User objects >>> ${item.toJson()}");
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RewardAllocationListScreen(
                          userId: item.userId!,
                        );
                      },
                    );
                  },
                  text: "View rewards",
                  textColor: Colors.white,
                ),
              ),
              CustomElevatedButton(
                onPressed: () {},
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
