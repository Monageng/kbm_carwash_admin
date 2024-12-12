import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../common/functions/common_functions.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../booking/models/appointment_model.dart';
import '../../booking/screens/appointment_form.dart';
import '../../franchise/models/franchise_model.dart';
import '../../rewards/screens/reward_allocation_list_screen.dart';
import '../models/user_data.dart';
import '../models/user_model.dart';
import '../services/car_wash_api_service.dart';
import 'user_form.dart';

class UserListScreen extends StatefulWidget {
  Franchise franchise;
  UserListScreen({super.key, required this.franchise});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
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

  void refreshData() {
    setState(() {
      getData();
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

  List<NewUsersData> getMonthlyNewUsersData(List<UserModel> users) {
    Map<String, int> monthlyCount = {};
    for (var user in users) {
      final date = user.createdAt!;
      final monthKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}"; // e.g., "2024-07"

      if (!monthlyCount.containsKey(monthKey)) {
        monthlyCount[monthKey] = 0;
      }
      monthlyCount[monthKey] = monthlyCount[monthKey]! + 1;
    }

    // Convert to list of NewUsersData
    return monthlyCount.entries
        .map((entry) => NewUsersData(entry.key, entry.value))
        .toList()
      ..sort((a, b) => a.month.compareTo(b.month));
  }

  Widget _buildNewUsersChart(List<UserModel> users) {
    final data = getMonthlyNewUsersData(users);
    return SfCartesianChart(
      title: const ChartTitle(
        text: 'Monthly New Users',
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(
          text: 'Month',
          textStyle: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        labelRotation: 45, // Rotates labels for better readability
        majorGridLines: MajorGridLines(width: 0), // Hides vertical grid lines
      ),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(
          text: 'Number of New Users',
          textStyle: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        labelFormat: '{value}', // Customize label format if needed
        majorTickLines: MajorTickLines(size: 8),
        axisLine: AxisLine(width: 0), // Removes main axis line
      ),
      series: <CartesianSeries>[
        ColumnSeries<NewUsersData, String>(
          dataSource: data,
          xValueMapper: (NewUsersData user, _) => user.month,
          yValueMapper: (NewUsersData user, _) => user.count,
          color: Colors.blueAccent,
          borderRadius:
              const BorderRadius.all(Radius.circular(4)), // Rounded bars
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
      legend: const Legend(
        isVisible: false,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y',
        color: Colors.blueGrey,
      ),
      plotAreaBorderWidth: 0, // Removes border around plot area
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: getTopNavigation(context),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomElevatedButton(
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
                      setState(() {
                        getData();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _filterController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Filter by name',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 16.0),
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
                                      source: MyDataTableSource(list!, context,
                                          widget.franchise, refreshData),
                                      rowsPerPage:
                                          list.length <= 5 ? list.length : 5,
                                      availableRowsPerPage:
                                          availableRowsPerPage2,
                                      onRowsPerPageChanged: (int? value) {},
                                      columns: _buildColumns(constraints),
                                    ),
                                  ),
                                  _buildNewUsersChart(list),
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
        },
      ),
    );
  }

  List<DataColumn> _buildColumns(BoxConstraints constraints) {
    return [
      const DataColumn(label: Text('User ID')),
      const DataColumn(label: Text("Title")),
      DataColumn(
        label: const Text('First Name'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortColumnIndex = columnIndex;
            _sortAscending = ascending;

            _futureList.then((list) {
              list.sort((a, b) {
                final aValue = a.firstName;
                final bValue = b.firstName;

                if (_sortAscending) {
                  return Comparable.compare(aValue!, bValue!);
                } else {
                  return Comparable.compare(bValue!, aValue!);
                }
              });
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

            _futureList.then((list) {
              list.sort((a, b) {
                final aValue = a.lastName;
                final bValue = b.lastName;

                if (_sortAscending) {
                  return Comparable.compare(aValue!, bValue!);
                } else {
                  return Comparable.compare(bValue!, aValue!);
                }
              });
            });
          });
        },
      ),
      const DataColumn(label: Text("Mobile Number")),
      const DataColumn(label: Text("Email")),
      const DataColumn(label: Text("Date Of Birth")),
      const DataColumn(label: Text('Action')),
    ];
  }
}

class MyDataTableSource extends DataTableSource {
  final List<UserModel> list;
  final BuildContext context;
  Franchise franchise;
  final VoidCallback refreshData;

  MyDataTableSource(this.list, this.context, this.franchise, this.refreshData);

  @override
  DataRow getRow(int index) {
    final item = list[index];
    WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue; // Change to the color you want when selected
      }
      return Colors.white; // Default color
    });
    return DataRow.byIndex(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue.withOpacity(0.2); // Highlight color when selected.
        }
        return index.isEven
            ? const Color.fromARGB(255, 61, 118, 242)
                .withOpacity(0.5) // Color for even rows.
            : const Color.fromARGB(255, 183, 190, 238); // Color for odd rows.
      }),
      // color: WidgetStateProperty.all<Color>(rowColor),
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
                        refreshData: refreshData,
                      );
                    },
                  );

                  refreshData;
                },
                text: "Edit",
                textColor: Colors.white,
              ),
              if (franchise.id > 0)
                CustomElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AppointmentScreen(
                          appointment: Appointment(
                              id: -1,
                              client: item,
                              clientId: item.id,
                              franchiseId: franchise.id),
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
                text: "Rewards",
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
                                  CommonApiService().update(
                                      item.id!, "client", item.toJson());
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
