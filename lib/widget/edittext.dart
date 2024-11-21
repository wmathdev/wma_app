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
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          width: 3, color: greyBorder), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(width: 3, color: greyBorder),
                    ),
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
      TextEditingController controller, bool _obscured, Function()? change) {
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
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: TextField(
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
                      borderSide: BorderSide(
                          width: 3, color: greyBorder), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(width: 3, color: greyBorder),
                    ),
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
          TextWidget.textTitleBold(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              SizedBox(
                height: 60,
                child: TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          width: 3, color: greyBorder), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(width: 3, color: greyBorder),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 60,
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

  static Widget edittextFormWithCheckbox(
      BuildContext context,
      String title,
      String unit,
      TextEditingController controller,
      bool required,
      bool checkedValue,
      Function(bool?)? onChangeCheckbox) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 3,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget.textTitleBold(title),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // TextWidget.textTitleBold('ค่า BOD     '),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          TextWidget.textTitle(controller.text),
                          const SizedBox(
                            width: 20,
                          ),
                          TextWidget.textTitle(unit)
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 40,
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  //   child: TextField(
                  //     controller: controller,
                  //     keyboardType:
                  //         const TextInputType.numberWithOptions(decimal: true),
                  //     decoration: InputDecoration(
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(15.0),
                  //         borderSide: BorderSide(
                  //             width: 3, color: greyBorder), //<-- SEE HERE
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(15.0),
                  //         borderSide: BorderSide(width: 3, color: greyBorder),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      child: ListTileTheme(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.zero,
                        child: CheckboxListTile(
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: TextWidget.textTitle("ตรวจสอบแล้ว"),
                          value: checkedValue,
                          onChanged: onChangeCheckbox,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // Container(
              //     margin: const EdgeInsets.fromLTRB(0, 10, 35, 0),
              //     height: 40,
              //     width: MediaQuery.of(context).size.width * 0.35,
              //     alignment: Alignment.centerRight,
              //     child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
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

  static Widget alignEdittextForm(String title, String unit,
      TextEditingController controller, bool required, double width) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget.textTitleBold(title),
                  SizedBox(
                    height: 60,
                    width: width,
                    child: TextField(
                      controller: controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              width: 3, color: greyBorder), //<-- SEE HERE
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(width: 3, color: greyBorder),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 60,
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

  static Widget alignEdittextFormDisable(String title, String unit,
      TextEditingController controller, bool required, double width) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  TextWidget.textTitleBold(title),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget.textTitle(controller.text),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget.textTitle(unit),
                  // SizedBox(
                  //   height: 40,
                  //   width: width,
                  //   child: TextField(
                  //     enabled: false,
                  //     controller: controller,
                  //     keyboardType:
                  //         const TextInputType.numberWithOptions(decimal: true),
                  //     decoration: InputDecoration(
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(15.0),
                  //         borderSide: BorderSide(
                  //             width: 3, color: greyBorder), //<-- SEE HERE
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(15.0),
                  //         borderSide: BorderSide(width: 3, color: greyBorder),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // Container(
              //     margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              //     height: 40,
              //     alignment: Alignment.centerRight,
              //     child: TextWidget.textGeneralWithColor(unit, Colors.grey)),
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

  static Widget edittextFormDisable(String title, String unit,
      TextEditingController controller, bool required) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.textTitleBold(title),
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              SizedBox(
                height: 40,
                child: TextField(
                  enabled: false,
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          width: 3, color: greyBorder), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(width: 3, color: greyBorder),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  height: 40,
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
                maxLines: 3,
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

  static Widget edittextAreaFormWhite(String title, String unit,
      TextEditingController controller, bool required) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextField(
                  maxLines: 3,
                  controller: controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          width: 3, color: greyBorder), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(width: 3, color: greyBorder),
                    ),
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

  // bool checkRequiredCheckbox(bool hasValue, bool isChecked) {
  //   if (hasValue & isChecked) {
  //     return true;
  //   }
  //   return false;
  // }
}
