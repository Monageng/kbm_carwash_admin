import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/reviews/models/review_model.dart';
import 'package:kbm_carwash_admin/features/reviews/services/review_service.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/date_utils.dart';
import '../../franchise/models/franchise_model.dart';

class ReviewListScreen extends StatefulWidget {
  Franchise franchise;

  ReviewListScreen({super.key, required this.franchise});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  late Future<List<ReviewModel>> _futureList;
  late Future<List<ReviewModel>> _originalfutureList;

  final bool _sortAscending = true;
  final int _sortColumnIndex = 0;
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    print("Insi _ReviewListScreenState");
    super.initState();
    getData();
    _filterController.addListener(() {
      _filterData(_filterController.text);
    });
  }

  void _filterData(String filter) {
    _originalfutureList.then((result) {
      List<ReviewModel> filteredList = result.where((element) {
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
    _futureList = ReviewApiService().getReviews(widget.franchise.id.toString());
    _originalfutureList = _futureList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                prefixIcon: Icon(Icons.search, color: Colors.blue),
              ),
            ),
          ),
          FutureBuilder<List<ReviewModel>>(
            future: _futureList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                List<ReviewModel>? list = snapshot.data;
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
                                DataColumn(label: Text('Review Date')),
                                DataColumn(label: Text('Rating')),
                                DataColumn(label: Text('Review')),
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
  final List<ReviewModel> list;
  final Franchise franchise;
  final BuildContext context;
  final VoidCallback refreshData;
  MyDataTableSource(this.list, this.context, this.franchise, this.refreshData);

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
          getDataCellWithWidth(formatDateTime(item.reviewDate), 80),
          getDataCellWithWidth('${item.rating}', 80),
          getDataCellWithWidth('${item.review}', 180),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => list.length;

  @override
  int get selectedRowCount => 0;
}
