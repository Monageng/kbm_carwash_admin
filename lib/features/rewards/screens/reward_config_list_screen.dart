import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/functions/date_utils.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../models/reward_config.dart';
import '../services/reward_service.dart';
import 'reward_config_form.dart';
import '../../../common/widgets/navigation_bar.dart';

class RewardConfigListScreen extends StatefulWidget {
  const RewardConfigListScreen({super.key});

  @override
  State<RewardConfigListScreen> createState() => _RewardConfigListScreenState();
}

class _RewardConfigListScreenState extends State<RewardConfigListScreen> {
  late Future<List<RewardConfig>> _futureList;
  late Future<List<RewardConfig>> _originalfutureList;

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
      List<RewardConfig> filteredList = result.where((element) {
        return element.description!
            .toUpperCase()
            .contains(filter.toUpperCase());
      }).toList();
      setState(() {
        _futureList = Future.value(filteredList);
      });
    });
  }

  void getData() {
    _futureList = RewardsApiService().getAllRewardConfig();
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
                  text: "Add Reward Configuration",
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RewardConfigScreen(
                          rewardConfig: RewardConfig(id: -1),
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
                  labelText: 'Filter by description',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.search, color: Colors.amber),
                ),
              ),
            ),
            FutureBuilder<List<RewardConfig>>(
              future: _futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<RewardConfig>? list = snapshot.data;
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
                                columns: const [
                                  DataColumn(
                                    label: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Reward'),
                                        Text('Title'),
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
                                        Text('Reward'),
                                        Text('Type.'),
                                      ],
                                    ),
                                  ),
                                  DataColumn(label: Text('Description')),
                                  DataColumn(
                                    label: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Discount'),
                                        Text('Type.'),
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
                                        Text('Reward'),
                                        Text('Value'),
                                      ],
                                    ),
                                  ),
                                  DataColumn(label: Text('Frequency')),
                                  DataColumn(
                                    label: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Frequency'),
                                        Text('Value'),
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
                                        Text('Start'),
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
                                        Text('End'),
                                        Text('Date'),
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
  final List<RewardConfig> list;
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
        getDataCellWithWidth(item.title ?? '', 70),
        getDataCellWithWidth(item.rewardType ?? '', 70),
        getDataCellWithWidth(item.description ?? '', 70),
        getDataCellWithWidth(item.discountType ?? '', 70),
        getDataCellWithWidth("${item.rewardValue}", 20),
        getDataCellWithWidth(item.frequencyType ?? '', 70),
        getDataCellWithWidth("${item.frequencyCount}", 20),
        getDataCellWithWidth(formatDateTime(item.fromDate), 70),
        getDataCellWithWidth(formatDateTime(item.toDate), 70),
        getDataCellWithWidth("${item.active}", 40),
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
                        return RewardConfigScreen(
                          rewardConfig: item,
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
                                'Are you sure you want to delete configuration',
                                style: TextStyle(color: Colors.black)),
                            actions: <Widget>[
                              CustomElevatedButton(
                                  text: "Yes",
                                  onPressed: () {
                                    item.active = false;
                                    CommonApiService().update(
                                        item.id,
                                        "reward_config",
                                        item.toJson()); // Close the AlertDialog
                                    list.remove(index);
                                    super.notifyListeners();

                                    Navigator.of(context).pop(index);
                                  }),
                              CustomElevatedButton(
                                text: "No",
                                onPressed: () {
                                  Navigator.of(context).pop(item);
                                },
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
