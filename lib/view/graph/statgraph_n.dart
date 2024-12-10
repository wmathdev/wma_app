// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/Utils/label.dart';
import 'package:wma_app/Utils/month.dart';

class Statgraph_n extends StatefulWidget {
  List<dynamic> data;
  String rule;
  Statgraph_n({
    Key? key,
    required this.data,
    required this.rule,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => Statgraph_nState();
}

class Statgraph_nState extends State<Statgraph_n> {
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
  static const Color textColor = Color(0xFF001F60);
  static const Color lineColor = Color(0xFF3859D0);

  final Color barBackgroundColor = Colors.transparent;
  final Color barColor = lineColor;
  final Color touchedBarColor = lineColor;

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  List<FlSpot> listPlot = [];

  List<bool> lebelactive = [];
  var maxValue = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<dynamic> temp = widget.data;
    for (var i = 0; i < temp.length; i++) {
      if (temp[i]['mantissa'] != null) {
        listPlot.add(FlSpot(i.toDouble(), temp[i]['mantissa'].toDouble()));
        lebelactive.add(false);
        if (maxValue < temp[i]['mantissa'].toDouble()) {
          maxValue = temp[i]['mantissa'].toDouble();
        }
      } else {
        listPlot.add(FlSpot(i.toDouble(), 0));
        lebelactive.add(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Align(
          //     alignment: Alignment.topRight,
          //     child: IconButton(
          //       icon: Icon(
          //         isPlaying ? Icons.pause : Icons.play_arrow,
          //         color:contentColorGreen,
          //       ),
          //       onPressed: () {
          //         setState(() {
          //           isPlaying = !isPlaying;
          //           if (isPlaying) {
          //             refreshState();
          //           }
          //         });
          //       },
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 5,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(widget.data.length, (i) {
        return makeGroupData(
            i,
            widget.data[i]['mantissa'] != null
                ? widget.data[i]['mantissa'].toDouble()
                : 0.00,
            barColor: lineColor,
            isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      maxY: maxValue * 1.2,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => red_n,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                 String total =
                Label.commaFormat('${widget.data[group.x]['total']}');
            return BarTooltipItem(
              total,
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: ' m\u{00B3} ',
                  style: TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          // setState(() {
          //   if (!event.isInterestedForInteractions ||
          //       barTouchResponse == null ||
          //       barTouchResponse.spot == null) {
          //     touchedIndex = -1;
          //     return;
          //   }
          //   touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          // });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
          topTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) => Container(),
            showTitles: true,
            reservedSize: 10,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 50,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: true),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
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
          width: 30,
          height: 100,
          padding: const EdgeInsets.all(5),
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
            child: Text(Month.getGraphDayMonth(widget.data[i]['report_at']),
                style: style2),
          ));
    } else {
      text = const Text('-', style: style);
    }

    return GestureDetector(
      onTap: () {
        for (var i = 0; i < lebelactive.length; i++) {
          lebelactive[i] = false;
        }
        lebelactive[i] = true;
        // listSelect.clear();
        // listSelect.add(VerticalLine(x: i.toDouble(), color: Colors.blue));
        setState(() {});
      },
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      ),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );

    const style2 = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 8, color: Colors.black);
    String text = '${(value * 10000).toInt()}';

     if (value.toInt() == (maxValue * 1.2).toInt()) {
       text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: Text(text, style: style2),
    );
  }
}
