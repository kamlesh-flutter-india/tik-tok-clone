import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static const backgroundColor = Colors.black;
  static const Color buttonColor = Color.fromRGBO(239, 83, 80, 1);
  static const borderColor = Colors.grey;

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    textTheme: darkTextTheme,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: backgroundColor,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    headline1: _headline1,
    headline2: _headline2,
    headline3: _headline3,
    subtitle1: _subtitle1,
    subtitle2: _subtitle2,
  );

  static final TextStyle _headline1 = const TextStyle(
    fontSize: 36.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ).comfortaa();

  static final TextStyle _headline2 = const TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w400,
  ).comfortaa();

  static final TextStyle _headline3 = const TextStyle(
    fontSize: 23.0,
    fontWeight: FontWeight.w400,
  ).comfortaa();

  static final TextStyle _subtitle1 = const TextStyle(
    fontSize: 21.0,
    fontWeight: FontWeight.w400,
  ).comfortaa();

  static final TextStyle _subtitle2 = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  ).comfortaa();
}

extension TextStyleX on TextStyle {
  TextStyle comfortaa() {
    return copyWith(
      fontFamily: "Comfortaa",
    );
  }
}
