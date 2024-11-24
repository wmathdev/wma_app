// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/widget/appbarGeneral.dart';

import '../../model/station.dart';
import '../../widget/appbar.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/text_widget.dart';

class DropDownSelect extends StatefulWidget {
  List<String> data;
  String title;

  DropDownSelect({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  State<DropDownSelect> createState() => _DropDownSelectState();
}

class _DropDownSelectState extends State<DropDownSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('asset/images/waterbg.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    // if (index == 0) {
                    //   return AppBar(title: Text(widget.title));
                    //   // return Padding(
                    //   //   padding: const EdgeInsets.all(8.0),
                    //   //   child: Center(
                    //   //       child: TextWidget.textSubTitle(widget.title)),
                    //   // );
                    // }

                    return ListItemWidget.cardListDropdown(
                        context, widget.data[index], () {
                      Navigator.pop(context, index);
                    });
                  }),
            ),
          ),
        ));
  }
}
