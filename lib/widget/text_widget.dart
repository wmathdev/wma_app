import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wma_app/Utils/Color.dart';

class TextWidget {
  static Widget textGeneral(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  static Widget textGeneralWithColor(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        // fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget textGeneralWithColorFixLine(String title, Color color) {
    return Html(
      data: title,
      style: {
        '#': Style(
          fontSize: FontSize(18),
          maxLines: 10,
          textOverflow: TextOverflow.ellipsis,
        ),
      },
    );
  }

  static Widget textTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  static Widget textTitleBold(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  static Widget textTitleHTMLBold(String title) {
    return Html(
      data: title,
    );
  }

  static Widget textTitleHTMLBoldBlue(String title) {
    return Html(
      data: title,
      style: {
        "body": Style(
          fontSize: FontSize(18.0),
          fontWeight: FontWeight.bold,
          color: blueNews
        ),
      },
    );
  }

  static Widget textTitleBoldCenter(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  static Widget textTitleBoldWithColor(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget textTitleBoldWithColorMarker(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget textTitleBoldWithColorDO(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget textTitleBoldWithColorCompare(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget textTitleWithColor(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color,
      ),
    );
  }

  static Widget textTitleWithColorSize(String title, Color color, double size) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.normal,
        color: color,
      ),
    );
  }

  static Widget textSubTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  static Widget textSubTitleBold(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  static Widget textSubTitleBoldPh(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  static Widget textSubTitleWithSize(String title, double size) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  static Widget textSubTitleWithSizeColor(
      String title, double size, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.normal,
        color: color,
      ),
    );
  }

  static Widget textBig(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.normal,
        color: blueSelected,
      ),
    );
  }

  static Widget textBigWithColor(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: color,
      ),
    );
  }
}
