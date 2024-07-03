import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BookingGraph extends StatelessWidget {
  final List<BarChartGroupData> bookingData = [
    // Example data for day/week/month
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 30, // Total bookings for day
          color: Colors.blue,
          width: 12,
        ),
      ],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: 200, // Total bookings for week
          color: Colors.green,
          width: 12,
        ),
      ],
    ),
    // BarChartGroupData(
    //   x: 2,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 850, // Total bookings for month
    //       color: Colors.red,
    //       width: 10,
    //     ),
    //   ],
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Wash Booking Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            // backgroundColor: Colors.yellow,
            alignment: BarChartAlignment.spaceAround,
            barGroups: bookingData,
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                axisNameSize: 14,
                drawBelowEverything: true,
                axisNameWidget: const Text(
                  'Number of appointments',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    String val = value.toString();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        val,
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 8),
                      ),
                    );
                  },
                  //  margin: 8,
                ),
              ),
              bottomTitles: AxisTitles(
                drawBelowEverything: true,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    // if (value.toInt() < 0 ||
                    //     value.toInt() >= bottomTitles.length) {
                    //   return Container();
                    // }
                    String val = "";
                    switch (value.toInt()) {
                      case 0:
                        val = 'Day';
                      case 1:
                        val = 'Week';
                      case 2:
                        val = 'Month';
                      default:
                        val = '';
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        val.toString(),
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              checkToShowHorizontalLine: (value) => value % 10 == 0,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
