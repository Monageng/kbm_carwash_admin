import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbm_carwash_admin/features/booking/services/book_appointment_service.dart';

import '../../common/widgets/navigation_bar.dart';
import '../booking/models/appointment_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BarChartGroupData> barData = [];
  List<String> bottomTitles = [];

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
    List<CarWashAppointment>? appointments =
        await BookAppointmentApiService().getAllActiveAppointments();
    Map<String, int> groupedData = {};

    // Group appointments by month
    for (var appointment in appointments!) {
      String month = DateFormat('MMM yy').format(appointment.date!);
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
          //showingTooltipIndicators: [0],
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

    setState(() {
      barData = barGroups;
      bottomTitles = titles;
    });
  }

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.lightGreen,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  @override
  Widget build(BuildContext context) {
    return barData.isEmpty
        ? const Center(child: const CircularProgressIndicator())
        : Scaffold(
            appBar: getTopNavigation(context),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
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
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width *
                            0.4, //double.infinity,
                        height: 500,
                        child: BarChart(
                          BarChartData(
                            backgroundColor:
                                const Color.fromARGB(120, 30, 151, 238),
                            alignment: BarChartAlignment.spaceAround,
                            maxY: barData
                                    .map((group) => group.barRods[0].toY)
                                    .reduce((a, b) => a > b ? a : b) +
                                1,
                            barGroups: barData,
                            titlesData: FlTitlesData(
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
                                axisNameSize: 14,
                                drawBelowEverything: true,
                                // axisNameWidget: const Text(
                                //   'Months',
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     color: Colors.blue,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() < 0 ||
                                        value.toInt() >= bottomTitles.length) {
                                      return Container();
                                    }
                                    return Transform.rotate(
                                      angle: 5,
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
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
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: true,
                              checkToShowHorizontalLine: (value) =>
                                  value % 10 == 0,
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
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                          ),
                        )),
                  ]),
            ));
    // return Scaffold(
    //     appBar: getTopNavigation(context),
    //     body: SingleChildScrollView(
    //         child: Column(
    //       children: [LineChartSample()],
    //     )));
  }
}

// class LineChartSample extends StatelessWidget {
//   final Color mainLineColor = Colors.yellow.withOpacity(1);
//   final Color belowLineColor = Colors.pink.withOpacity(1);
//   final Color aboveLineColor = Colors.purple.withOpacity(1);

//   final pilateColor = Colors.yellow.withOpacity(1);
//   final cyclingColor = Colors.cyan.withOpacity(1);
//   final quickWorkoutColor = Colors.blue.withOpacity(1);
//   final betweenSpace = 0.2;

//   LineChartSample({super.key});

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = 'Jan';
//         break;
//       case 1:
//         text = 'Feb';
//         break;
//       case 2:
//         text = 'Mar';
//         break;
//       case 3:
//         text = 'Apr';
//         break;
//       case 4:
//         text = 'May';
//         break;
//       case 5:
//         text = 'Jun';
//         break;
//       case 6:
//         text = 'Jul';
//         break;
//       case 7:
//         text = 'Aug';
//         break;
//       case 8:
//         text = 'Sep';
//         break;
//       case 9:
//         text = 'Oct';
//         break;
//       case 10:
//         text = 'Nov';
//         break;
//       case 11:
//         text = 'Dec';
//         break;
//       default:
//         return Container();
//     }

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 4,
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 10,
//           color: Colors.blue,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.blue,
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text("${value}", style: style),
//     );
//   }

//   Widget leftTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.blue,
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     String text;
//     if (value == 0) {
//       text = '1K';
//     } else if (value == 10) {
//       text = '5K';
//     } else if (value == 19) {
//       text = '10K';
//     } else {
//       return Container();
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 0,
//       child: Text(text, style: style),
//     );
//   }

//   BarChartGroupData generateGroupData(
//     int x,
//     double pilates,
//     double quickWorkout,
//     double cycling,
//   ) {
//     return BarChartGroupData(
//       x: x,
//       groupVertically: true,
//       barRods: [
//         BarChartRodData(
//             fromY: 0,
//             toY: pilates,
//             color: pilateColor,
//             width: 10,
//             gradient: const LinearGradient(
//               colors: [
//                 Colors.orange,
//                 Colors.white,
//               ],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             )),
//         // BarChartRodData(
//         //   fromY: pilates + betweenSpace,
//         //   toY: pilates + betweenSpace + quickWorkout,
//         //   color: quickWorkoutColor,
//         //   width: 5,
//         // ),
//         // BarChartRodData(
//         //   fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
//         //   toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
//         //   color: cyclingColor,
//         //   width: 5,
//         // ),
//       ],
//     );
//   }

//   Widget bottomTitles(double value, TitleMeta meta) {
//     const style = TextStyle(fontSize: 10, color: Colors.blue);
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = 'JAN';
//         break;
//       case 1:
//         text = 'FEB';
//         break;
//       case 2:
//         text = 'MAR';
//         break;
//       case 3:
//         text = 'APR';
//         break;
//       case 4:
//         text = 'MAY';
//         break;
//       case 5:
//         text = 'JUN';
//         break;
//       case 6:
//         text = 'JUL';
//         break;
//       case 7:
//         text = 'AUG';
//         break;
//       case 8:
//         text = 'SEP';
//         break;
//       case 9:
//         text = 'OCT';
//         break;
//       case 10:
//         text = 'NOV';
//         break;
//       case 11:
//         text = 'DEC';
//         break;
//       default:
//         text = '';
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(text, style: style),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Appointment Stats',
//             style: TextStyle(
//               color: Colors.blue,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           AspectRatio(
//             aspectRatio: 4,
//             child: BarChart(
//               BarChartData(
//                 backgroundColor: const Color.fromARGB(255, 30, 151, 238),
//                 alignment: BarChartAlignment.spaceBetween,
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     axisNameSize: 14,
//                     axisNameWidget: const Text(
//                       'Number of appointments',
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 28,
//                       interval: 1,
//                       getTitlesWidget: leftTitles,
//                     ),
//                   ),
//                   rightTitles: const AxisTitles(),
//                   topTitles: const AxisTitles(),
//                   bottomTitles: AxisTitles(
//                     axisNameSize: 14,
//                     axisNameWidget: const Text(
//                       '2024',
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: bottomTitles,
//                       reservedSize: 30,
//                     ),
//                   ),
//                 ),
//                 barTouchData: BarTouchData(enabled: true),
//                 borderData: FlBorderData(show: true),
//                 gridData: const FlGridData(show: false),
//                 barGroups: getGroupData,
//                 maxY: 11 + (betweenSpace * 3),
//                 extraLinesData: const ExtraLinesData(
//                   horizontalLines: [
//                     // HorizontalLine(
//                     //   y: 3.3,
//                     //   color: pilateColor,
//                     //   strokeWidth: 1,
//                     //   dashArray: [20, 4],
//                     // ),
//                     // HorizontalLine(
//                     //   y: 8,
//                     //   color: quickWorkoutColor,
//                     //   strokeWidth: 1,
//                     //   dashArray: [20, 4],
//                     // ),
//                     // HorizontalLine(
//                     //   y: 11,
//                     //   color: cyclingColor,
//                     //   strokeWidth: 1,
//                     //   dashArray: [20, 4],
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//     // return AspectRatio(
//     //   aspectRatio: 1,
//     //   child: Padding(
//     //     padding: EdgeInsets.all(5),
//     //     child: LineChart(
//     //       LineChartData(
//     //         lineTouchData: lineTouchData1,
//     //         //lineTouchData: const LineTouchData(enabled: false),
//     //         lineBarsData: [
//     //           LineChartBarData(
//     //             spots: const [
//     //               FlSpot(0, 4),
//     //               FlSpot(1, 3.5),
//     //               FlSpot(2, 4.5),
//     //               FlSpot(3, 1),
//     //               FlSpot(4, 4),
//     //               FlSpot(5, 6),
//     //               FlSpot(6, 6.5),
//     //               FlSpot(7, 6),
//     //               FlSpot(8, 4),
//     //               FlSpot(9, 6),
//     //               FlSpot(10, 6),
//     //               FlSpot(11, 7),
//     //             ],
//     //             //isCurved: true,
//     //             //barWidth: 8,
//     //             color: mainLineColor,
//     //             belowBarData: BarAreaData(
//     //               show: false,
//     //               color: belowLineColor,
//     //               cutOffY: cutOffYValue,
//     //               applyCutOffY: false,
//     //             ),
//     //             aboveBarData: BarAreaData(
//     //               show: false,
//     //               color: aboveLineColor,
//     //               cutOffY: cutOffYValue,
//     //               applyCutOffY: false,
//     //             ),
//     //             dotData: const FlDotData(
//     //               show: false,
//     //             ),
//     //           ),
//     //         ],
//     //         minY: 0,
//     //         titlesData: FlTitlesData(
//     //           show: true,
//     //           topTitles: const AxisTitles(
//     //             sideTitles: SideTitles(showTitles: false),
//     //           ),
//     //           rightTitles: const AxisTitles(
//     //             sideTitles: SideTitles(showTitles: false),
//     //           ),
//     //           bottomTitles: AxisTitles(
//     //             axisNameWidget: Text(
//     //               '2019',
//     //               style: TextStyle(
//     //                 fontSize: 10,
//     //                 color: mainLineColor,
//     //                 fontWeight: FontWeight.bold,
//     //               ),
//     //             ),
//     //             sideTitles: SideTitles(
//     //               showTitles: true,
//     //               reservedSize: 18,
//     //               interval: 1,
//     //               getTitlesWidget: bottomTitleWidgets,
//     //             ),
//     //           ),
//     //           leftTitles: AxisTitles(
//     //             axisNameSize: 20,
//     //             axisNameWidget: const Text(
//     //               'Value',
//     //               style: TextStyle(
//     //                 color: Colors.lightBlue,
//     //               ),
//     //             ),
//     //             sideTitles: SideTitles(
//     //               showTitles: true,
//     //               interval: 1,
//     //               reservedSize: 40,
//     //               getTitlesWidget: leftTitleWidgets,
//     //             ),
//     //           ),
//     //         ),
//     //         borderData: FlBorderData(
//     //           //show: true,
//     //           border: Border.all(
//     //             color: Colors.green,
//     //           ),
//     //         ),
//     //         gridData: FlGridData(
//     //           show: false,
//     //           drawVerticalLine: true,
//     //           horizontalInterval: 1,
//     //           // checkToShowHorizontalLine: (double value) {
//     //           //   return value == 1 || value == 6 || value == 4 || value == 5;
//     //           // },
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }

//   List<BarChartGroupData> get getGroupData {
//     return [
//       generateGroupData(0, 2, 3, 2),
//       generateGroupData(1, 2, 5, 1.7),
//       generateGroupData(2, 1.3, 3.1, 2.8),
//       generateGroupData(3, 3.1, 4, 3.1),
//       generateGroupData(4, 0.8, 3.3, 3.4),
//       generateGroupData(5, 2, 5.6, 1.8),
//       generateGroupData(6, 1.3, 3.2, 2),
//       generateGroupData(7, 2.3, 3.2, 3),
//       generateGroupData(8, 2, 4.8, 2.5),
//       generateGroupData(9, 1.2, 3.2, 2.5),
//       generateGroupData(10, 1, 4.8, 3),
//       generateGroupData(11, 2, 4.4, 2.8),
//     ];
//   }
// }

// LineChartData mainData() {
//   return LineChartData(
//     gridData: const FlGridData(
//       show: true,
//       //drawVerticalLine: true,
//       // getDrawingHorizontalLine: (value) {
//       //   return FlLine(
//       //     color: const Color.fromARGB(100, 100, 100, 100),
//       //     strokeWidth: 1,
//       //   );
//       // },
//       // getDrawingVerticalLine: (value) {
//       //   return FlLine(
//       //     color: const Color.fromARGB(100, 100, 100, 100),
//       //     strokeWidth: 1,
//       //   );
//       // },
//     ),
//     titlesData: const FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//           showTitles: true,
//         )),

//         // SideTitles(
//         //   showTitles: true,
//         //   reservedSize: 22,
//         //   getTextStyles: (_, value) => const TextStyle(
//         //       color: Color(0xff68737d),
//         //       fontWeight: FontWeight.bold,
//         //       fontSize: 16),
//         //   getTitles: (value) {
//         //     String? month = monthMap[value.toInt()];
//         //     if (month == null) {
//         //       return '';
//         //     }
//         //     return month;
//         //   },
//         //   margin: 8,
//         // ),
//         leftTitles: AxisTitles()
//         // SideTitles(
//         //   showTitles: true,
//         //   getTextStyles: (_, value) => const TextStyle(
//         //     color: Color(0xff67727d),
//         //     fontWeight: FontWeight.bold,
//         //     fontSize: 15,
//         //   ),
//         //   getTitles: (value) {
//         //     String? money = moneyMap[value.toInt()];
//         //     if (money == null) {
//         //       return '';
//         //     }
//         //     return money;
//         //   },
//         //   reservedSize: 28,
//         //   margin: 12,
//         // ),
//         ),
//     borderData: FlBorderData(
//       show: true,
//       border: Border.all(color: const Color(0xff37434d), width: 1),
//     ),
//     minX: 0,
//     maxX: 31,
//     minY: 0,
//     maxY: 6,
//     lineBarsData: [
//       LineChartBarData(
//         spots: [
//           const FlSpot(1, 3),
//           const FlSpot(2, 2),
//           const FlSpot(3, 5),
//           const FlSpot(4, 3.1),
//           const FlSpot(5, 4),
//           const FlSpot(6, 3),
//           const FlSpot(7, 4),
//         ],
//         isCurved: true,
//         color: Colors.blue,
//         barWidth: 5,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(
//           show: false,
//         ),
//         belowBarData: BarAreaData(
//           show: true,
//           color: Colors.blue,
//         ),
//       ),
//     ],
//   );
// }
