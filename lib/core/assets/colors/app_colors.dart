import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color vividBlue = Color(0xff006FFD); // Vivid Blue
  static const Color lightSkyBlue = Color(0xffB4DBFF); // Light Sky Blue
  static const Color paleBlue = Color(0xffEAF2FF); // Very Pale Blue
  static const Color lightGray = Color(0xffC5C6CC); // Light Gray
  static const Color paleGray = Color(0xffE8E9F1); // Pale Gray
  static const Color offWhiteBlueTint = Color(0xffF8F9FE); // Off White Blue Tint
  static const Color charcoalBlack = Color(0xff1F2024); // Charcoal Black
  static const Color ashGray = Color(0xff494A50); // Ash Gray
  static const Color coolGray = Color(0xff71727A); // Cool Gray
  static const Color grayishPurple = Color(0xff8F9098); // Grayish Purple
  static const Color strongRed = Color(0xffED3241); // Strong Red
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);
  static const Color yellow = Color(0xffFFC107); // Primary Yellow
  static const Color cloudBurst = Color(0xff373E4E); // Light Yellow
  static const Color yellowDark = Color(0xffFF8F00);
  static const Color mainDark = Color(0xff1C1C1C);
  static const Color red = Color(0xffFF3300);
  static const Color greySuit = Color(0xffB0B0B0);
  static const Color grey1 = Color(0xffE0E0E0);
  static const Color grey2 = Color(0xffBDBDBD);
  static const Color grey3 = Color(0xff616161);
  static const Color grey4 = Color(0xfff2f4f5);
  static const Color darkBackground = Color(0xff121212);
  static const Color darkCard = Color(0xff1E1E1E);
  static const Color lightBackground = white;
  static const Color lightCard = Color(0xffF5F5F5);
  static const Color containerFill = Color(0xFFF0F0F0);
  static const Color greyText = Color(0xFF8A8A8A);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color darkScaffoldColor = Color(0xFF121212);
  static const Color darkUnselectedNavBarItemColor = Color(0xFF9E9E9E);
  static const Color mainViolet = Color(0xFF5A4FCF);
  static const Color blue = Color(0xff2196F3);
  static const Color whiteSmoke = Color(0xffE9E9E9);

  // dark colors
  static const Color gondola = Color(0xff343434); // Darker Vivid Blue
  static const bastille = Color(0xff2C2C2E); // Bastille
  static const Color snow = Color(0xffFFEFEF); // Dark Grey
  static const Color blackMarlin = Color(0xff3A3A3C);
  static const Color whiteIce = Color(0xffEFF9F7);

  // Gradient Examples
  static const mainButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      yellow, // Main Yellow
      yellowDark, // Darker Shade
    ],
  );
  static const shadowLight = BoxShadow(
    color: Color(0x20000000), // Light shadow
    blurRadius: 8,
    offset: Offset(0, 4),
  );
  static const shadowDark = BoxShadow(
    color: Color(0x60000000), // Dark shadow
    blurRadius: 8,
    offset: Offset(0, 4),
  );
}
