import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/OtherRequest.dart';

import '../../Utils/label.dart';
import '../../widget/button_app.dart';
import '../../widget/text_widget.dart';
import '../graph/statgraph.dart';
import '../graph/statgraphMonth.dart';
import '../graph/statgraphQuarter.dart';
import '../graph/statgraphYear.dart';

class Statistic extends StatefulWidget {
  Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  late dynamic data;
  List<dynamic> graph = [];

  late dynamic dataMonth;
  List<dynamic> graphMonth = [];

  late dynamic dataQUARTER;
  List<dynamic> graphQUARTER = [];

  late dynamic dataYear;
  List<dynamic> graphYear = [];

  bool loading = true;

  var select = 0;

  Future<void> _getData() async {
    var res = await OtherRequest.statistic('WEEK');
    data = res;
    graph = data['data']['graph'];

    var res2 = await OtherRequest.statistic('MONTH');
    dataMonth = res2;
    graphMonth = dataMonth['data']['graph'];

    var res3 = await OtherRequest.statistic('QUARTER');
    dataQUARTER = res3;
    graphQUARTER = dataQUARTER['data']['graph'];

    var res4 = await OtherRequest.statistic('YEAR');
    dataYear = res4;
    graphYear = dataYear['data']['graph'];

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          body: SafeArea(
              child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'asset/lottie/animation_lk0uamsc.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
              TextWidget.textGeneralWithColor('กรุณารอสักครู่...', blueSelected)
            ],
          ),
        ),
      )));
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              headerBar(),
              const SizedBox(
                height: 10,
              ),
              valueCard(),
              const SizedBox(
                height: 20,
              ),
              graphFilter(),
              const SizedBox(
                height: 20,
              ),
              select == 0
                  ? weekgraph()
                  : select == 1
                      ? monthgraph()
                      : select == 2
                          ? quartergraph()
                          : yeargraph()
            ],
          ),
        ),
      ),
    );
  }

  Widget headerBar() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('asset/images/wave.png'),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textTitleWithColorSize(
                        'ปริมาณน้ำเสียที่ผ่านการบำบัด', Colors.black, 13),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textTitleWithColorSize(
                        'จากศูนย์บำบัดทั่วไทยทั้งหมด ${data['data']['stations']} แห่ง',
                        Colors.grey,
                        13),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget valueCard() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              Row(
                children: [
                  select == 0
                      ? TextWidget.textSubTitleWithSizeColor(
                          Label.nemerricFormat(data['data']['total']), 20, blueSelected)
                      : select == 1
                          ? TextWidget.textSubTitleWithSizeColor(
                              Label.nemerricFormat(dataMonth['data']['total']), 20, blueSelected)
                          : select == 2
                              ? TextWidget.textSubTitleWithSizeColor(
                                  Label.nemerricFormat(dataQUARTER['data']['total']),
                                  20,
                                  blueSelected)
                              : TextWidget.textSubTitleWithSizeColor(
                                  Label.nemerricFormat(dataYear['data']['total']),
                                  20,
                                  blueSelected),
                  SizedBox(
                    width: 10,
                  ),
                  TextWidget.textTitle('ลบ.ม.')
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: select == 0
                        ? TextWidget.textTitle(
                            'ปริมาณสะสมตั้งแต่ ${data['data']['period']}')
                        : select == 1
                            ? TextWidget.textTitle(
                                'ปริมาณสะสมตั้งแต่ ${dataMonth['data']['period']}')
                            : select == 2
                                ? TextWidget.textTitle(
                                    'ปริมาณสะสมตั้งแต่ ${dataQUARTER['data']['period']}')
                                : TextWidget.textTitle(
                                    'ปริมาณสะสมตั้งแต่ ${dataYear['data']['period']}'),
                  )
                ],
              ),
            ]),
          ),
        ));
  }

  List<bool> graphFilterIndex = [true, false, false, false];

  Widget graphFilter() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonApp.buttonGraphFilter(context, '1 สัปดาห์', () async {
          graphFilterIndex = [true, false, false, false];
          // await _getData('WEEK');
          setState(() {
            select = 0;
          });
        }, graphFilterIndex[0]),
        ButtonApp.buttonGraphFilter(context, '1 เดือน', () async {
          graphFilterIndex = [false, true, false, false];
          // await _getData('MONTH');
          setState(() {
            select = 1;
          });
        }, graphFilterIndex[1]),
        ButtonApp.buttonGraphFilter(context, '3 เดือน', () async {
          graphFilterIndex = [false, false, true, false];
          // await _getData('QUARTER');
          setState(() {
            select = 2;
          });
        }, graphFilterIndex[2]),
        ButtonApp.buttonGraphFilter(context, '1 ปี', () async {
          graphFilterIndex = [false, false, false, true];
          // await _getData('YEAR');
          setState(() {
            select = 3;
          });
        }, graphFilterIndex[3])
      ],
    );
  }

  Widget weekgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraph(
                        data: graph,
                        rule: '',
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraph(
                        data: graph,
                        rule: '',
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget monthgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraphMonth(
                        data: graphMonth,
                        rule: '',
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraphMonth(
                        data: graphMonth,
                        rule: '',
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget quartergraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraphQuater(
                        data: graphQUARTER,
                        rule: '',
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraphQuater(
                        data: graphQUARTER,
                        rule: '',
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget yeargraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraphYear(
                        data: graphYear,
                        rule: '',
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      StatGraphYear(
                        data: graphYear,
                        rule: '',
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
