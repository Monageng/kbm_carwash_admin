import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookingPieChart extends StatefulWidget {
  @override
  _BookingPieChartState createState() => _BookingPieChartState();
}

class _BookingPieChartState extends State<BookingPieChart> {
  int _touchedIndex = -1;

  final List<PieChartSectionData> bookingData = [
    PieChartSectionData(
      color: Colors.blue,
      value: 30,
      title: 'Industrial Coffee Works',
      radius: 50,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    PieChartSectionData(
      color: Colors.green,
      value: 200,
      title: 'The Wing Republic',
      radius: 50,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    PieChartSectionData(
      color: Colors.red,
      value: 850,
      title: 'Demo Restaurant',
      radius: 50,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PieChart(
      swapAnimationCurve: Curves.bounceInOut,
      swapAnimationDuration: Duration(seconds: 2),
      PieChartData(
        //sections: pieChartSectionData,
        sections: bookingData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final isTouched = index == _touchedIndex;
          final double fontSize = isTouched ? 18 : 16;
          final double radius = isTouched ? 60 : 50;

          return PieChartSectionData(
            color: data.color,
            value: data.value,
            title: data.title,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        centerSpaceColor: Colors.amber,
        borderData: FlBorderData(
          show: false,
        ),
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
      ),
    );
  }
}
