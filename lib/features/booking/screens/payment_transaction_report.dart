import 'package:flutter/material.dart';
import '../../franchise/models/franchise_model.dart';
import '../models/payment_transaction_model.dart';
import '../services/book_appointment_service.dart';

class MonthlyFinancialDashboard extends StatefulWidget {
  final Franchise franchise;

  const MonthlyFinancialDashboard({super.key, required this.franchise});

  @override
  createState() => _MonthlyFinancialDashboardState();
}

class _MonthlyFinancialDashboardState extends State<MonthlyFinancialDashboard> {
  late Future<List<Map<String, dynamic>>> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureTransactions = fetchTransactions();
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    List<PaymentTransaction> paymentList = await BookAppointmentApiService()
        .getAllPaymentTranactionsByFranchiseId(widget.franchise.id);

    return paymentList
        .map((transaction) => {
              'id': transaction.id,
              'created_at': transaction.date.toString(),
              'amount': transaction.amount,
              'client': {
                'first_name': transaction.client?.firstName,
                'last_name': transaction.client?.lastName,
              },
            })
        .toList();
  }

  double calculateTotalRevenue(List<Map<String, dynamic>> transactions) {
    return transactions.fold(
        0, (sum, transaction) => sum + transaction['amount']);
  }

  double calculateAverageTransaction(List<Map<String, dynamic>> transactions) {
    return transactions.isEmpty
        ? 0
        : calculateTotalRevenue(transactions) / transactions.length;
  }

  Map<String, List<Map<String, dynamic>>> groupTransactionsByMonth(
      List<Map<String, dynamic>> transactions) {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in transactions) {
      final date = DateTime.parse(transaction['created_at']);
      final month = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      groupedTransactions.putIfAbsent(month, () => []).add(transaction);
    }
    return groupedTransactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Financial Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureTransactions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No transactions found."));
            }

            final transactions = snapshot.data!;
            final totalRevenue = calculateTotalRevenue(transactions);
            final averageTransaction =
                calculateAverageTransaction(transactions);
            final groupedTransactions = groupTransactionsByMonth(transactions);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryRow(
                    totalRevenue, transactions.length, averageTransaction),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedTransactions.keys.length,
                    itemBuilder: (context, index) {
                      final month = groupedTransactions.keys.elementAt(index);
                      final monthlyTransactions = groupedTransactions[month]!;
                      final monthlyTotal = monthlyTransactions.fold(
                          0.0, (sum, tx) => sum + tx['amount']);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: ExpansionTile(
                          title: Text("Month: $month",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "Total: R${monthlyTotal.toStringAsFixed(2)}"),
                          children: monthlyTransactions.map((transaction) {
                            return ListTile(
                              title: Text(
                                  "${transaction['client']['first_name']} ${transaction['client']['last_name']}"),
                              subtitle:
                                  Text("Amount: R${transaction['amount']}"),
                              trailing: Text(
                                  "Date: ${transaction['created_at'].substring(0, 10)}",
                                  style: const TextStyle(fontSize: 12)),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      double totalRevenue, int totalTransactions, double averageTransaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard("Total Revenue",
            "R${totalRevenue.toStringAsFixed(2)}", Colors.blue),
        _buildSummaryCard(
            "Transactions", totalTransactions.toString(), Colors.green),
        _buildSummaryCard("Avg. Amount",
            "R${averageTransaction.toStringAsFixed(2)}", Colors.orange),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
