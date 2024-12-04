// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/booking/services/book_appointment_service.dart';

import '../../dashboard/payment_transaction_dash.dart';
import '../../franchise/models/franchise_model.dart';
import '../models/payment_transaction_model.dart';

class PaymentTransactionListScreen extends StatefulWidget {
  Franchise franchise;

  PaymentTransactionListScreen({super.key, required this.franchise});

  @override
  createState() => _PaymentTransactionTableState();
}

class _PaymentTransactionTableState
    extends State<PaymentTransactionListScreen> {
  late Future<List<PaymentTransaction>> futureTransactions;

  final bool _sortAscending = true;
  final int _sortColumnIndex = 0;
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureTransactions = fetchTransactions();
    _filterController.addListener(() {
      _filterData(_filterController.text);
    });
  }

  void _filterData(String filter) {
    futureTransactions.then((result) {
      List<PaymentTransaction> filteredList = result.where((element) {
        return element.client!.firstName!
            .toUpperCase()
            .contains(filter.toUpperCase());
      }).toList();

      setState(() {
        futureTransactions = Future.value(filteredList);
      });
    });
  }

  Future<List<PaymentTransaction>> fetchTransactions() async {
    List<PaymentTransaction> response = await BookAppointmentApiService()
        .getAllPaymentTranactionsByFranchiseId(widget.franchise.id);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Payment Transactions'),
      // ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 400,
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: PaymentDashboardScreen(franchise: widget.franchise)),
              Column(
                children: [
                  TextField(
                    controller: _filterController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Filter by name',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                    ),
                  ),
                  FutureBuilder<List<PaymentTransaction>>(
                    future: futureTransactions,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No transactions found.'));
                      }

                      final transactions = snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Client Name')),
                            DataColumn(label: Text('Franchise')),
                            DataColumn(label: Text('Service')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Client Contact')),
                          ],
                          rows: transactions.map((transaction) {
                            final client = transaction.client;
                            final franchise = transaction.franchise;
                            final service = transaction.service;

                            return DataRow(cells: [
                              DataCell(Text(transaction.id.toString())),
                              DataCell(Text(
                                  '${client!.firstName} ${client.lastName}')),
                              DataCell(Text(franchise!.name)),
                              DataCell(Text(service!.name!)),
                              DataCell(Text('R${transaction.amount}')),
                              DataCell(Text(transaction.date!
                                  .toIso8601String())), // Format the date as needed
                              DataCell(Text(client.mobileNumber!)),
                            ]);
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
