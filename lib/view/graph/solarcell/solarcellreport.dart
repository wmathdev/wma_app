import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/Utils/label.dart';
import 'package:wma_app/Utils/month.dart';

class SolarcellReportGraph extends StatefulWidget {
  dynamic data;
  int type;

  SolarcellReportGraph({Key? key, required this.data, required this.type})
      : super(key: key);

  @override
  State<SolarcellReportGraph> createState() => _SolarcellReportGraphState();
}

class _SolarcellReportGraphState extends State<SolarcellReportGraph> {
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
    if (widget.type == 0) {
      for (var i = 0; i < temp.length; i++) {
        if (temp[i]['reduction_total_coal'] != null) {
          listPlot.add(
              FlSpot(i.toDouble(), temp[i]['reduction_total_coal'].toDouble()));
          lebelactive.add(false);
          if (maxValue < temp[i]['reduction_total_coal'].toDouble()) {
            maxValue = temp[i]['reduction_total_coal'].toDouble();
          }
        } else {
          listPlot.add(FlSpot(i.toDouble(), 0));
          lebelactive.add(false);
        }
      }
    } else if (widget.type == 1) {
      for (var i = 0; i < temp.length; i++) {
        if (temp[i]['reduction_total_co2'] != null) {
          listPlot.add(
              FlSpot(i.toDouble(), temp[i]['reduction_total_co2'].toDouble()));
          lebelactive.add(false);
          if (maxValue < temp[i]['reduction_total_co2'].toDouble()) {
            maxValue = temp[i]['reduction_total_co2'].toDouble();
          }
        } else {
          listPlot.add(FlSpot(i.toDouble(), 0));
          lebelactive.add(false);
        }
      }
    } else if (widget.type == 2) {
      for (var i = 0; i < temp.length; i++) {
        if (temp[i]['reduction_total_tree'] != null) {
          listPlot.add(
              FlSpot(i.toDouble(), temp[i]['reduction_total_tree'].toDouble()));
          lebelactive.add(false);
          if (maxValue < temp[i]['reduction_total_tree'].toDouble()) {
            maxValue = temp[i]['reduction_total_tree'].toDouble();
          }
        } else {
          listPlot.add(FlSpot(i.toDouble(), 0));
          lebelactive.add(false);
        }
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // controller: barChartScroller,
                        // reverse: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          height: 325,
                          width: MediaQuery.of(context).size.width * 3,
                          child: BarChart(
                            mainBarData(),
                            swapAnimationDuration: animDuration,
                          ),
                        ),
                      )),
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

  List<BarChartGroupData> showingGroups0() =>
      List.generate(widget.data.length, (i) {
        return makeGroupData(
            i,
            widget.data[i]['reduction_total_coal'] != null
                ? widget.data[i]['reduction_total_coal'].toDouble()
                : 0.00,
            barColor: lineColor,
            isTouched: i == touchedIndex);
      });

  List<BarChartGroupData> showingGroups1() =>
      List.generate(widget.data.length, (i) {
        return makeGroupData(
            i,
            widget.data[i]['reduction_total_co2'] != null
                ? widget.data[i]['reduction_total_co2'].toDouble()
                : 0.00,
            barColor: lineColor,
            isTouched: i == touchedIndex);
      });

  List<BarChartGroupData> showingGroups2() =>
      List.generate(widget.data.length, (i) {
        return makeGroupData(
            i,
            widget.data[i]['reduction_total_tree'] != null
                ? widget.data[i]['reduction_total_tree'].toDouble()
                : 0.00,
            barColor: lineColor,
            isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      maxY: maxValue * 1.5,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => red_n,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,

          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String total = widget.type == 0
                ? '${widget.data[group.x]['reduction_total_coal']}'
                : widget.type == 1
                    ? '${widget.data[group.x]['reduction_total_co2']}'
                    : '${widget.data[group.x]['reduction_total_tree']}';
            return BarTooltipItem(
              total,
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                 TextSpan(
                  text: widget.type == 0 ||  widget.type == 1 ? ' Ton ' : 'Trees',
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
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) => Container(),
            showTitles: true,
            reservedSize: 10,
          ),
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
            interval: 0.1,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: widget.type == 0
          ? showingGroups0()
          : widget.type == 1
              ? showingGroups1()
              : showingGroups2(),
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
          color:  Colors.black);
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
            color:  Colors.white,
          ),
          child: Center(
            child: Text(Month.getGraphDayMonth(widget.data[i]['collect_date']),
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
        space: 5,
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
    String text = (value.toStringAsFixed(2));

    if (value == (maxValue * 1.5)) {
      text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: Text(text, style: style2),
    );
  }
}
