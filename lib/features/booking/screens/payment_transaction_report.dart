import 'package:flutter/material.dart';

import '../../franchise/models/franchise_model.dart';
import '../models/payment_transaction_model.dart';
import '../services/book_appointment_service.dart';

class MonthlyFinancialDashboard extends StatefulWidget {
  Franchise franchise;

  MonthlyFinancialDashboard({super.key, required this.franchise});

  @override
  _MonthlyFinancialDashboardState createState() =>
      _MonthlyFinancialDashboardState();
}

class _MonthlyFinancialDashboardState extends State<MonthlyFinancialDashboard> {
  // Simulated async function to fetch transactions data
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    // Fetch transactions from API
    List<PaymentTransaction> paymentList = await BookAppointmentApiService()
        .getAllPaymentTranactionsByFranchiseId(widget.franchise.id);

    // Map each PaymentTransaction to a Map<String, dynamic>
    return paymentList
        .map((transaction) => {
              'id': transaction.id,
              'created_at': transaction.createAt.toString(),
              'amount': transaction.amount,
              'client': {
                'first_name': transaction.client!.firstName,
                'last_name': transaction.client!.lastName,
              },
            })
        .toList();
  }

  // Helper function to calculate total revenue
  double calculateTotalRevenue(List<Map<String, dynamic>> transactions) {
    return transactions.fold(
        0, (sum, transaction) => sum + transaction['amount']);
  }

  // Helper function to get average transaction amount
  double calculateAverageTransaction(List<Map<String, dynamic>> transactions) {
    return transactions.isEmpty
        ? 0
        : calculateTotalRevenue(transactions) / transactions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Monthly Dashboard'),
      // ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error handling if fetching data fails
            return const Center(child: Text('Error loading transactions'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle case when no data is available
            return const Center(child: Text('No transactions found'));
          }

          // Data successfully fetched
          final transactions = snapshot.data!;
          final totalRevenue = calculateTotalRevenue(transactions);
          final averageTransaction = calculateAverageTransaction(transactions);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Summary Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryCard('Total Revenue',
                        '\R${totalRevenue.toStringAsFixed(2)}', Colors.blue),
                    _buildSummaryCard('Transactions',
                        transactions.length.toString(), Colors.green),
                    _buildSummaryCard(
                        'Avg. Amount',
                        '\R${averageTransaction.toStringAsFixed(2)}',
                        Colors.orange),
                  ],
                ),
                const SizedBox(height: 20),

                // Recent Transactions Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 10),

                // Recent Transactions List
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final client = transaction['client'];
                      return ListTile(
                        title: Text(
                            '${client["first_name"]} ${client["last_name"]}'),
                        subtitle: Text('Amount: \R${transaction["amount"]}'),
                        trailing: Text(transaction['created_at']
                            .substring(0, 10)), // Display date only
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Method to build summary cards
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
