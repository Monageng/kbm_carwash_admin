import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbm_carwash_admin/common/widgets/widget_style.dart';

import '../booking/models/appointment_model.dart';
import '../booking/models/payment_transaction_model.dart';
import '../booking/services/book_appointment_service.dart';
import '../franchise/models/franchise_model.dart';

class PaymentDashboardScreen extends StatefulWidget {
  final Franchise franchise;
  const PaymentDashboardScreen({super.key, required this.franchise});

  @override
  State<PaymentDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<PaymentDashboardScreen> {
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
    List<PaymentTransaction> appointments = await BookAppointmentApiService()
        .getAllPaymentTranactionsByFranchiseId(widget.franchise.id);

    Map<String, int> groupedData = {};

    getBookingMonthData(appointments, groupedData);

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

    Map<String, double> bookingCounts = {};
    for (var booking in appointments) {
      String? serviceName = booking.service!.name;

      double? amount = booking.amount;
      if (bookingCounts.containsKey(serviceName)) {
        bookingCounts[serviceName!] = bookingCounts[serviceName]! + amount!;
      } else {
        bookingCounts[serviceName!] = amount!;
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
      List<PaymentTransaction> appointments, Map<String, int> groupedData) {
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

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        touchTooltipData: const LineTouchTooltipData(
            //getTooltipColor: Colors.blueAccent;
            //tooltipBgColor: Colors.blueAccent,
            ),
        touchCallback:
            (FlTouchEvent event, LineTouchResponse? touchResponse) {},
        handleBuiltInTouches: true,
      );
  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 2:
                  return const Text(
                    'MAR',
                    style: TextStyle(color: Colors.blue),
                  );
                case 5:
                  return const Text('JUN',
                      style: TextStyle(color: Colors.blue));
                case 8:
                  return const Text('SEP',
                      style: TextStyle(color: Colors.blue));
                case 11:
                  return const Text('DEC',
                      style: TextStyle(color: Colors.blue));
              }
              return const Text('', style: TextStyle(color: Colors.blue));
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 1:
                  return const Text('1m', style: TextStyle(color: Colors.blue));
                case 2:
                  return const Text('2m', style: TextStyle(color: Colors.blue));
                case 3:
                  return const Text('3m', style: TextStyle(color: Colors.blue));
                case 4:
                  return const Text('4m', style: TextStyle(color: Colors.blue));
              }
              return const Text('', style: TextStyle(color: Colors.blue));
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlGridData get gridData => FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1,
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        LineChartBarData(
          isCurved: true,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 2.5),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
        ),
      ];
  @override
  Widget build(BuildContext context) {
    var localPieChart = PieChart(
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
        sectionsSpace: 5,
        centerSpaceRadius: 20,
        centerSpaceColor: Colors.white,
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

    var appointmentStats = Expanded(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                height: 350,
                color: Colors.red,
                child: BarChart(
                  BarChartData(
                    extraLinesData: ExtraLinesData(
                      extraLinesOnTop: true,
                      horizontalLines: [
                        HorizontalLine(
                          y: 10,
                          color: Colors.grey,
                          strokeWidth: 2,
                        ),
                      ],
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) {
                          return Colors.blue;
                        },
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY}',
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(120, 30, 151, 238),
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: barData
                            .map((group) => group.barRods[0].toY)
                            .reduce((a, b) => a > b ? a : b) +
                        1,
                    barGroups: barData,
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        axisNameSize: 14,
                        drawBelowEverything: true,
                        axisNameWidget: const Text(
                          'Number of transactions',
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            );
                          },
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
                    ),
                    gridData: const FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                  ),
                )),
          ]),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double chartWidth = constraints.maxWidth * 0.5;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: boxDecoration,
                      width: chartWidth * 0.9,
                      height: 350,
                      child: Column(
                        children: [
                          const Text(
                            'Transactions Per Month',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: appointmentStats),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
