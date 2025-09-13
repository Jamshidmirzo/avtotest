import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors(
      {required this.navBarItemColor,
      required this.whiteSmokeToWhiteSmoke,
      required this.whiteToGondola,
      required this.vividBlueToWhite,
      required this.blackToWhite,
      required this.whiteToBlack,
      required this.paleBlueToCharcoalBlack,
      required this.paleBlueToAshGray,
      required this.mainBlackToWhite,
      required this.offWhiteBlueTintToGondola,
      required this.charcoalBlackToWhite,
      required this.blackToVividBlue,
      required this.charcoalBlackToVividBlue,
      required this.offWhiteBlueTintAshGray,
      required this.cloudBurstToWhite,
      required this.snowToBastille,
      required this.whiteIceToBlackMarlin,
      required this.ashGrayToPaleGray,
      required this.paleBlueToGondola,
      required this.grayishPurpleToWhite,
      required this.whiteSmokeToTransparent});

  final Color? navBarItemColor;
  final Color? whiteSmokeToWhiteSmoke;
  final Color? whiteToGondola;
  final Color? vividBlueToWhite;
  final Color? blackToWhite;
  final Color? whiteToBlack;
  final Color? paleBlueToCharcoalBlack;
  final Color? paleBlueToAshGray;
  final Color? mainBlackToWhite;
  final Color? offWhiteBlueTintToGondola;
  final Color? charcoalBlackToWhite;
  final Color? blackToVividBlue;
  final Color? charcoalBlackToVividBlue;
  final Color? offWhiteBlueTintAshGray;
  final Color? cloudBurstToWhite;
  final Color? snowToBastille;
  final Color? whiteIceToBlackMarlin;
  final Color? ashGrayToPaleGray;
  final Color? paleBlueToGondola;
  final Color? grayishPurpleToWhite;
  final Color? whiteSmokeToTransparent;

  @override
  CustomColors copyWith({
    Color? navBarItemColor,
    Color? whiteSmokeToWhiteSmoke,
    Color? whiteToGondola,
    Color? vividBlueToWhite,
    Color? blackToWhite,
    Color? whiteToBlack,
    Color? paleBlueToCharcoalBlack,
    Color? paleBlueToAshGray,
    Color? mainBlackToWhite,
    Color? offWhiteBlueTintToGondola,
    Color? charcoalBlackToWhite,
    Color? blackToVividBlue,
    Color? charcoalBlackToVividBlue,
    Color? offWhiteBlueTintAshGray,
    Color? cloudBurstToWhite,
    Color? snowToBastille,
    Color? whiteIceToBlackMarlin,
    Color? ashGrayToPaleGray,
    Color? paleBlueToGondola,
    Color? grayishPurpleToWhite,
    Color? whiteSmokeToTransparent,
  }) {
    return CustomColors(
      navBarItemColor: navBarItemColor ?? this.navBarItemColor,
      whiteSmokeToWhiteSmoke: whiteSmokeToWhiteSmoke ?? this.whiteSmokeToWhiteSmoke,
      whiteToGondola: whiteToGondola ?? this.whiteToGondola,
      vividBlueToWhite: vividBlueToWhite ?? this.vividBlueToWhite,
      blackToWhite: blackToWhite ?? this.blackToWhite,
      whiteToBlack: whiteToBlack ?? this.whiteToBlack,
      paleBlueToCharcoalBlack: paleBlueToCharcoalBlack ?? this.paleBlueToCharcoalBlack,
      paleBlueToAshGray: paleBlueToAshGray ?? this.paleBlueToAshGray,
      mainBlackToWhite: mainBlackToWhite ?? this.mainBlackToWhite,
      offWhiteBlueTintToGondola: offWhiteBlueTintToGondola ?? this.offWhiteBlueTintToGondola,
      charcoalBlackToWhite: charcoalBlackToWhite ?? this.charcoalBlackToWhite,
      blackToVividBlue: blackToVividBlue ?? this.blackToVividBlue,
      charcoalBlackToVividBlue: charcoalBlackToVividBlue ?? this.charcoalBlackToVividBlue,
      offWhiteBlueTintAshGray: offWhiteBlueTintAshGray ?? this.offWhiteBlueTintAshGray,
      cloudBurstToWhite: cloudBurstToWhite ?? this.cloudBurstToWhite,
      snowToBastille: snowToBastille ?? this.snowToBastille,
      whiteIceToBlackMarlin: whiteIceToBlackMarlin ?? this.whiteIceToBlackMarlin,
      ashGrayToPaleGray: ashGrayToPaleGray ?? this.ashGrayToPaleGray,
      paleBlueToGondola: paleBlueToGondola ?? this.paleBlueToGondola,
      grayishPurpleToWhite: grayishPurpleToWhite ?? this.grayishPurpleToWhite,
      whiteSmokeToTransparent: whiteSmokeToTransparent ?? this.whiteSmokeToTransparent,
    );
  }

  // Controls how the properties change on theme changes
  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      navBarItemColor: Color.lerp(navBarItemColor, other.navBarItemColor, t),
      whiteSmokeToWhiteSmoke: Color.lerp(whiteSmokeToWhiteSmoke, other.whiteSmokeToWhiteSmoke, t),
      whiteToGondola: Color.lerp(whiteToGondola, other.whiteToGondola, t),
      vividBlueToWhite: Color.lerp(vividBlueToWhite, other.vividBlueToWhite, t),
      blackToWhite: Color.lerp(blackToWhite, other.blackToWhite, t),
      whiteToBlack: Color.lerp(whiteToBlack, other.whiteToBlack, t),
      paleBlueToCharcoalBlack: Color.lerp(paleBlueToCharcoalBlack, other.paleBlueToCharcoalBlack, t),
      paleBlueToAshGray: Color.lerp(paleBlueToAshGray, other.paleBlueToAshGray, t),
      mainBlackToWhite: Color.lerp(mainBlackToWhite, other.mainBlackToWhite, t),
      offWhiteBlueTintToGondola: Color.lerp(offWhiteBlueTintToGondola, other.offWhiteBlueTintToGondola, t),
      charcoalBlackToWhite: Color.lerp(charcoalBlackToWhite, other.charcoalBlackToWhite, t),
      blackToVividBlue: Color.lerp(blackToVividBlue, other.blackToVividBlue, t),
      charcoalBlackToVividBlue: Color.lerp(charcoalBlackToVividBlue, other.charcoalBlackToVividBlue, t),
      offWhiteBlueTintAshGray: Color.lerp(offWhiteBlueTintAshGray, other.offWhiteBlueTintAshGray, t),
      cloudBurstToWhite: Color.lerp(cloudBurstToWhite, other.cloudBurstToWhite, t),
      snowToBastille: Color.lerp(snowToBastille, other.snowToBastille, t),
      whiteIceToBlackMarlin: Color.lerp(whiteIceToBlackMarlin, other.whiteIceToBlackMarlin, t),
      ashGrayToPaleGray: Color.lerp(ashGrayToPaleGray, other.ashGrayToPaleGray, t),
      paleBlueToGondola: Color.lerp(paleBlueToGondola, other.paleBlueToGondola, t),
      grayishPurpleToWhite: Color.lerp(grayishPurpleToWhite, other.grayishPurpleToWhite, t),
      whiteSmokeToTransparent: Color.lerp(whiteSmokeToTransparent, other.whiteSmokeToTransparent, t),
    );
  }

  // Controls how it displays when the instance is being passed
  // to the `print()` method.
  // @override
  // String toString() => 'CustomColors('
  //     'success: $navBarItemColor, info: $text, warning: $text, danger: $radioContainerColor'
  //     ')';

  // the light theme
  static CustomColors light = const CustomColors(
    navBarItemColor: AppColors.grey2,
    whiteSmokeToWhiteSmoke: AppColors.whiteSmoke,
    whiteToGondola: AppColors.white,
    vividBlueToWhite: AppColors.vividBlue,
    blackToWhite: AppColors.black,
    whiteToBlack: AppColors.white,
    paleBlueToCharcoalBlack: AppColors.paleBlue,
    paleBlueToAshGray: AppColors.paleBlue,
    mainBlackToWhite: AppColors.mainDark,
    offWhiteBlueTintToGondola: AppColors.offWhiteBlueTint,
    charcoalBlackToWhite: AppColors.charcoalBlack,
    blackToVividBlue: AppColors.black,
    charcoalBlackToVividBlue: AppColors.charcoalBlack,
    offWhiteBlueTintAshGray: AppColors.offWhiteBlueTint,
    cloudBurstToWhite: AppColors.cloudBurst,
    snowToBastille: AppColors.snow,
    whiteIceToBlackMarlin: AppColors.whiteIce,
    ashGrayToPaleGray: AppColors.ashGray,
    paleBlueToGondola: AppColors.paleBlue,
    grayishPurpleToWhite: AppColors.grayishPurple,
    whiteSmokeToTransparent: AppColors.whiteSmoke,
  );

  // the dark theme
  static CustomColors dark = CustomColors(
    navBarItemColor: AppColors.darkUnselectedNavBarItemColor,
    whiteSmokeToWhiteSmoke: AppColors.ashGray,
    whiteToGondola: AppColors.gondola,
    vividBlueToWhite: AppColors.white,
    blackToWhite: AppColors.white,
    whiteToBlack: AppColors.black,
    paleBlueToCharcoalBlack: AppColors.charcoalBlack,
    paleBlueToAshGray: AppColors.ashGray,
    mainBlackToWhite: AppColors.white,
    offWhiteBlueTintToGondola: AppColors.gondola,
    charcoalBlackToWhite: AppColors.white,
    blackToVividBlue: AppColors.vividBlue,
    charcoalBlackToVividBlue: AppColors.vividBlue,
    offWhiteBlueTintAshGray: AppColors.ashGray,
    cloudBurstToWhite: AppColors.white,
    snowToBastille: AppColors.bastille,
    whiteIceToBlackMarlin: AppColors.blackMarlin,
    ashGrayToPaleGray: AppColors.paleGray,
    paleBlueToGondola: AppColors.gondola,
    grayishPurpleToWhite: AppColors.white,
    whiteSmokeToTransparent: Colors.transparent,
  );
}

class ThemedIcons extends ThemeExtension<ThemedIcons> {
  final String energoLogo;

  const ThemedIcons({
    required this.energoLogo,
  });

  @override
  ThemeExtension<ThemedIcons> copyWith({String? energoLogo}) => ThemedIcons(
        energoLogo: energoLogo ?? this.energoLogo,
      );

  @override
  ThemeExtension<ThemedIcons> lerp(ThemeExtension<ThemedIcons>? other, double t) {
    if (other is! ThemedIcons) {
      return this;
    }
    return ThemedIcons(
      energoLogo: energoLogo,
    );
  }
}
