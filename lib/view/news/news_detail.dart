// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wma_app/api/OtherRequest.dart';

import '../../Utils/Color.dart';
import '../../widget/button_app.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';

class NewsDetail extends StatefulWidget {
  dynamic news;

  NewsDetail({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  List<dynamic> image = [];

  var loading = true;
  Future<void> _getImage(String url) async {
    var result = await OtherRequest.newsImage(url);

    setState(() {
      image = result;
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (loading) {
      _getImage(widget.news['_links']['wp:attachment'][0]['href']);
    }
    print('widget.news : ${widget.news}');
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: loading
          ? Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'asset/lottie/Loading1.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    TextWidget.textGeneralWithColor(
                        'กรุณารอสักครู่...', blueSelected)
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Stack(
                        children: [
                          CarouselSlider.builder(
                              itemCount: image.length,
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 200.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                return Image.network(
                                  image[itemIndex]['source_url'],
                                  fit: BoxFit.cover,
                                  height: 180.0,
                                  width: MediaQuery.of(context).size.width,
                                );
                              }),
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 180.0,
                            child: DotsIndicator(
                              dotsCount: image.length,
                              position: currentIndex,
                              decorator: DotsDecorator(
                                color: Colors.white60, // Inactive color
                                activeColor: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 215.0,
                            child: Container(
                              height: 30.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Container(
                                child: Text('  '),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextWidget.textTitle(
                              '· ${showDate(widget.news['date'])} ·'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextWidget.textTitleHTMLBoldBlue(
                          widget.news['title']['rendered'],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Html(data: widget.news['excerpt']['rendered']),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: NavigateBar.NavBar(
                      context, 'ข่าวสารองค์การจัดการน้ำเสีย', () {
                    Get.back();
                  }),
                ),
              ],
            ),
    ));
  }

  static Widget newsCard(BuildContext context, String title, String url) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(url, fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(children: [
              Expanded(child: TextWidget.textTitleBold(title)),
            ]),
          ),
          ButtonApp.buttonNews(context, 'ดูรายละเอียดเพิ่มเติม', () {}, true)
        ],
      ),
    );
  }

  String showDate(String date) {
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }
}
