import 'package:flutter/material.dart';

const primaryColor = Color(0xff673ab7);
const primaryLightColor = Color(0xff9a67ea);
const primaryDarkColor = Color(0xff320b86);
const secondaryColor = Color(0xff4a148c);
const secondaryLightColor = Color(0xff7c43bd);
const secondaryDarkColor = Color(0xff12005e);
const primaryTextColor = Color(0xffffffff);
const secondaryTextColor = Color(0xffffffff);
const Background = Color(0xfffffdf7);
const TextColor = Color(0xffffffff);

class MyTheme {
  static final ThemeData defaultTheme = _buildMyTheme();

  static ThemeData _buildMyTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      accentColor: secondaryColor,
      accentColorBrightness: Brightness.dark,

      primaryColor: primaryColor,
      primaryColorDark: primaryDarkColor,
      primaryColorLight: primaryLightColor,
      primaryColorBrightness: Brightness.dark,

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: secondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      scaffoldBackgroundColor: Background,
      cardColor: Background,
      textSelectionColor: primaryLightColor,
      backgroundColor: Background,

      // textTheme: base.textTheme.copyWith(
      //     title: base.textTheme.title.copyWith(color: TextColor),
      //     body1: base.textTheme.body1.copyWith(color: TextColor),
      //     body2: base.textTheme.body2.copyWith(color: TextColor)
      // ),
    );
  }
}
