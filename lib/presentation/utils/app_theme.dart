import 'dart:io';

import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/themedata_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class LightTheme {
  static ThemeData theme() => ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'Inter',
        highlightColor: AppColors.white,
        primaryColor: AppColors.containerFill,
        primaryColorLight: AppColors.white,
        primaryColorDark: AppColors.darkScaffoldColor,
        hintColor: AppColors.grey2,
        disabledColor: AppColors.dividerColor,
        iconTheme: const IconThemeData(color: AppColors.grey1),
        hoverColor: AppColors.greyText,
        unselectedWidgetColor: AppColors.containerFill,
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: AppColors.containerFill),
        dividerTheme: const DividerThemeData(color: AppColors.mainViolet),
        secondaryHeaderColor: AppColors.greyText,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.mainViolet,
            unselectedItemColor: AppColors.grey2,
            selectedLabelStyle: TextStyle(color: AppColors.mainViolet, fontWeight: FontWeight.w600, fontSize: 11),
            unselectedLabelStyle: TextStyle(color: AppColors.grey2, fontWeight: FontWeight.w400, fontSize: 11),
            selectedIconTheme: IconThemeData(color: AppColors.mainViolet),
            unselectedIconTheme: IconThemeData(color: AppColors.grey2)),
        dividerColor: AppColors.dividerColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.mainDark),
          titleTextStyle: displayMedium.copyWith(color: AppColors.mainDark),
          centerTitle: true,
          backgroundColor: AppColors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Platform.isIOS ? AppColors.mainDark : AppColors.white,
              statusBarIconBrightness: Platform.isIOS ? Brightness.light : Brightness.dark,
              statusBarBrightness: Platform.isIOS ? Brightness.light : Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark),
        ),
        tabBarTheme: TabBarThemeData(
          indicatorColor: AppColors.black,
          labelColor: AppColors.black,
          indicator: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.white.withOpacity(.12),
              width: 1,
            ),
          ),
          labelStyle: bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        drawerTheme: const DrawerThemeData(
            backgroundColor: AppColors.mainViolet, surfaceTintColor: AppColors.white, shadowColor: AppColors.mainDark),
        textTheme: const TextTheme(
            displayLarge: displayLarge,
            displayMedium: displayMedium,
            displaySmall: displaySmall,
            headlineLarge: headlineLarge,
            headlineMedium: headlineMedium,
            headlineSmall: headlineSmall,
            titleLarge: titleLarge,
            titleMedium: titleMedium,
            titleSmall: titleSmall,
            bodyLarge: bodyLarge,
            bodyMedium: bodyMedium,
            bodySmall: bodySmall,
            labelLarge: labelLarge,
            labelMedium: labelMedium,
            labelSmall: labelSmall),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors.light,
        ],
      );

  // Fonts
  static const displayLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: AppColors.mainDark); //
  static const displayMedium = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.mainDark); //
  static const displaySmall = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.mainDark); //
  static const headlineLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.mainDark); //
  static const headlineMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.mainDark);
  static const headlineSmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.mainDark); //
  static const titleLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainDark); //
  static const titleMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.mainDark);
  static const titleSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.mainDark);
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.mainDark); //
  static const bodyMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.mainDark); //
  static const bodySmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.mainDark); //
  static const labelLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white); //
  static const labelMedium = TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.mainDark); //

  static const labelSmall =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.mainDark, letterSpacing: .41);
}

abstract class DarkTheme {
  static ThemeData theme() => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        scaffoldBackgroundColor: AppColors.black,
        fontFamily: 'Inter',
        highlightColor: AppColors.white,
        primaryColor: AppColors.containerFill,
        primaryColorLight: AppColors.white,
        primaryColorDark: AppColors.darkScaffoldColor,
        hintColor: AppColors.grey2,
        disabledColor: AppColors.dividerColor,
        iconTheme: const IconThemeData(color: AppColors.grey1),
        hoverColor: AppColors.gondola,
        unselectedWidgetColor: AppColors.containerFill,
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: AppColors.containerFill),
        dividerTheme: const DividerThemeData(color: AppColors.mainViolet),
        secondaryHeaderColor: AppColors.greyText,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.mainViolet,
            unselectedItemColor: AppColors.grey2,
            selectedLabelStyle: TextStyle(color: AppColors.mainViolet, fontWeight: FontWeight.w600, fontSize: 11),
            unselectedLabelStyle: TextStyle(color: AppColors.grey2, fontWeight: FontWeight.w400, fontSize: 11),
            selectedIconTheme: IconThemeData(color: AppColors.mainViolet),
            unselectedIconTheme: IconThemeData(color: AppColors.grey2)),
        dividerColor: AppColors.dividerColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.mainDark),
          titleTextStyle: displayMedium.copyWith(color: AppColors.mainDark),
          centerTitle: true,
          backgroundColor: AppColors.mainDark,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Platform.isIOS ? AppColors.white : AppColors.mainDark,
              statusBarIconBrightness: Platform.isIOS ? Brightness.dark : Brightness.light,
              statusBarBrightness: Platform.isIOS ? Brightness.dark : Brightness.light,
              systemNavigationBarIconBrightness: Brightness.light),
        ),
        tabBarTheme: TabBarThemeData(
          indicatorColor: AppColors.black,
          labelColor: AppColors.black,
          indicator: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.white.withOpacity(.12),
              width: 1,
            ),
          ),
          labelStyle: bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.mainViolet,
          surfaceTintColor: AppColors.white,
          shadowColor: AppColors.mainDark,
        ),
        textTheme: const TextTheme(
            displayLarge: displayLarge,
            displayMedium: displayMedium,
            displaySmall: displaySmall,
            headlineLarge: headlineLarge,
            headlineMedium: headlineMedium,
            headlineSmall: headlineSmall,
            titleLarge: titleLarge,
            titleMedium: titleMedium,
            titleSmall: titleSmall,
            bodyLarge: bodyLarge,
            bodyMedium: bodyMedium,
            bodySmall: bodySmall,
            labelLarge: labelLarge,
            labelMedium: labelMedium,
            labelSmall: labelSmall),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors.dark,
        ],
      );

  // Fonts
  static const displayLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: AppColors.white); //
  static const displayMedium = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.white); //
  static const displaySmall = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.white); //
  static const headlineLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.white); //
  static const headlineMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white);
  static const headlineSmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.white); //
  static const titleLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white); //
  static const titleMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white);
  static const titleSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.white);
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.white); //
  static const bodyMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.white); //
  static const bodySmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.white); //
  static const labelLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white); //
  static const labelMedium = TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.white); //

  static const labelSmall =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.white, letterSpacing: .41);
}
