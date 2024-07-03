import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/services/common_api_service.dart';
import 'package:kbm_carwash_admin/features/booking/models/appointment_model.dart';
import 'package:kbm_carwash_admin/features/rewards/screens/reward_allocation_list_screen.dart';
import '../../../common/functions/common_functions.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../booking/screens/appointment_form.dart';
import '../models/user_model.dart';
import '../services/car_wash_api_service.dart';
import 'user_form.dart';
import '../../../common/widgets/navigation_bar.dart';

class UserListScreenOld extends StatefulWidget {
  const UserListScreenOld({super.key});

  @override
  State<UserListScreenOld> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreenOld> {
  late Future<List<UserModel>> _futureList;
  late Future<List<UserModel>> _originalfutureList;

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
      List<UserModel> filteredList = result.where((element) {
        return element.firstName!.toUpperCase().contains(filter.toUpperCase());
      }).toList();

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
                  text: "Add new client",
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
        getDataCellWithWidth(item.userId ?? '', 180),
        getDataCellWithWidth(item.title ?? '', 20),
        getDataCellWithWidth(item.firstName ?? '', 100),
        getDataCellWithWidth(item.lastName ?? '', 100),
        getDataCellWithWidth(item.mobileNumber ?? '', 100),
        getDataCellWithWidth(item.email ?? '', 250),
        getDataCellWithWidth(item.dateOfBirth ?? '', 80),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
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
              CustomElevatedButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AppointmentScreen(
                        appointment: CarWashAppointment(
                            id: -1, client: item, clientId: item.id),
                      );
                    },
                  );
                },
                text: "Book",
                textColor: Colors.white,
              ),
              CustomElevatedButton(
                onPressed: () async {
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
                                'Are you sure you want to delete user?',
                                style: TextStyle(color: Colors.black)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  item.active = false;
                                  CommonApiService()
                                      .update(item.id, "client", item.toJson());
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