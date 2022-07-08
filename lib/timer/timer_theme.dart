import 'package:flutter/material.dart';

class TimerTheme {
  static TextTheme textTheme = TextTheme(
    bodyText1: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal),
    bodyText2: TextStyle(
        fontSize: 30,
        color: Colors.black,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal),
    headline1: TextStyle(
        fontSize: 70,
        color: Colors.black,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal),
    headline2: TextStyle(
        fontSize: 50,
        color: Colors.black,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal),
  );

  static ButtonStyle redButton = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.red),
      minimumSize: MaterialStateProperty.all(Size(100, 45)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))));

  static ButtonStyle greyButton = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
      minimumSize: MaterialStateProperty.all(Size(100, 45)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))));

  static ButtonStyle primaryButton = ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(100, 45)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))));
}
