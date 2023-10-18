import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../Utils/month.dart';

class StatGraphQuater extends StatefulWidget {
  List<dynamic> data;
  String rule;
  StatGraphQuater({
    Key? key,
    required this.data,
    required this.rule,
  }) : super(key: key);
  @override
  State<StatGraphQuater> createState() => _StatGraphQuaterState();
}

class _StatGraphQuaterState extends State<StatGraphQuater> {
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
    contentColorBlue,
    contentColorWhite,
  ];

  List<Color> gradientColors2 = [
    contentColorBlue,
    contentColorCyan,
  ];

  bool showAvg = false;

  List<FlSpot> listPlot = [];

  List<bool> lebelactive = [];

  var maxValue = 0.0;

  List<VerticalLine> listSelect = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<dynamic> temp = widget.data;
    for (var i = 0; i < temp.length; i++) {
      if (temp[i]['total'] != null) {
        listPlot.add(FlSpot(i.toDouble(), temp[i]['total'] * 1.0));
        lebelactive.add(false);
        if (maxValue < temp[i]['total'].toDouble()) {
          maxValue = temp[i]['total'].toDouble();
        }
      } else {
        listPlot.add(FlSpot(i.toDouble(), 0));
        lebelactive.add(false);
      }
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
                  margin: const EdgeInsets.fromLTRB(30, 0, 0, 50),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          contentColorBlue,
                          contentColorBlue,
                          contentColorCyan,
                        ],
                      )),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

      extraLinesData: ExtraLinesData(
          /*horizontalLines: listRule,*/ verticalLines: listSelect),
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
            interval: maxValue > 50000 ? 50000 : 10000,
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
      maxX: listPlot.length * 1,
      minY: 0,
      maxY: maxValue.toInt() + 5000,
      lineBarsData: [
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    List<dynamic> temp = widget.data;
    var i = value.toInt();
    Widget text;
    if (i < temp.length) {
      String temp2 = Month.getGraphDay(widget.data[i]['report_at']);

      if (temp2 == '16') {
        var style2 = TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: lebelactive[i] ? Colors.blue : Colors.black);
        text = Container(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Text(Month.getGraphMonth(widget.data[i]['report_at']),
                  style: style2),
            ));
      } else {
        text = const Text('', style: style);
      }
    } else {
      text = const Text('', style: style);
    }

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
      fontSize: 10,
    );

    const style2 = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 7, color: Colors.white);

    // if (value.toInt() == int.parse(widget.rule)) {
    //   String text = '${value.toInt()} ค่ามาตรฐาน';
    //   return Container(
    //       width: 5,
    //       margin: const EdgeInsets.fromLTRB(5, 5, 15, 5),
    //       padding: const EdgeInsets.all(5),
    //       decoration: const BoxDecoration(
    //           borderRadius: BorderRadius.all(Radius.circular(5)),
    //           color: Colors.blue),
    //       child: Text(text, style: style2, textAlign: TextAlign.center));
    // }
    String text = '';
    try {
      text = '${value.toInt()}';
    } catch (e) {
      text = '-';
    }

    if (text.length > 3) {
      text = '${text.substring(0, 3)}K';
    }

    //  print(value.toInt());
    // switch (value.toInt()) {
    //   case 1:
    //     text = '10K';
    //     break;
    //   case 3:

    // if (text.length > 3) {
    //   text = '${text.substring(0, 3)}K';
    // }
    //     break;
    //   case 5:
    //     text = '50k';
    //     break;
    //   default:
    //     return Container();
    // }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
