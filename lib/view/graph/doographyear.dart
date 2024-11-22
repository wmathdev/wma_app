// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dotted_line/dotted_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/widget/text_widget.dart';

import '../../Utils/month.dart';



class DooYearGraph extends StatefulWidget {
  dynamic data;
  String rule;
  DooYearGraph({
    Key? key,
    required this.data,
    required this.rule,
  }) : super(key: key);

  @override
  State<DooYearGraph> createState() => _DooYearGraphState();
}

class _DooYearGraphState extends State<DooYearGraph> {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);

  List<Color> gradientColors = [
    contentColorYellow,
    contentColorWhite,
  ];

  List<Color> gradientColors2 = [
    contentColorBlue,
    contentColorWhite,
  ];

  bool showAvg = false;

  List<FlSpot> listPlot = [];
  List<FlSpot> listtreatedPlot = [];

  List<HorizontalLine> listRule = [];

  List<bool> lebelactive = [];

  List<VerticalLine> listSelect = [];

  var maxValue = 0.0;

  final double width = 7;

  List<BarChartGroupData> rawBarGroups = [];
  List<String> label = [];
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data);
    List<dynamic> temp = widget.data;

    var a = 0.0;
    var b = 0.0;
    for (var i = 0; i < temp.length; i++) {
      if (temp[i]['before'] != null) {
        // listPlot.add(FlSpot(i.toDouble(), temp[i]['before'] * 1.0));
        a = temp[i]['before'] * 1.0;
        if (maxValue < temp[i]['before'].toDouble()) {
          maxValue = temp[i]['before'].toDouble();
        }
      } else {
        a = 0.0 * 1.0;
        listPlot.add(FlSpot(i.toDouble(), 0));
      }

      if (temp[i]['after'] != null) {
        // listtreatedPlot.add(FlSpot(i.toDouble(), temp[i]['after'] * 1.0));
        b = temp[i]['after'] * 1.0;
        if (maxValue < temp[i]['after'].toDouble()) {
          maxValue = temp[i]['after'].toDouble();
        }
      } else {
        b = 0.0 * 1.0;
        listtreatedPlot.add(FlSpot(i.toDouble(), 0));
      }
      lebelactive.add(false);
      label.add(Month.getGraphDayMonth(temp[i]['report_at']));
      rawBarGroups.add(makeGroupData(i, a, b));
    }
    if (widget.rule != '') {
      listRule.add(HorizontalLine(
          y: double.parse(widget.rule), color: Colors.blue, dashArray: [4, 4]));
    }

    // final barGroup1 = makeGroupData(0, 5, 12);
    // final barGroup2 = makeGroupData(1, 16, 12);
    // final barGroup3 = makeGroupData(2, 18, 5);
    // final barGroup4 = makeGroupData(3, 20, 16);
    // final barGroup5 = makeGroupData(4, 17, 6);
    // final barGroup6 = makeGroupData(5, 19, 1.5);
    // final barGroup7 = makeGroupData(6, 10, 1.5);

    // final items = [
    //   barGroup1,
    //   barGroup2,
    //   barGroup3,
    //   barGroup4,
    //   barGroup5,
    //   barGroup6,
    //   barGroup7,
    // ];

    // rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: red_n,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: TextWidget.textTitle('คุณภาพน้ำก่อนการบำบัด'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: blue_n,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: TextWidget.textTitle('คุณภาพน้ำหลังการบำบัด'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(
                    width: 100,
                    child: DottedLine(
                      dashColor: blue_n,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: TextWidget.textTitle('ค่ามาตรฐาน'),
                  ),
                ]),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 3,
                      child: BarChart(
                        BarChartData(
                          extraLinesData: ExtraLinesData(
                              horizontalLines: listRule, verticalLines: listSelect),
                          maxY: maxValue,
                          barTouchData: BarTouchData(
                            touchTooltipData:
                                BarTouchTooltipData(getTooltipColor: ((group) {
                              return Colors.white;
                            }), getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex,
                            ) {
                              return BarTooltipItem(
                                'ก่อนบำบัด ${rod.fromY} หลังบำบัด ${rod.toY}',
                                TextStyle(
                                  color: Colors.black,
                                  fontSize: 8.0,
                                ),
                              );
                            }),
                            touchCallback: (FlTouchEvent event, response) {},
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitles,
                                reservedSize: 60,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                interval: 1,
                                getTitlesWidget: leftTitles,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: showingBarGroups,
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text = '';
    if (value % 20 == 0) {
      text = '${value}';
    }
    //   text = '1K';
    // } else if (value == 10) {
    //   text = '5K';
    // } else if (value == 19) {
    //   text = '10K';
    // } else {
    //   return Container();
    // }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = label;

    Widget text;
    var i = value.toInt();
    var style2 = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10,
        color: lebelactive[i] ? Colors.white : Colors.black);
    text = Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: lebelactive[i] ? Colors.blue : Colors.white,
        ),
        child: Center(
          child: Text(widget.data[i]['label'],
              style: style2),
        ));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: red_n,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: blue_n,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}


// class DooYearGraph extends StatefulWidget {
//   dynamic data;
//   String rule;
//   DooYearGraph({
//     Key? key,
//     required this.data,
//     required this.rule,
//   }) : super(key: key);

//   @override
//   State<DooYearGraph> createState() => _DooYearGraphState();
// }

// class _DooYearGraphState extends State<DooYearGraph> {
//   static const Color primary = contentColorCyan;
//   static const Color menuBackground = Color(0xFF090912);
//   static const Color itemsBackground = Color(0xFF1B2339);
//   static const Color pageBackground = Color(0xFF282E45);
//   static const Color mainTextColor1 = Colors.white;
//   static const Color mainTextColor2 = Colors.white70;
//   static const Color mainTextColor3 = Colors.white38;
//   static const Color mainGridLineColor = Colors.white10;
//   static const Color borderColor = Colors.white54;
//   static const Color gridLinesColor = Color(0x11FFFFFF);

//   static const Color contentColorBlack = Colors.black;
//   static const Color contentColorWhite = Colors.white;
//   static const Color contentColorBlue = Color(0xFF2196F3);
//   static const Color contentColorYellow = Color(0xFFFFC300);
//   static const Color contentColorOrange = Color(0xFFFF683B);
//   static const Color contentColorGreen = Color(0xFF3BFF49);
//   static const Color contentColorPurple = Color(0xFF6E1BFF);
//   static const Color contentColorPink = Color(0xFFFF3AF2);
//   static const Color contentColorRed = Color(0xFFE80054);
//   static const Color contentColorCyan = Color(0xFF50E4FF);

//   List<Color> gradientColors = [
//     contentColorYellow,
//     contentColorWhite,
//   ];

//   List<Color> gradientColors2 = [
//     contentColorBlue,
//     contentColorWhite,
//   ];

//   bool showAvg = false;

//   List<FlSpot> listPlot = [];
//   List<FlSpot> listtreatedPlot = [];

//   List<HorizontalLine> listRule = [];

//   List<bool> lebelactive = [];

//   List<VerticalLine> listSelect = [];

//   var maxValue = 0.0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.data);
//     List<dynamic> temp = widget.data;
//     for (var i = 0; i < temp.length; i++) {
//       if (temp[i]['before'] != null) {
//         listPlot.add(FlSpot(i.toDouble(), temp[i]['before'] * 1.0));
//         if (maxValue < temp[i]['before'].toDouble()) {
//           maxValue = temp[i]['before'].toDouble();
//         }
//       } else {
//         listPlot.add(FlSpot(i.toDouble(), 0));
//       }

//       if (temp[i]['after'] != null) {
//         listtreatedPlot.add(FlSpot(i.toDouble(), temp[i]['after'] * 1.0));
//         if (maxValue < temp[i]['after'].toDouble()) {
//           maxValue = temp[i]['after'].toDouble();
//         }
//       } else {
//         listtreatedPlot.add(FlSpot(i.toDouble(), 0));
//       }
//       lebelactive.add(false);
//     }
//     if (widget.rule != '') {
//       listRule.add(HorizontalLine(
//           y: double.parse(widget.rule), color: Colors.blue, dashArray: [4, 4]));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AspectRatio(
//           aspectRatio: 1.70,
//           child: Padding(
//             padding: const EdgeInsets.only(
//               right: 18,
//               left: 12,
//               top: 24,
//               bottom: 12,
//             ),
//             child: Stack(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.fromLTRB(20, 0, 0, 50),
//                   decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       gradient: LinearGradient(
//                         begin: Alignment.topRight,
//                         end: Alignment.bottomLeft,
//                         colors: [
//                           Colors.blue,
//                           Colors.blue,
//                           Colors.orange,
//                         ],
//                       )),
//                   height: MediaQuery.of(context).size.height * 0.6,
//                   width: 20,
//                 ),
//                 LineChart(
//                   mainData(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );

//     List<dynamic> temp = widget.data;
//     var i = value.toInt();
//     Widget text;
//     if (i < temp.length) {
//       String temp2 = Month.getGraphDay(widget.data[i]['report_at']);

//       if (temp2 == '16') {
//         var style2 = TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 10,
//             color: lebelactive[i] ? Colors.black : Colors.black);
//         text = Container(
//             padding: const EdgeInsets.all(4),
//             child: Center(
//               child: Text(Month.getGraphMonth(widget.data[i]['report_at']),
//                   style: style2),
//             ));
//       } else {
//         text = const Text('', style: style);
//       }
//     } else {
//       text = const Text('', style: style);
//     }

//     // switch (value.toInt()) {
//     //   case 2:
//     //     text = const Text('MAR', style: style);
//     //     break;
//     //   case 5:
//     //     text = const Text('JUN', style: style);
//     //     break;
//     //   case 8:
//     //     text = const Text('SEP', style: style);
//     //     break;
//     //   default:
//     //     text = const Text('', style: style);
//     //     break;
//     // }

//     return GestureDetector(
//       onTap: () {
//         for (var i = 0; i < lebelactive.length; i++) {
//           lebelactive[i] = false;
//         }
//         lebelactive[i] = true;
//         listSelect.clear();
//         listSelect.add(VerticalLine(x: i.toDouble(), color: Colors.blue));
//         setState(() {});
//       },
//       child: SideTitleWidget(
//         axisSide: meta.axisSide,
//         child: text,
//       ),
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );

//     const style2 = TextStyle(
//         fontWeight: FontWeight.bold, fontSize: 7, color: Colors.white);

//     try {
//       if (value.toInt() == int.parse(widget.rule)) {
//         String text = '${value.toInt()} ค่ามาตรฐาน';
//         return Container(
//             width: 5,
//             margin: const EdgeInsets.fromLTRB(5, 5, 15, 5),
//             padding: const EdgeInsets.all(5),
//             decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(5)),
//                 color: Colors.blue),
//             child: Text(text, style: style2, textAlign: TextAlign.center));
//       }
//     } catch (e) {
//       print(e);
//     }
//     String text = '${value.toInt()}';
//     // switch (value.toInt()) {
//     //   case 1:
//     //     text = '10K';
//     //     break;
//     //   case 3:
//     //     text = '30k';
//     //     break;
//     //   case 5:
//     //     text = '50k';
//     //     break;
//     //   default:
//     //     return Container();
//     // }

//     return Text(text, style: style, textAlign: TextAlign.left);
//   }

//   LineChartData mainData() {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );

//     return LineChartData(
//       //   lineTouchData: LineTouchData(
//       // touchTooltipData: LineTouchTooltipData(
//       //   getTooltipItems: (value) {
//       //     return value
//       //         .map((e) => LineTooltipItem(
//       //             "Before  ",
//       //             style))
//       //         .toList();
//       //   },
//       //   tooltipBgColor: blueButton,
//       // ),),

//       extraLinesData:
//           ExtraLinesData(horizontalLines: listRule, verticalLines: listSelect),
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: mainGridLineColor,
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: Color.fromARGB(255, 227, 226, 226),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 50,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//                     interval:1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 80,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: listPlot.length * 1,
//       minY: 0,
//       maxY: maxValue.toInt()  +2,
//       lineBarsData: [
//         LineChartBarData(
//           // showingIndicators: [1],

//           spots: listtreatedPlot,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors2,
//           ),
//           barWidth: 2,
//           // isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: gradientColors2
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//         LineChartBarData(
//           spots: listPlot,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//             // spotsLine: BarAreaSpotsLine(
//             //   show: true,
//             //   flLineStyle: FlLine(
//             //     color: Colors.black,
//             //     strokeWidth: 2,
//             //   ),
//             //   checkToShowSpotLine: (spot) {
//             //     if (spot.x == 0 || spot.x == 6) {
//             //       return false;
//             //     }

//             //     return true;
//             //   },
//             // ),
//           ),
//         ),
//       ],
//     );
//   }
// }
