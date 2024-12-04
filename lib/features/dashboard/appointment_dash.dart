import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/widget_style.dart';
import '../booking/models/appointment_model.dart';
import '../booking/services/book_appointment_service.dart';
import '../franchise/models/franchise_model.dart';

class DashboardScreen extends StatefulWidget {
  final Franchise franchise;
  const DashboardScreen({super.key, required this.franchise});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BarChartGroupData> barData = [];
  List<PieChartSectionData> pieChartData = [];
  List<String> bottomTitles = [];
  late Map<String, Color> restaurantColors;
  late List<Appointment>? appointments = [];
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    getAppointmentDate();
  }

  DateTime _addMonths(DateTime date, int monthsToAdd) {
    int newYear = date.year;
    int newMonth = date.month + monthsToAdd;
    if (newMonth > 12) {
      newYear += newMonth ~/ 12;
      newMonth = newMonth % 12;
      if (newMonth == 0) {
        newMonth = 12;
        newYear -= 1;
      }
    }
    int newDay = date.day;

    while (true) {
      try {
        return DateTime(newYear, newMonth, newDay);
      } catch (e) {
        newDay -= 1;
      }
    }
  }

  getAppointmentDate() async {
    List<Appointment>? appointments = await BookAppointmentApiService()
        .getAllActiveAppointmentsByFranchiseId(widget.franchise.id);
    Map<String, int> groupedData = {};

    getBookingMonthData(appointments, groupedData);

    // Prepare data for BarChart
    List<String> sortedKeys = groupedData.keys.toList()..sort();
    List<BarChartGroupData> barGroups = [];
    List<String> titles = [];

    for (int i = 0; i < sortedKeys.length; i++) {
      String month = sortedKeys[i];
      barGroups.add(
        BarChartGroupData(
          groupVertically: true,
          x: i,
          barRods: [
            BarChartRodData(
              toY: groupedData[month]!.toDouble(),
              gradient: _barsGradient,
              color: Colors.blue,
              width: 5,
            ),
          ],
        ),
      );
      titles.add(month);
    }

    Map<String, int> bookingCounts = {};
    for (var booking in appointments) {
      String? serviceName = booking.serviceName;
      if (bookingCounts.containsKey(serviceName)) {
        bookingCounts[serviceName!] = bookingCounts[serviceName]! + 1;
      } else {
        bookingCounts[serviceName!] = 1;
      }
    }

    List<PieChartSectionData> mypieChartData = [];

    bookingCounts.forEach((serviceName, count) {
      Color? colors = Colors.blue;

      final restaurantColorsColrs =
          _getRestaurantColors(bookingCounts.keys.toList());
      if (restaurantColorsColrs.isNotEmpty) {
        colors = restaurantColorsColrs[serviceName];
      }
      mypieChartData.add(
        PieChartSectionData(
          color: colors,
          value: count.toDouble(),
          title: serviceName,
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    });

    final restaurantColorsColrs =
        _getRestaurantColors(bookingCounts.keys.toList());

    setState(() {
      barData = barGroups;
      bottomTitles = titles;
      pieChartData = mypieChartData;
      restaurantColors = restaurantColorsColrs;
    });
  }

  void getBookingMonthData(
      List<Appointment> appointments, Map<String, int> groupedData) {
    for (var appointment in appointments) {
      String month = DateFormat('yyyy-MM').format(appointment.date!);
      if (groupedData.containsKey(month)) {
        groupedData[month] = groupedData[month]! + 1;
      } else {
        groupedData[month] = 1;
      }
    }

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, DateTime.january, 1);

    for (int i = 0; i < 12; i++) {
      String month = DateFormat('yyyy-MM').format(date);

      if (groupedData.containsKey(month)) {
        groupedData[month] = groupedData[month]!;
      } else {
        groupedData[month] = 0;
      }
      date = _addMonths(date, 1);
    }
  }

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.lightGreen,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Map<String, Color> _getRestaurantColors(List<String> restaurants) {
    final Map<String, Color> restaurantColors = {};

    final List<Color> amberColors = [
      Colors.blue,
      const Color.fromARGB(255, 13, 78, 176),
      const Color.fromARGB(255, 154, 205, 246),
      Colors.lightBlue,
      Colors.lightBlueAccent,
      Colors.blueAccent,
    ];

    for (int i = 0; i < restaurants.length; i++) {
      var col = amberColors[i % amberColors.length];
      restaurantColors[restaurants[i]] = col;
    }

    return restaurantColors;
  }

  Widget _buildBarChartNew(double width) {
    double maxYValue = barData.isNotEmpty
        ? barData
                .map((group) => group.barRods[0].toY)
                .reduce((a, b) => a > b ? a : b) *
            1.1
        : 1; // Adding a 10% buffer

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration,
      width: width,
      height: 380,
      child: Column(
        children: [
          const Text(
            'Total Bookings Per Month',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                extraLinesData: const ExtraLinesData(
                  extraLinesOnTop: false,
                ),
                backgroundColor: const Color.fromARGB(120, 30, 151, 238),
                alignment: BarChartAlignment.spaceEvenly,
                maxY: maxYValue, // Dynamic maxY
                barGroups: barData,
                titlesData: FlTitlesData(
                    show: true,
                    leftTitles: const AxisTitles(
                      axisNameSize: 14,
                      drawBelowEverything: true,
                      axisNameWidget: Text(
                        'Number of appointments',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < 0 ||
                              value.toInt() >= bottomTitles.length) {
                            return Container();
                          }
                          return Transform.rotate(
                            angle: -pi / 4,
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                bottomTitles[value.toInt()],
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false))),
                gridData: const FlGridData(
                  show: true,
                  //drawHorizontalLine: true,
                  drawVerticalLine: true,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(double width) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration,
      width: width,
      height: 380,
      child: Column(
        children: [
          const Text(
            'Total Bookings Per Service',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: pieChartData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final isTouched = index == _touchedIndex;
                  final double fontSize = isTouched ? 14 : 10;
                  final double radius = isTouched ? 120 : 100;

                  return PieChartSectionData(
                    color: data.color,
                    value: data.value,
                    title: "${data.title} - ${data.value}",
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                }).toList(),
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
                // Configure PieChart with pieChartData and other styling
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        double chartWidth = constraints.maxWidth * (isSmallScreen ? 0.8 : 0.4);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildBarChartNew(chartWidth),
                  ),
                  SizedBox(width: isSmallScreen ? 0 : 16),
                  if (!isSmallScreen)
                    Expanded(
                      child: _buildPieChart(chartWidth),
                    ),
                ],
              ),
              if (isSmallScreen)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildPieChart(chartWidth),
                ),
            ],
          ),
        );
      },
    );
  }
}
