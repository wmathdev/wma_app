import 'package:flutter/material.dart';

import '../../Utils/Color.dart';

class DropDown {
  static Widget dropdownButton(
      BuildContext context, String title, GestureTapCallback onBack) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          side: BorderSide(width: 2, color: Colors.white),
        ),
        onPressed: onBack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
              ),
              icon: Image.asset(
                'asset/images/bi_chevron-down.png',
              ),
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }

  static Widget dropdownButtonSmall(
      BuildContext context, String title, GestureTapCallback onBack) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          side: BorderSide(width: 2, color: greyBorder),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
              ),
              icon: Image.asset(
                'asset/images/bi_chevron-down.png',
              ),
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}
