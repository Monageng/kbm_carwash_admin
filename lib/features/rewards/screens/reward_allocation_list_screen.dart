import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/rewards/models/reward_model.dart';
import 'package:kbm_carwash_admin/features/rewards/services/reward_service.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/widgets/navigation_bar.dart';

class RewardAllocationListScreen extends StatefulWidget {
  RewardAllocationListScreen({super.key, required this.userId});

  String userId;

  @override
  State<RewardAllocationListScreen> createState() =>
      _RewardAllocationListScreenState();
}

class _RewardAllocationListScreenState
    extends State<RewardAllocationListScreen> {
  late Future<List<Reward>> _futureList;
  late Future<List<Reward>> _originalfutureList;

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
      List<Reward> filteredList = result.where((element) {
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
    _futureList =
        RewardsApiService().getAllRewardAllocationByClientUserId(widget.userId);
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
            FutureBuilder<List<Reward>>(
              future: _futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<Reward>? list = snapshot.data;
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
                                  DataColumn(label: Text("Title")),
                                  DataColumn(label: Text("Description")),
                                  DataColumn(label: Text("Transaction Date")),
                                  DataColumn(label: Text("Transaction Amount")),
                                  DataColumn(label: Text("Reward Amount")),
                                  DataColumn(label: Text("Discount Amount")),
                                  // DataColumn(label: Text('Action')),
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
  final List<Reward> services;
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
          service.title ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.description ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.date?.toLocal().toString() ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.transactionAmount?.toStringAsFixed(2) ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.rewardAmount?.toStringAsFixed(2) ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
        DataCell(Text(
          service.discountedAmount?.toStringAsFixed(2) ?? '',
          style: const TextStyle(color: Colors.grey),
        )),
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
