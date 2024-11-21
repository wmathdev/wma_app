// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wma_app/widget/text_widget.dart';

class PreviewImageValue extends StatefulWidget {
  dynamic img;
  PreviewImageValue({
    Key? key,
    required this.img,
  }) : super(key: key);

  @override
  State<PreviewImageValue> createState() => _PreviewImageValueState();
}

class _PreviewImageValueState extends State<PreviewImageValue> {
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
                child:
                    Container(child: Column(children: [appbar(), image()])))));
  }

  Widget image() {
    try {
      return Card(
        child: widget.img['type'] == 'url'
            ? Image.network(
                widget.img['value'],
              )
            : Image.file(
                widget.img['value'],
              ),
      );
    } catch (e) {
      return Card(
          child: Image.network(
        widget.img,
      ));
    }
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
          TextWidget.textTitle('รูปภาพประกอบ')
        ],
      ),
    );
  }
}
