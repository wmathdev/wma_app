import 'package:flutter/material.dart';
import 'package:wma_app/Utils/color.dart';
import 'package:wma_app/widget/text_widget.dart';

class Edittext {
  static Widget edittextGeneral(
      String title, String unit, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.textSubTitle(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        BorderSide(width: 3, color: greyBorder), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 3, color: greyBorder),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  static Widget edittextGeneralSecure(String title, String unit,
      TextEditingController controller, bool _obscured,Function()? change) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.textSubTitle(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              TextField(
                obscureText: _obscured,
                controller: controller,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: change,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        BorderSide(width: 3, color: greyBorder), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 3, color: greyBorder),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  static Widget edittextForm(String title, String unit,
      TextEditingController controller, bool required) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.textSubTitle(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        BorderSide(width: 3, color: greyBorder), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 3, color: greyBorder),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          required
              ? Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/images/required.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(child: TextWidget.textGeneral('กรุณากรอก$title'))
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  static Widget 
  edittextFormDisable(String title, String unit,
      TextEditingController controller, bool required) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.textSubTitle(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              TextField(
                enabled: false,
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        BorderSide(width: 3, color: greyBorder), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 3, color: greyBorder),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          required
              ? Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/images/required.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget.textGeneral('กรุณากรอก$title')
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  static Widget edittextAreaForm(String title, String unit,
      TextEditingController controller, bool required) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.textSubTitle(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              TextField(
                maxLines: 5,
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        BorderSide(width: 3, color: greyBorder), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 3, color: greyBorder),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          required
              ? Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/images/required.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget.textGeneral('กรุณากรอก$title')
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  static Widget edittextAreaFormDisable(String title, String unit,
      TextEditingController controller, bool required) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.textSubTitle(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              TextField(
                enabled: false,
                maxLines: 5,
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        BorderSide(width: 3, color: greyBorder), //<-- SEE HERE
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        BorderSide(width: 3, color: greyBorder), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(width: 3, color: greyBorder),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          required
              ? Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/images/required.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget.textGeneral('กรุณากรอก$title')
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
