import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RestaurantBookingPieChart extends StatefulWidget {
  @override
  _BookingPieChartState createState() => _BookingPieChartState();
}

class _BookingPieChartState extends State<RestaurantBookingPieChart> {
  int _touchedIndex = -1;

  final List<Map<String, dynamic>> bookings = [
    {"uuid": 4, "restaurant_uuid": "Industrial Coffee Works"},
    {"uuid": 5, "restaurant_uuid": "Industrial Coffee Works"},
    {"uuid": 6, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 7, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 8, "restaurant_uuid": "The Wing Republic"},
    {"uuid": 9, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 10, "restaurant_uuid": "The Wing Republic"},
    {"uuid": 11, "restaurant_uuid": "The Wing Republic"},
    {"uuid": 15, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 17, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 18, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 19, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 20, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 21, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 22, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 23, "restaurant_uuid": "Demo Restaurant"},
    {"uuid": 24, "restaurant_uuid": "Demo Restaurant"}
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Map<String, int> bookingCounts = {};
    for (var booking in bookings) {
      String restaurantUuid = booking["restaurant_uuid"];
      if (bookingCounts.containsKey(restaurantUuid)) {
        bookingCounts[restaurantUuid] = bookingCounts[restaurantUuid]! + 1;
      } else {
        bookingCounts[restaurantUuid] = 1;
      }
    }

    List<PieChartSectionData> pieChartData = [];

    bookingCounts.forEach((restaurantUuid, count) {
      pieChartData.add(
        PieChartSectionData(
          color:
              Colors.primaries[pieChartData.length % Colors.primaries.length],
          value: count.toDouble(),
          title: restaurantUuid,
          radius: screenWidth * 0.12, // Adjust radius based on screen width
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      );
    });

    var center = Center(
      child: Container(
        color: Colors.yellow,
        width: 300, // Set the desired width
        height: 300, // Set the desired height
        padding: const EdgeInsets.all(16.0),

        child: PieChart(
          PieChartData(
            sections: pieChartData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final isTouched = index == _touchedIndex;
              //final double fontSize = isTouched ? 18 : 16;
              //final double radius = isTouched ? 200 : 180;
              final double fontSize =
                  isTouched ? screenWidth * 0.05 : screenWidth * 0.04;
              final double radius =
                  isTouched ? screenWidth * 0.14 : screenWidth * 0.12;

              return PieChartSectionData(
                color: data.color,
                value: data.value,
                title: "${data.title} - ${data.value}",
                radius: radius,
                titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              );
            }).toList(),
            sectionsSpace: 5,
            centerSpaceRadius: 10,
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
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings Pie Chart'),
      ),
      body: center,
    );
  }
}
