import 'package:flutter/material.dart';

class TransactionDataSource extends DataTableSource {
  final List<Map<String, dynamic>> transactions;

  TransactionDataSource(this.transactions);

  @override
  DataRow? getRow(int index) {
    if (index >= transactions.length) return null;

    final transaction = transactions[index];
    final client = transaction['client'];
    return DataRow(
      cells: [
        DataCell(Text('${client["first_name"]} ${client["last_name"]}')),
        DataCell(Text('R${transaction["amount"]}')),
        DataCell(Text(transaction['created_at'].substring(0, 10))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => transactions.length;
  @override
  int get selectedRowCount => 0;
}

class TransactionTable extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> transactionsFuture;

  const TransactionTable({Key? key, required this.transactionsFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: transactionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading transactions'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions found'));
        }

        final transactions = snapshot.data!;
        final transactionDataSource = TransactionDataSource(transactions);

        return PaginatedDataTable(
          header: const Text('Transactions'),
          columns: const [
            DataColumn(label: Text('Client Name')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Date')),
          ],
          source: transactionDataSource,
          rowsPerPage:
              5, // You can adjust this value to set the default rows per page
          showCheckboxColumn: false,
        );
      },
    );
  }
}
