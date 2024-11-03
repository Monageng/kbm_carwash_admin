import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../booking/models/payment_transaction_model.dart';

class PaymentTransactionChart extends StatelessWidget {
  final Future<List<PaymentTransaction>> transactionsFuture;

  const PaymentTransactionChart({required this.transactionsFuture, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<PaymentTransaction>>(
          future: transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No transactions available.'));
            }

            final transactions = snapshot.data!;
            final monthlyData = _aggregateMonthlyData(transactions);

            return SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: monthlyData.values.isNotEmpty
                      ? (monthlyData.values.reduce((a, b) => a > b ? a : b) *
                          1.2)
                      : 1000,
                  barGroups: _buildBarGroups(monthlyData),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: _leftTitles(),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: _bottomTitles(),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
//                      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String month = DateFormat.MMM().format(
                            DateTime(0, group.x.toInt())); // Use x for month
                        return BarTooltipItem(
                          '$month\nR${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (value) => value % 100 == 0,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    ),
                  ),
                  groupsSpace: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, double> _aggregateMonthlyData(
      List<PaymentTransaction> transactions) {
    final monthlyData = <String, double>{};
    for (var transaction in transactions) {
      if (transaction.amount != null && transaction.date != null) {
        String monthKey = DateFormat('yyyy-MM').format(transaction.date!);
        monthlyData[monthKey] =
            (monthlyData[monthKey] ?? 0) + transaction.amount!;
      }
    }
    return monthlyData;
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, double> monthlyData) {
    return monthlyData.entries.map((entry) {
      return BarChartGroupData(
        x: int.parse(entry.key.split('-')[1]), // Extract month as integer
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blueAccent,
            width: 18,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    }).toList();
  }

  SideTitles _leftTitles() {
    return SideTitles(
      showTitles: true,
      interval: 100, // Adjust the interval based on the range of values
      getTitlesWidget: (value, _) => Text(
        '\$${value.toInt()}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, _) {
        final month = DateFormat.MMM().format(DateTime(0, value.toInt()));
        return Text(
          month,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
