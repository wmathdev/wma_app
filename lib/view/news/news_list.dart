// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:wma_app/widget/list_item_widget.dart';
import 'package:wma_app/widget/text_widget.dart';

class NewsList extends StatefulWidget {
  dynamic news;

  NewsList({
    Key? key,
    required this.news,
  }) : super(key: key);

  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List diaplaylist = [];
  dynamic alldata;

  @override
  void initState() {
    super.initState();
    alldata = widget.news;
    diaplaylist = widget.news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('asset/images/waterbg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        child: Column(
          children: [
            appbar(),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset('asset/images/iconintro.png')),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget.textTitle('องค์การจัดการน้ำเสีย'),
                    TextWidget.textSubTitleBold('ข่าวประชาสัมพันธ์'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
            width: MediaQuery.of(context).size.width * 0.9,
                  height: 55,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      ),
                      
                      labelText: 'ค้นหา'),
                  onChanged: (value) {
                    diaplaylist = [];
                    for (var i = 1; i < alldata.length; i++) {
                      if (alldata[i]['title']['rendered']
                          .toString()
                          .contains(value)) {
                        diaplaylist.add(alldata[i]);
                      }
                    }
                    setState(() {
                      diaplaylist.length;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              const SizedBox(
                width: 20,
              ),
              TextWidget.textTitleBold('ข่าวทั้งหมด'),
            ]),
            Expanded(
              child: ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: diaplaylist
                      .length, // Replace with your actual number of news articles
                  itemBuilder: (context, index) {
                    return ListItemWidget.newsCard(
                        context,
                        diaplaylist[index]['title']['rendered'],
                        diaplaylist[index]['jetpack_featured_media_url'],
                        diaplaylist[index],
                        showDate(diaplaylist[index]['date']));
                  }),
            )
          ],
        ),
      ),
    )));
  }

  String showDate(String date) {
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }

  Widget appbar() {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Image.asset('asset/images/arrow_left_n.png')),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
          ),
          TextWidget.textTitle('ข่าวประชาสัมพันธ์')
        ],
      ),
    );
  }



}
