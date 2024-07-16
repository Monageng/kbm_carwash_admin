import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbm_carwash_admin/features/franchise/models/franchise_model.dart';

import '../../common/widgets/navigation_bar.dart';
import '../booking/models/appointment_model.dart';
import '../booking/services/book_appointment_service.dart';

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
  int _touchedIndex = -1;

  final List<Map<String, dynamic>> bookings = [
    {
      "uuid": 4,
      "created_at": "2024-01-25T16:33:13.924+00:00",
      "restaurant_uuid": "Industrial Coffee Works"
    },
    {
      "uuid": 5,
      "created_at": "2024-01-27T14:51:42.052+00:00",
      "restaurant_uuid": "Industrial Coffee Works"
    },
    {
      "uuid": 6,
      "created_at": "2024-01-27T14:59:41.376+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 7,
      "created_at": "2024-02-07T15:49:26.308+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 8,
      "created_at": "2024-02-11T06:22:47.546515+00:00",
      "restaurant_uuid": "The Wing Republic"
    },
    {
      "uuid": 9,
      "created_at": "2024-02-11T08:29:45.218356+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 10,
      "created_at": "2024-02-11T08:32:20.191507+00:00",
      "restaurant_uuid": "The Wing Republic"
    },
    {
      "uuid": 11,
      "created_at": "2024-02-11T08:38:12.251926+00:00",
      "restaurant_uuid": "The Wing Republic"
    },
    {
      "uuid": 15,
      "created_at": "2024-03-13T22:50:24.945387+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 17,
      "created_at": "2024-03-14T09:11:08.195297+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 18,
      "created_at": "2024-03-14T09:12:19.352826+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 19,
      "created_at": "2024-03-14T09:13:08.153092+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 20,
      "created_at": "2024-03-14T09:53:09.271187+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 21,
      "created_at": "2024-03-14T09:58:54.079862+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 22,
      "created_at": "2024-03-14T10:03:35.426232+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 23,
      "created_at": "2024-03-14T08:48:18.679372+00:00",
      "restaurant_uuid": "Demo Restaurant"
    },
    {
      "uuid": 24,
      "created_at": "2024-03-30T18:10:33.773094+00:00",
      "restaurant_uuid": "Demo Restaurant"
    }
  ];

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

    // Handle end-of-month edge cases by using the last day of the next month
    while (true) {
      try {
        return DateTime(newYear, newMonth, newDay);
      } catch (e) {
        newDay -= 1;
      }
    }
  }

  getAppointmentDate() async {
    List<Appointment>? appointments =
        await BookAppointmentApiService().getAllActiveAppointments();
    Map<String, int> groupedData = {};

    // Group appointments by month
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

// Set data for
    Map<String, int> bookingCounts = {};
    for (var booking in appointments) {
      String? restaurantUuid = booking.serviceName;
      if (bookingCounts.containsKey(restaurantUuid)) {
        bookingCounts[restaurantUuid!] = bookingCounts[restaurantUuid]! + 1;
      } else {
        bookingCounts[restaurantUuid!] = 1;
      }
    }

    List<PieChartSectionData> mypieChartData = [];

    bookingCounts.forEach((restaurantUuid, count) {
      final hue = Random().nextDouble() * 3; // Generate random hue value
      final alpha = Random().nextDouble() * 1.0;
      final color =
          HSVColor.fromAHSV(alpha, 240, 0.8, 0.9).toColor(); // Convert to Color

      mypieChartData.add(
        PieChartSectionData(
          // color:
          //     Colors.primaries[mypieChartData.length % Colors.primaries.length],
          color: color,
          value: count.toDouble(),
          title: restaurantUuid,
          radius:
              50, //screenWidth * 0.12, // Adjust radius based on screen width
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        groupedData[month] = groupedData[month]! + 1;
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

  Map<String, Map<int, int>> _getBookingCounts() {
    final Map<String, Map<int, int>> bookingCounts = {};
    for (var booking in bookings) {
      final dateTime = DateTime.parse(booking['created_at']);
      final month = dateTime.month;
      final restaurant = booking['restaurant_uuid'];
      if (!bookingCounts.containsKey(restaurant)) {
        bookingCounts[restaurant] = {};
      }
      if (bookingCounts[restaurant]!.containsKey(month)) {
        bookingCounts[restaurant]![month] =
            bookingCounts[restaurant]![month]! + 1;
      } else {
        bookingCounts[restaurant]![month] = 1;
      }
    }
    return bookingCounts;
  }

  List<BarChartGroupData> _generateBarGroups(
      Map<String, Map<int, int>> bookingCounts) {
    final List<BarChartGroupData> barGroups = [];
    for (int i = 1; i <= 12; i++) {
      final bars = <BarChartRodData>[];
      bookingCounts.forEach((restaurant, monthCounts) {
        final count = monthCounts[i] ?? 0;

        bars.add(
          BarChartRodData(
            toY: count.toDouble(),
            color:
                restaurantColors[restaurant.hashCode % restaurantColors.length],
            // color:
            //     Colors.primaries[restaurant.hashCode % Colors.primaries.length],
            width: 5,
          ),
        );
      });
      barGroups.add(
        BarChartGroupData(
          barsSpace: 2,
          x: i - 1,
          barRods: bars,
        ),
      );
    }
    return barGroups;
  }

  Map<String, Color> _getRestaurantColors(List<String> restaurants) {
    final Map<String, Color> restaurantColors = {};
    final List<Color> colors = Colors.primaries;

    for (int i = 0; i < restaurants.length; i++) {
      restaurantColors[restaurants[i]] = colors[i % colors.length];
    }

    return restaurantColors;
  }

  Widget _buildLegend(Map<String, Color> restaurantColors) {
    return Container(
      // width: 200,
      // height: 200,
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 10,
        children: restaurantColors.entries.map((entry) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                color: entry.value,
              ),
              const SizedBox(width: 4),
              Text(
                entry.key,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingCounts = _getBookingCounts();
    final barGroups = _generateBarGroups(bookingCounts);

    var monthlyBarChart = Container(
      width: MediaQuery.of(context).size.width *
          0.70, //500, // Set the desired width
      height: 300, // Set the desired height
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          backgroundColor: const Color.fromARGB(120, 30, 151, 238),
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
                _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              });
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) {
                return Colors.blue;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String month = bottomTitles[group.x.toInt()];
                return BarTooltipItem(
                  '${rod.toY}',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
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
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
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
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );

    var localPieChart = PieChart(
      PieChartData(
        sections: pieChartData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final isTouched = index == _touchedIndex;
          final double fontSize = isTouched ? 18 : 16;
          final double radius = isTouched ? 200 : 180;
          // final double fontSize =
          //     isTouched ? screenWidth * 0.05 : screenWidth * 0.04;
          // final double radius =
          //     isTouched ? screenWidth * 0.14 : screenWidth * 0.12;

          return PieChartSectionData(
            color: data.color,
            value: data.value,
            title: "${data.title} - ${data.value}",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 5,
        centerSpaceRadius: 10,
        centerSpaceColor: Colors.blue,
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

    var appointmentStats = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Appointment Stats',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              //width: MediaQuery.of(context).size.width * 0.8, //double.infinity,
              height: 300,
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
                        String month = bottomTitles[group.x.toInt()];
                        return BarTooltipItem(
                          '${rod.toY}',
                          const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                        //  margin: 8,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      // axisNameSize: 14,
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
                        //margin: 8,
                      ),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    //checkToShowHorizontalLine: (value) => value % 10 == 0,
                    // getDrawingHorizontalLine: (value) {
                    //   return const FlLine(
                    //     color: Colors.grey,
                    //     strokeWidth: 1,
                    //   );
                    // },
                    // getDrawingVerticalLine: (value) {
                    //   return const FlLine(
                    //     color: Colors.grey,
                    //     strokeWidth: 1,
                    //   );
                    // },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                ),
              )),
        ]);

    // return Scaffold(
    //   appBar: CustomAppBar(),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       // color: Colors.red,
    //       padding: const EdgeInsets.all(16.0),
    //       child: LayoutBuilder(
    //         builder: (context, constraints) {
    //           double chartWidth = constraints.maxWidth;
    //           double chartHeight = constraints.maxHeight;
    //           return Column(
    //             children: [
    //               const SizedBox(height: 20),
    //               if (appointments!.isNotEmpty) appointmentStats,
    //               const SizedBox(height: 20),
    //               if (appointments!.isNotEmpty)
    //                 Row(
    //                   children: [
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.circular(8),
    //                         boxShadow: [
    //                           BoxShadow(
    //                             color: Colors.orange.withOpacity(0.2),
    //                             spreadRadius: 3,
    //                             blurRadius: 5,
    //                             offset: const Offset(
    //                                 0, 3), // changes position of shadow
    //                           ),
    //                         ],
    //                       ),
    //                       width: chartWidth * 0.4,
    //                       height: chartWidth * 0.3,
    //                       child: Column(
    //                         children: [
    //                           Text(
    //                             'Total Bookings Per Restaurant',
    //                             style: TextStyle(
    //                               color: Colors.orange,
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                           SizedBox(height: 20),
    //                           Expanded(child: localPieChart),
    //                         ],
    //                       ),
    //                     ),
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.circular(8),
    //                         boxShadow: [
    //                           BoxShadow(
    //                             color: Colors.orange.withOpacity(0.2),
    //                             spreadRadius: 3,
    //                             blurRadius: 5,
    //                             offset: const Offset(
    //                                 0, 3), // changes position of shadow
    //                           ),
    //                         ],
    //                       ),
    //                       width: chartWidth * 0.6,
    //                       height: chartWidth * 0.3,
    //                       child: Column(
    //                         children: [
    //                           Text(
    //                             'Monthly Bookings Per Restaurant',
    //                             style: TextStyle(
    //                               color: Colors.orange,
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                           SizedBox(height: 20),
    //                           Expanded(child: monthlyBarChart),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //             ],
    //           );
    //         },
    //       ),

    //     ),
    //   ),
    // );

    return Scaffold(
      appBar: getTopNavigation(context),
      body: SingleChildScrollView(
        child: Padding(
          // color: Colors.red,
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double chartWidth = constraints.maxWidth;
              double chartHeight = constraints.maxHeight;
              return Column(
                children: [
                  const SizedBox(height: 20),
                  appointmentStats,
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: chartWidth * 0.4,
                        height: chartWidth * 0.3,
                        child: Column(
                          children: [
                            const Text(
                              'Total Bookings Per Merchant',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(child: localPieChart),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: chartWidth * 0.6,
                        height: chartWidth * 0.3,
                        child: Column(
                          children: [
                            const Text(
                              'Monthly Bookings Per Merchant',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(child: monthlyBarChart),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     if (appointments!.isNotEmpty) appointmentStats,
          //     const SizedBox(height: 32.0),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Column(
          //           children: [
          //             const SizedBox(height: 40.0),
          //             if (appointments!.isNotEmpty) localPieChart,
          //           ],
          //         ),
          //         // Column(
          //         //   children: [
          //         //     // const Text(
          //         //     //   'Booking Chart',
          //         //     //   style: TextStyle(
          //         //     //     fontSize: 16,
          //         //     //     fontWeight: FontWeight.bold,
          //         //     //     color: Colors.orange,
          //         //     //   ),
          //         //     // ),
          //         //     // const SizedBox(height: 40.0),
          //         //     // if (appointments!.isNotEmpty) monthlyBarChart,
          //         //     // const SizedBox(height: 40.0),
          //         //     // if (appointments!.isNotEmpty)
          //         //     //   _buildLegend(restaurantColors),
          //         //],
          //         // ),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
