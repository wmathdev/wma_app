// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../Utils/month.dart';

class TempGraphWeek extends StatefulWidget {
    dynamic data;
  String rule;
  TempGraphWeek({
    Key? key,
    required this.data,
    required this.rule,
  }) : super(key: key);

  @override
  State<TempGraphWeek> createState() => _TempGraphWeekState();
}

class _TempGraphWeekState extends State<TempGraphWeek> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data);
    List<dynamic> temp = widget.data;
    for (var i = 0; i < temp.length; i++) {
      if (temp[i]['before'] != null) {
        listPlot.add(FlSpot(i.toDouble(), temp[i]['before'] * 1.0));
        if (maxValue < temp[i]['before'].toDouble()) {
          maxValue = temp[i]['before'].toDouble();
        }
      } else {
        listPlot.add(FlSpot(i.toDouble(), 0));
      }

      if (temp[i]['after'] != null) {
        listtreatedPlot.add(FlSpot(i.toDouble(), temp[i]['after'] * 1.0));
        if (maxValue < temp[i]['after'].toDouble()) {
          maxValue = temp[i]['after'].toDouble();
        }
      } else {
        listtreatedPlot.add(FlSpot(i.toDouble(), 0));
      }
      lebelactive.add(false);
    }
    if (widget.rule != '') {
      listRule.add(HorizontalLine(
          y: double.parse(widget.rule), color: Colors.blue, dashArray: [4, 4]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 50),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue,
                          Colors.blue,
                          Colors.orange,
                        ],
                      )),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: 20,
                ),
                LineChart(
                  mainData(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    List<dynamic> temp = widget.data;
    var i = value.toInt();
    Widget text;
    if (i < temp.length) {
      var style2 = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          color: lebelactive[i] ? Colors.white : Colors.black);
      text = Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
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
            child: Text(Month.getGraphDayMonth(widget.data[i]['report_at']),
                style: style2),
          ));
    } else {
      text = const Text('', style: style);
    }

    // switch (value.toInt()) {
    //   case 2:
    //     text = const Text('MAR', style: style);
    //     break;
    //   case 5:
    //     text = const Text('JUN', style: style);
    //     break;
    //   case 8:
    //     text = const Text('SEP', style: style);
    //     break;
    //   default:
    //     text = const Text('', style: style);
    //     break;
    // }

    return GestureDetector(
      onTap: () {
        for (var i = 0; i < lebelactive.length; i++) {
          lebelactive[i] = false;
        }
        lebelactive[i] = true;
        listSelect.clear();
        listSelect.add(VerticalLine(x: i.toDouble(), color: Colors.blue));
        setState(() {});
      },
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    const style2 = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 7, color: Colors.white);

    try {
      if (value.toInt() == int.parse(widget.rule)) {
        String text = '< ${value.toInt()}\nค่ามาตรฐาน';
        return Container(
            width: 5,
            margin: const EdgeInsets.fromLTRB(5, 5, 15, 5),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.blue),
            child: Text(text, style: style2, textAlign: TextAlign.center));
      }
    } catch (e) {
      print(e);
    }

    String text = '${value.toInt()}';
    // switch (value.toInt()) {
    //   case 1:
    //     text = '10K';
    //     break;
    //   case 3:
    //     text = '30k';
    //     break;
    //   case 5:
    //     text = '50k';
    //     break;
    //   default:
    //     return Container();
    // }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    return LineChartData(
      //   lineTouchData: LineTouchData(
      // touchTooltipData: LineTouchTooltipData(
      //   getTooltipItems: (value) {
      //     return value
      //         .map((e) => LineTooltipItem(
      //             "Before  ",
      //             style))
      //         .toList();
      //   },
      //   tooltipBgColor: blueButton,
      // ),),

      extraLinesData:
          ExtraLinesData(horizontalLines: listRule, verticalLines: listSelect),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 227, 226, 226),
            strokeWidth: 1,
          );
        },
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
            reservedSize: 50,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 80,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: listPlot.length.toDouble() + 3.0,
      minY: 0,
      maxY: 60,
      lineBarsData: [
        LineChartBarData(
          // showingIndicators: [1],

          spots: listtreatedPlot,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors2,
          ),
          barWidth: 2,
          // isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors2
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: listPlot,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
            // spotsLine: BarAreaSpotsLine(
            //   show: true,
            //   flLineStyle: FlLine(
            //     color: Colors.black,
            //     strokeWidth: 2,
            //   ),
            //   checkToShowSpotLine: (spot) {
            //     if (spot.x == 0 || spot.x == 6) {
            //       return false;
            //     }

            //     return true;
            //   },
            // ),
          ),
        ),
      ],
    );
  }
}
