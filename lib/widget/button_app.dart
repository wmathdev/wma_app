import 'package:flutter/material.dart';
import 'package:wma_app/widget/text_widget.dart';

import '../Utils/Color.dart';

class ButtonApp {
  static Widget buttonMain(BuildContext context, String title,
      GestureTapCallback onPressed, bool isDisable) {
    return TextButton(
        onPressed: isDisable ? onPressed : () {},
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: isDisable ? blueSelected : greyBorder,
                  border: Border.all(
                    color: isDisable ? blueSelected : greyBorder,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                  child: TextWidget.textGeneralWithColor(title, Colors.white)),
            ),
            // isRequired ? Text('data'):Container()
          ],
        ));
  }

  // static Widget buttonMainFix(BuildContext context, String title,
  //     GestureTapCallback onPressed, bool isDisable) {
  //   return TextButton(
  //       onPressed: isDisable ? onPressed : () {},
  //       child: Column(
  //         children: [
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.3,
  //             padding: const EdgeInsets.all(8.0),
  //             decoration: BoxDecoration(
  //                 color: isDisable ? blueSelected : greyBorder,
  //                 border: Border.all(
  //                   color: isDisable ? blueSelected : greyBorder,
  //                 ),
  //                 borderRadius: const BorderRadius.all(Radius.circular(10))),
  //             child: Center(
  //                 child: TextWidget.textGeneralWithColor(title, Colors.white)),
  //           ),
  //           // isRequired ? Text('data'):Container()
  //         ],
  //       ));
  // }

  static Widget buttonMainFix(BuildContext context, String title,
      GestureTapCallback onPressed, bool isDisable) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: TextButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isDisable ? blueSelected : greyBorder,
            side: BorderSide(
              width: 1.0,
              color: isDisable ? blueSelected : greyBorder,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: isDisable ? onPressed : () {},
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            // padding: const EdgeInsets.all(8.0),
            // decoration: BoxDecoration(
            //     // color: blueSelected,
            //     border: Border.all(
            //       color: blueSelected,
            //     ),
            //     borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: TextWidget.textTitleBoldWithColor(
              title,
              Colors.white,
            )),
          )),
    );
  }

  static Widget buttonTab(BuildContext context, String title,
      GestureTapCallback onPressed, bool isDisable) {
    return SizedBox(
      height: 50,
      child: TextButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isDisable ? blueSelected : Colors.transparent,
            side: BorderSide(
              width: 1.0,
              color: isDisable ? blueSelected : greyBorder,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            // padding: const EdgeInsets.all(8.0),
            // decoration: BoxDecoration(
            //     // color: blueSelected,
            //     border: Border.all(
            //       color: blueSelected,
            //     ),
            //     borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: TextWidget.textTitleBoldWithColor(
              title,
              isDisable ? Colors.white : Colors.black,
            )),
          )),
    );
  }

  static Widget buttonGraphFilter(BuildContext context, String title,
      GestureTapCallback onPressed, bool isDisable) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.2,
      child: TextButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isDisable ? blueSelected : Colors.transparent,
            side: BorderSide(
              width: 1.0,
              color: isDisable ? blueSelected : greyBorder,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            // padding: const EdgeInsets.all(8.0),
            // decoration: BoxDecoration(
            //     // color: blueSelected,
            //     border: Border.all(
            //       color: blueSelected,
            //     ),
            //     borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: TextWidget.textTitleBoldWithColor(
              title,
              isDisable ? Colors.white : Colors.black,
            )),
          )),
    );
  }

  static Widget buttonSecondary(
      BuildContext context, String title, GestureTapCallback onPressed) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: TextWidget.textGeneralWithColor(title, blueSelected)),
        ));
  }

  static Widget buttonSecondaryWithColor(BuildContext context, String title,
      GestureTapCallback onPressed, Color? color) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(child: TextWidget.textGeneralWithColor(title, color!)),
        ));
  }

  // static Widget buttonSecondaryFix(BuildContext context, String title,
  //     GestureTapCallback onPressed, bool isDisable) {
  //   return TextButton(
  //       onPressed: isDisable ? onPressed : () {},
  //       child: Column(
  //         children: [
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.3,
  //             padding: const EdgeInsets.all(8.0),
  //             decoration: BoxDecoration(
  //                 color: isDisable ? Colors.transparent : Colors.transparent,
  //                 border: Border.all(
  //                   color:
  //                       isDisable ? Colors.transparent : Colors.transparent,
  //                 ),
  //                 borderRadius: const BorderRadius.all(Radius.circular(10))),
  //             child: Center(
  //                 child:
  //                     TextWidget.textGeneralWithColor(title, blueSelected)),
  //           ),
  //           // isRequired ? Text('data'):Container()
  //         ],
  //       ));
  // }

  static Widget buttonSecondaryFix(BuildContext context, String title,
      GestureTapCallback onPressed, bool isDisable) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              width: 1.0,
              color: isDisable ? Colors.transparent : Colors.transparent,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(8.0),
            // decoration: BoxDecoration(
            //     // color: blueSelected,
            //     border: Border.all(
            //       color: blueSelected,
            //     ),
            //     borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: TextWidget.textTitleBoldWithColor(
              title,
              blueSelected,
            )),
          )),
    );
  }

  static Widget buttonSecondaryFixCard(BuildContext context, String title,
      GestureTapCallback onPressed, bool isDisable) {
    return TextButton(
        onPressed: isDisable ? onPressed : () {},
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: isDisable ? Colors.transparent : Colors.transparent,
                  border: Border.all(
                    color: isDisable ? Colors.transparent : Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                  child:
                      TextWidget.textTitleBoldWithColor(title, blueSelected)),
            ),
            // isRequired ? Text('data'):Container()
          ],
        ));
  }

  static Widget buttonOutline(
      BuildContext context, String title, GestureTapCallback onPressed) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              // color: blueSelected,
              border: Border.all(
                color: blueSelected,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: TextWidget.textGeneralWithColor(title, blueSelected)),
        ));
  }

  static Widget buttonOutlineFix(
      BuildContext context, String title, GestureTapCallback onPressed) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1.0,
            color: blueSelected,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.all(8.0),
          // decoration: BoxDecoration(
          //     // color: blueSelected,
          //     border: Border.all(
          //       color: blueSelected,
          //     ),
          //     borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: TextWidget.textTitleBoldWithColor(title, blueSelected)),
        ));
  }

  static Widget buttonOutlineFixRed(
      BuildContext context, String title, GestureTapCallback onPressed) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              width: 1.0,
              color: Colors.red,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(8.0),
            // decoration: BoxDecoration(
            //     // color: blueSelected,
            //     border: Border.all(
            //       color: blueSelected,
            //     ),
            //     borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: TextWidget.textTitleBoldWithColor(title, Colors.red)),
          )),
    );
  }

  static Widget buttonNews(BuildContext context, String title,
      GestureTapCallback onPressed, bool isDisable) {
    return TextButton(
        onPressed: isDisable ? onPressed : () {},
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //     color:  Colors.white ,
              //     border: Border.all(
              //       color: isDisable ? blueSelected : greyBorder,
              //     ),
              //     borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                  child:
                      TextWidget.textTitleBoldWithColor(title, blueSelected)),
            ),
            // isRequired ? Text('data'):Container()
          ],
        ));
  }
}
