import 'package:avtotest/presentation/utils/themedata_extention.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  CustomColors get themeExtension => theme.extension<CustomColors>()!;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  EdgeInsets get padding => MediaQuery.paddingOf(this);

  Size get sizeOf => MediaQuery.sizeOf(this);

  bool get isSmallScreen => sizeOf.width < 600;

  bool get isLargeScreen => sizeOf.width >= 1024;
}
