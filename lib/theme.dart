import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:songaree_worktime/constants.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
      primaryColor: kPrimaryColor,
      accentColor: kAccentLightColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        secondary: kSecondaryLightColor,
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: kBodyTextColorLight),
      accentIconTheme: IconThemeData(color: kPrimaryIconLightColor),
      primaryIconTheme: IconThemeData(color: kPrimaryIconLightColor),
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        bodyText1: TextStyle(color: kBodyTextColorLight),
        bodyText2: TextStyle(color: kBodyTextColorLight),
        headline1: TextStyle(color: kTitleTextLightLightColor, fontSize: 32),
        headline2: TextStyle(color: kTitleTextLightLightColor, fontSize: 80),
      ));
}
